//
//  UILabelButtonCell.h
//  PlayGame
//
//  Created by FriendWu on 2020/11/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabelButtonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic, strong) success block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHeight;

@end

NS_ASSUME_NONNULL_END
