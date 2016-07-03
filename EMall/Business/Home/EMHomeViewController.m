//
//  EMHomeViewController.m
//  EMall
//
//  Created by Luigi on 16/6/22.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMHomeViewController.h"
#import "EMInfiniteView.h"
#import "EMHomeCatCell.h"
#import "EMHomeModel.h"
@interface EMHomeViewController ()<EMInfiniteViewDelegate>
@property (nonatomic,strong)EMInfiniteView *infiniteView;
@property (nonatomic,strong)NSMutableArray *adArray;
@property (nonatomic,strong)EMHomeModel *homeModel;

@end

@implementation EMHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title=@"海吃GO";
    self.tableView.tableHeaderView=self.infiniteView;
    [self.tableView registerClass:[EMHomeCatCell class] forCellReuseIdentifier:NSStringFromClass([EMHomeCatCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -EMInfiniteVieDelegate
- (NSInteger)numberOfInfiniteViewCellsInInfiniteView:(EMInfiniteView *)infiniteView{
    return self.adArray.count;
}

- (EMInfiniteViewCell *)infiniteView:(EMInfiniteView *)infiniteView cellForRowAtIndex:(NSInteger)index{
    return nil;
}
- (void)infiniteView:(EMInfiniteView *)infiniteView didSelectRowAtIndex:(NSInteger)index{
    
}

#pragma mark -tableview Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * aCell;
    if (indexPath.row==0) {
        EMHomeCatCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EMHomeCatCell class]) forIndexPath:indexPath];
        cell.catModelArray=self.homeModel.catArray;
        aCell=cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
        if (nil==cell) {
            cell=[[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        }
        aCell=cell;
    }
   
    return aCell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}
#pragma mark - getter
-(EMInfiniteView *)infiniteView{
    if (nil==_infiniteView) {
        _infiniteView=[[EMInfiniteView alloc]  initWithFrame:CGRectMake(0, 0, OCWidth, OCUISCALE(170))];
        _infiniteView.delegate=self;
    }
    return _infiniteView;
}
@end
