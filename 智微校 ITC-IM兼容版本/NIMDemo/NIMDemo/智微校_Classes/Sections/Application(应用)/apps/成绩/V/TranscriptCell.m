//
//  TranscriptCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/21.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TranscriptCell.h"
#import "TranscriptModel.h"
#import "SDAutoLayout.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation TranscriptCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //Label
        _subjectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH / 4 + 20, 40)];
        _subjectLabel.font = [UIFont boldSystemFontOfSize:16];
        _subjectLabel.textAlignment = NSTextAlignmentCenter;
        _subjectLabel.textColor = [UIColor grayColor];
        _subjectLabel.numberOfLines = 0;
        [self.contentView addSubview:_subjectLabel];
        
        //Label
        _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 4 + 20 , 0, (WIDTH - WIDTH / 4 - 20) / 3 , 40)];
        _scoreLabel.font = [UIFont boldSystemFontOfSize:14];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
        _scoreLabel.textColor = [UIColor grayColor];
        //        _header_scoreLabel.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_scoreLabel];
        
        //Label
        _classRankLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 4 + 20 + (WIDTH - WIDTH / 4 - 20) / 3, 0, (WIDTH - WIDTH / 4 - 20) / 3, 40)];
        _classRankLabel.font = [UIFont boldSystemFontOfSize:14];
        _classRankLabel.textAlignment = NSTextAlignmentCenter;
        _classRankLabel.textColor = [UIColor grayColor];
        //        _header_classRankLabel.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:_classRankLabel];
        
        //Label
        _gradeRankLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 4 + 20 + (WIDTH - WIDTH / 4 - 20) / 3 * 2, 0, (WIDTH - WIDTH / 4 - 20) / 3, 40)];
        _gradeRankLabel.font = [UIFont boldSystemFontOfSize:14];
        _gradeRankLabel.textAlignment = NSTextAlignmentCenter;
        _gradeRankLabel.textColor = [UIColor grayColor];
        //        _header_gradeRankLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_gradeRankLabel];
    }
    return self;
}

-(void)setModel:(StudentScoreModel *)model
{
    _subjectLabel.text = model.courseName;
    _scoreLabel.text = model.score;
    _classRankLabel.text = model.eclassRank;
    _gradeRankLabel.text = model.gradeRank;
}
@end
