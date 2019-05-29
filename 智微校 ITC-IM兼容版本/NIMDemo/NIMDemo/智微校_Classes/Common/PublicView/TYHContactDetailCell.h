//
//  TYHContactDetailCell.h
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/24.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@interface TYHContactDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic,retain)UserModel *model;
@end
