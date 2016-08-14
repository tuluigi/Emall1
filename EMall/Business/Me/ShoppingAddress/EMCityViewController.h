//
//  EMCityViewController.h
//  EMall
//
//  Created by Luigi on 16/8/12.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "OCBaseTableViewController.h"
#import "ZJScrollPageViewDelegate.h"

@class EMAreaModel;
@protocol EMCityViewControlelrDelegate <NSObject>

- (void)cityViewControllerDidSelectWithAreadModel:(EMAreaModel *)aremModel
                                         pageInde:(NSInteger )pageIndex
                                        isAnother:(BOOL)isAnother
                                     isUserSelect:(BOOL)isSelect;
@end

@interface EMCityViewController : OCBaseViewController<ZJScrollPageViewChildVcDelegate>
- (void)setAreas:(NSMutableArray *)array selectIndex:(NSInteger)selectIndex;
@property (nonatomic,weak)id <EMCityViewControlelrDelegate>delegate;
@end
