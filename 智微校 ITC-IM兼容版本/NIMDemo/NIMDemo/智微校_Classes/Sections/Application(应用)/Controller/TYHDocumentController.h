//
//  TYHDocumentController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/3/16.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHDocumentController : UIViewController
- (IBAction)didClickClose:(id)sender;
@property (nonatomic, strong) UIWebView * webView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) NSURL * url;
- (IBAction)openWithSafari:(id)sender;

@end
