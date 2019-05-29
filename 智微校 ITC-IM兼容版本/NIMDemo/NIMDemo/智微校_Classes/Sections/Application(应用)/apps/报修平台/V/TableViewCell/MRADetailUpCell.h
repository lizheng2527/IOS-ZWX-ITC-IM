//
//  MRADetailUpCell.h
//  NIM
//
//  Created by 中电和讯 on 17/3/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MRARequestInfoModel;

@protocol MRADetailUpCellDelegate <NSObject>
@optional
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag;

@end


@interface MRADetailUpCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *applyPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyGoodsLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyErrorLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyErrorDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *historyServiceLabel;
@property (weak, nonatomic) IBOutlet UILabel *errorPlaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;


@property(nonatomic,retain)MRARequestInfoModel *model;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serverPersonLabelSpaceToTopLayout1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serverPersonLabelSpaceToTopLayout2;

@property(nonatomic,assign)id<MRADetailUpCellDelegate>delegate;
@end
