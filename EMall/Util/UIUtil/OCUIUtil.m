//
//  OCUIUtil.m
//  OpenCourse
//
//  Created by Luigi on 15/11/30.
//
//

#import "OCUIUtil.h"

static CGFloat OCUISCALE =0;

@implementation OCUIUtil
/**
 *  适配各个大小屏幕后的字体大小
 *
 *  @param fontSize iphone6<750> 的字体大小
 *
 *  @return 适配后的字体大小
 */
+ (CGFloat)scaleFontSize:(CGFloat)fontSize{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGFloat scaleFontSize= fontSize *[OCUIUtil ocCommentScale];
        return scaleFontSize;
    }else{
        return fontSize;
    }
}

/**
 *  UI 缩放比例
 *  该比例是按照iphone6 的尺寸为基准
 *
 *  @return 缩放比例
 */
+ (CGFloat)uiScale:(CGFloat)width{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CGFloat scaleWidth = [OCUIUtil ocCommentScale]*width;
        return scaleWidth;
    }else{
        return width;
    }
}
+ (CGFloat)ocCommentScale{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ((!OCUISCALE)||(0.5>OCUISCALE)||(OCUISCALE>2)) {
            CGFloat scale=1;
            UIInterfaceOrientation interfaceOrientataion = [[UIApplication sharedApplication] statusBarOrientation];
            if (interfaceOrientataion== UIInterfaceOrientationLandscapeLeft || interfaceOrientataion == UIInterfaceOrientationLandscapeRight) {
                scale=([UIScreen mainScreen].bounds.size.height)/375.0f;
            }else{
                scale=([UIScreen mainScreen].bounds.size.width)/375.0f;
            }
            OCUISCALE=scale;
        }
        return OCUISCALE;
    }else{
        return 1;
    }
}

/**
 *  根据标注图字间距计算出实际的字间距
 *
 *  @param fontSize  字体大小
 *  @param fontRatio 字体比率
 *
 *  @return 实际的字间距
 */
+ (long)kerningWithFontSize:(CGFloat)fontSize fontRatio:(CGFloat)fontRatio{
    long  kerning=((fontSize*fontRatio*3)/1000.0);
    return 0;
    return kerning;
}
@end

