//
//  UITipsCell.h
//  PlayGame
//
//  Created by admin on 2020/10/30.
//

#import <UIKit/UIKit.h>

//typedef void(^cellBlock)(id _Nullable value);
NS_ASSUME_NONNULL_BEGIN

@interface UITipsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTips;
//@property (nonatomic, strong) cellBlock block;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintLeading;
- (void)setModel:(UIBaseModel*)model;
@end

NS_ASSUME_NONNULL_END
