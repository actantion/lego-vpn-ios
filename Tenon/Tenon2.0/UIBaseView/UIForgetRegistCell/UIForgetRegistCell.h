//
//  UIForgetRegistCell.h
//  PlayGame
//
//  Created by FriendWu on 2020/11/1.
//

#import <UIKit/UIKit.h>

typedef enum BtnLocal{
    BTN_LEFT = 1,
    BTN_RIGHT
}UILocal;
NS_ASSUME_NONNULL_BEGIN

@interface UIForgetRegistCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnLeft;
@property (weak, nonatomic) IBOutlet UIButton *btnRight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeftLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintRightTrailing;
@property (nonatomic, strong) success block;
@end

NS_ASSUME_NONNULL_END
