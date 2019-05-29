//
//  CAMainListController.h
//  NIM
//
//  Created by 中电和讯 on 2018/1/19.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAMainListController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *mainWebview;


@property(copy,nonatomic)NSString *requestURL;
@property(copy,nonatomic)NSString *titleString;

@end

