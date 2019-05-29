//
//  PaiCheCell.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/13/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "PaiCheCell.h"

@implementation PaiCheCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.useButton.layer.cornerRadius = 2;
    self.useButton.layer.masksToBounds = YES;
//    [self.useButton addTarget:self action:@selector(didEnter:) forControlEvents:(UIControlEventTouchUpInside)];
}
- (void)didEnter:(UIButton *)btn {
    
    NSLog(@"didEnter === ");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
