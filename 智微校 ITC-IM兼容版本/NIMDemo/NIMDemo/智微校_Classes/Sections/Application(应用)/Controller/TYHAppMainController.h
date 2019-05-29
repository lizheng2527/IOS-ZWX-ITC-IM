//
//  TYHAppMainController.h
//  NIM
//
//  Created by 中电和讯 on 2017/5/24.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHAppMainController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;

@property(nonatomic,assign)BOOL isLoadSuccessful;
@end
