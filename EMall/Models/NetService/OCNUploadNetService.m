//
//  OCNUploadNetService.m
//  OpenCourse
//
//  Created by Luigi on 16/4/21.
//
//

#import "OCNUploadNetService.h"
#import "OCNetSessionManager.h"
#import "OCBaseModel.h"
@implementation OCNUploadNetService
+ (NSURLSessionUploadTask *)uploadPhotoWithFileURL:(NSURL *)url
                                           parmDic:(NSDictionary *)parmDic
                                       didSendData:(void(^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))progressBlock
                                 onCompletionBlock:(OCResponseResultBlock)completionBlock{
    
    NSString *apiPath=[self urlWithSuffixPath:@"upload"];
    NSDictionary *fileDic = @{@"filepath": url.absoluteString,
                           @"name": @"imageFile",
                           @"mimetype": @"application/octet-stream"};
    
    NSArray *fileBePostArray=[NSArray arrayWithObject:fileDic];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiPath]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSMutableData *bodyData = [NSMutableData data];
    [parmDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
                                     boundary, key, obj];
        
        [bodyData appendData:[thisFieldString dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [fileBePostArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        NSDictionary *thisFile = (NSDictionary*) obj;
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",
                                     boundary,
                                     thisFile[@"name"],
                                     [thisFile[@"filepath"] lastPathComponent],
                                     thisFile[@"mimetype"]];
        
        [bodyData appendData:[thisFieldString dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData: [NSData dataWithContentsOfFile:thisFile[@"filepath"]]];
        [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    [bodyData appendData: [[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    if(([fileBePostArray count] > 0)) {
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@", charset, boundary]
            forHTTPHeaderField:@"Content-Type"];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    }
    [request setHTTPBody:bodyData];
    NSURLSessionUploadTask *task=[[OCNetSessionManager sharedSessionManager] uploadWithRequest:request fileURL:url didSendData:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (progressBlock) {
            progressBlock(bytesSent,totalBytesSent,totalBytesExpectedToSend);
        }
    } onCompletionBlock:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[OCBaseModel class] error:error onCompletionBlock:^(OCResponseResult *responseResult) {
            if (completionBlock) {
                completionBlock(responseResult);
            }
        }];
    }];
    return task;
}


+ (NSURLSessionUploadTask *)uploadPhotoWithData:(NSData *)data parmDic:(NSDictionary *)parmDic fileType:(NSString *)fileType didSendData:(void (^)(int64_t, int64_t, int64_t))progressBlock onCompletionBlock:(OCResponseResultBlock)completionBlock {
    NSString *apiPath=[self urlWithSuffixPath:@"upload"];
    
    
    NSDictionary *fileDic = @{@"data": data,
                              @"name": @"imageFile",
                              @"mimetype": @"image/png",
                              @"filename": [NSString stringWithFormat:@"file.%@",fileType]};
    
    NSArray *fileBePostArray=[NSArray arrayWithObject:fileDic];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiPath]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"0xKhTmLbOuNdArY";
    NSMutableData *bodyData = [NSMutableData data];
    [parmDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",
                                     boundary, key, obj];
        
        [bodyData appendData:[thisFieldString dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    [fileBePostArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *thisDataObject = (NSDictionary*) obj;
        NSString *thisFieldString = [NSString stringWithFormat:
                                     @"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",
                                     boundary,
                                     thisDataObject[@"name"],
                                     thisDataObject[@"filename"],
                                     thisDataObject[@"mimetype"]];
        
        [bodyData appendData:[thisFieldString dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:thisDataObject[@"data"]];
        [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    [bodyData appendData: [[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    if(([fileBePostArray count] > 0)) {
        [request setValue:[NSString stringWithFormat:@" multipart/form-data; charset=%@; boundary=%@", charset, boundary]
       forHTTPHeaderField:@"Content-Type"];
        
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long) [bodyData length]] forHTTPHeaderField:@"Content-Length"];
    }
    
    
    [request setHTTPBody:bodyData];
    /*
     [[OCNetWorkManager sharedNetWorkManager] POST:apiPath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
     
     NSString *boundary = [NSString stringWithFormat:@"--------------------819560%lld", [DateUtil currentTimeMillis]];
     NSMutableData *postData = [NSMutableData dataWithCapacity:[data length] + 512];
     [postData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     //            [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n\r\n", FORM_FLE_INPUT, [aFilePath lastPathComponent]] dataUsingEncoding:NSUTF8StringEncoding]];
     [postData appendData:data];
     [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
     //        [formData appendPartWithFileData:postData name:@"imageFile" fileName:@"file" mimeType:@"image/png"];
     [formData appendPartWithFormData:postData name:@"imageFile"];
     
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
     NSString *str = [[NSString alloc] initWithData:operation.responseData encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
     NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
     NSError *err;
     NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
     options:NSJSONReadingMutableContainers
     error:&err];
     if (err) {//解析失败
     
     
     }else {//解析成功
     }
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     NSLog(@"反馈请求上传文件错误返回的数据==%@",error);
     
     }];
     
     return nil;
     */
    
    
    
    NSURLSessionUploadTask *task=[[OCNetSessionManager sharedSessionManager] uploadWithRequest:request fileData:nil didSendData:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (progressBlock) {
            progressBlock(bytesSent,totalBytesSent,totalBytesExpectedToSend);
        }
    } onCompletionBlock:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[OCBaseModel class] error:error onCompletionBlock:^(OCResponseResult *responseResult) {
            if (completionBlock) {
                completionBlock(responseResult);
            }
        }];
    }];
    return task;

}

+ (NSURLSessionUploadTask *)uploadPhotoWithImagesArray:(NSArray *)imageArray parmDic:(NSDictionary *)parmDic didSendData:(void (^)(int64_t, int64_t, int64_t))progressBlock onCompletionBlock:(OCResponseResultBlock)completionBlock {
    NSString *apiPath=[self urlWithSuffixPath:@"photo/batchUpload.do"];
    /**
     *  初始化
     */
    __block  NSMutableData *bodyData = [NSMutableData data];
    NSString *boundary = @"0xKhTmLbOuNdArY";
    
    //其他参数 parameterDic
    [parmDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *thisFiledString = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"\r\n\r\n%@",boundary, key, obj];
        [bodyData appendData:[thisFiledString dataUsingEncoding:NSUTF8StringEncoding]];
        [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    //图片 imageArray里面为image的Data数据
    [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *imageDic = (NSDictionary *)obj;
        NSDictionary *fileDic = @{@"data":imageDic[@"imageData"], @"name":imageDic[@"name"], @"mimetype":@"application/octet-stream", @"filename":[NSString stringWithFormat:@"file%ld.png",idx]};
        NSArray *fileBePostArray = [NSArray arrayWithObject:fileDic];
        [fileBePostArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *thisDataObject = (NSDictionary *)obj;
            NSString *thisFileldString = [NSString stringWithFormat:@"--%@\r\nContent-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\nContent-Type: %@\r\nContent-Transfer-Encoding: binary\r\n\r\n",boundary, thisDataObject[@"name"], thisDataObject[@"filename"], thisDataObject[@"mimetype"]];
            [bodyData appendData:[thisFileldString dataUsingEncoding:NSUTF8StringEncoding]];
            [bodyData appendData:thisDataObject[@"data"]];
            [bodyData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }];
    }];

    [bodyData appendData:[[NSString stringWithFormat:@"--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:apiPath]];
    [request setHTTPMethod:@"POST"];
    NSString *charset = (__bridge NSString *)CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    if (imageArray.count) {
        [request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=%@; boundary=%@",charset, boundary] forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    }
    [request setHTTPBody:bodyData];
    
    NSURLSessionUploadTask *task = [[OCNetSessionManager sharedSessionManager] uploadWithRequest:request fileData:nil didSendData:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        if (progressBlock) {
            progressBlock(bytesSent, totalBytesSent, totalBytesExpectedToSend);
        }
    } onCompletionBlock:^(id responseData, NSError *error) {
        [OCBaseNetService parseOCResponseObject:responseData modelClass:[OCBaseModel class] error:error onCompletionBlock:^(OCResponseResult *responseResult) {
            if (completionBlock) {
                completionBlock(responseResult);
            }
        }];
    }];
    
    return task;
    
}
@end
