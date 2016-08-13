//
//  OCResponseResult.h
//  OpenCourse
//
//  Created by Luigi on 15/7/2.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OCCodeState) {
    OCCodeStateSuccess      =100,//成功
    OCCodeStateFailed       =101,//所有的失败,包括网络异常和服务器内部异常
    OCCodeStateEmpty          ,//请求成功，但是数据为空
    OCCodeStateParaError    =400,//参数异常
    OCCodeStateNetworkFailure = 1000,//自定义 网络异常
};


FOUNDATION_EXPORT NSString *const OCNetGET;
FOUNDATION_EXPORT NSString *const OCNetPOST;
@interface OCResponseResult : NSObject
@property ( nonatomic, copy)    NSString    *responseMessage;
@property ( nonatomic, assign)   NSInteger   cursor,totalPage;//分页用
@property ( nonatomic, strong)  id          responseData;
@property ( nonatomic, assign)  OCCodeState responseCode;
+(OCResponseResult *)responseResultWithOCResponseObject:(id)responseObject error:(NSError *)aError;
@end


typedef void(^OCResponseResultBlock)(OCResponseResult *responseResult);
typedef void(^OCResponseObjectBlock)(id responseData, NSError *error);
typedef void(^OCResponseDictionaryBlock)(NSDictionary *dic);