//
//  AppDelegate.m
//  EMall
//
//  Created by Luigi on 16/6/16.
//  Copyright © 2016年 Luigi. All rights reserved.
//

#import "AppDelegate.h"
#import "OCRootTabbarController.h"
#import <UMMobClick/MobClick.h>

//ShareSDK
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK
#import "WXApi.h"

//新浪微博
#import "WeiboSDK.h"

//一定要先配置自己项目在商店的APPID,配置完最好在真机上运行才能看到完全效果哦
#define STOREAPPID @"1149246338"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)customeApperance{
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    NSDictionary *titleAttibutes = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [UIFont oc_boldSystemFontOfSize:18],NSFontAttributeName,
                                    [UIColor whiteColor],NSForegroundColorAttributeName,
                                     shadow,NSShadowAttributeName,
                                    nil];
    
    [[UINavigationBar appearance] setTitleTextAttributes:titleAttibutes];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

/**
 *  检测app更新
 */
-(void)hsUpdateApp
{
    //先获取当前工程项目版本号
    NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
    //从网络获取appStore版本号
    NSError *error;
    NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",STOREAPPID]]] returningResponse:nil error:nil];
    
    if (response == nil) {
        NSLog(@"你没有连接网络哦");
        return;
    }
    NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSLog(@"hsUpdateAppError:%@",error);
        return;
    }
    NSArray *array = appInfoDic[@"results"];
    NSDictionary *dic = array[0];
    NSString *appStoreVersion = dic[@"version"];
    
    //打印版本号
    NSLog(@"当前版本号:%@\n商店版本号:%@",currentVersion,appStoreVersion);
    BOOL hasNewVersion = [EMCommonInfo compareOldVersion:currentVersion withNewVersion:appStoreVersion];
    //当前版本号小于商店版本号,就更新
    if(hasNewVersion)
    {
        UIAlertController *alter = [UIAlertController alertControllerWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] preferredStyle:UIAlertControllerStyleAlert] ;
        
        [alter addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"取消") ;
        }]] ;
        [alter addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            //此处加入应用在app store的地址，方便用户去更新：
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?ls=1&mt=8", STOREAPPID]];
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }]] ;
        
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alter animated:YES completion:nil] ;
       // UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
        //[alert show];
    }else{
        NSLog(@"版本号好像比商店大噢!检测到不需要更新");
    }
    
}
////更新选择器
//- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //实现跳转到应用商店进行更新
//    if(buttonIndex==1)
//    {
//        //此处加入应用在app store的地址，方便用户去更新：
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?ls=1&mt=8", STOREAPPID]];
//        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//    }
//}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self customeApperance];
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    
/*
 注册PayPal的账号
 */
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"AdKSjd26mmvH96uWHQ-zPRR0zufS75ug7AjtLc8Oqp2OYo3zsO1JUZIOF9SxJl0It7-ZOLF-7pYNLr6V",
                                                           PayPalEnvironmentSandbox : @"Ad-83I7vYVfTMk5GVZScv7qeIliH53HfnNGRTl29VEf8UWdz8--m4RSoqZBz7m1SYAvo1Z5iuLktGDY-"}];
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App,登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    [ShareSDK registerApp:@"17d3686a33471"
          activePlatforms:@[
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformSubTypeQZone),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeSinaWeibo)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
                 case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]] ;
                 break;
                 
                 case SSDKPlatformSubTypeQZone:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]] ;
                 break;
                 
                 case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]] ;
                 break;
                 
                 case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
                 
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
                 switch (platformType)
                 {
                     case SSDKPlatformTypeQQ:
                         [appInfo SSDKSetupQQByAppId:@"1105677795"
                                              appKey:@"unCEpKI9DpyLqzza"
                                            authType:SSDKAuthTypeBoth] ;
                         break;
                         
                     case SSDKPlatformSubTypeQZone:
                         [appInfo SSDKSetupQQByAppId:@"1105677795"
                                              appKey:@"unCEpKI9DpyLqzza"
                                            authType:SSDKAuthTypeBoth] ;
                         break;
                         
                     case SSDKPlatformTypeWechat:
                         [appInfo SSDKSetupWeChatByAppId:@"wx18610948958759cb"appSecret:@"985010fca27475b7a68329408f12bab3"] ;
                         break;
                         
                     case SSDKPlatformTypeSinaWeibo:
                         [appInfo SSDKSetupSinaWeiboByAppKey:@"2870821249"
                                                   appSecret:@"4820c5c48b521d68d77a2ee692d09c77"
                                                 redirectUri:@"http://www.sharesdk.cn"
                                                    authType:SSDKAuthTypeBoth] ;
                         break;
         
                     default:
                         break;
                 }
     }] ;

    
    sleep(2);//客户觉得启动页太快了，所以就等了2秒
    OCRootTabbarController *rootTarbarController=[[OCRootTabbarController alloc]  init];
    self.window.rootViewController=rootTarbarController;
    [self.window makeKeyAndVisible];
    UMConfigInstance.appKey = @"57d0208e67e58ef9110030fa";
    [MobClick setAppVersion:[EMCommonInfo appVersion]];
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    [self hsUpdateApp] ;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
