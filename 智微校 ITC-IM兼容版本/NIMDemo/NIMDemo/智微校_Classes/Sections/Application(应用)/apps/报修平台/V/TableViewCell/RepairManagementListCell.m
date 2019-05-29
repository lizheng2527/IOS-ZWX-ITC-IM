//
//  RepairManagementListCell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/24.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RepairManagementListCell.h"
#import "RepairManagementModel.h"

@implementation RepairManagementListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self viewConfig];
}


-(void)setModel:(RepairManagementModel *)model
{
    _model = model;
    
    self.cellRepairID = model.repairID;
    self.phoneNumber = model.requestUserPhone;
    self.userID = model.userId;
    
    self.selectionStyle = NO;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.applyTime];
    self.applyPhoneNumLabel.text = [NSString stringWithFormat:@"%@",model.requestUserPhone];
    self.statusLabel.text = [NSString stringWithFormat:@"%@",model.statusView.length?model.statusView:@""];
    self.applyDeviceLabel.text = [NSString stringWithFormat:@"%@",model.DeviceName];
    self.applyPersonLabel.text = [NSString stringWithFormat:@"%@",model.requestUserName];
    self.errorSpaceLabel.text = [NSString stringWithFormat:@"%@",model.placeName];
    
//    model.faultDescription 好像也是故障现象  model.malfunction
    self.errorDescriptionLabel.text = [NSString stringWithFormat:@"%@",model.faultDescription];
    
    if ( [model.statusCode isEqualToString:@"4"] || [model.statusCode isEqualToString:@"1"]) {
        self.paiBtn.hidden = YES;
        self.dealBtn.hidden = YES;
    }
    else if([model.statusCode isEqualToString:@"3"])
    {
        self.dealBtn.hidden = NO;
        self.paiBtn.hidden = YES;
    }
    else if([model.statusCode isEqualToString:@"0"])
    {
//        self.dealBtn.hidden = YES;
        [self.dealBtn setTitle:@"接单" forState:UIControlStateNormal];
    }
    else if([model.statusCode isEqualToString:@"2"])
    {
        if([model.checkStatus isEqualToString:@"0"])
        {
            self.paiBtn.hidden = YES;
            self.dealBtn.hidden = NO;
        }
        else
        {
            self.paiBtn.hidden = YES;
            self.dealBtn.hidden = YES;
        }
    }

    if (self.paiBtn.hidden) {
        self.dealBtnRightToSpaceLayout.constant = 112 - 40 - 12;
    }
    
    
    if (self.isFYSP) {
        self.fyspOrPhoneNumLabel.text = @"待审批费用:";
        self.callBtn.hidden = YES;
        self.messageBtn.hidden = YES;
        self.applyPhoneNumLabel.text = [NSString stringWithFormat:@"%@元",model.costApplication];
        self.applyPhoneNumLabel.textColor = [UIColor colorWithRed:116/255.0 green:139/255.0 blue:216/255.0 alpha:1];
    }
}

-(void)viewConfig
{
    _lookBtn.layer.masksToBounds = YES;
    _lookBtn.layer.cornerRadius = 3.0f;
    _lookBtn.layer.borderWidth = .5f;
    _lookBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _paiBtn.layer.masksToBounds = YES;
    _paiBtn.layer.cornerRadius = 3.0f;
    _paiBtn.layer.borderWidth = .5f;
    _paiBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _dealBtn.layer.masksToBounds = YES;
    _dealBtn.layer.cornerRadius = 3.0f;
    _dealBtn.layer.borderWidth = .5f;
    _dealBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

//查看
- (IBAction)LookAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(LookBtnClicked:)]) {
        [self.delegate LookBtnClicked:self];
    }
}

//派单
- (IBAction)paiAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(PaiBtnClicked:)]) {
        [self.delegate PaiBtnClicked:self];
    }
}

//费用审批
- (IBAction)dealAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DealBtnClicked:)]) {
        [self.delegate DealBtnClicked:self];
    }
}

//打电话
- (IBAction)callAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(CallBtnClicked:)]) {
        [self.delegate CallBtnClicked:self];
    }
}

//用云信聊天
- (IBAction)messageAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(MessageBtnClicked:)]) {
        [self.delegate MessageBtnClicked:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
