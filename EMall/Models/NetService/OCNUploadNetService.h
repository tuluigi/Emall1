//
//  OCNUploadNetService.h
//  OpenCourse
//
//  Created by Luigi on 16/4/21.
//
//

#import "OCBaseNetService.h"

@interface OCNUploadNetService : OCBaseNetService
/**
 *  上传图片
 *
 *  @param url             文件路径
 *  @param parmDic         额外参数，可以为nil
 *  @param sentblock       上传进度
 *  @param completionBlock 完成回调
 *
 *  @return NSURLSessionUploadTask
 */
+ (NSURLSessionUploadTask *)uploadPhotoWithFileURL:(NSURL *)url
                                           parmDic:(NSDictionary *)parmDic
                                       didSendData:(void(^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))progressBlock
                                 onCompletionBlock:(OCResponseResultBlock)completionBlock;

/**
 *  以Data格式上传图片
 *
 *  @param data            图片data
 *  @param parmDic         额外参数，可以为nil
 *  @param progressBlock   进度
 *  @param completionBlock 完成回调
 *
 *  @return NSURLSessionUploadTask
 */
+ (NSURLSessionUploadTask *)uploadPhotoWithData:(NSData *)data
                                        parmDic:(NSDictionary *)parmDic
                                       fileType:(NSString *)fileType
                                    didSendData:(void(^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend))progressBlock
                              onCompletionBlock:(OCResponseResultBlock)completionBlock;


/**
 *  传多张图片
 *
 *  @param imageArray      图片Array
 *  @param parmDic         额外参数，可以为nil
 *  @param progressBlock   进度
 *  @param completionBlock 完成回调
 *
 *  @return
 */
+ (NSURLSessionUploadTask *)uploadPhotoWithImagesArray:(NSArray *)imageArray
                                               parmDic:(NSDictionary *)parmDic
                                           didSendData:(void(^)(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpetecedTosend))progressBlock
                                     onCompletionBlock:(OCResponseResultBlock)completionBlock;
@end
