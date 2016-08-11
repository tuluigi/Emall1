//
//  EMHomeCatCell.h
//  EMall
//
//  Created by Luigi on 16/7/3.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMHomeCatCell;
@class EMHomeCatModel;
@protocol EMHomeCatCellDelegate <NSObject>

- (void)homeCatCell:(EMHomeCatCell *)cell didSelectItem:(EMHomeCatModel *)catModel;

@end

@interface EMHomeCatCell : UICollectionViewCell
@property (nonatomic,strong)NSArray *catModelArray;
@property (nonatomic,weak) id <EMHomeCatCellDelegate>delegate;
@end
