//
//  NoticeCell.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/10/20.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoticeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *logImage;

@property (weak, nonatomic) IBOutlet UIImageView *readImg;

@property (weak, nonatomic) IBOutlet UILabel *sendUserLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *checkDetailLabel;

@property (nonatomic, assign) NSInteger count;

@property (weak, nonatomic) IBOutlet UIImageView *lineImageView;
@end
