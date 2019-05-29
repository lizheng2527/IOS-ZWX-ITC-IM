//
//  NewNoticeCell.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/12/28.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewNoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *readImg;

@property (weak, nonatomic) IBOutlet UIImageView *attentionImage;


@property (weak, nonatomic) IBOutlet UILabel *sendUserLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic, assign) NSInteger count;
@end
