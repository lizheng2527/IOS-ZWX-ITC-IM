//
//  CAEvaluateListHeaderView.m
//  NIM
//
//  Created by 中电和讯 on 2018/1/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "CAEvaluateListHeaderView.h"
#import <CoreText/CoreText.h>

@implementation CAEvaluateListHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
        
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, 60)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgView];
        
        _iconView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 15, 24, 24)];
        _iconView.image = [UIImage imageNamed:@"CA_circle"];
        [bgView addSubview:_iconView];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake( 38, 5, SCREEN_WIDTH - 8 - 60, 45)];
        _titleLabel.text = @"评价记录";
        _titleLabel.font = [UIFont boldSystemFontOfSize:17];
        _titleLabel.textColor = [UIColor colorWithRed:24 / 255.0 green:182 / 255.0 blue:152 / 255.0 alpha:1];
        [bgView addSubview:_titleLabel];
        
        _gradeLabel = [[UILabel alloc]initWithFrame:CGRectMake( SCREEN_WIDTH - 8 - 170 - 16, 5, 170, 45)];
//        _gradeLabel.attributedText = [self dealHeadSumTitle];
        _gradeLabel.textAlignment = NSTextAlignmentRight;
        _gradeLabel.font = [UIFont systemFontOfSize:17];
        [bgView addSubview:_gradeLabel];
        
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(36, 59.5, SCREEN_WIDTH - 8 - 36, 0.5f)];
        lineLabel.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineLabel];
    }
    return self;
}

//-(void)setAddScore:(NSString *)addScore
//{
//    _gradeLabel.attributedText = [self dealHeadSumTitle];
//}
//
//-(void)setMinusScore:(NSString *)minusScore
//{
//    _gradeLabel.attributedText = [self dealHeadSumTitle];
//}


-(NSMutableAttributedString *)dealHeadSumTitle
{
    NSString *stringSumTitle =@"合计 :";

    NSString *stringAdd =[NSString stringWithFormat:@" +%@分",_addScore];
    
    NSString *stringMinus =[NSString stringWithFormat:@" -%@分",_minusScore];
    
    NSString *needDealString = [NSString stringWithFormat:@"%@%@%@",stringSumTitle,stringAdd,stringMinus];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc]initWithString:needDealString];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor grayColor]
                       range:[needDealString rangeOfString:stringSumTitle]];
//    if (_addScore.length) {
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithRed:24 / 255.0 green:182 / 255.0 blue:152 / 255.0 alpha:1]
                           range:[needDealString rangeOfString:stringAdd]];
//    }
//    if (_minusScore.length) {
        [attrString addAttribute:NSForegroundColorAttributeName
                           value:[UIColor redColor]
                           range:[needDealString rangeOfString:stringMinus]];
//    }
    
    return attrString;
}

-(void)layoutSubviews
{
    _gradeLabel.attributedText = [self dealHeadSumTitle];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
