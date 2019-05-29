//
//  TYHCarButton.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/25/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHCarButton.h"

@implementation TYHCarButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        [self.layer setMasksToBounds:YES];//设置按钮的圆角半径不会被遮挡
        [self.layer setCornerRadius:4];
        [self.layer setBorderWidth:2];//设置边界的宽度
        
        //设置按钮的边界颜色
        
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        if (self.selected) {
            
            CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){1,0,0,1});
            [self.layer setBorderColor:color];
        } else {
            
            CGColorRef color = CGColorCreate(colorSpaceRef, (CGFloat[]){246.0/255,139.0/255,64.0/255,1});
            [self.layer setBorderColor:color];

        }
    }
    return self;
}

@end
