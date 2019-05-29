//
//  CAEvaluateListHeaderView.h
//  NIM
//
//  Created by 中电和讯 on 2018/1/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAEvaluateListHeaderView : UIView

@property(nonatomic,retain)UIImageView *iconView;
@property(nonatomic,retain)UILabel *titleLabel;

@property(nonatomic,retain)UILabel *gradeLabel;

@property(nonatomic,copy)NSString *addScore;
@property(nonatomic,copy)NSString *minusScore;

@end
