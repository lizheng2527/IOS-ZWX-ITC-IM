//
//  TYHUserListCell.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/2/29.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHUserListCell.h"
#import <MJExtension.h>
#import <UIImageView+WebCache.h>
@implementation TYHUserListCell

- (void)awakeFromNib {
    // Initialization code
}

//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        [self layoutSubviews];
//    }
//    return self;
//    
//}

//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    self.image.contentMode = UIViewContentModeScaleAspectFill;
//    self.image.clipsToBounds = YES;
//    
//}

-(void)setCellWithMomentModel :(momentsModel *)model
{
    
    if (model.picUrls.count == 0) {
        self.contentLabel.text = model.content;
        self.contentLabel.textColor = [UIColor blackColor];
        self.dateLabel.text = [self dealDateWithSrting:model.publishTime];
        self.monthLabel.text = [self dealMonthWithSrting:model.publishTime];
        self.timeLabel.text = [self dealTimeWithSrting:model.publishTime];
    }
    else
    {
        self.imageTmp.contentMode = UIViewContentModeScaleAspectFill;
        self.imageTmp.clipsToBounds = YES;
        self.imageTmp.backgroundColor = [UIColor blackColor];
        picUrlsModel *picModel = [picUrlsModel objectArrayWithKeyValuesArray:model.picUrls][0];
        NSMutableArray *tmpArray = [NSMutableArray array];
        for (picUrlsModel *picModel in [picUrlsModel objectArrayWithKeyValuesArray:model.picUrls]) {
            [tmpArray addObject:picModel];
        }
        
        self.contenLabelImage.text = model.content;
        self.contenLabelImage.textColor = [UIColor blackColor];

        self.imageCountLabel.text = [NSString stringWithFormat:@"共%lu张",(unsigned long)model.picUrls.count];
        [self.imageTmp sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,picModel.smallPicUrl]] placeholderImage:[UIImage imageNamed:@"mk-photo"]];
        
        self.dateLabelImage.text = [self dealDateWithSrting:model.publishTime];
        self.monthLabelImage.text = [self dealMonthWithSrting:model.publishTime];
        self.timeLabelImage.text = [self dealTimeWithSrting:model.publishTime];
        
    }
}

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
