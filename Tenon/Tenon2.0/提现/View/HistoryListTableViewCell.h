//
//  HistoryListTableViewCell.h
//  Tenonvpn
//
//  Created by Robin on 2020/9/25.
//  Copyright © 2020 Raobin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistoryListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellOneLab;
@property (weak, nonatomic) IBOutlet UILabel *cellTwoLab;
@property (weak, nonatomic) IBOutlet UILabel *cellThreeLab;
@property (weak, nonatomic) IBOutlet UILabel *cellForLab;
@property (weak, nonatomic) IBOutlet UIView *backView;

@end

NS_ASSUME_NONNULL_END
