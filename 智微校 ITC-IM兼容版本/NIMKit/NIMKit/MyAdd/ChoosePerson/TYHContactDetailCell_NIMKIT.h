//
//  TYHContactDetailCell_NIMKIT.h
//  NIMKit
//
//  Created by 中电和讯 on 16/12/26.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@interface TYHContactDetailCell_NIMKIT : UITableViewCell
@property (retain, nonatomic)UIImageView *userIcon;
@property (retain, nonatomic)UILabel *nameLabel;

@property(nonatomic,retain)UserModel *model;
@end
