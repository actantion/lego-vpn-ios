//
//  UIView+baseExtra.h
//  LR_FrameWork
//
//  Created by LiRun on 15/9/21.
//  Copyright © 2015年 李润. All rights reserved.
//

#import "UIView+baseExtra.h"

@implementation UIView (baseExtra)

- (void)addTapTarget:(id)target action:(SEL)sel{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)addLoogTapTarget:(id)target action:(SEL)sel{
    UILongPressGestureRecognizer  * longPgr = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:sel];
    longPgr.minimumPressDuration = 1;
    [self addGestureRecognizer:longPgr];
}



- (void)removeSubviews{
    for(UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
}

- (UITextField *)textfiled4Tag:(int)tag{
    UIView *view = [self viewWithTag:tag];
    if (view!=nil && [view isKindOfClass:[UITextField class]]) {
        return (UITextField *)view;
    }
    return nil;
}

- (UIButton *)button4Tag:(int)tag{
    UIView *view = [self viewWithTag:tag];
    if (view!=nil && [view isKindOfClass:[UIButton class]]) {
        return (UIButton *)view;
    }
    return nil;
}

- (UILabel *)label4Tag:(int)tag{
    UIView *view = [self viewWithTag:tag];
    if (view!=nil && [view isKindOfClass:[UILabel class]]) {
        return (UILabel *)view;
    }
    return nil;
}

- (UIImageView *)imageView4Tag:(int)tag{
    UIView *view = [self viewWithTag:tag];
    if (view!=nil && [view isKindOfClass:[UIImageView class]]) {
        return (UIImageView *)view;
    }
    return nil;
}



@end
