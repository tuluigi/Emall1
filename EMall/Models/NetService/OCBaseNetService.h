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
@end
