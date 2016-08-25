//
//  UIFont+OCUIUtil.m
//  OpenCourse
//
//  Created by Luigi on 15/11/30.
//
//

#import "UIFont+OCUIUtil.h"
@implementation UIFont (OCUIUtil)
+ (nullable UIFont *)oc_systemFontOfSize:(CGFloat)fontSize{
    UIFont *font;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.2) {
         font=[UIFont systemFontOfSize:OCUIScaleFontSize(fontSize) weight:UIFontWeightRegular];
    }else{
        font=[UIFont systemFontOfSize:OCUIScaleFontSize(fontSize)];
    }
    return font;
}

+ (nullable UIFont *)oc_constantFontOfSize:(CGFloat)fontSize{
    UIFont *font;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.2) {
        font=[UIFont systemFontOfSize:fontSize weight:UIFontWeightThin];
    }else{
        font=[UIFont systemFontOfSize:fontSize];
    }
    return font;
}

+ (nullable UIFont *)oc_systemLightFontOfSize:(CGFloat)fontSize{
    UIFont *font;
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.2) {
        font=[UIFont systemFontOfSize:OCUIScaleFontSize(fontSize) weight:UIFontWeightLight];
    }else{
        font=[UIFont systemFontOfSize:OCUIScaleFontSize(fontSize)];
    }
    return font;
}

+ (nullable UIFont *)oc_boldSystemFontOfSize:(CGFloat)fontSize{
    return [UIFont boldSystemFontOfSize:OCUIScaleFontSize(fontSize)];
}
+ (nullable UIFont *)oc_italicSystemFontOfSize:(CGFloat)fontSize{
    return [UIFont italicSystemFontOfSize:OCUIScaleFontSize(fontSize)];
}

+ (nullable UIFont *)oc_fontWithName:(NSString *)fontName size:(CGFloat)fontSize{
    return [UIFont fontWithName:fontName size:OCUIScaleFontSize(fontSize)];
}

+ (nullable UIFont *)oc_monospacedDigitSystemFontOfSize:(CGFloat)fontSize weight:(CGFloat)weight{
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0) {
        return [UIFont monospacedDigitSystemFontOfSize:OCUIScaleFontSize(fontSize) weight:weight];
    }else{
        return nil;
    }
}
 
@end
