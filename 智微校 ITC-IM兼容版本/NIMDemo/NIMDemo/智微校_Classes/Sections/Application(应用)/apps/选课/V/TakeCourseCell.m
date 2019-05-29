//
//  TakeCourseCell.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/28.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TakeCourseCell.h"
#import "TakeCourseModel.h"
#import "SDAutoLayout.h"
#import "NSString+NTES.h"

@implementation TakeCourseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.courseStatusImage.sd_layout.topSpaceToView(self.contentView,10).rightSpaceToView(self.contentView,20).bottomSpaceToView(self.contentView,45).widthIs(55).heightIs(55);
    self.limitLabel.sd_layout.topSpaceToView(self.courseStatusImage,2).rightEqualToView(self.courseStatusImage).widthIs(75);
    
    self.detailButton.sd_layout.rightSpaceToView(self.contentView,10).bottomSpaceToView(self.contentView,5).widthIs(88).heightIs(20);
}

-(void)setModel:(EcActivityCourseListModel *)model
{
    self.subjectLabel.text = model.courseDisplayName;
    self.nameLabel.text = ![NSString isBlankString:model.teacherName]?[NSString stringWithFormat:@"[ %@ ]",model.teacherName]:@"";
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"上课时间:%@",model.classTimeOfWeekStr];
    self.startTimeLabel.numberOfLines = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"学分:%@",model.scoreStr];
    self.hourLabel.text = [NSString stringWithFormat:@"课时:%@",model.hourStr];
    self.hasSubmitLabel.text = [NSString stringWithFormat:@"%@ / %@",model.selectedNum,[self isBlankString:model.maxCount]?@"oo":model.maxCount];
    self.courseStatusImage.userInteractionEnabled = YES;
    [self.detailButton setTitleColor:[UIColor colorWithRed:65 /255.0 green:105 / 255.0 blue:185/255.0 alpha:1] forState:UIControlStateNormal];
    
    
    //limit_type:   已选
    //                      未选
    //                      不可选:选课上限,课时上限,学分上限,时间冲突
    //                      选课最大人数(已满)
    
    if ([model.limit_type isEqualToString:@"已选"]) {
        self.courseStatusImage.image = [UIImage imageNamed:@"icon_check_course_selected"];
        self.courseStatusImage.userInteractionEnabled = NO;
    }
    else if([model.limit_type isEqualToString:@"已满"])
    {
        self.courseStatusImage.image = [UIImage imageNamed:@"icon_check_course_full"];
        self.courseStatusImage.userInteractionEnabled = YES;
    }
    else if([model.limit_type isEqualToString:@"选课上限"] || [model.limit_type isEqualToString:@"课时上限"] || [model.limit_type isEqualToString:@"学分上限"] || [model.limit_type isEqualToString:@"时间冲突"] || [model.limit_type isEqualToString:@"选课冲突"] || [model.limit_type isEqualToString:@"已封版"])
    {
        self.courseStatusImage.image = [UIImage imageNamed:@"icon_check_course_disable"];
        self.limitLabel.hidden = NO;
        self.limitLabel.text = model.limit_labelString;
        self.courseStatusImage.userInteractionEnabled = YES;
    }
    else
    {
        self.courseStatusImage.userInteractionEnabled = NO;
    }
    
//    CGSize expectSize = [self.subjectLabel sizeThatFits:CGSizeMake(MAXFLOAT, 20)];
//    self.subjectLabel.frame = CGRectMake(self.subjectLabel.frame.origin.x, self.subjectLabel.frame.origin.y, expectSize.width, expectSize.height);
//    
//    self.nameLabel.frame = CGRectMake(self.subjectLabel.frame.origin.x + self.subjectLabel.frame.size.width + 10, self.nameLabel.frame.origin.y, self.nameLabel.frame.size.width, self.nameLabel.frame.size.height);
    
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
