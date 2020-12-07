//
//  UIVerificationCodeCell.m
//  PlayGame
//
//  Created by FriendWu on 2020/10/31.
//

#import "UIVerificationCodeCell.h"
#import "UIButton+countDown.h"
@implementation UIVerificationCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.textFiled.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(UIBaseModel*)model
{
    if (model.subTitle) {
        self.textFiled.placeholder = model.subTitle;
    }else if (model.title){
        self.textFiled.text = model.title;
    }
    if (model.keyboardType){
        self.textFiled.keyboardType = [model.keyboardType intValue];
    }
    if (model.leading) {
        self.leading.constant = [model.leading floatValue];
    }
    if (model.trading) {
        self.trailing.constant = [model.trading floatValue];
    }
}
- (IBAction)clickBtn:(id)sender {
    NSLog(@"click btn");
    if (self.block) {
        self.block(@{@"code":@(1),@"data":@""});
    }
    [self.btnVerification startWithTime:60 title:@"" countDownTitle:@"" mainColor:UIColor.whiteColor countColor:UIColor.blueColor];
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.block) {
        self.block(@{@"code":@(2),@"data":textField.text});
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
//    if ([NSString isNineKeyBoard:string]){
//        //判断键盘是不是九宫格键盘
//            return YES;
//    }else{
//        if ([NSString stringContainsEmoji:string] == YES){
//            return NO;
//        }
//    }
    if (textField.text.length > 5) {
        return NO;
    }
    return YES;
}
@end
