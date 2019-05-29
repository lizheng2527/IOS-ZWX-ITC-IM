//
//  qcsClassReviewInsideClassCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassReviewInsideClassCell.h"
#import "QCSchoolDefine.h"
#import "QCSMainModel.h"


@implementation qcsClassReviewInsideClassCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.backgroundColor = [UIColor QCSBackgroundColor];
    self.selectionStyle = NO;
    
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:_subjectLabel.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
    maskLayer.frame=_subjectLabel.bounds;
    maskLayer.path=maskPath.CGPath;
    _subjectLabel.layer.mask=maskLayer;
    
    [self initButtonView];
}




-(void)setModel:(QCSMainCLassModel *)model
{
    _model = model;
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@",model.mobileName,model.courseName];
    self.subjectLabel.text = model.courseName;
    
    self.subjectLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[QCSSourceHandler getSubjectBackgroundImageWithCourseName:model.courseName]]];
}


-(void)initButtonView
{
    NSInteger width = SCREEN_WIDTH - 20;
    _stasticButton.frame = CGRectMake(0, 70, width/3, 30);
    _interativeButton.frame = CGRectMake(width/3, 70, width/3, 30);
    _detailButton.frame = CGRectMake(width / 3 * 2, 70, width/3, 30);
    
    _leftLineView.frame = CGRectMake(width/3, 78, 0.5, 15);
    _rightLineView.frame = CGRectMake(width/3 * 2, 78, 0.5, 15);
}


#pragma mark - ClickActions
- (IBAction)StasticAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(StasticsBtnClicked:)]) {
        [self.delegate StasticsBtnClicked:self];
    }
}

- (IBAction)InteractionAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(InteractionBtnClicked:)]) {
        [self.delegate InteractionBtnClicked:self];
    }
}

- (IBAction)DetailAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(ClassDetailBtnClicked:)]) {
        [self.delegate ClassDetailBtnClicked:self];
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
