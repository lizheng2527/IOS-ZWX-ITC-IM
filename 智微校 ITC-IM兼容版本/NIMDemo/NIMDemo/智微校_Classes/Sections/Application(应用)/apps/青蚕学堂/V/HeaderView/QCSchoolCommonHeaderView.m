//
//  QCSchoolCommonHeaderView.m
//  NIM
//
//  Created by 中电和讯 on 2018/3/30.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "QCSchoolCommonHeaderView.h"

@implementation QCSchoolCommonHeaderView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imgaeView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 8, 6, 20)];
        _imgaeView.image = [UIImage imageNamed:@"矩形 10"];
        [self addSubview:_imgaeView];
        
        _titleOfLabel = [[UILabel alloc]initWithFrame:CGRectMake(22, 8, 80, 20)];
        _titleOfLabel.text = @"常用应用";
        _titleOfLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleOfLabel.textColor = [UIColor grayColor];
        [self addSubview:_titleOfLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
