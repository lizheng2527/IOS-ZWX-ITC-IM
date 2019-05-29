//
//  TYHHomeLabel.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/24/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHHomeLabel.h"

#define XMGRed (246.0/255)
#define XMGGreen (139.0/255)
#define XMGBlue (64.0/255)

@implementation TYHHomeLabel
-(instancetype)initWithFrame:(CGRect)frame WithType:(NSInteger )type
{
    if (self = [super initWithFrame:frame]) {
        
        self.font = [UIFont boldSystemFontOfSize:15];
        self.textColor = [UIColor darkGrayColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        _labelType = type;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.font = [UIFont boldSystemFontOfSize:15];
        self.textColor = [UIColor darkGrayColor];
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)setScale:(CGFloat)scale
{
    _scale = scale;
    
    //      R G B
    // 默认：0.4 0.6 0.7  // 默认黑色 0 0 0
    // 红色：1   0   0   // Red Green Blue
    
    CGFloat red = XMGRed * scale;
    CGFloat green = XMGGreen * scale;
    CGFloat blue = XMGBlue * scale;
    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    if (_labelType == 2) {
        //        2代表资产管理的变色label
        CGFloat red1 = (19.0/255) * scale;
        CGFloat green1 = (137.0/255) * scale;
        CGFloat blue1 = (218.0/255) * scale;
        self.textColor = [UIColor colorWithRed:red1 green:green1 blue:blue1 alpha:1.0];
    }
    
    // 大小缩放比例
    CGFloat transformScale = 1 + scale * 0; // [1, 1.2]
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}

@end
