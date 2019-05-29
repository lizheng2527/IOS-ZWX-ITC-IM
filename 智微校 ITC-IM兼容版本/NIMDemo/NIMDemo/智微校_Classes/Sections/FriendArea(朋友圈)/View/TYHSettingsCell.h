//
//  TYHSettingsCell.h
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/10.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewStateModel.h"
@interface TYHSettingsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *settingLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemIcon;


@property (weak, nonatomic) IBOutlet UILabel *nnewLikeOrComment_Label;
@property (weak, nonatomic) IBOutlet UIImageView *nnewContent_Image;
@property (weak, nonatomic) IBOutlet UILabel *nnewContent_Label;

@property(nonatomic,retain)NewStateModel *stateModel;

@end
