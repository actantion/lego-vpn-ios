//
//  UIForgetRegistCell.m
//  PlayGame
//
//  Created by FriendWu on 2020/11/1.
//

#import "UIForgetRegistCell.h"

@implementation UIForgetRegistCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(UIBaseModel*)model{
    if (model.title) {
        [self.btnLeft setTitle:model.title forState:UIControlStateNormal];
    }
    if (model.subTitle) {
        [self.btnRight setTitle:model.subTitle forState:UIControlStateNormal];
    }
}
- (IBAction)clickLeft:(id)sender {
    if (self.block) {
        self.block(@(BTN_LEFT));
    }
}
- (IBAction)clickRight:(id)sender {
    if (self.block) {
        self.block(@(BTN_RIGHT));
    }
}
@end
