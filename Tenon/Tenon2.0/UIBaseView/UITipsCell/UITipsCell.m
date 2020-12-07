//
//  UITipsCell.m
//  PlayGame
//
//  Created by admin on 2020/10/30.
//

#import "UITipsCell.h"

@implementation UITipsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//- (IBAction)clickBtn:(id)sender {
//    if (self.block) {
//        self.block(nil);
//    }
//}
- (void)setModel:(UIBaseModel*)model
{
    if (model.mark) {
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[model.title  dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,NSFontAttributeName:[UIFont systemFontOfSize:15.0f] } documentAttributes:nil error:nil];
        self.lbTips.attributedText = attrStr;//用于显示
    }else{
        self.lbTips.text = model.title;
    }
    
    if (model.titleSize != 0) {
        self.lbTips.font = [UIFont systemFontOfSize:[model.titleSize intValue]];
    }else{
        self.lbTips.font = [UIFont systemFontOfSize:16];
    }
    if (model.titleColor) {
        self.lbTips.textColor = model.titleColor;
    }else{
        self.lbTips.textColor = UIColor.blackColor;
    }
    if (model.leading) {
        self.constraintLeading.constant = [model.leading floatValue];
    }
    if (model.backColor) {
        self.backgroundColor = model.backColor;
    }
    if (model.titleAlignment) {
        self.lbTips.textAlignment = [model.titleAlignment intValue];
    }
    
}
@end
