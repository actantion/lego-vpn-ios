//
//  UIColor+Extension.h
//  RunningMan
//
//  Created by Seven Lv on 15/12/29.
//  Copyright © 2015年 Toocms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

+ (UIColor *)colorWithHex:(NSInteger)hexValue;
+ (UIColor *)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (NSString *)hexFromUIColor:(UIColor *)color;


+ (UIColor *)hexColor:(NSString *)hex;

@end
