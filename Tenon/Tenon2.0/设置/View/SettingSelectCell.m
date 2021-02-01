//
//  SettingSelectCell.m
//  TenonVPN
//
//  Created by admin on 2021/2/1.
//  Copyright © 2021 zly. All rights reserved.
//

#import "SettingSelectCell.h"

@implementation SettingSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lbTitle.text = GCLocalizedString(@"Language");
    self.lbTitle.textColor = APP_MAIN_COLOR;
    
    self.lbSubTitle.textColor = kRBColor(154, 162, 161);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickCell:(id)sender {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

- (void)setModel:(UIBaseModel*)model{
    self.lbTitle.text = model.title;
    self.lbSubTitle.text = model.subTitle;
}
@end
