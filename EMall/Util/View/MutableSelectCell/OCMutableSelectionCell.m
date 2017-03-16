//
//  OCMutableSelectionCell.m
//  OpenCourse
//
//  Created by Luigi on 15/12/22.
//
//

#import "OCMutableSelectionCell.h"

@implementation OCMutableSelectionCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *selectBackgroundView=[[UIView alloc]  init];
        selectBackgroundView.backgroundColor=[UIColor clearColor];
        self.selectedBackgroundView=selectBackgroundView;
        
    }
    return self;
}
- (void)layoutSubviews
{
   
    CGFloat systemVerson=[[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVerson>=8.0) {
        for(UIView *subsubview in [self subviews]){
            if ([NSStringFromClass([subsubview class]) isEqualToString:@"UITableViewCellEditControl"]){
                for (UIView *itemSubView in subsubview.subviews) {
                    if ([itemSubView isKindOfClass: [UIImageView class]]) {
                        if (self.isSelected) {
                            ((UIImageView *)itemSubView).image = [UIImage imageNamed: @"me_check_selected"];
                        }else{
                            ((UIImageView *)itemSubView).image = [UIImage imageNamed: @"me_check_to_select"];
                        }
                    }
                }
            }
        }
    }else   if (systemVerson>=7.0){
        for (UIView* subview in [self subviews]){
            for(UIView *subsubview in subview.subviews){
                if ([NSStringFromClass([subsubview class]) isEqualToString:@"UITableViewCellEditControl"]){
                    for (UIView *itemSubView in subsubview.subviews) {
                        if ([itemSubView isKindOfClass: [UIImageView class]]) {
                            if (self.isSelected) {
                                ((UIImageView *)itemSubView).image = [UIImage imageNamed: @"me_check_selected"];
                            }else{
                                ((UIImageView *)itemSubView).image = [UIImage imageNamed: @"me_check_to_select"];
                            }
                        }
                    }
                }
            }
        }
    }
     [super layoutSubviews];
}
@end
