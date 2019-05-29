//
//  homeworkListCell.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#define myCyanColor colorWithRed:54/255.0 green:191/255.0 blue:181/255.0 alpha:1

#import "homeworkListCell.h"
#import "UIView+SDAutoLayout.h"

@implementation homeworkListCell
#pragma mark - 赋予数据
-(void)setModel:(HWListModel *)model
{
    _nameLabel.text = model.courseName;
    
    _FinishLabel.attributedText = [self dealWithFinishLabel:model.statusName];
    
    _DetailLabel.text = model.title;
    
    _endLabel.attributedText = [self dealEndTimeString:[NSString stringWithFormat:@"提交截止至：%@",model.endTime]];
    
    _mutableTimeLabel_Left.text = [self dealDateWithSrting:model.setTime];
    
    _mutableTimeLabel_Right.attributedText = [self dealWithDayTimeLabel_Right:[NSString stringWithFormat:@"%@\n%@",[self dealMonthWithSrting:model.setTime],[self dealTimeWithSrting:model.setTime]]] ;
    [self createLayout];
}

#pragma mark - 约束
-(void)createLayout
{
#define BGView self.contentView
#define borderView    self.backgroundView
    [BGView addSubview:_myBackgroundView];
    [BGView addSubview:_FinishLabel];
    [BGView addSubview:_arrowImageView];

    _myBackgroundView.sd_layout.leftSpaceToView(BGView,90).topSpaceToView(BGView,5).rightSpaceToView(BGView,5).bottomSpaceToView(BGView,5);
    
    _FinishLabel.sd_layout.rightSpaceToView(BGView,20).topSpaceToView(BGView,5).bottomSpaceToView(BGView,50).widthIs(50);
    _arrowImageView.sd_layout.rightSpaceToView(BGView,10).topSpaceToView(BGView,37).bottomSpaceToView(BGView,37).widthIs(5);
    
}

#pragma mark - 字符串处理方法
//结束时间加入橙色
-(NSMutableAttributedString *)dealEndTimeString:(NSString *)srting
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:srting];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor]
                          range:NSMakeRange(0, 6)];
    return attributedString;
    
}
//完成状态label颜色判定
-(NSMutableAttributedString *)dealWithFinishLabel:(NSString *)string
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    if ([string isEqualToString:@"已完成"]) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor myCyanColor]
                                 range:NSMakeRange(0, 3)];
    }
    else if ([string isEqualToString:@"未完成"]) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]
                                 range:NSMakeRange(0, 3)];
    }
    else if ([string isEqualToString:@"已过期"])
    {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]
                                 range:NSMakeRange(0, 3)];
    }
    return attributedString;
}

-(NSMutableAttributedString *)dealWithDayTimeLabel_Right:(NSString *)string
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
//    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    // 行间距
//    paragraphStyle.lineSpacing = 10.0;
//    //段间距
//    paragraphStyle.paragraphSpacing = 20.0;
//    [attributedString addAttribute:NSForegroundColorAttributeName value:paragraphStyle
//                             range:NSMakeRange(0, 0)];
    
    
    
    if ([string hasPrefix:@"10"] || [string hasPrefix:@"11"] || [string hasPrefix:@"12"] ) {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont  systemFontOfSize:13.0] range:NSMakeRange(3, 4)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor myCyanColor]
                                 range:NSMakeRange(3, 4)];
    }else
    {
        [attributedString addAttribute:NSFontAttributeName value:[UIFont  systemFontOfSize:13.0] range:NSMakeRange(2, 4)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor myCyanColor]
                                 range:NSMakeRange(2, 4)];
    }
    
    return attributedString;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _myBackgroundView.layer.masksToBounds = YES;
    _myBackgroundView.layer.borderWidth = 0.3f;
    _myBackgroundView.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

#pragma mark - 日期字符串处理

-(NSString *)dealDateWithSrting:(NSString *)string
{
    NSString *needDealString =[string substringWithRange:NSMakeRange(8, 2)];
    return needDealString;
}

-(NSString *)dealTimeWithSrting:(NSString *)string
{
    NSString *needDealString = [self weekdayStringFromDate:[self dateFromString:string]];
    return needDealString;
}


-(NSString *)dealMonthWithSrting:(NSString *)string
{
    NSString *needDealString =[string substringWithRange:NSMakeRange(5, 2)];
    if ([needDealString integerValue] >0 && [needDealString integerValue] <13 ) {
        needDealString = [NSString stringWithFormat:@"%ld月",(long)[needDealString integerValue]];
    }
    return needDealString;
}



- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (NSDate *)dateFromString:(NSString *)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
