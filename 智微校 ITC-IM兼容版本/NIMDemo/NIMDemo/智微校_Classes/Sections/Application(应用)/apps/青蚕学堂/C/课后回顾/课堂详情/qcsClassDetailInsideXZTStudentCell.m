//
//  qcsClassDetailInsideXZTStudentCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassDetailInsideXZTStudentCell.h"
#import "QCSMainModel.h"
#import "QCSchoolDefine.h"
#import <UIImageView+WebCache.h>
#import "NSString+NTES.h"


@implementation qcsClassDetailInsideXZTStudentCell

-(void)setModel:(QCSMainStudentXZTJModel *)model
{
    self.rightAnswerLabel.text = model.rightAnswer;
    self.answerTimeLabel.text = [NSString stringWithFormat:@"答题用时: %@",model.useTime];
    self.answerStudentLabel.text = [NSString stringWithFormat:@"学生答案: %@",model.stuAnswer];
    
    self.answerRightPercentLabel.text = [NSString stringWithFormat:@"正确率 :%@/%@(人)",model.rightPersonNum,model.allPersonNum];
    if ([NSString isBlankString:model.stuAnswer]) {
        
    }
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],model.picUrl]] placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 1.f;
    self.imageView.layer.borderColor = [UIColor orangeColor].CGColor;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
