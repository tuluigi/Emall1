//
//  OCResponseResult.h
//  OpenCourse
//
//  Created by Luigi on 15/7/2.
//
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, OCCodeState) {
    OCCodeStateSuccess      =200,//成功
    OCCodeStateFailed       =1,//所有的失败,包括网络异常和服务器内部异常
    OCCodeStateEmpty          ,//请求成功，但是数据为空
    OCCodeStateParaError    =400,//参数异常
    OCCodeStateUnLogin      =401,//未登录，需要登录
    OCCodeStateNoAccess     =403,//没有访问权限
    OCCodeStateInExistence  =410,//已被删除或不存在
    OCCodeStateNonSupportType=415,//不支持type类型
    OCCodeStateSeverError   =500,//服务器异常
    OCCodeStateSeverUnAvaiable =503,//服务器不可用
    OCCodeStateNetworkFailure = 1000,//自定义 网络异常
    OCCodeStateNameExisted = -10 ,     //该昵称已存在
    OCCodeStateNameForbidden = 412    //敏感词
};


FOUNDATION_EXPORT NSString *const OCNetGET;
FOUNDATION_EXPORT NSString *const OCNetPOST;
@interface OCResponseResult : NSObject
@property ( nonatomic, copy)    NSString    *responseMessage;
@property ( nonatomic, copy)    NSString    *cursor;//分页用
@property ( nonatomic, strong)  id          responseData;
@property ( nonatomic, assign)  OCCodeState responseCode;
+(OCResponseResult *)responseResultWithOCResponseObject:(id)responseObject error:(NSError *)aError;
@end


typedef void(^OCResponseResultBlock)(OCResponseResult *responseResult);
typedef void(^OCResponseObjectBlock)(id responseData, NSError *error);
typedef void(^OCResponseDictionaryBlock)(NSDictionary *dic);