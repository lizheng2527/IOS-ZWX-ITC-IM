//
//  UILabel+Shake.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/11/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "UILabel+Shake.h"
//#import <UIView+Toast.h>

@implementation UILabel (Shake)

- (void)shake {

    CAKeyframeAnimation * keyframe = [CAKeyframeAnimation animationWithKeyPath:@"position.x"];
    keyframe.duration = 0.4;
    CGFloat x = self.layer.position.x;
    
    keyframe.values = @[@(x + 10), @(x - 10),@(x + 5), @(x - 5),@(x + 10), @(x - 10),@(x + 5), @(x - 5),@(x + 10), @(x - 10),@(x + 5), @(x - 5),@(x + 10), @(x - 10),@(x + 5), @(x - 5)];
    
    [self.layer addAnimation:keyframe forKey:@"shake"];
}

@end
