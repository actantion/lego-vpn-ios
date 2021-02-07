//
//  UIImage+Extra.m
//  LRFrameWorks
//
//  Created by Mac on 16/7/8.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "UIImage+Extra.h"
#import <QuartzCore/QuartzCore.h>
#import <Accelerate/Accelerate.h>
@implementation UIImage (Extra)
#pragma mark - 生成图片
#pragma mark ---根据color生成一张1X1大小的纯色图片
+ (UIImage *)lr_imageWithColor:(UIColor *)color
{
    return [self lr_imageWithColor:color size:CGSizeMake(1, 1)];
}

#pragma mark ---根据color生成一张size大小的纯色图片
+ (UIImage *)lr_imageWithColor:(UIColor *)color size:(CGSize)size
{
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark --- 截屏
+ (instancetype)imageWithCaptureView:(UIView *)view
{
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染控制器view的图层到上下文
    // 图层只能用渲染不能用draw
    [view.layer renderInContext:ctx];
    
    // 获取截屏图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}
#pragma mark --- 生成一个带圆环的图片
+ (instancetype)imageWithImg:(UIImage*)img border:(CGFloat)border borderColor:(UIColor *)color {
    // 圆环的宽度
    CGFloat borderW = border;
    
    // 加载旧的图片
 
     UIImage * oldImage = img ;
    
    
    // 新的图片尺寸
    CGFloat imageW = oldImage.size.width + 2 * borderW;
    CGFloat imageH = oldImage.size.height + 2 * borderW;
    
    // 设置新的图片尺寸
    CGFloat circirW = imageW > imageH ? imageH : imageW;
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circirW, circirW), NO, 0.0);
    
    // 画大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(circirW/2, circirW/2) radius:circirW/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
    //    [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circirW, circirW)];
    
    // 获取当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 添加到上下文
    CGContextAddPath(ctx, path.CGPath);
    
    // 设置颜色
    [color set];
    
    // 渲染
    CGContextFillPath(ctx);
    
    CGFloat olimageWH = oldImage.size.width>oldImage.size.height?oldImage.size.height:oldImage.size.width;
    
    CGRect clipR = CGRectMake(borderW, borderW, olimageWH, olimageWH);
    
    // 画圆：正切于旧图片的圆
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:clipR];
    
    // 设置裁剪区域
    [clipPath addClip];
    
    
    // 画图片
    [oldImage drawAtPoint:CGPointMake(borderW, borderW)];
    
    // 获取新的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


//绘图
- (UIImage*)imageChangeColor:(UIColor*)color
{
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)imageToscaleWithwToH:(CGFloat)scale opaque:(BOOL)opaque{
    //确定压缩后的size
    CGFloat scaleWidth = self.size.width;
    CGFloat scaleHeight = self.size.width / scale;
    CGSize scaleSize = CGSizeMake(scaleWidth, scaleHeight);
    //开启图形上下文 opaque：Yes 不透明
    UIGraphicsBeginImageContextWithOptions(scaleSize, opaque, 1.0);
    
    CGFloat h = (scaleHeight - self.size.height)/2;
    
    //绘制图片
    [self drawInRect:CGRectMake(0, h, self.size.width, self.size.height)];
    //从图形上下文获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark -  压缩图片
- (UIImage *)compressedWithImage:(UIImage *)originImage {
    
    UIImage *image;
    return image;
}


//压缩图片到mb以下的Image
- (UIImage *)compressionImage {
    UIImage *img = self;
    CGFloat maxLength = 1024*1024;
    NSData *img_data = UIImageJPEGRepresentation(img, 1);
    if (img_data.length > maxLength) {
        while (img_data.length > 400000) {
            img = [self scaleImage:img toScale:0.6];
            img_data = UIImageJPEGRepresentation(img, 1);
            DLog(@"%lu",(unsigned long)img_data.length);
        }
    }
    else{
        while (img_data.length > 400000) {
            img = [self scaleImage:img toScale:0.8];
            img_data = UIImageJPEGRepresentation(img, 1);
        }
    }
    return img;
}


//压缩图片
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

+(UIImage *)compressPic:(UIImage *)image withScale:(float)scaleSize{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
+(UIImage *)compressPic:(UIImage *)image toSize:(float)size{
    NSData *img_data=UIImageJPEGRepresentation(image,1);
    
    if (img_data.length>1000*size*100) {
        image = [self compressPic:image withScale:0.25];
        img_data=UIImageJPEGRepresentation(image, 1);
    }
    
    if (img_data.length>1000*size*10) {
        image = [self compressPic:image withScale:0.25];
        img_data=UIImageJPEGRepresentation(image, 1);
    }
    
    if (img_data.length>1000*size) {
        while (img_data.length>1000*size) {
            image = [self compressPic:image withScale:0.9];
            img_data=UIImageJPEGRepresentation(image, 1);
        }
    }
    
    return image;
}

+(NSData *)dataCompressPic:(UIImage *)image toSize:(float)size{
    NSData *img_data=UIImageJPEGRepresentation(image,1);
    
    if (img_data.length>1000*size*100) {
        image = [self compressPic:image withScale:0.25];
        img_data=UIImageJPEGRepresentation(image, 1);
    }
    
    if (img_data.length>1000*size*10) {
        image = [self compressPic:image withScale:0.25];
        img_data=UIImageJPEGRepresentation(image, 1);
    }
    
    if (img_data.length>1000*size) {
        while (img_data.length>1000*size) {
            image = [self compressPic:image withScale:0.9];
            img_data=UIImageJPEGRepresentation(image, 1);
        }
    }
    
    return img_data;
}

- (UIImage *)blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    
    //convert to ARGB if it isn't
    if (CGImageGetBitsPerPixel(imageRef) != 32 ||
        CGImageGetBitsPerComponent(imageRef) != 8 ||
        !((CGImageGetBitmapInfo(imageRef) & kCGBitmapAlphaInfoMask)))
    {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        [self drawAtPoint:CGPointZero];
        imageRef = UIGraphicsGetImageFromCurrentImageContext().CGImage;
        UIGraphicsEndImageContext();
    }
    
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}

//毛玻璃
- (UIImage *)boxblurWithBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider); //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img)); if(pixelBuffer == NULL)
        DLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        DLog(@"error from convolution %ld", error);
        
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast); CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef]; //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}
//+(void)load{
//
//    Method imageNamed = class_getClassMethod(self,@selector(imageNamed:));
//    Method looha_ImageNamed =class_getClassMethod(self,@selector(looha_none_imageNamed:));
//    method_exchangeImplementations(imageNamed, looha_ImageNamed);
//
//}
//
//+(instancetype)looha_none_imageNamed:(NSString*)name{
//
//    if (name.length == 0) {//判断是否为空的方法，不提供，自行搞定
//
//      return  [self looha_none_imageNamed:name];
//
//    }else{
//
//        return nil;
//    }
//}
@end
