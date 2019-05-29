//
//  MRADetailUpCell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRADetailUpCell.h"
#import "MyRepairApplicationModel.h"

#import <UIImageView+WebCache.h>
#import "YMTapGestureRecongnizer.h"

@implementation MRADetailUpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
}

-(void)setModel:(MRARequestInfoModel *)model
{
    self.applyPersonLabel.text = model.requestUserName;
    self.applyTimeLabel.text = model.requestTime;
    self.applyErrorLabel.text = model.faultDescription;
    self.applyGoodsLabel.text = model.deviceName;
    self.errorPlaceLabel.text = model.malfunctionPlace;
    self.phoneLabel.text = model.phoneNum;
    self.applyErrorDescriptionLabel.text = model.malfunction;
    
    
    if (model.imageList.count && model.imageList.count <= 4){
        self.serverPersonLabelSpaceToTopLayout1.constant = SCREEN_WIDTH / 5 + 7.5 + 7.5;
        self.serverPersonLabelSpaceToTopLayout2.constant = SCREEN_WIDTH / 5 + 7.5 + 7.5;
    }
    else if(model.imageList.count > 4)
    {
        self.serverPersonLabelSpaceToTopLayout1.constant = SCREEN_WIDTH / 5 * 2 + 7.5 + 7.5 + 5;
        self.serverPersonLabelSpaceToTopLayout2.constant = SCREEN_WIDTH / 5 * 2 + 7.5  + 7.5+ 5;
    }
    
    [model.imageList enumerateObjectsUsingBlock:^(NSString *urlString, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10 + SCREEN_WIDTH / 5 * (idx % 4) + (idx % 4) * 6, 42 +7.5  + 3 * ((idx / 4) + 1) + (idx / 4) *  SCREEN_WIDTH / 5  , SCREEN_WIDTH / 5, SCREEN_WIDTH / 5)];
        imageView.userInteractionEnabled = YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,urlString]] placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
        [self.contentView addSubview:imageView];
        
        YMTapGestureRecongnizer *tap = [[YMTapGestureRecongnizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        tap.appendArray = model.imageList;
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
