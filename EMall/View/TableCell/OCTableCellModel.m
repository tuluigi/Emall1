//
//  OCTableCellModel.m
//  OpenCourse
//
//  Created by Luigi on 15/11/25.
//
//

#import "OCTableCellModel.h"

@implementation OCTableCellModel
- (instancetype)initWithTitle:(NSString *)title  imageName:(NSString *)imageName accessoryType:(UITableViewCellAccessoryType)accessType type:(NSInteger)type{
    self=[super init];
    if (self) {
        self.title          =   title;
        self.imageName      =   imageName;
        self.accessoryType  =   accessType;
        self.type           =   type;
        [self onInitData];
 
    }
    return self;
}
-(void)onInitData{
    self.tableCellStyle=UITableViewCellStyleDefault;
}
- (NSString *)reusedCellIdentifer{
    return @"OCTableCellModelIdentifier";
}
- (id)cellWithReuseIdentifer:(NSString *)identifer{
    if (nil==self.cellClassName||[self.cellClassName isEqualToString:@""]) {
        self.cellClassName= @"OCUTableViewCell";
    }
    return [[NSClassFromString(self.cellClassName) alloc] initWithStyle:self.tableCellStyle reuseIdentifier:identifer];
}
@end
