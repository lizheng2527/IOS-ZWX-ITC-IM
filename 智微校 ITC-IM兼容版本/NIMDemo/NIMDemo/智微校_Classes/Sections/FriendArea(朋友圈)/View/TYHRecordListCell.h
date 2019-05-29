//
//  TYHRecordListCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/19.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentRecordListModel;

@interface TYHRecordListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentDetailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentDetailLabel;

@property (weak, nonatomic) IBOutlet UIImageView *contentFirstImage;

@property(nonatomic,retain)CommentRecordListModel *model;

-(void)setRecordModel:(CommentRecordListModel *)model withKind:(NSString *)kind;
@end
