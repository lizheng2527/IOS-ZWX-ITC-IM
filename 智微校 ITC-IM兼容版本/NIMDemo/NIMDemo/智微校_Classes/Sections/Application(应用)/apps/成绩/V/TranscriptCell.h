//
//  TranscriptCell.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/21.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudentScoreModel;

@interface TranscriptCell : UITableViewCell
@property(nonatomic,retain)UILabel *subjectLabel;
@property(nonatomic,retain)UILabel *scoreLabel;
@property(nonatomic,retain)UILabel *classRankLabel;
@property(nonatomic,retain)UILabel *gradeRankLabel;

@property(nonatomic,retain)StudentScoreModel *model;
@end
