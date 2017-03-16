//
//  NSDate+Category.m
//  OpenCourse
//
//  Created by 徐坤 on 16/2/19.
//
//

#import "NSDate+Category.h"

@implementation NSDate (Category)

- (NSString *)getCommonTimeString {
    
    NSDate* current_date = [[NSDate alloc] init];
    NSTimeInterval time= [current_date timeIntervalSinceDate:self];//间隔的秒数
    int month = ((int)time)/(3600*24*30);
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
    int minute = ((int)time)%(3600*24)/60;
    int secs = ((int)time)%(3600*24);
    
    NSString *dateContent;
    NSDateFormatter *objDateformat = [[NSDateFormatter alloc] init];
    
    if(month!=0){
        if ([self isSameYearByDate:self]) {
            [objDateformat setDateFormat:@"yyyy/MM/dd"];
        }else {
            [objDateformat setDateFormat:@"yyyy/MM/dd"];
        }
        dateContent = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate:self]];
        
    }else if(days!=0){
        if (days>2) {
            if ([self isSameYearByDate:self]) {
                [objDateformat setDateFormat:@"yyyy/MM/dd"];
            }else {
                [objDateformat setDateFormat:@"yyyy/MM/dd"];
            }
            
            dateContent = [NSString stringWithFormat:@"%@",[objDateformat stringFromDate:self]];
            
        }else{
            if (days == 1) {
                dateContent = @"昨天";
            }
            if (days == 2) {
                dateContent = @"前天";
            }
        }
    }else if(hours!=0){
        
        dateContent = [NSString stringWithFormat:@"%d小时前",hours];
        
    }else if(minute!=0){
        
        dateContent = [NSString stringWithFormat:@"%d分钟前",minute];
    }else {
        dateContent = [NSString stringWithFormat:@"%d秒前",secs];
        dateContent = @"刚刚";
    }
    
    
    return dateContent;
    
}

- (BOOL)isSameYearByDate:(NSDate *)date {
    
    NSDateComponents *nowComponents = [[NSCalendar currentCalendar] components: NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger nowYear= [nowComponents year];
    
    NSDateComponents *timeComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    NSInteger timeYear= [timeComponents year];
    
    if (timeYear == nowYear) {
        return YES;
        
    }else {
        return NO;
    }
}
- (NSString *)convertDateToStringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    //    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    //    [dateFormatter setTimeZone:timeZone];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}
@end
