//
//  UIView+PubicColor.m
//  CNUKwallet
//
//  Created by 黄焕林 on 2019/5/31.
//  Copyright © 2019 黄焕林. All rights reserved.
//

#import "UIView+PubicColor.h"

@implementation UIView (PubicColor)

- (UIColor *)bgColor{
    
    return self.backgroundColor;
}

- (void)setBgColor:(UIColor *)bgColor{

    self.backgroundColor = UIColor.whiteColor;
}

@end
