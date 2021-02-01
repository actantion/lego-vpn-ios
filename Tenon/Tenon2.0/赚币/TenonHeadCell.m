//
//  TenonHeadCell.m
//  TenonVPN
//
//  Created by FriendWu on 2021/1/30.
//  Copyright © 2021 zly. All rights reserved.
//

#import "TenonHeadCell.h"

@implementation TenonHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickBtn:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
