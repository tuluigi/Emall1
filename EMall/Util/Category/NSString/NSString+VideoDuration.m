//
//  NSString+VideoDuration.m
//  OpenCourse
//
//  Created by Luigi on 15/12/3.
//
//

#import "NSString+VideoDuration.h"

@implementation NSString (VideoDuration)
+ (NSString *)durationDataStingWithVideoSeconds:(CGFloat)videoSeconds{
    CGFloat pre=60.0;
    NSInteger hour=0,minute=0,second=0;
    hour=(NSInteger)(videoSeconds/(pre*pre));
    minute=(NSInteger)((videoSeconds-hour*pre*pre)/pre);
    second=(NSInteger)(videoSeconds-hour*pre*pre-minute*pre);
    NSString *timeStr=@"";
    if (hour) {
        timeStr=[NSString stringWithFormat:@"%ld时",(long)hour];
    }
    if (minute) {
        timeStr=[timeStr stringByAppendingString:[NSString stringWithFormat:@"%ld分",(long)minute]];
    }
    if (second) {
        timeStr=[timeStr stringByAppendingString:[NSString stringWithFormat:@"%ld秒",(long)second]];
    }
    return timeStr;
}

+ (NSString *)hourMinuteStingWithVideoSeconds:(CGFloat)videoSeconds{
    CGFloat pre=60.0;
    NSInteger hour=0,minute=0,second=0;
    hour=(NSInteger)(videoSeconds/(pre*pre));
    minute=(NSInteger)((videoSeconds-hour*pre*pre)/pre);
    second=(NSInteger)(videoSeconds-hour*pre*pre- minute*pre);
    NSString *timeStr=@"";
    if (hour) {
        timeStr=[NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)hour,minute,second];
    }else{
          timeStr=[NSString stringWithFormat:@"%.2ld:%.2ld",(long)minute,second];
    }
//        timeStr=[NSString stringWithFormat:@"%.2ld:",hour];
//        timeStr=[timeStr stringByAppendingString:[NSString stringWithFormat:@"%.2ld",minute]];
    return timeStr;
}
+ (NSString *)tenThousandUnitString:(NSInteger)numberValue{
    NSString *str=@"";
    NSInteger unit=10000;
    if (numberValue<unit) {//小于1w 显示实际数字
        str=[NSString stringWithFormat:@"%ld",(long)numberValue];
    }else if(numberValue>(10*unit)){//大于10W 只显示整数万
      str=[NSString stringWithFormat:@"%ld万",(long)(numberValue/unit)];
    }else{//1W--10W 之间，整数万 没有小数点，非整数万有1位小数
        NSInteger remainderValue= numberValue%unit;
        if (remainderValue==0) {//整数万
            str=[NSString stringWithFormat:@"%ld万",(long)(numberValue/unit)];
        }else{
            CGFloat count=(numberValue/(unit*1.0)) ;
            NSString *countString=[self notRounding:count afterPoint:1];
            str=[NSString stringWithFormat:@"%@万",countString];
        }
    }
    return str;
}
+(NSString *)notRounding:(CGFloat)price afterPoint:(NSInteger)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:price];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}
+ (NSString *)byteStringFormatted:(unsigned long long)byte{
    NSString *str=@"";
    if (byte>1024*1024*1024) {
        str=[NSString stringWithFormat:@"%.1fGB",byte/(1024.0*1024.0*1024)];
    }else if (byte>=1024*1024) {
        str=[NSString stringWithFormat:@"%.1fMB",byte/(1024.0*1024.0)];
    }else{
        str=[NSString stringWithFormat:@"%.1fKB",byte/(1024.0)];
    }
    return str;
}
@end
