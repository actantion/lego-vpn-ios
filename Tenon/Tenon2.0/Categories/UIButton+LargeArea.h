//
//  UIButton+LargeArea.h
//  OneETrip
//
//  Created by Qiunee on 15/4/24.
//  Copyright (c) 2015年 traveksky. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIButton(EnlargeTouchArea)
/*
 * 加大button点击范围
 */
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;
@end
