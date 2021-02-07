//
//  DKProgressHUD+LKExt.m
//  ZhongShen
//
//  Created by leiwenkai on 2020/2/14.
//  Copyright © 2020 Chongqing Lanmai Network Technology Co., Ltd. All rights reserved.
//

#import "DKProgressHUD+LKExt.h"
#import "AZHUDView.h"

#define UIViewHUDDismissDuration 1.5f

@implementation DKProgressHUD (LKExt)

+ (void)showHUDHoldOn:(UIViewController*)vc {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[AZHUDView manager] showInView:vc.view withViewController:vc];
    });
     
    
}

+ (void)hiddenHud
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
         [[AZHUDView manager] dismiss];
    });
}
+ (void)dismissHud {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
         [[AZHUDView manager] dismiss];
    });
}

+ (void)dismissHUDWithError:(NSString *)error withViewController:(UIViewController*)vc {
    if (!error) {
        error = @"";
    }
    dispatch_async(dispatch_get_main_queue(), ^(void) {
         [[AZHUDView manager] dismiss];
         [self showErrorWithStatus:error toView:vc.view];
    });
     
    
}

+(void)dismissHUDWithSuccess:(NSString *)success withViewController:(UIViewController*)vc{
    if (!success) {
        success = @"";
    }
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[AZHUDView manager] dismiss];
        [self showSuccessWithStatus:success toView:vc.view];
    });
   
    
}
+ (void)dismissHUDWithErrorDefult {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[AZHUDView manager] dismiss];
//        [self dismissHUDWithError:@"服务器繁忙"];
    });
    
    
}
+ (void)dismissHUDWithSuccessDefult {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[AZHUDView manager] dismiss];
//        [self dismissHUDWithSuccess:nil];
    });
   
//    dispatch_async(dispatch_get_main_queue(), ^{
//
////        [self dismissHUDWithError:@"请求成功"];
//    });
    
}

///自动dismiss
+ (void)showDurationHUD:(NSString *)message {
    if (!message) {
        message = @"";
    }
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [[AZHUDView manager] dismiss];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:ZSWindow animated:YES];
        hud.bezelView.backgroundColor = [UIColor colorWithRed:18 green:181 blue:170 alpha:0.5];//[UIColor colorWithHex:0x alpha:0.5];
            hud.mode = MBProgressHUDModeText;
            hud.detailsLabel.text = NSLocalizedString(message, @"HUD message title");
            hud.detailsLabel.font = [UIFont systemFontOfSize:15];
            hud.detailsLabel.textColor = [UIColor whiteColor];
        //    hud.maxWidth = 300.f;
            [hud hideAnimated:YES afterDelay:UIViewHUDDismissDuration];
    });
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//
////        [self showInfoWithStatus:message toView:[UIViewController currentViewController].view];
//    });
    
    
}

@end
