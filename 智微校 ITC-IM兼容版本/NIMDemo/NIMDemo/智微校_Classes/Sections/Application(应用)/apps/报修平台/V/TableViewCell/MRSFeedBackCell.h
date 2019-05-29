//
//  MRSFeedBackCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/5.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ETTextView;
@class MRSRepairInfoModel;


@interface MRSFeedBackCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *repairWorkerLabel;

@property (weak, nonatomic) IBOutlet ETTextView *errorReasonTextView;

@property (weak, nonatomic) IBOutlet UIButton *yiXiuHaoBtn;
@property (weak, nonatomic) IBOutlet UILabel *yiXiuHaoLabel;

@property (weak, nonatomic) IBOutlet UIButton *buNengWeiXiuBtn;
@property (weak, nonatomic) IBOutlet UILabel *buNengWeiXiuLabel;

@property (weak, nonatomic) IBOutlet UIButton *ziRanSunHuaiBtn;
@property (weak, nonatomic) IBOutlet UILabel *ziRanSunHuaiLabel;

@property (weak, nonatomic) IBOutlet UIButton *renWeiSunHuaiBtn;
@property (weak, nonatomic) IBOutlet UILabel *renWeiSunHuaiLabel;

@property(nonatomic,retain)MRSRepairInfoModel *model;
@property(nonatomic,retain)MRSRepairInfoModel *innerModel;
@end

@interface MRSRepairInfoModel : NSObject
@property(nonatomic,copy)NSString *faultkind;
@property(nonatomic,copy)NSString *repairStatus;
@property(nonatomic,copy)NSString *faultReason;
@end
