//
//  OCNetSessionManager.m
//  OpenCourse
//
//  Created by Luigi on 15/9/22.
//
//


#if ( ( defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090) || \
( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 ) )
#import "OCNetSessionManager.h"
#import "AFHTTPSessionManager.h"



static OCNetSessionManager *sharedSessionManager;

@interface OCNetSessionManager ()
@property(nonatomic,strong)AFHTTPSessionManager *afSessionManager;
@end

@implementation OCNetSessionManager
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(AFHTTPSessionManager *)afSessionManager{
    if (nil==_afSessionManager) {
        _afSessionManager=[AFHTTPSessionManager manager];
        [[_afSessionManager requestSerializer] setTimeoutInterval:20];
//        _afSessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
              _afSessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
         _afSessionManager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil ];
 
    }
    return _afSessionManager;
}
-(instancetype)init{
    if (self==[super init]) {
        _afSessionManager=[self afSessionManager];
        _enableLog=YES;
    }
    return self;
}
+(instancetype)sharedSessionManager{
    @synchronized(self){
        if (nil==sharedSessionManager) {
            sharedSessionManager=[[OCNetSessionManager alloc] init];
        }
    }
    return sharedSessionManager;
}

-(NSURLSessionTask *)requestWithUrl:(NSString *)url
                            parmars:(NSDictionary *)parmar
                             method:(NSString *)method
                 onCompletionHander:(OCResponseObjectBlock)completionBlock{
    NSAssert(url, @"Request url can not be nil");
    NSURLSessionTask *sessionTask=nil;
    __weak OCNetSessionManager *weakSelf=sharedSessionManager;
    if ([method isEqualToString:@"GET"]) {
        sessionTask = [sharedSessionManager.afSessionManager GET:url parameters:parmar success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf handleSessionResponseWithTask:task responseObject:responseObject error:nil onCompletionBlock:completionBlock];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf handleSessionResponseWithTask:task responseObject:nil error:error onCompletionBlock:completionBlock];
        }];
    }else if ([method isEqualToString:@"POST"]){
        sessionTask=[sharedSessionManager.afSessionManager POST:url parameters:parmar success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf handleSessionResponseWithTask:task responseObject:responseObject error:nil onCompletionBlock:completionBlock];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf handleSessionResponseWithTask:task responseObject:error error:error onCompletionBlock:completionBlock];
        }];
    }else if ([method isEqualToString:@"DELETE"]){
        sessionTask = [sharedSessionManager.afSessionManager DELETE:url parameters:parmar success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf handleSessionResponseWithTask:task responseObject:responseObject error:nil onCompletionBlock:completionBlock];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf handleSessionResponseWithTask:task responseObject:error error:error onCompletionBlock:completionBlock];
        }];
    }else if ([method isEqualToString:@"PUT"]){
        sessionTask = [sharedSessionManager.afSessionManager PUT:url parameters:parmar success:^(NSURLSessionDataTask *task, id responseObject) {
            [weakSelf handleSessionResponseWithTask:task responseObject:responseObject error:nil onCompletionBlock:completionBlock];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf handleSessionResponseWithTask:task responseObject:error error:error onCompletionBlock:completionBlock];
        }];
    }
    return sessionTask;
}
-(void)handleSessionResponseWithTask:(NSURLSessionDataTask *)task responseObject:(id)responseObject error:(NSError *)error onCompletionBlock:(OCResponseObjectBlock)completionBlock{
    [self handleDebugMessageWithTask:task responseObject:responseObject error:error];
    if (completionBlock) {
        completionBlock(responseObject,error);
    }
}
-(void)handleDebugMessageWithTask:(NSURLSessionDataTask * )task responseObject:(id)responseObject error:(NSError *)error{
#ifdef DEBUG
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (task) {
            NSString *url= task.currentRequest.URL.absoluteString;
            id resultValue ;
            if (error) {
                resultValue=error;
            }else{
                 resultValue=[NSString stringWithFormat:@"%@",responseObject];
                /*
                if ([resultValue isKindOfClass:[NSData class]]) {
                   resultValue=[NSString stringWithFormat:@"%@",responseObject];
                }else{
                    resultValue=responseObject;
                }
                 */
            }
            if ([task.currentRequest.HTTPMethod isEqualToString:@"POST"]) {
                NSLog(@"\n 网络请求接口地址:\n%@\n参数\n%@\n返回值\n%@",url,[[NSString alloc]  initWithData:task.originalRequest.HTTPBody encoding:4],resultValue);
            }else{
                NSLog(@"\n网络请求接口地址:\n%@\n返回值\n%@",url,resultValue);
            }
            }
        });
#endif
}
- (NSURLSessionUploadTask *)uploadWithRequest:(NSURLRequest *)request
                                           fileURL:(NSURL *)url
                                    didSendData:(void(^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))sentblock
                                 onCompletionBlock:(OCResponseObjectBlock)completionBlock{
    NSAssert(url, @"Request url can not be nil");
    WEAKSELF
    __block NSURLSessionUploadTask *uploadTask=[self.afSessionManager uploadTaskWithRequest:request fromFile:url progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [weakSelf handleSessionResponseWithTask:nil responseObject:error error:error onCompletionBlock:completionBlock];
    }];
    [self.afSessionManager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (sentblock) {
            sentblock(bytesSent,totalBytesSent,totalBytesExpectedToSend);
        }
    }];
        [uploadTask resume];
    return uploadTask;
}
- (NSURLSessionUploadTask *)uploadWithRequest:(NSURLRequest *)request
                                     fileData:(NSData *)data
                                  didSendData:(void(^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))sentblock
                            onCompletionBlock:(OCResponseObjectBlock)completionBlock{
//    NSAssert(data, @"upload data can not be nil");
    WEAKSELF
    __block NSURLSessionUploadTask *uploadTask=[self.afSessionManager uploadTaskWithRequest:request fromData:data progress:nil completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [weakSelf handleSessionResponseWithTask:nil responseObject:responseObject error:error onCompletionBlock:completionBlock];
    }];
    [self.afSessionManager setTaskDidSendBodyDataBlock:^(NSURLSession *session, NSURLSessionTask *task, int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (sentblock) {
            sentblock(bytesSent,totalBytesSent,totalBytesExpectedToSend);
        }
    }];
    [uploadTask resume];
    return uploadTask;
}
/**
 *  取消正在下载的task
 *
 *  @param tasks task
 */
- (void )cancleSessionTasks:(NSArray *)tasks{
    for (id task in tasks) {
        if ([task respondsToSelector:@selector(cancel)]) {
            [task cancel];
        }
    }
}

@end

#endif
