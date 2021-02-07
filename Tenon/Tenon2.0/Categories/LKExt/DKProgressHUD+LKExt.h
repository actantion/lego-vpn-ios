//
//  DKProgressHUD+LKExt.h
//  ZhongShen
//
//  Created by leiwenkai on 2020/2/14.
//  Copyright © 2020 Chongqing Lanmai Network Technology Co., Ltd. All rights reserved.
//
#import <DKProgressHUD.h>
@interface DKProgressHUD (LKExt)
+ (void)showHUDHoldOn:(UIViewController*)vc;
///dismiss
+ (void)dismissHUDWithError:(NSString *)error withViewController:(UIViewController*)vc;
+(void)dismissHUDWithSuccess:(NSString *)success withViewController:(UIViewController*)vc;
+ (void)dismissHUDWithErrorDefult;
+ (void)dismissHUDWithSuccessDefult;

+ (void)dismissHud;
+ (void)hiddenHud;
///自动dismiss
+ (void)showDurationHUD:(NSString *)message;

@end

