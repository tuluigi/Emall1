//
//  OCNetSessionManager.h
//  OpenCourse
//
//  Created by Luigi on 15/9/22.
//
//



#if ( ( defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1090) || \
( defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000 ) )

#import "OCResponseResult.h"

@interface OCNetSessionManager : NSObject
/**
 *  default is YES
 */
@property(nonatomic,assign) BOOL enableLog;
/**
 *  创建SessionManager
 *
 *  @return
 */
+(instancetype)sharedSessionManager;
/**
 *  创建session网络请求
 *
 *  @param url             接口地址
 *  @param parmar          参数
 *  @param method          方法(GET/POST/PUT/DELETE)
 *  @param completionBlock 请求结果回调
 *
 *  @return NSURLSessionTask
 */
-(NSURLSessionTask *)requestWithUrl:(NSString *)url
                            parmars:(NSDictionary *)parmar
                             method:(NSString *)method
                 onCompletionHander:(OCResponseObjectBlock)completionBlock;
/**
 *  上传文件
 *
 *  @param apiPath         接口
 *  @param url             url
 *  @param sentblock       progressBlok
 *  @param completionBlock
 *
 *  @return
 */
- (NSURLSessionUploadTask *)uploadWithRequest:(NSURLRequest *)request
                                           fileURL:(NSURL *)url
                                       didSendData:(void(^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))sentblock
                                 onCompletionBlock:(OCResponseObjectBlock)completionBlock;
- (NSURLSessionUploadTask *)uploadWithRequest:(NSURLRequest *)request
                                      fileData:(NSData *)data
                                  didSendData:(void(^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))sentblock
                            onCompletionBlock:(OCResponseObjectBlock)completionBlock;
/**
 *  取消正在下载的task
 *
 *  @param tasks task
 */
- (void )cancleSessionTasks:(NSArray *)tasks;
/**
 *  根据默认域名生成完整接口地址
 *
 *  @param str 接口名称部分
 *
 *  @return 完整接口地址
 */
+(NSString *)urlWithSuffixPath:(NSString *)str;
@end
#endif