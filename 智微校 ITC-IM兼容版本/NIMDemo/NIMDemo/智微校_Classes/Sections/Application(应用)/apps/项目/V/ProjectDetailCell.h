//
//  ProjectDetailCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectListDetailModel;


@interface ProjectDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *applyPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyPersonPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectFromLabel;

@property (weak, nonatomic) IBOutlet UILabel *projectBidOrNotLabel;   //是否招投标
@property (weak, nonatomic) IBOutlet UILabel *projectBidRateLabel;   //中标率
@property (weak, nonatomic) IBOutlet UILabel *projectGetbidTimeLabel;   //预期中标日期

@property (weak, nonatomic) IBOutlet UILabel *projectClientNameLabel; //客户名称
@property (weak, nonatomic) IBOutlet UILabel *projectClientLeaderPhoneLabel; //客户方负责人电话
@property (weak, nonatomic) IBOutlet UILabel *projectClientLeaderNameLabel;  //客户方负责人
@property (weak, nonatomic) IBOutlet UILabel *projectContractAmountLabel;   //预期合同额
@property (weak, nonatomic) IBOutlet UILabel *projectPreCostLabel;   //售前预算
@property (weak, nonatomic) IBOutlet UILabel *projectMaoliLabel;   //预计毛利
@property (weak, nonatomic) IBOutlet UILabel *projectMaolilvLabel;   //预计毛利率
@property (weak, nonatomic) IBOutlet UILabel *projectProjectDescribeLabel;   //项目描述
@property (weak, nonatomic) IBOutlet UILabel *projectCompetitorsAboutLabel;   //竞争对手情况
@property (weak, nonatomic) IBOutlet UILabel *projectPartnerAboutLabel;   //合作伙伴情况


@property(nonatomic,retain)ProjectListDetailModel *model;
@end
