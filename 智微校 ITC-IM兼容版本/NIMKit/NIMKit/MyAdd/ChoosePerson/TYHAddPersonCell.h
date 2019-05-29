//
//  TYHAddPersonCell.h
//  NIMKit
//
//  Created by 中电和讯 on 16/12/26.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@interface TYHAddPersonCell : UITableViewCell

@property (nonatomic, strong) UIImageView *portraitImg;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIImageView * selecImage;

- (void)updateContent:(UserModel *)contact;

@end
