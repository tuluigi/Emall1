//
//  EMGoodsListViewController.h
//  EMall
//
//  Created by Luigi on 16/8/11.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseViewController.h"

@interface EMGoodsListViewController : OCBaseViewController
/**
 *  从分类页面进来的
 *
 *  @param catID
 *  @param catName
 *
 *  @return
 */
- (instancetype)initWithCatID:(NSInteger )catID catName:(NSString *)catName;

/**
 *  从首页进来的
 *
 *  @param typeID type 上架类型 1 = 精品, 2 = 热卖
 *  @param typeName
 *
 *  @return
 */
- (instancetype)initWithHomeType:(NSInteger )typeID typeName:(NSString *)typeName;
@end
