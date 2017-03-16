//
//  EMInfiniteView.h
//  EMall
//
//  Created by Luigi on 16/7/2.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMInfiniteViewCell.h"
@class EMInfiniteViewCell;
@class EMInfiniteView;

@protocol EMInfiniteViewDelegate <NSObject>

- (NSInteger)numberOfInfiniteViewCellsInInfiniteView:(EMInfiniteView *)infiniteView;
- (EMInfiniteViewCell *)infiniteView:(EMInfiniteView *)infiniteView cellForRowAtIndex:(NSInteger)index;
- (void)infiniteView:(EMInfiniteView *)infiniteView didSelectRowAtIndex:(NSInteger)index;

@end


@interface EMInfiniteView : UICollectionReusableView
+ (EMInfiniteView *)InfiniteViewWithFrame:(CGRect)frame;
@property (nonatomic,strong,readonly) UICollectionView *collectionView;
@property (nonatomic,assign,readwrite)NSInteger totalNumber;
@property (nonatomic,weak)id <EMInfiniteViewDelegate> delegate;
- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier atIndex:(NSInteger)index;
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
@end
