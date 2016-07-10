//
//  OCTableCellSwitchModel.h
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import "OCTableCellModel.h"
#import "OCUTableCellDelegate.h"
@interface OCTableCellSwitchModel : OCTableCellModel
@property(nonatomic,assign) BOOL on;
@property(nonatomic,weak)id <OCUTableViewSwitchCellDelegate> switchDelegate;
@end
