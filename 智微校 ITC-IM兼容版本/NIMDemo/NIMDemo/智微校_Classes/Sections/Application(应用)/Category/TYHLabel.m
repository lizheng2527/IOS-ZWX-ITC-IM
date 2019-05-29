//
//  TYHLabel.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/21/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHLabel.h"

@implementation TYHLabel

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        
        self.font = [UIFont systemFontOfSize:15];
        self.textAlignment = NSTextAlignmentRight;
    
    }
    return self;
}

@end
