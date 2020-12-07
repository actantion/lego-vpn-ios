//
//  UIConfirnBtnCell.h
//  PlayGame
//
//  Created by FriendWu on 2020/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIConfirnBtnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;
@property (nonatomic, strong) success block;
@property (nonatomic, strong) UIBaseModel* dataModel;
@end

NS_ASSUME_NONNULL_END
