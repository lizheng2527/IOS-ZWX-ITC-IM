//
//  TakeCourseMineCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TakeCourseMineCell.h"
#import "TakeCourseModel.h"


@implementation TakeCourseMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}


-(void)setModel:(schoolTermStudentCourseModel *)model
{
    if (![self isBlankString:model.courseDisplayName]) {
        _subjectLabel.text = model.courseDisplayName;
    }
    if (![self isBlankString:model.teacherName]) {
        _teacherNameLabel.text = [NSString stringWithFormat:@"[%@]",model.teacherName];
    }
    if (![self isBlankString:model.schoolTermStartDate]) {
        _beginClassLabel.text = [NSString stringWithFormat:@"上课时间:%@",model.schoolTermStartDate];
    }
    if (![self isBlankString:model.scoreStr]) {
        _subjectScoreLabel.text = [NSString stringWithFormat:@"科目学分:%@",model.scoreStr];
    }
    if (![self isBlankString:model.evaluate]) {
        _subjectJudgeLabel.text = [NSString stringWithFormat:@"综合评价:%@",model.evaluate];
    }
    
   
    
//    self.subjectLabel.frame = CGRectMake(self.subjectLabel.frame.origin.x, self.subjectLabel.frame.origin.y, expectSize.width, expectSize.height);
//    self.subjectLabel.numberOfLines = 0;
//    self.teacherNameLabel.numberOfLines = 0;
//    self.teacherNameLabel.frame = CGRectMake(self.subjectLabel.frame.origin.x + self.subjectLabel.frame.size.width + 10, self.teacherNameLabel.frame.origin.y, self.teacherNameLabel.frame.size.width, self.teacherNameLabel.frame.size.height);
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
