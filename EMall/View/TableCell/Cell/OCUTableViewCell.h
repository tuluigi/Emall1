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

//需要子类实现创建,创建view
-(void)onInitContentView;

@end
