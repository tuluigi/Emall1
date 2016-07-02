//
//  EMInfiniteView.h
//  EMall
//
//  Created by Luigi on 16/7/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EMInfiniteViewCell;
@class EMInfiniteView;

@protocol EMInfiniteViewDelegate <NSObject>

- (NSInteger)numberOfInfiniteViewCellsInInfiniteView:(EMInfiniteView *)infiniteView;

- (EMInfiniteViewCell *)infiniteView:(EMInfiniteView *)infiniteView cellForRowAtIndex:(NSInteger)index;
- (void)infiniteView:(EMInfiniteView *)infiniteView didSelectRowAtIndex:(NSInteger)index;
@end


@interface EMInfiniteView : UIView
@property (nonatomic,strong,readonly) UICollectionView *collectionView;
@property (nonatomic,weak)id <EMInfiniteViewDelegate> delegate;
@end
