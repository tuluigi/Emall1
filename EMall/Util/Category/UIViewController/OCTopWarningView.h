//
//  OCTopWarningView.h
//  OpenCourse
//
//  Created by 姜苏珈 on 15/12/4.
//
//

#import "FXBlurView.h"
@interface OCTopWarningView : FXBlurView
@property (nonatomic, strong) NSString *warningText;
@property (nonatomic, strong) NSString *textColor;
@property (nonatomic, copy) dispatch_block_t tapHandler;
@property (nonatomic, assign) float dismissDelay;

+ (CGSize)sizeOfwarningView;
@end
