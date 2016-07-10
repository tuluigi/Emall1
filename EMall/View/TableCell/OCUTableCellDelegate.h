//
//  OCUTableCellDelegate.h
//  OpenCourse
//
//  Created by Luigi on 15/11/26.
//
//

#ifndef OCUTableCellDelegate_h
#define OCUTableCellDelegate_h

@class OCTableCellSwitchModel;

@protocol OCUTableViewSwitchCellDelegate <NSObject>

-(void)didOCTableSwitchCellValueChanged:(OCTableCellSwitchModel *)cellModel;

@end
#endif /* OCUTableCellDelegate_h */
