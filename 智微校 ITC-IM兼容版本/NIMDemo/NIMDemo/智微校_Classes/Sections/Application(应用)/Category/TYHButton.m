//
//  TYHButton.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/25/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHButton.h"

@implementation TYHButton


- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
//        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0;
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
