

#import <UIKit/UIKit.h>

@interface UILabel (Category)

- (void)setAttributedText:(NSString *)attributedText lineSpacing:(CGFloat)lineSpace;

- (void)setAttributedText:(NSString *)attributedText lineSpacing:(CGFloat)lineSpace characterSpacing:(long)characterSpace lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)setAttributedText:(NSString *)attributedText lineSpacing:(CGFloat)lineSpace characterSpacing:(long)characterSpace lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)alignment;

- (void)changeLineSpacing:(CGFloat)lineSpace characterSpacing:(long)characterSpace;

- (void)changeColor:(UIColor *)color range:(NSRange)range;
- (void)changeColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range;
- (void)changeColor:(UIColor *)color font:(UIFont *)font rangeArray:(NSArray *)rangeArray;

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment;
+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor*)textColor backgroundColor:(UIColor *)backGroundColor textAlignment:(NSTextAlignment)textAlignment;

@end
