//
//  SettingSelectCell.h
//  TenonVPN
//
//  Created by admin on 2021/2/1.
//  Copyright © 2021 zly. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^clickCellBlock) (void);
@interface SettingSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbSubTitle;
@property (nonatomic, strong) clickCellBlock clickBlock;
- (void)setModel:(UIBaseModel*)model;
@end

NS_ASSUME_NONNULL_END
