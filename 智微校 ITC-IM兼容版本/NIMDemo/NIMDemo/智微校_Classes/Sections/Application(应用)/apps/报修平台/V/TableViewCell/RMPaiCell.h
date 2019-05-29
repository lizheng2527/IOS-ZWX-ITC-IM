//
//  RMPaiCell.h
//  NIM
//
//  Created by 中电和讯 on 17/3/29.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RMServerWorkerModel;

@interface RMPaiCell : UITableViewCell

@property(nonatomic,retain)UILabel *nameLabel;
@property(nonatomic,retain)UILabel *likeRepairCountLabel;
@property(nonatomic,retain)UILabel *nowRepairingLabel;

@property(nonatomic,retain)RMServerWorkerModel *model;
@end
