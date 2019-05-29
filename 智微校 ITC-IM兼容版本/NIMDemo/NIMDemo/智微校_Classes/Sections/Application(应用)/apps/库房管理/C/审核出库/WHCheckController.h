//
//  WHCheckController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHCheckController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *passBtn;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;

@property (weak, nonatomic) IBOutlet UIButton *unPassBtn;
@property (weak, nonatomic) IBOutlet UILabel *unPassLabel;

@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;

@property(nonatomic,copy)NSString *applyID;
@property(nonatomic,copy)NSString *checkKind;

@end
