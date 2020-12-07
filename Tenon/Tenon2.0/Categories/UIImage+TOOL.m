//
//  UIImage+TOOL.m
//  buyer
//
//  Created by huazhe on 16/5/26.
//  Copyright © 2016年 王印. All rights reserved.
//

#import "UIImage+TOOL.h"

@implementation UIImage (TOOL)

-(UIImage *)imageWithScale:(CGFloat)scale
{
    NSData *dataImg=UIImageJPEGRepresentation(self, scale);
    return [UIImage imageWithData:dataImg];
}

-(NSData *)imageDataWithScale:(CGFloat)scale{
    return UIImageJPEGRepresentation(self, scale);
}

-(NSData *)imageCompressWidth:(CGFloat)defineWidth scale:(CGFloat)scale
{
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = (targetWidth / width) *height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [self drawInRect:CGRectMake(0,0,targetWidth,  targetHeight)];
    UIImage* newImage =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return UIImageJPEGRepresentation(newImage, scale);
}

- (NSData *)compressToSize:(CGFloat)kb{
    
    NSData *oldData = UIImagePNGRepresentation(self);
    
    CGFloat size = oldData.length/1024.f;
    
    CGFloat scale = kb/size;
    
    return [self imageDataWithScale:scale];
}


@end
