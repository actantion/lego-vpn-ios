//
//  UISpaceCell.h
//  PlayGame
//
//  Created by admin on 2020/10/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UISpaceCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintCellHeight;
- (void)setModel:(UIBaseModel*)model;
@end

NS_ASSUME_NONNULL_END
