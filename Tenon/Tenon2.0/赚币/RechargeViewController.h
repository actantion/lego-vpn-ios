//
//  RechargeViewController.h
//  Tenonvpn
//
//  Created by Raobin on 2020/8/30.
//  Copyright © 2020 Raobin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^clickVCBackBlock)(void);
@interface RechargeViewController : UIViewController
@property (nonatomic, strong) clickVCBackBlock backBlock;
@end

NS_ASSUME_NONNULL_END
