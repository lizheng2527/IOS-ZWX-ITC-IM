//
//  MRADetailBottomCell.h
//  NIM
//
//  Created by 中电和讯 on 17/3/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MRAServerInfoModel;

@protocol MRADetailBottomCellDelegate <NSObject>

@optional
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;

@end


@interface MRADetailBottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *serviceStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *severPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *severTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorReasonLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *chargeLabel;

@property(nonatomic,retain)MRAServerInfoModel *model;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serverPersonLabelSpaceToTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serverPersonLabelSpaceToTopLayout2;

@property(nonatomic,assign)id<MRADetailBottomCellDelegate>delegate;
@end
