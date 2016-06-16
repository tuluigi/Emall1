//
//  OCBaseModel.m
//  OpenCourse
//
//  Created by 徐坤 on 15/7/3.
//
//

#import "OCBaseModel.h"

@implementation OCBaseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{};
}
- (void)setNilValueForKey:(NSString *)key {
    [self setValue:@0 forKey:key];  // For NSInteger/CGFloat/BOOL
}

@end
