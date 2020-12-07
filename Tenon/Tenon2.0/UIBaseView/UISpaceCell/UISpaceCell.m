//
//  UISpaceCell.m
//  PlayGame
//
//  Created by admin on 2020/10/30.
//

#import "UISpaceCell.h"

@implementation UISpaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(UIBaseModel*)model
{
    if (model.backColor) {
        self.backView.backgroundColor = model.backColor;
    }
    self.constraintCellHeight.constant = [model.cellHeight floatValue];
}
@end
