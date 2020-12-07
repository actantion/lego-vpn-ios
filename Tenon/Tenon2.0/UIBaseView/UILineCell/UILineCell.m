//
//  UILineCell.m
//  PlayGame
//
//  Created by admin on 2020/11/5.
//

#import "UILineCell.h"

@implementation UILineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(UIBaseModel*)model{
    if (model.leading) {
        self.leading.constant = model.leading.floatValue;
    }
    if (model.trading) {
        self.trailing.constant = model.trading.floatValue;
    }
    if (model.backColor) {
        self.vwLine.backgroundColor = model.backColor;
    }
}
@end
