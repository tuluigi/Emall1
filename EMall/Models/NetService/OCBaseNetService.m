//
//  OCBaseNetService.m
//  OpenCourse
//
//  Created by Luigi on 15/8/20.
//
//

#import "OCBaseNetService.h"
#import "OCBaseModel.h"
@implementation OCBaseNetService
+(void)parseOCResponseObject:(id)responseObject modelClass:(Class )modelClass error:(NSError *)error onCompletionBlock:(OCResponseResultBlock)completionBlock{
    OCResponseResult *responseResult=[OCResponseResult responseResultWithOCResponseObject:responseObject error:error];
    if (responseResult.responseData != nil && responseResult.responseData != [NSNull null]&&modelClass ){
        if ([responseResult.responseData isKindOfClass:[NSDictionary class]]) {
            NSError *aError;
            MTLModel *dataModel=[MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:responseResult.responseData error:&aError];
            if (dataModel&&nil==aError) {
                responseResult.responseData=dataModel;
            }
        }else if ([responseResult.responseData isKindOfClass:[NSArray class]]){
            NSError *aError;
            responseResult.responseData = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:responseResult.responseData error:&aError];
            if (aError) {
                
            }
        }else if ([responseResult.responseData isKindOfClass:[NSString class]]){
            //如果是字符串,暂时不做处理

        }
    }
    if ([NSThread isMainThread]) {
        if (completionBlock) {
            completionBlock(responseResult);
        }
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
            completionBlock(responseResult);
            }
        });
    }
}


#pragma mark - 测试服务器
//static NSString const *DomainHost  = @"http://www.tulip.city:7080/shop_server/";
//static NSString const *DomainHost  = @"http://www.tulip.city:82/shop_server/";
static NSString const *DomainHost  = @"http://180.153.58.144:8081/";

#pragma mark - 正式服务器

//static NSString const *DomainHost  = @"http://www.hichigo.com.au:8081/";


+(NSString *)urlWithSuffixPath:(NSString *)str{
    if (str&&str.length) {
        if ([str hasPrefix:@"http://"]||[str hasPrefix:@"https://"]||[str hasPrefix:@"www."]) {
            
        }else{
            str=[NSString stringWithFormat:@"%@%@",DomainHost,str];
        }
    }
    return str;
}
@end
