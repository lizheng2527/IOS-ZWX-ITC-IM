//
//  CAClassDetailController.h
//  NIM
//
//  Created by 中电和讯 on 2018/1/30.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAClassDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *mainWebview;

@property(copy,nonatomic)NSString *requestURL;

@property(copy,nonatomic)NSString *titleString;
@end
