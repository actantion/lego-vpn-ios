//
//  RBProgressView.m
//  Test
//
//  Created by Robin on 2020/10/10.
//  Copyright © 2020 Kison. All rights reserved.
//

#import "RBProgressView.h"

#define KProgressPadding 1.0f
@interface RBProgressView ()

@property (nonatomic, weak) UIView *tView;
@property (nonatomic, weak) UIView *borderView;


@end

@implementation RBProgressView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //边框
        UIView *borderView = [[UIView alloc] initWithFrame:self.bounds];
        borderView.layer.cornerRadius = self.bounds.size.height * 0.5;
        borderView.layer.masksToBounds = YES;
        borderView.backgroundColor = [UIColor whiteColor];
        borderView.layer.borderColor = [[UIColor blueColor] CGColor];
        borderView.layer.borderWidth = 2.0f;
        self.borderView=borderView;
        [self addSubview:borderView];

        //进度
        UIView *tView = [[UIView alloc] init];
        tView.backgroundColor = [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1];
        tView.layer.cornerRadius = (self.bounds.size.height - (2.0f + 1.0f) * 2) * 0.5;
        tView.layer.masksToBounds = YES;
        [self addSubview:tView];
        self.tView = tView;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height+8, self.bounds.size.width, 20)];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = Font_B(16);
        textLabel.textColor = kRBColor(18, 181, 170);
        [self addSubview:textLabel];
        self.textLabel = textLabel;
    }

    return self;
}

-(void)setProgerssColor:(UIColor *)progerssColor{
    _progerssColor=progerssColor;
    _tView.backgroundColor=progerssColor;
}

-(void)setProgerStokeWidth:(CGFloat)progerStokeWidth{
    _progerStokeWidth=progerStokeWidth;
    _borderView.layer.borderWidth = progerStokeWidth;

}

-(void)setProgerssStokeBackgroundColor:(UIColor *)progerssStokeBackgroundColor{
    _progerssStokeBackgroundColor=progerssStokeBackgroundColor;
     _borderView.layer.borderColor = [progerssStokeBackgroundColor CGColor];
}

-(void)setProgerssBackgroundColor:(UIColor *)progerssBackgroundColor{
    _progerssBackgroundColor = progerssBackgroundColor;
    _borderView.backgroundColor=progerssBackgroundColor;
}

//更新进度
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    CGFloat margin = self.progerStokeWidth + KProgressPadding;
    CGFloat maxWidth = self.bounds.size.width - margin * 2;
    CGFloat heigth = self.bounds.size.height - margin * 2;

    _tView.frame = CGRectMake(margin, margin, maxWidth * progress, heigth);
}

@end
