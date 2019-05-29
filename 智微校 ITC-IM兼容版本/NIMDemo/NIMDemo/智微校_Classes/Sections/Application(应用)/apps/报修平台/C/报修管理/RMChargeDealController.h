//
//  RMChargeDealController.h
//  NIM
//
//  Created by 中电和讯 on 17/3/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RMChargeDealController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *passBtn;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;

@property (weak, nonatomic) IBOutlet UIButton *unPassBtn;
@property (weak, nonatomic) IBOutlet UILabel *unPassLabel;

@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;


@property(nonatomic,copy)NSString *repairID;
@property(nonatomic,copy)NSString *checkKind;

@end
