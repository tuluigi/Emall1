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
<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) TPKeyboardAvoidingTableView *tableView;
/**
 *  分页的页码，default = @""
 */
@property (nonatomic, copy) __block NSString *cursor;       //记录新加载数据的个数以及在数组中的位置
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
