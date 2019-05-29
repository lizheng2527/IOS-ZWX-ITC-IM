//
//  UIView+ButtonInCell.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 5/24/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "UIView+ButtonInCell.h"

@implementation UIView (ButtonInCell)

- (__kindof UITableViewCell *)getSuperViewInButtonCell {

    if ([[[self superview] superview] isKindOfClass:[UITableViewCell class]]) {
        return (UITableViewCell *)[[self superview] superview];
    } else if ([[[[self superview] superview] superview] isKindOfClass:[UITableViewCell class]]) {
        
        return (UITableViewCell *)[[[self superview] superview] superview];
    } else {
    
        NSLog(@"抛出异常");
    }
    return nil;
    
}
@end
