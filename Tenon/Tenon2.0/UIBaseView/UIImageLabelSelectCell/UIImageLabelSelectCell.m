//
//  UIImageLabelSelectCell.m
//  PlayGame
//
//  Created by admin on 2020/11/6.
//

#import "UIImageLabelSelectCell.h"

@implementation UIImageLabelSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imgIcon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(UIBaseModel*)model{
    if (model.title) {
        [self.imgIcon setImage:[UIImage imageNamed:model.title]];
    }
    if (model.subTitle) {
        self.lbContent.text = model.subTitle;
    }
    if (model.subTitleSize) {
        self.lbContent.font = [UIFont systemFontOfSize:model.subTitleSize.floatValue];
    }
    if (model.mark && [model.mark intValue] == 1) {
        self.imgSelect.hidden = NO;
    }else{
        self.imgSelect.hidden = YES;
    }
    if (model.subAlignment) {
        if ([model.subAlignment intValue] == 1){
            [self.imgSelect setImage:[UIImage imageNamed:@"右箭头"]];
        }else if([model.subAlignment intValue] == 2){
            self.lbContent.textAlignment = NSTextAlignmentRight;
        }
        
    }
    if (model.cellHeight) {
        CGFloat value = model.cellHeight.floatValue - 16.f;
        if (value > 0) {
            self.top.constant = value/2;
            self.bottom.constant = value/2;
        }
    }
    self.imgIcon.layer.cornerRadius = self.imgIcon.width/2.f;
    if (model.backColor) {
        self.backgroundColor = model.backColor;
    }
    if (model.leading) {
        self.leading.constant = model.leading.floatValue;
    }
    self.lbContent.textColor = APP_MAIN_COLOR;
}
@end
