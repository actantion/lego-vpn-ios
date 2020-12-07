//
//  UIImageView+loading.m
//  PlayGame
//
//  Created by admin on 2020/11/7.
//

#import "UIImageView+loading.h"

@implementation UIImageView(Loading)
- (void)LoadImage:(NSString*)url withHoderImage:(UIImage*)hoderImage successBlock:(void(^)(UIImage* retImage))successblock
{
//    if (hoderImage == nil)
//        hoderImage = [UIImage imageNamed:@"img_default"];
//
//    UIImage *placeholderImage = hoderImage;
//    NSURL *picUrl =  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",SERVER_URL,url]];
//    [self sd_setImageWithURL:picUrl
//            placeholderImage:placeholderImage
//                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
//     {
//         if(image != nil && ![image isKindOfClass:[NSNull class]])
//         {
//             if (successblock) {
//                 successblock(image);
//             }
//         }
//     }];
}
@end
