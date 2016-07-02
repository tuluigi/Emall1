//
//  OCRootTabbarController.m
//  OpenCourse
//
//  Created by Luigi on 15/11/23.
//
//

#import "OCRootTabbarController.h"
#import "EMMeViewController.h"
#import "EMCartViewController.h"
#import "EMHomeViewController.h"
#import "EMDiscoveryViewController.h"
@interface OCTbabarItem  : UITabBarItem;
@end
@implementation OCTbabarItem
- (id)initWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    self = [super initWithTitle:title image:image selectedImage:selectedImage];
    [self setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self setSelectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    if (self) {
        
        // Custom initializatio
        [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:OCUISCALE(10)],NSFontAttributeName,UIColorHex(@"#5d5c5c"),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        [self setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:OCUISCALE(10)],NSFontAttributeName,RGB(229, 26, 30),NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
        
        [self setTitlePositionAdjustment:UIOffsetMake(0, -3)];
    }
    return self;
}
@end
@interface OCRootTabbarController ()<UITabBarControllerDelegate>
@property (nonatomic, retain) UIView *tabbarBackgroundView;


@end

@implementation OCRootTabbarController
- (instancetype)init{
    if (self==[super init]) {
        [self onInitRootControllers];
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)onInitRootControllers{
   
    EMHomeViewController *homeViewController=[[EMHomeViewController alloc] init];
    UINavigationController *homeNavController=[[UINavigationController alloc] initWithRootViewController:homeViewController];
    OCTbabarItem *homeTabbarItem=[[OCTbabarItem alloc]  initWithTitle:@"首页" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage   imageNamed:@"tabbar_home_select"]];
    homeNavController.tabBarItem=homeTabbarItem;
    
    EMDiscoveryViewController *catViewController=[[EMDiscoveryViewController alloc] init];
    UINavigationController *catNavController=[[UINavigationController alloc] initWithRootViewController:catViewController];
    OCTbabarItem *catTabbarItem=[[OCTbabarItem alloc]  initWithTitle:@"发现" image:[UIImage imageNamed:@"tabbar_discover"] selectedImage:[UIImage   imageNamed:@"tabbar_discover_select"]];
    catNavController.tabBarItem=catTabbarItem;
    
    EMCartViewController *lessonViewController=[[EMCartViewController alloc] init];
    UINavigationController *lessonNavController=[[UINavigationController alloc] initWithRootViewController:lessonViewController];
    OCTbabarItem *lessonTabbarItem=[[OCTbabarItem alloc]  initWithTitle:@"购物车" image:[UIImage imageNamed:@"tabbar_shop"] selectedImage:[UIImage   imageNamed:@"tabbar_shop_select"]];
    lessonNavController.tabBarItem=lessonTabbarItem;
    
    
    EMMeViewController *meViewController=[[EMMeViewController alloc]  initWithStyle:UITableViewStyleGrouped];
    UINavigationController *meNavController=[[UINavigationController alloc] initWithRootViewController:meViewController];
    OCTbabarItem *meTabbarItem=[[OCTbabarItem alloc]  initWithTitle:@"我" image:[UIImage imageNamed:@"tabbar_me"] selectedImage:[UIImage   imageNamed:@"tabbar_me_select"]];
    meNavController.tabBarItem=meTabbarItem;
    
    
    UIColor *bgColor=[UIColor whiteColor];
    
    [self.tabBar setBarTintColor:bgColor];
    self.tabBar.opaque=NO;
    self.tabBar.translucent=YES;
    NSArray *controllerArrays=@[homeNavController,catNavController,lessonNavController,meNavController];
    self.viewControllers=controllerArrays;

    
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
