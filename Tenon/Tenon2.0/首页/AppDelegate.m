//
//  AppDelegate.m
//  Tenonvpn
//
//  Created by Raobin on 2020/8/30.
//  Copyright © 2020 Raobin. All rights reserved.
//

#import "AppDelegate.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "MainViewController.h"
#import "ADViewController.h"
#import "libp2p/libp2p.h"

NSString  *GlobalLanguePath;
NSString* GlobalMonitorString;
@interface AppDelegate ()
@end

@implementation AppDelegate

#pragma mark 在应用程序加载完毕之后调用
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ADViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ADViewController"];
    mainVC.FROM = @"MAIN";
    UINavigationController *na=[[UINavigationController alloc] initWithRootViewController:mainVC];
    na.navigationBar.barStyle = UIBarStyleBlack;
    na.navigationBarHidden=YES;
    na.interactivePopGestureRecognizer.delegate = nil;
    self.window.rootViewController=na;
    [self.window makeKeyAndVisible];
    
    [self loadKeyboard];      //设置全局键盘弹出规则
    [self configAppLangue];
    return YES;
}

#pragma mark 程序失去焦点的时候调用（不能跟用户进行交互了，类似接电话）
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

#pragma mark 当应用程序进入后台的时候调用（点击HOME键）
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    printf("applicationDidEnterBackground called!");
//    [LibP2P Destroy];
}

#pragma mark 当应用程序进入前台的时候调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

#pragma mark 当应用程序获取焦点的时候调用
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

#pragma mark 程序在某些情况下被终结时会调用这个方法（例如强制杀死进程）
- (void)applicationWillTerminate:(UIApplication *)application {
    printf("applicationWillTerminate called!");
    [LibP2P Destroy];
}

/* 全局键盘自动弹出设置 */
-(void)loadKeyboard
{
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量
    keyboardManager.enable = YES; // 控制整个功能是否启用
    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘
    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义
    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框
    keyboardManager.enableAutoToolbar = NO; // 控制是否显示键盘上的工具条
    keyboardManager.shouldShowToolbarPlaceholder = NO; // 是否显示占位文字
    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体
    keyboardManager.keyboardDistanceFromTextField = 110.0f; // 输入框距离键盘的距离
}

-(void)configAppLangue{
    
}

@end
