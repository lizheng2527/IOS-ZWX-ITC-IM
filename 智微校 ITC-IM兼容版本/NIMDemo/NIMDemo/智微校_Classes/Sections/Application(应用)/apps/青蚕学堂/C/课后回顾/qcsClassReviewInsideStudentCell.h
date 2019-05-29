//
//  qcsClassReviewInsideStudentCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class qcsClassReviewInsideStudentCell;
@class QCSMainStudentModel;


@protocol qcsClassReviewInsideStudentCellDelegate <NSObject>

@optional

- (void)DetailBtnClicked:(qcsClassReviewInsideStudentCell *)cell;

@end


@interface qcsClassReviewInsideStudentCell : UITableViewCell

@property(nonatomic,assign)id<qcsClassReviewInsideStudentCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UILabel *qiangdaLabel;
@property (weak, nonatomic) IBOutlet UILabel *xuanzetiLabel;
@property (weak, nonatomic) IBOutlet UILabel *pingjiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *shouxietiLabel;
@property (weak, nonatomic) IBOutlet UILabel *zongheLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;

@property(nonatomic,retain)QCSMainStudentModel *model;
@end
