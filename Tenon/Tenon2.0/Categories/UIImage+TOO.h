//
//  UIImage+TOO.h
//  CNUKwallet
//
//  Created by 黄焕林 on 2018/11/20.
//  Copyright © 2018 黄焕林. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (TOO)

+ (UIImage *)circleImageWithString:(NSString *)string bgColor:(UIColor *)bgColor size:(CGSize)size WithFont:(UIFont *)font;


/** 获取屏幕截图 */
+(UIImage *) getCurrentScreenShot;
/** 获取某个view 上的截图 */
+(UIImage *) getCurrentViewShot:(UIView *) view;
/** 获取某个scrollview 上的截图 */
+(UIImage *) getCurrentScrollviewShot:(UIScrollView *) scrollview;
/** 获取某个 范围内的 截图 */
+ (UIImage *) getCurrentInnerViewShot: (UIView *) innerView atFrame:(CGRect)rect;
//压缩图片
+(UIImage *)scaleImage:(UIImage *)image toKb:(NSInteger)kb;


+(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

@end

NS_ASSUME_NONNULL_END
