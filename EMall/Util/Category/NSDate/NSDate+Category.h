//
//  NSDate+Category.h
//  OpenCourse
//
//  Created by 徐坤 on 16/2/19.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (Category)

- (NSString *)getCommonTimeString;
- (NSString *)convertDateToStringWithFormat:(NSString *)format;
@end
