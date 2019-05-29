//
//  MRADetailBottomCell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRADetailBottomCell.h"
#import "MyRepairApplicationModel.h"

#import <UIImageView+WebCache.h>
#import "YMTapGestureRecongnizer.h"

#import "MRSAddDetailCell.h"
#import <MJExtension.h>
#import "NSString+NTES.h"

@implementation MRADetailBottomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.selectionStyle = NO;
}

-(void)setModel:(MRAServerInfoModel *)model
{
    if (![NSString isBlankString:model.repairStatus]) {
        self.serviceStatusLabel.text = model.repairStatus;
    }
    if (![NSString isBlankString:model.repairTime]) {
        self.severTimeLabel.text = model.repairTime;
    }
    if (![NSString isBlankString:model.workerName]) {
        self.severPersonLabel.text = model.workerName;
    }
    if (![NSString isBlankString:model.malfunctionReason]) {
        self.errorReasonLabel.text = model.malfunctionReason;
    }
    if (![NSString isBlankString:model.malfunctionKind]) {
        self.errorTypeLabel.text = model.malfunctionKind;
    }
    
    
    if (![NSString isBlankString:model.costApplication] && [model.costApplication floatValue] != 0) {
        self.chargeLabel.text = [NSString stringWithFormat:@"%@元",model.costApplication];
    }
    
    NSMutableString *addString = [NSMutableString string];
    for (MRSAddModel *addModel in model.goodsSumModelArray) {
        if (model.goodsSumModelArray.count > 2) {
            [addString appendFormat: @"%@", [NSString stringWithFormat:@"%@ [ %@元 * %@个 = %@元] \n",addModel.name,addModel.price,addModel.count,addModel.subtotal]  ];
        }else
        {
            [addString appendFormat: @"%@", [NSString stringWithFormat:@"%@ [ %@元 * %@个 = %@元]",addModel.name,addModel.price,addModel.count,addModel.subtotal]  ];
        }
    }
    self.countLabel.text = [NSString isBlankString:addString]?@"无":addString;
    
    if (model.repairImageList.count && model.repairImageList.count <= 4){
        self.serverPersonLabelSpaceToTopLayout.constant = SCREEN_WIDTH / 5 + 7.5 + 7.5;
        self.serverPersonLabelSpaceToTopLayout2.constant = SCREEN_WIDTH / 5 + 7.5 + 7.5;
    }
    else if(model.repairImageList.count >4)
    {
        self.serverPersonLabelSpaceToTopLayout.constant = SCREEN_WIDTH / 5 * 2 + 7.5 + 7.5 + 5;
        self.serverPersonLabelSpaceToTopLayout2.constant = SCREEN_WIDTH / 5 * 2 + 7.5  + 7.5+ 5;
    }
    
    [model.repairImageList enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + SCREEN_WIDTH / 5 * (idx % 4) + (idx % 4) * 6, 42 +7.5  + 3 * ((idx / 4) + 1) + (idx / 4) *  SCREEN_WIDTH / 5  , SCREEN_WIDTH / 5, SCREEN_WIDTH / 5)];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,urlString]] placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
        [self.contentView addSubview:imageView];
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        tap.appendArray = model.repairImageList;
        imageView.backgroundColor = [UIColor clearColor];
        imageView.tag = 9999 + idx;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
    }];

}

#pragma mark - 点击action
- (void)tapImageView:(YMTapGestureRecongnizer *)tapGes{
    
    [_delegate showImageViewWithImageViews:tapGes.appendArray byClickWhich:tapGes.view.tag];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
