//
//  OCBaseTableViewController.h
//  OpenCourse
//
//  Created by Luigi on 15/11/23.
//
//

#import "OCBaseViewController.h"
#import <TPKeyboardAvoidingTableView.h>
@interface OCBaseTableViewController : OCBaseViewController
<UITableViewDataSource, UITableViewDelegate>{
    UITableView *_tableView;
}

@property (nonatomic, strong,readonly,getter=tableView) UITableView *tableView;

/**
 *  tableview datasource
 */
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
/**
 *  tableview style default is  UITableViewStylePlain
 */
@property (nonatomic, assign) UITableViewStyle tableViewStyle;


- (instancetype)initWithStyle:(UITableViewStyle)style;

@end
