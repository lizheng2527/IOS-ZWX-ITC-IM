//
//  AssetDrawController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PPSSignatureView;

@interface AssetDrawController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;

@property (strong, nonatomic) IBOutlet PPSSignatureView *drawView;

@property(nonatomic,assign)NSInteger type;

@end
