//
//  OCUTableViewCell.h
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import <UIKit/UIKit.h>
@class OCTableCellModel;
@interface OCUTableViewCell : UITableViewCell
@property(nonatomic,strong)OCTableCellModel *cellModel;
-(void)onInitContentView;

@end
