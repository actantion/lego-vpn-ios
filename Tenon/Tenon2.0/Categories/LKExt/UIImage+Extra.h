//
//  UIImage+Extra.h
//  LRFrameWorks
//
//  Created by Mac on 16/7/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extra)
/**
 *  根据color生成一张1X1大小的纯色图片
 */
+ (UIImage *)lr_imageWithColor:(UIColor *)color;
/**
 *根据color生成一张size大小的纯色图片
 */
+ (UIImage *)lr_imageWithColor:(UIColor *)color size:(CGSize)size;
//+(instancetype)looha_none_imageNamed:(NSString*)name;
//+(void)load;
/**
 *  生成一个带圆环的图片
 *
 *  @param img   图片
 *  @param border 圆环的宽度
 *  @param color  圆环的颜色
 *
 */
+ (instancetype)imageWithImg:(UIImage*)img border:(CGFloat)border borderColor:(UIColor *)color;

/**
 *  截屏
 *
 *  @param view 需要截屏的视图
 *
 */
+ (instancetype)imageWithCaptureView:(UIView *)view;

//重绘图片，更改颜色
- (UIImage*)imageChangeColor:(UIColor*)color;

/**
 * 将图片制作成指定比例的新图片

 @param scale 比例
 @param opaque 空白处用:YES黑色填充,NO透明
 *
 */
- (UIImage *)imageToscaleWithwToH:(CGFloat)scale opaque:(BOOL)opaque;


//压缩图片到mb以下的Image
- (UIImage *)compressionImage;


#pragma mark - 压缩图片
/******************************************************************
 函数描述 :压缩图片
 * @param image  被压图片。
 * @param scaleSize  被压比列。
 ********************************************************************/
+(UIImage *)compressPic:(UIImage *)image withScale:(float)scaleSize;

#pragma mark - 压缩图片到指定大小以下
/******************************************************************
 函数描述 :压缩图片到指定大小以下
 * @param image  被压图片。
 * @param size  被压到的大小(单位Kb)。
 ********************************************************************/
+(UIImage *)compressPic:(UIImage *)image toSize:(float)size;

#pragma mark - 压缩图片到指定大小以下
/******************************************************************
 函数描述 :压缩图片到指定大小以下
 * @param image  被压图片。
 * @param size  被压到的大小(单位Kb)。
 ********************************************************************/
+(NSData *)dataCompressPic:(UIImage *)image toSize:(float)size;


/**
 获取玻璃效果图片

 @param radius 模糊大小
 @param iterations 重叠次数
 @param tintColor 填充颜色
 @return img
 */
- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;
//blur 0 ~ 1 模糊度
- (UIImage *)boxblurWithBlurNumber:(CGFloat)blur;

@end
