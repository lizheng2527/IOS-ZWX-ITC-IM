//
//  qcsClassStasticInsideDTBCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/9.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassStasticInsideDTBCell.h"
#import "QCSStasticModel.h"
#import "QCSchoolDefine.h"

@implementation qcsClassStasticInsideDTBCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self initLabelFrame];
}


-(void)setModel:(QCSStasticListModel *)model
{
    
    if ([model.orderNumber isEqualToString:@"1"]) {
        
        self.scoreImageView.image = [UIImage imageNamed:@"modal1"];
        self.nameLabel.text = model.name;
        
        
    }else if([model.orderNumber isEqualToString:@"2"])
    {
        self.scoreImageView.image = [UIImage imageNamed:@"modal2"];
        self.nameLabel.text = model.name;
        
    }else if([model.orderNumber isEqualToString:@"3"])
    {
        self.scoreImageView.image = [UIImage imageNamed:@"modal3"];
        self.nameLabel.text = model.name;
    
    }
    else
    {
        self.scoreImageView.hidden = YES;
        self.rankLabel.text = model.orderNumber;
        self.nameLabel.text = model.name;
        self.scoreLabel.text = model.status;
    }
    
    if ([model.modelType isEqualToString:@"answerNum"]) {
        self.scoreLabel.text = model.answerNum;
    }
    else if([model.modelType isEqualToString:@"quickAnswerNum"]) {
        self.scoreLabel.text = model.quickAnswerNum;
    }
    else
    {
        self.scoreLabel.text = model.evaluateCount;
    }
}

-(void)initLabelFrame
{
    _scoreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    _scoreImageView.center = CGPointMake((SCREEN_WIDTH - 16) / 6, 22);
    [self addSubview:_scoreImageView];
    
    _lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH - 16, 1.0f)];
    _lineView.backgroundColor = [UIColor QCSBackgroundColor];
    [self addSubview:_lineView];
    
    
    _rankLabel.center = CGPointMake((SCREEN_WIDTH - 16) / 6, 22);
    _nameLabel.frame = CGRectMake((SCREEN_WIDTH - 16) / 3, 0,(SCREEN_WIDTH - 16) / 3 , 44);
    _scoreLabel.frame = CGRectMake((SCREEN_WIDTH - 16) / 3 * 2, 0,(SCREEN_WIDTH - 16) / 3 , 44);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
