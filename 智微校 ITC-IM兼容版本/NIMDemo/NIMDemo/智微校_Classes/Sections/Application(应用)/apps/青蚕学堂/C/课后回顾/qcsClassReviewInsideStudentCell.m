//
//  qcsClassReviewInsideStudentCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassReviewInsideStudentCell.h"
#import "QCSchoolDefine.h"
#import "QCSMainModel.h"

@implementation qcsClassReviewInsideStudentCell

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
    
}

-(void)setModel:(QCSMainStudentModel *)model
{
    _model = model;
    self.subjectLabel.text = model.courseName;
    self.detailLabel.text = [NSString stringWithFormat:@"%@ %@ (%@)",model.mobileName,model.courseName,model.studentName];
    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@",model.classDate,model.classTime];
    
    self.qiangdaLabel.text = [NSString stringWithFormat:@"抢答次数: %@",model.quickAnswer];
    self.xuanzetiLabel.text = [NSString stringWithFormat:@"选择题总数: %@",model.chooseSize];
    self.pingjiaLabel.text = [NSString stringWithFormat:@"评价次数: %@",model.evaluate];
    self.shouxietiLabel.text = [NSString stringWithFormat:@"手写题总数: %lu",(unsigned long)model.handwriteList.count];
    
    NSString *attString = [NSString stringWithFormat:@"综合表现:  %@",model.totalScore];
    self.zongheLabel.attributedText = [self dealScoreString:attString];
    
    self.subjectLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[QCSSourceHandler getSubjectBackgroundImageWithCourseName:model.courseName]]];
}

#pragma mark - ClickActions

- (IBAction)DetailAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(DetailBtnClicked:)]) {
        [self.delegate DetailBtnClicked:self];
    }
}

#pragma mark - Private

-(NSMutableAttributedString *)dealScoreString:(NSString *)needDealString
{
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:needDealString];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor redColor]
                       range:[needDealString rangeOfString:_model.totalScore]];
    [attrString addAttribute:NSFontAttributeName
                          value:[UIFont systemFontOfSize:18.0]
                          range:[needDealString rangeOfString:_model.totalScore]];
    
    
    return attrString;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
