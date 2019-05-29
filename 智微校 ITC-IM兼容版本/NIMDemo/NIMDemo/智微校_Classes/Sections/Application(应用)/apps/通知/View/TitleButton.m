//
//  TitleButton.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/10/20.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import "TitleButton.h"
#import "UIView+Extention.h"

@implementation TitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:18];
       
    }
    return self;
}

-(void)setTitleTypeByV3App:(NSString *)titleTypeByV3App
{
    _titleTypeByV3App = titleTypeByV3App;
    if ([_titleTypeByV3App isEqualToString:@"homework"]) {
        [self setImage:[UIImage imageNamed:@"HomeWork_dropdown"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"HomeWork_dropdown"] forState:UIControlStateSelected];
    }
    else
    {
        [self setImage:[UIImage imageNamed:@"iv_change"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"iv_change_up"] forState:UIControlStateSelected];
    }
}

// 目的：想在系统计算和设置完按钮的尺寸后，再修改一下尺寸
/**
 *  重写setFrame:方法的目的：拦截设置按钮尺寸的过程
 *  如果想在系统设置完控件的尺寸后，再做修改，而且要保证修改成功，一般都是在setFrame:中设置
 */
//- (void)setFrame:(CGRect)frame
//{
//    frame.size.width += 5;
//    [super setFrame:frame];
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 如果仅仅是调整按钮内部titleLabel和imageView的位置，那么在layoutSubviews中单独设置位置即可
    // 计算titleLabel的frame
    self.imageView.x = 0;
    self.titleLabel.x = self.imageView.x;
    
    // 计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame);
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    
    // 只要修改了文字，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    // 只要修改了图片，就让按钮重新计算自己的尺寸
    [self sizeToFit];
}


@end
