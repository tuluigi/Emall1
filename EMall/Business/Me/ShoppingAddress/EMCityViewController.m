//
//  EMCityViewController.m
//  EMall
//
//  Created by Luigi on 16/8/12.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMCityViewController.h"
#import "EMAreaModel.h"


@interface EMCityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)NSInteger pageInde,selectIndex;
//@property (nonatomic,strong)NSMutableArray *dataSourceArray;
//@property (nonatomic,strong)UITableView *tableView;
@end

@implementation EMCityViewController

-(void)viewDidLoad{
    [super viewDidLoad];
//    [self.view addSubview:self.tableView];
//    self.automaticallyAdjustsScrollViewInsets=YES;
//        self.edgesForExtendedLayout=UIRectEdgeNone;
    self.tableView.separatorStyle=UITableViewCellSelectionStyleNone;
    
      [self.tableView reloadData];
}
//-(UITableView *)tableView{
//    if (nil==_tableView) {
//        _tableView=[[UITableView alloc]  initWithFrame:self.view.bounds style:UITableViewStylePlain];
//        _tableView.delegate=self;
//        _tableView.dataSource=self;
//        _tableView.tableFooterView=[UIView new];
//        
//    }
//    return _tableView;
//}
- (void)setAreas:(NSMutableArray *)array selectIndex:(NSInteger)selectIndex{
    self.dataSourceArray=array;
    self.selectIndex=selectIndex;
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}
- (void)setSelectIndex:(NSInteger)selectIndex{
    if (_selectIndex!=selectIndex) {
       //  [self updaetCellTextColorWithOldSelectRow:_selectIndex latestRow:selectIndex];
        _selectIndex=selectIndex;
    }
}
#pragma mark -tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    if (nil==cell) {
        cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        cell.textLabel.textAlignment=NSTextAlignmentLeft;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        cell.textLabel.font=[UIFont oc_systemFontOfSize:13];
        cell.textLabel.textColor=kEM_LightDarkTextColor;
    }
   
   
    EMAreaModel *areaModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    /*
    if (indexPath.row==self.selectIndex) {
         cell.textLabel.textColor=RGB(229, 24, 31);
    }else{
        cell.textLabel.textColor=kEM_LightDarkTextColor;
    }
     */
    cell.textLabel.text=areaModel.areaName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL isAnother=YES;
    if (self.selectIndex==indexPath.row) {
        isAnother=NO;
    }
    self.selectIndex=indexPath.row;
     EMAreaModel *selectAreaModel=[self.dataSourceArray objectAtIndex:indexPath.row];
    if (_delegate &&[_delegate respondsToSelector:@selector(cityViewControllerDidSelectWithAreadModel:pageInde:isAnother:isUserSelect:)]) {
       
        [_delegate cityViewControllerDidSelectWithAreadModel:selectAreaModel pageInde:self.pageInde isAnother:isAnother isUserSelect:YES];
    }
}
- (void)updaetCellTextColorWithOldSelectRow:(NSInteger)oldRow latestRow:(NSInteger)latestRow{
    if (oldRow<self.dataSourceArray.count &&latestRow <self.dataSourceArray.count) {
        UITableViewCell *oldCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldRow inSection:0]];
        oldCell.textLabel.textColor=kEM_LightDarkTextColor;
        UITableViewCell *latestCell=[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:latestRow inSection:0]];
        latestCell.textLabel.textColor=RGB(229, 24, 31);
    }
   
}
#pragma mark -page delegate
- (void)setUpWhenViewWillAppearForTitle:(NSString *)title forIndex:(NSInteger)index firstTimeAppear: (BOOL)isFirstTime{
    self.pageInde=index;
    if (isFirstTime) {
        self.tableView.frame=self.view.bounds;
    }else{

    }
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
