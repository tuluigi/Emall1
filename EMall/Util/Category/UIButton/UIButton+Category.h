

#import <UIKit/UIKit.h>

@interface UIButton (Category)

+ (UIButton *)buttonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor font:(UIFont *)font;

@end

@interface UIButton (UIButtonExt)
- (void)centerImageAndTitle:(float)space;
- (void)centerImageAndTitle;
@end