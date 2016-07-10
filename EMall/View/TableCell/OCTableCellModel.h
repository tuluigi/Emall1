//
//  OCTableCellModel.h
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import <Foundation/Foundation.h>

@interface OCTableCellModel : NSObject
@property(nonatomic ,assign) NSInteger type;
@property(nonatomic ,copy)   NSString *title;

/**
 *  可以是url,本机图片,项目图片
 */
@property(nonatomic ,copy)   NSString *imageName;
@property(nonatomic, assign) UITableViewCellAccessoryType accessoryType;

@property(nonatomic, assign) UITableViewCellStyle tableCellStyle;
@property(nonatomic, copy)  NSString *cellClassName;

@property(nonatomic,copy)NSString *reusedCellIdentifer;

- (instancetype)initWithTitle:(NSString *)title  imageName:(NSString *)imageName accessoryType:(UITableViewCellAccessoryType)accessType type:(NSInteger)type;
/**
 *  初始化，自定义数据用,子类重写
 */
- (void)onInitData;



- (NSString *)reusedCellIdentifer;

- (id)cellWithReuseIdentifer:(NSString *)identifer;
@end
