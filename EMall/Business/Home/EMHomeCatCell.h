//
//  EMHomeCatCell.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMHomeCatCell;
@class EMCatModel;
@protocol EMHomeCatCellDelegate <NSObject>

- (void)homeCatCell:(EMHomeCatCell *)cell didSelectItem:(EMCatModel *)catModel;

@end

@interface EMHomeCatCell : UICollectionViewCell
@property (nonatomic,strong)NSArray *catModelArray;
@property (nonatomic,weak) id <EMHomeCatCellDelegate>delegate;
+ (CGSize)homeCatCellSize;
@end
