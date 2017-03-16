//
//  OCBaseViewController.m
//  OpenCourse
//
//  Created by Luigi on 15/11/23.
//
//

#import "OCBaseViewController.h"

@interface OCBaseViewController ()

@end

@implementation OCBaseViewController
- (void)dealloc{
#ifdef DEBUG
    NSLog(@"\n %@ is dealloced",self);
#endif
    [self cancelSessionTasks];
    [self.view dismissHUDLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

  
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}
-(NSInteger)cursor{
    _cursor=MAX(_cursor, 1);
    return _cursor;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.cursor = 1;
    // Do any additional setup after loading the view
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.modalPresentationCapturesStatusBarAppearance = NO;        // Load resources for iOS 7 or later
        self.navigationController.navigationBar.translucent=YES;
        [self.navigationController.navigationBar setBarTintColor:RGB(229, 26, 30)];//377d46//2c6748
        self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
        self.navigationController.navigationBar.opaque=YES;
        
    }
    self.view.backgroundColor=[UIColor whiteColor];
//    self.view.backgroundColor=RGB(241, 243, 240);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return NO;
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
