//
//  qcsClassDetailInsideXZTCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/9.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassDetailInsideXZTCell.h"
#import "QCSchoolDefine.h"
#import "QCSClassDetailModel.h"
#import <UIImageView+WebCache.h>


@implementation qcsClassDetailInsideXZTCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor QCSBackgroundColor];
    
    self.imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageviewTapAction:)];
    [self.imageView addGestureRecognizer:ges];
    
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 1.f;
    self.imageView.layer.borderColor = [UIColor orangeColor].CGColor;
    
}

-(void)setModel:(QCSClassDetailXZTModel *)model
{
    _model = model;
    if ([model.chooseType isEqualToString:@"0"]) {
        self.typeLabel.text = @"单选题";
    }
    else if ([model.chooseType isEqualToString:@"1"]) {
        self.typeLabel.text = @"多选题";
    }
    else
    {
        self.typeLabel.text = @"选择题";
    }
    
    self.rightAnswerLabel.text = model.rightAnswer;
    
    [model.optionListModelArray enumerateObjectsUsingBlock:^(QCSClassDetailXZTInsideModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 0) {
            self.answerOneChooseLabel.text = obj.option;
            self.answerOneStudentLabel.text = obj.studentNames;
        }
        if (idx == 1) {
            self.answerTwoChooseLabel.text = obj.option;
            self.answerTwoStudentLabel.text = obj.studentNames;
        }
    }];

    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],model.urls]] placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
    
}


-(void)imageviewTapAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(ImageViewClicked:)]) {
        [self.delegate ImageViewClicked:self];
    }
}
- (IBAction)detailAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DetailBtnClicked:)]) {
        [self.delegate DetailBtnClicked:self];
    }
}

@end
