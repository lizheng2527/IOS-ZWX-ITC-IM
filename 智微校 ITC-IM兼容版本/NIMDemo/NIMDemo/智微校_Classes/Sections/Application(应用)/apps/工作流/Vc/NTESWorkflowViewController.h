//
//  NTESWorkflowViewController.h
//  NIM
//
//  Created by 中电和讯 on 2019/10/23.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "TitleButton.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTESWorkflowViewController : UIViewController
@property (nonatomic, copy) NSString *code;
@property (nonatomic, strong) TitleButton * titleButton;
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (nonatomic, copy) NSString * aNewTitle;
@property (nonatomic, assign) NSInteger index;
@end

NS_ASSUME_NONNULL_END
