//
//  UIImage+TOOL.h
//  buyer
//
//  Created by huazhe on 16/5/26.
//  Copyright © 2016年 王印. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TOOL)
//比例压缩
-(UIImage *)imageWithScale:(CGFloat)scale;
-(NSData *)imageDataWithScale:(CGFloat)scale;
-(NSData *)imageCompressWidth:(CGFloat)defineWidth scale:(CGFloat)scale;
- (NSData *)compressToSize:(CGFloat)kb;
@end
