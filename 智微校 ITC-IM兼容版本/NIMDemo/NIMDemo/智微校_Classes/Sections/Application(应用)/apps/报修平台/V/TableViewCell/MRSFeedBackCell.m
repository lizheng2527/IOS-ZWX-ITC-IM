//
//  MRSFeedBackCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/4/5.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRSFeedBackCell.h"
#import "ETTextView.h"


@implementation MRSFeedBackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self contetViewConfig];
    self.selectionStyle = NO;
    self.errorReasonTextView.placeholder = @"选填";
}


-(void)setModel:(MRSRepairInfoModel *)model
{
    self.innerModel = model;
    
    self.errorReasonTextView.text = model.faultReason;
    
    if ([model.repairStatus isEqualToString:@"2"]) {
        [_buNengWeiXiuBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
        [_yiXiuHaoBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    }
    else {
        [_yiXiuHaoBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
        [_buNengWeiXiuBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    }
    
    if ([model.faultkind isEqualToString:@"0"]) {
        [_renWeiSunHuaiBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
        [_ziRanSunHuaiBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    }
    else{
        [_ziRanSunHuaiBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
        [_renWeiSunHuaiBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    }
}


-(void)contetViewConfig
{
    self.errorReasonTextView.layer.masksToBounds = YES;
    self.errorReasonTextView.layer.cornerRadius = 3.f;
    self.errorReasonTextView.layer.borderWidth = 1.f;
    self.errorReasonTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.errorReasonTextView.delegate = self;
    
//    self.yiXiuHaoLabel.userInteractionEnabled = YES;
//    self.buNengWeiXiuLabel.userInteractionEnabled = YES;
//    self.ziRanSunHuaiLabel.userInteractionEnabled = YES;
//    self.renWeiSunHuaiLabel.userInteractionEnabled = YES;
//    
//    UITapGestureRecognizer *gesYiXiuHao = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hasPrefix:)];
//    [self.yiXiuHaoLabel addGestureRecognizer:gesYiXiuHao];
//    
//    UITapGestureRecognizer *gesBuNengWeiXiu = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cantFixAction:)];
//    [self.yiXiuHaoLabel addGestureRecognizer:gesBuNengWeiXiu];
//    
//    UITapGestureRecognizer *gesZiRanSunHuai = [[UITapGestureRecognizer alloc]initWithTarget:self.contentView action:@selector(normalDamageAction:)];
//    [self.yiXiuHaoLabel addGestureRecognizer:gesZiRanSunHuai];
//    
//    UITapGestureRecognizer *gesRenWeiSunHuai = [[UITapGestureRecognizer alloc]initWithTarget:self.contentView action:@selector(humanDemageAction:)];
//    [self.yiXiuHaoLabel addGestureRecognizer:gesRenWeiSunHuai];
    
}


- (IBAction)hasFixedAction:(id)sender {
    [_buNengWeiXiuBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_yiXiuHaoBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    self.innerModel.repairStatus = @"2";
}

- (IBAction)cantFixAction:(id)sender {
    [_yiXiuHaoBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_buNengWeiXiuBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    self.innerModel.repairStatus = @"3";
}

- (IBAction)normalDamageAction:(id)sender {
    [_renWeiSunHuaiBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_ziRanSunHuaiBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    self.innerModel.faultkind = @"0";
}

- (IBAction)humanDemageAction:(id)sender {
    [_ziRanSunHuaiBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_renWeiSunHuaiBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    self.innerModel.faultkind = @"1";
}

#pragma mark - TextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    self.innerModel.faultReason = textView.text;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



@implementation MRSRepairInfoModel

@end
