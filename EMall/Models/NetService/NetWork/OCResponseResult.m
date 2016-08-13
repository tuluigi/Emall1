//
//  OCResponseResult.m
//  OpenCourse
//
//  Created by Luigi on 15/7/2.
//
//

#import "OCResponseResult.h"
NSString *const OCNetGET=@"GET";
NSString *const OCNetPOST=@"POST";
static NSString *OCNetWorkErrorMessage    = @"网络不给力，请稍后重试";
static NSString *OCFailureMessage = @"数据跑丢了，请点击重试";
@implementation OCResponseResult
+(OCResponseResult *)responseResultWithOCResponseObject:(id)responseObject error:(NSError *)aError{
    OCResponseResult *responeResult=[[OCResponseResult alloc]  init];

    if (responseObject != nil && responseObject != [NSNull null]&&nil==aError ) {
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            [OCResponseResult  parseOCResponesDic:responseObject withResponseResut:&responeResult];
        }else if([responseObject isKindOfClass:[NSData class]]){
            NSError *jsonError;
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:&jsonError];
            if (dic&&nil==jsonError) {
               [OCResponseResult  parseOCResponesDic:dic withResponseResut:&responeResult];
            }else{
                    responeResult.responseCode = OCCodeStateNetworkFailure;
                    responeResult.responseMessage=OCNetWorkErrorMessage;

            }
        }else if ([responseObject isKindOfClass:[NSString class]]){
            NSData *aData=[responseObject dataUsingEncoding:4];
            NSError *jsonError;
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingMutableLeaves error:&jsonError];
            if (dic&&nil==jsonError) {
               [OCResponseResult  parseOCResponesDic:dic withResponseResut:&responeResult];
            }else{
                responeResult.responseCode = OCCodeStateNetworkFailure;
            responeResult.responseMessage=OCNetWorkErrorMessage;
            }
        }else{
                responeResult.responseCode = OCCodeStateNetworkFailure;
                responeResult.responseMessage=OCNetWorkErrorMessage;
        }
    }else{
            responeResult.responseCode = OCCodeStateNetworkFailure;
            responeResult.responseMessage=OCNetWorkErrorMessage;
    }
    return responeResult;
}
+(void)parseOCResponesDic:(NSDictionary *)dic withResponseResut:(OCResponseResult **)aResponseResult{
    OCResponseResult *responeResult= *aResponseResult;
    responeResult.responseCode    =[[dic objectForKey:@"code"] integerValue];
    responeResult.responseMessage =[dic objectForKey:@"message"];
    responeResult.cursor          =[[dic objectForKey:@"cursor"] integerValue];
        responeResult.totalPage          =[[dic objectForKey:@"totalPage"] integerValue];
    responeResult.responseData    =[dic objectForKey:@"data"];
}
@end
