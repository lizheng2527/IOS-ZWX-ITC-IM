//
//  TYHFindPasswordCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/11/10.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHFindPasswordCell.h"
#import "NSString+NTES.h"

@interface TYHFindPasswordCell ()

@end

@implementation TYHFindPasswordCell
{
    NSTimer *timer;
    NSInteger btnSecond;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _getCodeBtn.layer.masksToBounds = YES;
    _getCodeBtn.layer.cornerRadius = 3.0f;
    [_getCodeBtn setTitleColor:[UIColor TabBarColorGreen] forState:UIControlStateNormal];
    _getCodeBtn.layer.borderColor = [UIColor TabBarColorGreen].CGColor;
    _getCodeBtn.layer.borderWidth = 0.5f;
    btnSecond = 60;
}

- (IBAction)getAjaxCodeAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(getAjaxCodeAction:)]) {
        if ([NSString isMobileNumber:_inputTextField.text]) {
            //                [self initTimer];
            [_delegate getAjaxCodeAction:(self)];
        }
        else [_delegate getAjaxCodeAction:(self)];
    }
}


//-(void)initTimer
//{
//    timer = [NSTimer scheduledTimerWithTimeInterval:1.0
//                                             target:self
//                                           selector:@selector(changeBtnState:)
//                                           userInfo:nil
//                                            repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
//}
//
//-(void)changeBtnState:(id)sender
//{
//    btnSecond -= 1;
//    [_getCodeBtn setTitle:[NSString stringWithFormat:@"还剩%ld秒",(long)btnSecond] forState:UIControlStateNormal];
//    _getCodeBtn.userInteractionEnabled = NO;
//    [_getCodeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//    _getCodeBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    if (btnSecond == 0) {
//        _getCodeBtn.userInteractionEnabled = YES;
//        [_getCodeBtn setTitleColor:[UIColor TabBarColorGreen] forState:UIControlStateNormal];
//        _getCodeBtn.layer.borderColor = [UIColor TabBarColorGreen].CGColor;
//        [_getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//        [timer invalidate];
//        btnSecond = 60;
//    }
//}


//-(void)willRemoveSubview:(UIView *)subview
//{
//    [timer invalidate];
//    timer = nil;
//}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
