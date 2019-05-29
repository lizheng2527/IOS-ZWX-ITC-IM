//
//  WHOutListCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WHMyApplicationModel;

@interface WHOutListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *applyCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyOrgLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyCheckStatusLabel;

@property (weak, nonatomic) IBOutlet UILabel *applyDiliverStatusLabel;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *lookBtn;

@property(nonatomic,retain)WHMyApplicationModel *model;

@end
