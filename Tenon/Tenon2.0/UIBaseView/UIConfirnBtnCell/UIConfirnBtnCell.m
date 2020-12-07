//
//  UIConfirnBtnCell.m
//  PlayGame
//
//  Created by FriendWu on 2020/11/1.
//

#import "UIConfirnBtnCell.h"

@implementation UIConfirnBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clickBtn:(id)sender {
    if (self.block) {
        self.block(@(1));
    }
}
- (void)setModel:(UIBaseModel*)model
{
    if (model.title) {
        [self.button setTitle:model.title forState:UIControlStateNormal];
    }
    if (model.leading) {
        self.leading.constant = model.leading.floatValue;
    }
    if (model.trading) {
        self.trailing.constant  = model.trading.floatValue;
    }
    if (model.cellHeight) {
        self.btnHeight.constant = model.cellHeight.floatValue;
    }
    if (model.titleColor) {
        [self.button setTitleColor:model.titleColor forState:UIControlStateNormal];
    }
    if (model.backColor) {
        [self.button setBackgroundColor:model.backColor];
    }
    if (model.titleSize) {
        self.button.titleLabel.font = [UIFont systemFontOfSize:model.titleSize.floatValue];
    }
    self.backgroundColor = UIColor.clearColor;
    self.button.layer.masksToBounds = YES;
    self.button.layer.cornerRadius = 25;
    if ([model.mark isEqualToString:@"myproket"]) {
        self.button.layer.cornerRadius = 5;
        self.backgroundColor = UIColor.whiteColor;
    }
}
@end
