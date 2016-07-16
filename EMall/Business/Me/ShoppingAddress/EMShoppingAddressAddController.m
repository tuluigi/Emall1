//
//  EMShoppingAddressAddController.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "EMShoppingAddressAddController.h"
#import "OCUTableCellHeader.h"

typedef NS_ENUM(NSInteger,EMShopAddressItemType) {
    EMShopAddressItemTypeUserName       =1,//用户名
    EMShopAddressItemTypeTel            ,
    EMShopAddressItemTypeWeChat         ,
    EMShopAddressItemTypeProvience      ,//省
    EMShopAddressItemTypeCity           ,//城市
    EMShopAddressItemTypeStreet         ,//街道
    EMShopAddressItemTypeDetailAddress  ,//详细地址
    EMShopAddressItemTypeIsDefault      ,//是否默认
};

@interface EMShoppingAddressAddController ()
@property (nonatomic,strong)EMShopAddressModel *addressModel;

@end

@implementation EMShoppingAddressAddController
+(EMShoppingAddressAddController *)shoppingAddrssControllerWithAddressModel:(EMShopAddressModel *)addressModel{
    EMShoppingAddressAddController *addController=[[EMShoppingAddressAddController alloc]  init];
    addController.addressModel=addressModel;
    return addController;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    if (nil==self.addressModel) {
        self.navigationItem.title=@"添加收获地址";
    }else{
        self.navigationItem.title=@"修改收获地址";
    }
    
    OCTableCellTextFiledModel   *textFieldModel   =[[OCTableCellTextFiledModel alloc] initWithTitle:@"收货人" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeUserName];
    
     OCTableCellTextFiledModel   *telFieldModel   =[[OCTableCellTextFiledModel alloc] initWithTitle:@"联系电话" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeTel];
    
     OCTableCellTextFiledModel   *wechatFieldModel   =[[OCTableCellTextFiledModel alloc] initWithTitle:@"微信" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeWeChat];
    
    OCTableCellTextFiledModel   *streetFieldModel   =[[OCTableCellTextFiledModel alloc] initWithTitle:@"街道" imageName:nil accessoryType:UITableViewCellAccessoryNone type:EMShopAddressItemTypeStreet];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    
    
    return cell;
}

@end
