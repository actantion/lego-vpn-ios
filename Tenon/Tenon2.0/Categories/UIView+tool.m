//
//  UIView+tool.m
//  categoryTest
//
//  Created by 段贤才 on 16/6/22.
//  Copyright © 2016年 volientDuan. All rights reserved.
//

#import "UIView+tool.h"

@implementation UIView (tool)

#pragma mark [frame]
// [GET方法]

- (CGFloat)v_x{
    return self.frame.origin.x;
}

- (CGFloat)v_y{
    return self.frame.origin.y;
}

- (CGFloat)v_w{
    return self.frame.size.width;
}

- (CGFloat)v_h{
    return self.frame.size.height;
}

// [SET方法]

- (void)setV_x:(CGFloat)v_x{
    self.frame = CGRectMake(v_x, self.v_y, self.v_w, self.v_h);
}

- (void)setV_y:(CGFloat)v_y{
    self.frame = CGRectMake(self.v_x, v_y, self.v_w, self.v_h);
}

- (void)setV_w:(CGFloat)v_w{
    self.frame = CGRectMake(self.v_x, self.v_y, v_w, self.v_h);
}

- (void)setV_h:(CGFloat)v_h{
    self.frame = CGRectMake(self.v_x, self.v_y, self.v_w, v_h);
}


#pragma mark [layer]

- (CGFloat)v_cornerRadius{
    return self.layer.cornerRadius;
}

- (void)setV_cornerRadius:(CGFloat)v_cornerRadius{
    self.layer.cornerRadius = v_cornerRadius;
    self.layer.masksToBounds = YES;
}

- (void)setBorderAndCornerRadius:(CGFloat)radius topLeft:(BOOL)topleft topRight:(BOOL)topright bottomLeft:(BOOL)bottomleft topRight:(BOOL)bottomright
{
    // 先清除原有的圆角
    self.layer.mask = [CAShapeLayer layer];
    for (CAShapeLayer *layer in self.layer.sublayers) {
        if (layer.lineWidth == 1) {
            [layer removeFromSuperlayer];
        }
    }
    // 设置新的
    UIRectCorner cornerDir = 0;
    if (topleft) {
        cornerDir = UIRectCornerTopLeft;
    }
    if (topright) {
        cornerDir = cornerDir | UIRectCornerTopRight;
    }
    if (bottomleft && topleft) {
        cornerDir = cornerDir | UIRectCornerBottomLeft;
    }else if(bottomleft){
        cornerDir = UIRectCornerBottomLeft;
    }
    if (bottomright) {
        cornerDir = cornerDir | UIRectCornerBottomRight;
    }
    CGRect aframe = self.bounds;
    //    aframe.size.width += 30;
    //    aframe.size.height += 1;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:aframe byRoundingCorners:cornerDir cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.path = path.CGPath;
    borderLayer.frame = self.bounds;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = [UIColor lightGrayColor].CGColor;
    borderLayer.lineWidth = 1;
    
    self.layer.mask = maskLayer;
    [self.layer addSublayer:borderLayer];
}

//画半圆圈
- (void)drawCircle:(CGFloat)height{
    CGFloat width = kWIDTH - 32;

    //半径
    CGFloat radius = 8;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(width, 0)];
    [path addLineToPoint:CGPointMake(width, 120-4 - radius)];
    [path addArcWithCenter:CGPointMake(width, 120) radius:radius startAngle:1.5 * M_PI endAngle:0.5 * M_PI clockwise:NO]; // 右面凹巢
    [path addLineToPoint:CGPointMake(width, height)];
    [path addLineToPoint:CGPointMake(0, height)];
    [path addLineToPoint:CGPointMake(0, 120-4 + radius)];
    [path addArcWithCenter:CGPointMake(0, 120) radius:radius startAngle:0.5 * M_PI endAngle:1.5 * M_PI clockwise:NO]; // 左面凹巢
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = path.CGPath;
    self.layer.mask = maskLayer;
}


@end
