//
//  qcsClassStasticInsideXTTJCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/9.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassStasticInsideXTTJCell.h"
#import "QCSStasticModel.h"
#import "QCSchoolDefine.h"


@implementation qcsClassStasticInsideXTTJCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initLabelFrame];
}


-(void)setModel:(QCSStasticModel *)model
{
    self.scoreImageView.hidden = YES;
    
    self.rankLabel.text = model.orderNumber;
    self.nameLabel.text = model.rightAnswer;
    self.scoreLabel.text = model.countStr;
    self.levelLabel.text = model.percentStr;
}

-(void)setCModel:(QCSStasticComprehensiveModel *)cModel
{
    
    if ([cModel.orderNumber isEqualToString:@"1"]) {
        
        self.scoreImageView.image = [UIImage imageNamed:@"modal1"];
        self.nameLabel.text = cModel.studentName;
        self.scoreLabel.text = cModel.totalScore;
        self.levelLabel.text = cModel.range;
        
    }else if([cModel.orderNumber isEqualToString:@"2"])
    {
        self.scoreImageView.image = [UIImage imageNamed:@"modal2"];
        self.nameLabel.text = cModel.studentName;
        self.scoreLabel.text = cModel.totalScore;
        self.levelLabel.text = cModel.range;
    }else if([cModel.orderNumber isEqualToString:@"3"])
    {
        self.scoreImageView.image = [UIImage imageNamed:@"modal3"];
        self.nameLabel.text = cModel.studentName;
        self.scoreLabel.text = cModel.totalScore;
        self.levelLabel.text = cModel.range;
    }
    else
    {
        self.scoreImageView.hidden = YES;
        self.rankLabel.text = cModel.orderNumber;
        self.nameLabel.text = cModel.studentName;
        self.scoreLabel.text = cModel.totalScore;
        self.levelLabel.text = cModel.range;
    }
    
}

-(void)initLabelFrame
{
    
    _scoreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _scoreImageView.center = CGPointMake((SCREEN_WIDTH - 16) / 8, 22);
    [self addSubview:_scoreImageView];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH - 16, 1.0f)];
    _lineView.backgroundColor = [UIColor QCSBackgroundColor];
    [self addSubview:_lineView];
    
    _rankLabel.center = CGPointMake((SCREEN_WIDTH - 16) / 8, 22);
    _nameLabel.frame = CGRectMake((SCREEN_WIDTH - 16) / 4, 0,(SCREEN_WIDTH - 16) / 4 , 44);
    _scoreLabel.frame = CGRectMake((SCREEN_WIDTH - 16) / 2, 0,(SCREEN_WIDTH - 16) / 4 , 44);
    _levelLabel.frame = CGRectMake((SCREEN_WIDTH - 16) / 4 * 3, 0,(SCREEN_WIDTH - 16) / 4 , 44);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
