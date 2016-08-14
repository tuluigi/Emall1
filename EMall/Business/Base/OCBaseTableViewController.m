//
//  OCBaseTableViewController.m
//  OpenCourse
//
//  Created by Luigi on 15/11/23.
//
//

#import "OCBaseTableViewController.h"

@interface OCBaseTableViewController ()
@end

@implementation OCBaseTableViewController
@synthesize tableView=_tableView;
-(id)initWithStyle:(UITableViewStyle)style{
    if (self=[super init]) {
        _tableViewStyle = style;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets=YES;
    // Do any additional setup after loading the view.
}
- (UITableView *)tableView{
    if (nil==_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource=
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdenfier = @"cellIdenfier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdenfier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:cellIdenfier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}
#pragma mark - UITableViewDelegate
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 44;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}


#pragma mark -getter setter
//- (UITableView *)tableView {
//    if (nil==_tableView) {
//        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
//        _tableView.dataSource = self;
//        _tableView.delegate = self;
//        _tableView.tableFooterView=[UIView new];
//        
//    }
//    return _tableView;
//}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [[NSMutableArray alloc] init];
    }
    return _dataSourceArray;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
