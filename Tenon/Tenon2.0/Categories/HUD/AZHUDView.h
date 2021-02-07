//
//
//  Created by leiwenkai on 2018/4/25.
//  Copyright © 2018年 com.askzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AZHUDView : UIView
+ (AZHUDView *)manager;

- (void)showInView:(UIView *)view withViewController:(UIViewController*)vc;

- (void)dismiss;
@end
