//
//  CarStatusCell.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/24/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "CarStatusCell.h"

@implementation CarStatusCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//- (void)layoutSubviews {
//
//    [super layoutSubviews];
//    
//    if ([self.optionalTwo.currentTitle isEqualToString:@"结束派车"]) {
//        NSLog(@"结束派车 %@",NSStringFromCGRect(self.optionalTwo.frame));
//        
//        CGRect frame = self.optionalTwo.frame;
//        frame.size.width = 80;
//        self.optionalTwo.frame = frame;
//        
//        NSLog(@"结束派车2 %@",NSStringFromCGRect(self.optionalTwo.frame));
//    } else if ([self.optionalTwo.currentTitle isEqualToString:@"派车"]) {
//        NSLog(@"派车 %@",NSStringFromCGRect(self.optionalTwo.frame));
//        
//        //        frame.size.width =
//        
//    }
//    
//}

@end
