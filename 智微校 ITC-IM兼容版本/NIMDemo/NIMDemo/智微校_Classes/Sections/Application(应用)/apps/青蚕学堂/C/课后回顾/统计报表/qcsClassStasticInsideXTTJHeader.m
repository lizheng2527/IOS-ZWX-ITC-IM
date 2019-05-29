//
//  qcsClassStasticInsideXTTJHeader.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/9.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassStasticInsideXTTJHeader.h"
#import "QCSchoolDefine.h"


@implementation qcsClassStasticInsideXTTJHeader
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame: frame];
    if (self) {
        [self initCellContentView];
    }
    return self;
}

-(void)initCellContentView
{
    self.backgroundColor = [UIColor whiteColor];
    
    _itemRankLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH - 16) / 4, 44)];
    _itemRankLabel.textColor = [UIColor darkGrayColor];
    _itemRankLabel.font = [UIFont boldSystemFontOfSize:15];
    _itemRankLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_itemRankLabel];
    
    _itemNameLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 16) / 4, 0, (SCREEN_WIDTH - 16) / 4, 44)];
    _itemNameLabel.textColor = [UIColor darkGrayColor];
    _itemNameLabel.font = [UIFont boldSystemFontOfSize:15];
    _itemNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_itemNameLabel];
    
    //5s上修复显示不全
    _itemScoreLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 16) / 2 - 10, 0, (SCREEN_WIDTH - 16) / 4 + 20, 44)];
    _itemScoreLabel.textColor = [UIColor darkGrayColor];
    _itemScoreLabel.font = [UIFont boldSystemFontOfSize:15];
    _itemScoreLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_itemScoreLabel];
    
    _itemLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 16) / 4 * 3, 0, (SCREEN_WIDTH - 16) / 4, 44)];
    _itemLevelLabel.textColor = [UIColor darkGrayColor];
    _itemLevelLabel.font = [UIFont boldSystemFontOfSize:15];
    _itemLevelLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_itemLevelLabel];
    
    
    UIView  *_lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 43, SCREEN_WIDTH - 16, 1)];
    _lineView.backgroundColor = [UIColor QCSBackgroundColor];
    [self addSubview:_lineView];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
