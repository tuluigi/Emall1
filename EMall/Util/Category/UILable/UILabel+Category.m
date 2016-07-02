
#import "UILabel+Category.h"
#import <CoreText/CoreText.h>
@implementation UILabel (Category)
- (void)setAttributedText:(NSString *)attributedText lineSpacing:(CGFloat)lineSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:attributedText];
    if (lineSpace) {
        NSMutableParagraphStyle *paragraphStype = [[NSMutableParagraphStyle alloc] init];
        paragraphStype.lineSpacing = lineSpace;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStype range:NSMakeRange(0, attributedText.length)];
    }

    self.attributedText = attributedString;
}


- (void)setAttributedText:(NSString *)attributedText lineSpacing:(CGFloat)lineSpace characterSpacing:(long)characterSpace lineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [self setAttributedText:attributedText lineSpacing:lineSpace characterSpacing:characterSpace lineBreakMode:lineBreakMode textAlignment:NSTextAlignmentLeft];
}

- (void)setAttributedText:(NSString *)attributedText lineSpacing:(CGFloat)lineSpace characterSpacing:(long)characterSpace lineBreakMode:(NSLineBreakMode)lineBreakMode textAlignment:(NSTextAlignment)alignment {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:attributedText];
    NSMutableParagraphStyle *paragraphStype = [[NSMutableParagraphStyle alloc] init];
    paragraphStype.lineBreakMode = lineBreakMode;
    paragraphStype.alignment = alignment;
    
    if (lineSpace) {
        paragraphStype.lineSpacing = lineSpace;
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStype range:NSMakeRange(0, attributedText.length)];
    
    if (characterSpace) {
        long kerning=[OCUIUtil kerningWithFontSize:[self.font pointSize] fontRatio:characterSpace];
        if (kerning) {
            CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &kerning);
            [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, attributedText.length)];
            CFRelease(num);
        }
    }
    self.attributedText = attributedString;
}
- (void)changeLineSpacing:(CGFloat)lineSpace characterSpacing:(long)characterSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    NSMutableParagraphStyle *paragraphStype = [[NSMutableParagraphStyle alloc] init];
    paragraphStype.lineBreakMode = NSLineBreakByCharWrapping;
    
    if (lineSpace) {
        paragraphStype.lineSpacing = lineSpace;
    }
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStype range:NSMakeRange(0, self.text.length)];
    
    if (characterSpace) {
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &characterSpace);
        [attributedString addAttribute:(id)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0, self.text.length)];
        CFRelease(num);
    }
    
    self.attributedText = attributedString;
}

- (void)changeColor:(UIColor *)color range:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: color} range:range];
    self.attributedText = attributedString;
}

- (void)changeColor:(UIColor *)color font:(UIFont *)font range:(NSRange)range {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedString addAttributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: font} range:range];
    self.attributedText = attributedString;
}

- (void)changeColor:(UIColor *)color font:(UIFont *)font rangeArray:(NSArray *)rangeArray
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    for (NSString *rangeString in rangeArray) {
        NSRange range = NSRangeFromString(rangeString);
        [attributedString addAttributes:@{NSForegroundColorAttributeName: color, NSFontAttributeName: font} range:range];
    }
    self.attributedText = attributedString;
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    label.textAlignment = textAlignment;
    
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor*)textColor textAlignment:(NSTextAlignment)textAlignment {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    [label setTextColor:textColor];
    label.textAlignment = textAlignment;
    
    return label;
}

+ (UILabel *)labelWithText:(NSString *)text font:(UIFont *)font textColor:(UIColor*)textColor backgroundColor:(UIColor *)backGroundColor textAlignment:(NSTextAlignment)textAlignment {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = font;
    [label setTextColor:textColor];
    label.backgroundColor = backGroundColor;
    label.textAlignment = textAlignment;
    
    return label;
}


@end
