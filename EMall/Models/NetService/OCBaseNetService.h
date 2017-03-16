//
//  OCBaseNetService.h
//  OpenCourse
//
//  Created by Luigi on 15/8/20.
//
//

#import <Foundation/Foundation.h>
#import "OCResponseResult.h"
#import "Mantle.h"
#import "OCNetSessionManager.h"
@interface OCBaseNetService : NSObject

+(void)parseOCResponseObject:(id)responseObject modelClass:(Class )modelClass error:(NSError *)error onCompletionBlock:(OCResponseResultBlock)completionBlock;
/**
 *  根据默认域名生成完整接口地址
 *
 *  @param str 接口名称部分
 *
 *  @return 完整接口地址
 */
+(NSString *)urlWithSuffixPath:(NSString *)str;
@end
