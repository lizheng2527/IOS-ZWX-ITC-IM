//
//  CAEvaluateItemHeaderView.h
//  NIM
//
//  Created by 中电和讯 on 2018/1/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LLSwitch;


@interface CAEvaluateItemHeaderView : UIView

@property(nonatomic,retain)UIImageView *iconView;
@property(nonatomic,retain)UILabel *titleLabel;

@property(nonatomic,retain)LLSwitch *switchButton;

@property(nonatomic,assign)BOOL isAddItem;

@end
