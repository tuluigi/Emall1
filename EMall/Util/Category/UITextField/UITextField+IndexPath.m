//
//  UITextField+IndexPath.m
//  EMall
//
//  Created by Luigi on 16/7/10.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "UITextField+IndexPath.h"
#import <objc/runtime.h>

static char TextFiledIndexPath;
@implementation UITextField (IndexPath)
- (void)setIndexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, &TextFiledIndexPath, indexPath, OBJC_ASSOCIATION_RETAIN);
}

- (NSIndexPath *)indexPath{
     id indexPath = objc_getAssociatedObject(self, &TextFiledIndexPath);
    return indexPath;
}
@end
