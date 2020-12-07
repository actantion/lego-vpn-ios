//
//  UIView+tool.h
//  categoryTest
//
//  Created by 段贤才 on 16/6/22.
//  Copyright © 2016年 volientDuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (tool)

#pragma mark [frame]

/**
*  view的x(横)坐标
*/
@property (nonatomic, assign)CGFloat v_x;
/**
 *  view的y(纵)坐标
 */
@property (nonatomic, assign)CGFloat v_y;
/**
 *  view的宽度
 */
@property (nonatomic, assign)CGFloat v_w;
/**
 *  view的高度
 */
@property (nonatomic, assign)CGFloat v_h;


#pragma mark [layer]

/**
 *  view的圆角半径
 */
@property (nonatomic, assign)CGFloat v_cornerRadius;


/**
 *  设置(部分)圆角 以及 圆角半径
 *
 *  @param radius      圆角半径
 */
- (void)setBorderAndCornerRadius:(CGFloat)radius topLeft:(BOOL)topleft topRight:(BOOL)topright bottomLeft:(BOOL)bottomleft topRight:(BOOL)bottomright;

//画半圆圈
- (void)drawCircle:(CGFloat)height;

@end
