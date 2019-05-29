//
//  QCSHomeLabel.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "QCSHomeLabel.h"
#import "QCSchoolDefine.h"

#define XMGRed (194.0/255)
#define XMGGreen (242.0/255)
#define XMGBlue (221.0/255)

@implementation QCSHomeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        self.font = [UIFont boldSystemFontOfSize:16];
        self.textColor = [UIColor whiteColor];
        self.textAlignment = NSTextAlignmentCenter;
        
        self.backgroundColor = [UIColor QCSThemeColor];
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

//    CGFloat red =  (255 - XMGRed) * scale;
//    CGFloat green = (255 - XMGGreen) * scale;
//    CGFloat blue = (255 - XMGBlue) * scale;

//    CGFloat red = XMGRed * scale;
//    CGFloat green = XMGGreen * scale;
//    CGFloat blue = XMGBlue * scale;
//    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    self.textColor = [UIColor whiteColor];
//    self.textColor = [UIColor colorWithRed:183/255.0 green:241/255.0 blue:213/255.0 alpha:1];
    
    // 大小缩放比例
//    CGFloat transformScale = 1 + scale * 0; // [1, 1.2]
//    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
}


//- (void)setScale:(CGFloat)scale
//{
//    _scale = scale;
//
//    //      R G B
//    // 默认：0.4 0.6 0.7  // 默认黑色 0 0 0
//    // 红色：1   0   0   // Red Green Blue
//
//    CGFloat red =  (255 - XMGRed) * scale;
//    CGFloat green = (255 - XMGGreen) * scale;
//    CGFloat blue = (255 - XMGBlue) * scale;
//
//    //    CGFloat red = XMGRed * scale;
//    //    CGFloat green = XMGGreen * scale;
//    //    CGFloat blue = XMGBlue * scale;
//    self.textColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
//
//    // 大小缩放比例
//    CGFloat transformScale = 1 + scale * 0; // [1, 1.2]
//    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
//}



@end
