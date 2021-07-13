//
//  getTenonCell.h
//  TenonVPN
//
//  Created by FriendWu on 2021/1/30.
//  Copyright © 2021 zly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^clickBtnBlock) (void);
@interface getTenonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSubTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnEnter;
@property (nonatomic, strong) clickBtnBlock clickBlock;
@end

NS_ASSUME_NONNULL_END
