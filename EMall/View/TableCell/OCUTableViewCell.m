//
//  OCUTableViewCell.m
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import "OCUTableViewCell.h"
#import "OCTableCellModel.h"

@interface OCUTableViewCell()
@property(nonatomic,strong)UIView *redCircle;

@end

@implementation OCUTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle   =UITableViewCellSelectionStyleGray;
        self.separatorInset   = UIEdgeInsetsMake(0, 13, 0, 0);
        [self onInitContentView];
    }
    return self;
}
-(void)onInitContentView{
    self.textLabel.font=[UIFont oc_systemFontOfSize:15];
    self.textLabel.textColor=[UIColor colorWithHexString:@"#00000"];

}


- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType{
    if (accessoryType==UITableViewCellAccessoryDisclosureIndicator) {
//        if (!self.accessoryView) {
//            UIImageView *checkmark = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"button_Checkmark"]];
//            self.accessoryView = checkmark;
//        }
    }else{
        self.accessoryView=nil;
    }
    [super setAccessoryType:accessoryType];
}
-(void)setCellModel:(OCTableCellModel *)cellModel{
    _cellModel=cellModel;
    self.textLabel.text=cellModel.title;
    if (cellModel.imageName.length) {
        if ([cellModel.imageName hasPrefix:@"http://"]||[cellModel.imageName hasPrefix:@"https://"]||[cellModel.imageName hasPrefix:@"www."]) {
            [self.imageView setImageName:cellModel.imageName placeholderImageName:@"icon_me_userHeader" original:NO animated:NO success:^(UIImage *image) {
                
            }];

        }else if([cellModel.imageName hasPrefix:NSHomeDirectory()]){
            self.imageView.image=[UIImage imageWithContentsOfFile:cellModel.imageName];
        }else{
            self.imageView.image=[UIImage imageNamed:cellModel.imageName];
        }
    }else{
        self.imageView.image=nil;
    }
    self.accessoryType=cellModel.accessoryType;
}
@end
