//
//  ProjectDetailCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "ProjectDetailCell.h"
#import "ProjectMainModel.h"


@implementation ProjectDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
}

-(void)setModel:(ProjectListDetailModel *)model
{
    _applyPersonLabel.text = model.applyerName;
    _applyPersonPhoneLabel.text = model.phoneNum;
    _applyDateLabel.text = model.applyTime;
    
    _projectNameLabel.text = model.projectName;
    _projectFromLabel.text = model.projectFrom;
    _projectBidOrNotLabel.text = model.bidOrNot;   //是否招投标
    _projectBidRateLabel.text = model.bidRate;   //中标率
    _projectGetbidTimeLabel.text = model.getbidTime;   //预期中标日期
    _projectClientNameLabel.text = model.clientName; //客户名称
    _projectClientLeaderPhoneLabel.text = model.clientLeaderPhone; //客户方负责人电话
    _projectClientLeaderNameLabel.text = model.clientLeader;  //客户方负责人
    _projectContractAmountLabel.text = [NSString stringWithFormat:@"%@ 万",model.contractAmount];  //预期合同额
    _projectPreCostLabel.text = [NSString stringWithFormat:@"%@ 万",model.preCost];   //售前预算
    _projectMaoliLabel.text = [NSString stringWithFormat:@"%@ 万",model.maoli];  //预计毛利
    _projectMaolilvLabel.text = [NSString stringWithFormat:@"%@ %%",model.maoliLv];   //预计毛利率
    _projectProjectDescribeLabel.text = model.projectDescribe;   //项目描述
    _projectCompetitorsAboutLabel.text = model.competitors;   //竞争对手情况
    _projectPartnerAboutLabel.text = model.partner;   //合作伙伴情况
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
