//
//  EMShopProvienceCityController.m
//  EMall
//
//  Created by Luigi on 16/7/16.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMShopProvienceCityController.h"

@interface EMShopProvienceCityController ()
@property (nonatomic,copy)NSString *provienceID,*provienceName;
@end

@implementation EMShopProvienceCityController
- (instancetype)initWithProvienceID:(NSString *)provienceID provienceName:(NSString *)provienceName;{
    if (self=[super init]) {
        self.provienceID=provienceID;
        self.provienceName=provienceName;
    }
    return self;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    if (self.provienceID) {
        self.navigationItem.title=self.provienceID;
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didSaveButtonPressed)];

    }else{
        self.navigationItem.title=@"选择省份";
    }
}
- (void)didSaveButtonPressed{
    
}
- (void)getProviences{
    
}
- (void)getCitysWithPorvicenID:(NSString *)provienceID{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger row=self.dataSourceArray.count;
    return row;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
NSString *identifer=@"EMShopProvicenCityCellIdenfier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifer];
    if (nil==cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifer];
        
    }
    if ([NSString isNilOrEmptyForString:self.provienceID]) {
        cell.accessoryType=UITableViewCellAccessoryNone;
    }else{
         cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text=[self.dataSourceArray objectAtIndex:indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.provienceID) {
        
    }else{
        NSString *provience=[self.dataSourceArray objectAtIndex:indexPath.row];
        EMShopProvienceCityController *citysViewController=[[EMShopProvienceCityController alloc] initWithProvienceID:provience provienceName:nil];
        citysViewController.delegate=self;
        citysViewController.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:citysViewController animated:YES];
    }
}

#pragma mark delegate
- (void)shopProvicenceCityControllerDidSelectProvienceID:(NSString *)provienceID
                                           provienceName:(NSString *)provienceName
                                                  cityID:(NSString *)cityID
                                                cityName:(NSString *)cityName{
    if (_delegate&&[_delegate respondsToSelector:@selector(shopProvicenceCityControllerDidSelectProvienceID:provienceName:cityID:cityName:)]) {
        [_delegate shopProvicenceCityControllerDidSelectProvienceID:provienceID provienceName:provienceName cityID:cityID cityName:cityName ];
    }
}

@end
