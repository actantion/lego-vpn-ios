//
//  UIView+baseExtra.h
//  LR_FrameWork
//
//  Created by LiRun on 15/9/21.
//  Copyright © 2015年 李润. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (baseExtra)

/**
 * 添加点击事件
 */
- (void)addTapTarget:(id)target action:(SEL)sel;
// 长按事件
- (void)addLoogTapTarget:(id)target action:(SEL)sel;

/**
 *  删除当前视图的所有子视图
 */
- (void)removeSubviews;

/**
 * 获得文本框
 * @param tag Tag值
 */
- (UITextField *)textfiled4Tag:(int)tag;
- (UIButton *)button4Tag:(int)tag;
- (UILabel *)label4Tag:(int)tag;
- (UIImageView *)imageView4Tag:(int)tag;


@end
