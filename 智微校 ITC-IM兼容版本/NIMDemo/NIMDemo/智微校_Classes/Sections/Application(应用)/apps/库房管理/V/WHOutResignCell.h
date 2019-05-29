//
//  WHOutResignCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/12.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHOutModel;

@interface WHOutResignCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *outCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outWareHouseLabel;
@property (weak, nonatomic) IBOutlet UILabel *outDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *outKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *outApplicationUserLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *lookBtn;
@property (weak, nonatomic) IBOutlet UIButton *resignBtn;

@property(nonatomic,retain)WHOutModel *model;

@end
