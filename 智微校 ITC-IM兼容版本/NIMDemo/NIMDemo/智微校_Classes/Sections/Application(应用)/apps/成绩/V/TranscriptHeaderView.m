//
//  TranscriptHeaderView.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/21.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TranscriptHeaderView.h"
#import "SDAutoLayout.h"

#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation TranscriptHeaderView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //header
        _header_bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
//        _header_bgView.backgroundColor = [UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:1];
        [self addSubview:_header_bgView];
        //Label
        _header_subjectLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH / 4 + 20, 30)];
        _header_subjectLabel.text = @"科目";
        _header_subjectLabel.font = [UIFont boldSystemFontOfSize:15];
        _header_subjectLabel.textAlignment = NSTextAlignmentCenter;
        _header_subjectLabel.textColor = [UIColor whiteColor];
        _header_subjectLabel.backgroundColor = [UIColor colorWithRed:102.0/255 green:204.0/255 blue:204.0/255 alpha:1];
        [self.header_bgView addSubview:_header_subjectLabel];
        
        //Label
        _header_scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 4 + 20 -1, 0, (WIDTH - WIDTH / 4 - 20) / 3 +1, 30)];
        _header_scoreLabel.text = @"分数";
        _header_scoreLabel.font = [UIFont boldSystemFontOfSize:15];
        _header_scoreLabel.textAlignment = NSTextAlignmentCenter;
        _header_scoreLabel.textColor = [UIColor whiteColor];
        _header_scoreLabel.backgroundColor = [UIColor colorWithRed:255.0/255 green:153.0/255 blue:102.0/255 alpha:1];
        [self.header_bgView addSubview:_header_scoreLabel];
        
        //Label
        _header_classRankLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 4 + 20 + (WIDTH - WIDTH / 4 - 20) / 3 - 1, 0, (WIDTH - WIDTH / 4 - 20) / 3 + 1, 30)];
        _header_classRankLabel.text = @"班级排名";
        _header_classRankLabel.font = [UIFont boldSystemFontOfSize:15];
        _header_classRankLabel.textAlignment = NSTextAlignmentCenter;
        _header_classRankLabel.textColor = [UIColor whiteColor];
        _header_classRankLabel.backgroundColor = [UIColor colorWithRed:255.0/255 green:153.0/255 blue:102.0/255 alpha:1];
        [self.header_bgView addSubview:_header_classRankLabel];
        
        //Label
        _header_gradeRankLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH / 4 + 20 + (WIDTH - WIDTH / 4 - 20) / 3 * 2 - 1, 0, (WIDTH - WIDTH / 4 - 20) / 3 + 2, 30)];
        _header_gradeRankLabel.text = @"年级排名";
        _header_gradeRankLabel.font = [UIFont boldSystemFontOfSize:15];
        _header_gradeRankLabel.textAlignment = NSTextAlignmentCenter;
        _header_gradeRankLabel.textColor = [UIColor whiteColor];
        _header_gradeRankLabel.backgroundColor = [UIColor colorWithRed:255.0/255 green:153.0/255 blue:102.0/255 alpha:1];
        [self.header_bgView addSubview:_header_gradeRankLabel];
    }
    return self;
}
@end
