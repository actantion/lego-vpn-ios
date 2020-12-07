//
//  UIImageView+loading.h
//  PlayGame
//
//  Created by admin on 2020/11/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView(Loading)
- (void)LoadImage:(NSString*)url withHoderImage:(UIImage*)hoderImage successBlock:(void(^)(UIImage* retImage))successblock;
@end

NS_ASSUME_NONNULL_END
