//
//  UILineCell.h
//  PlayGame
//
//  Created by admin on 2020/11/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILineCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vwLine;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailing;

@end

NS_ASSUME_NONNULL_END
