//
//  OCUTableViewSwitchCell.h
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import "OCUTableViewCell.h"
#import "OCUTableCellDelegate.h"
@class OCTableCellSwitchModel;

@interface OCUTableViewSwitchCell : OCUTableViewCell
@property(nonatomic,weak)id <OCUTableViewSwitchCellDelegate> switchDelegate;
@end
