//
//  AssetApplyCheckController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/2.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetApplyCheckController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *passBtn;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;

@property (weak, nonatomic) IBOutlet UIButton *unPassBtn;
@property (weak, nonatomic) IBOutlet UILabel *unPassLabel;

@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;

@property(nonatomic,copy)NSString *assetID;

@end
