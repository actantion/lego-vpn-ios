//
//  HomeGuideView.m
//  TenonVPN
//
//  Created by admin on 2021/2/2.
//  Copyright © 2021 zly. All rights reserved.
//

#import "HomeGuideView.h"

@implementation HomeGuideView

- (HomeGuideView*)nib
{
    return [[NSBundle mainBundle] loadNibNamed:@"HomeGuideView" owner:self options:nil].firstObject;
}

- (IBAction)clickHidden:(id)sender {
    [self.imagePop removeFromSuperview];
    [self.lbText removeFromSuperview];
    [self removeFromSuperview];
}

- (void)show:(UIViewController*)vc withRect:(CGRect)rect{
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:[UIScreen mainScreen].bounds cornerRadius:0];
    //设置圆形镂空
    UIBezierPath *path1 = [UIBezierPath bezierPathWithOvalInRect:rect];

    [path appendPath:path1];
    //Default is NO. When YES, the even-odd fill rule is used for drawing, clipping, and hit testing
    [path setUsesEvenOddFillRule:YES];
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    [self.layer addSublayer:fillLayer];
    
    [vc.view addSubview:self];
    
    self.imagePop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_prompt"]];
    self.imagePop.top = rect.origin.y + rect.size.height + 8;
    self.imagePop.left = rect.origin.x;
    NSUserDefaults *defaultdata = [NSUserDefaults standardUserDefaults];
    NSString *language = [defaultdata objectForKey:@"language"];
    
    CGFloat width = 0;
    if (![language isEqualToString:@"中文"] && language.length != 0) {
        width = 50;
    }
    self.imagePop.width = 100 + width;
    [vc.view addSubview:self.imagePop];
    
    self.lbText = [[UILabel alloc] initWithFrame:CGRectMake(self.imagePop.left + 4, self.imagePop.top + 12, self.imagePop.width + width, 15)];
    self.lbText.text = GCLocalizedString(@"Click modify settings");
    self.lbText.font = [UIFont systemFontOfSize:14];
    self.lbText.textColor = [UIColor whiteColor];
    [vc.view addSubview:self.lbText];
}
@end
