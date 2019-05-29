//
//  TYHHomeLabel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/24/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHHomeLabel : UILabel
-(instancetype)initWithFrame:(CGRect)frame WithType:(NSInteger )type;

/** label的比例值 */
@property (nonatomic, assign) CGFloat scale;
@property(nonatomic,assign)NSInteger labelType;
@end
