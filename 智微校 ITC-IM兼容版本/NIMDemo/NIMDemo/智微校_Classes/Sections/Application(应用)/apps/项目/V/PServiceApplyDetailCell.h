//
//  PServiceApplyDetailCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PServiceApplyDetailCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *applyPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyPersonPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *serviceJianshuLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceBeginTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceEndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceWaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceSchoolOrCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceCustomLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceClientPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceClientPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceClientMailLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTargetLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceMemberLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceRemarkLabel;

@end
