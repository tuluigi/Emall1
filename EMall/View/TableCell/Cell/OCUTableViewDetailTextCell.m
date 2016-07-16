//
//  OCUTableViewDetailTextCell.m
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import "OCUTableViewDetailTextCell.h"
#import "OCTableCellDetialTextModel.h"
@implementation OCUTableViewDetailTextCell


-(void)onInitContentView{
    [super onInitContentView];
    self.detailTextLabel.textColor=[UIColor colorWithHexString:@"#000000"];
    self.detailTextLabel.font=[UIFont oc_systemFontOfSize:13];
}



-(void)setCellModel:(OCTableCellModel *)cellModel{
    [super setCellModel:cellModel];
    [self.detailTextLabel setText:[(OCTableCellDetialTextModel *)cellModel detailText]];
}

@end
