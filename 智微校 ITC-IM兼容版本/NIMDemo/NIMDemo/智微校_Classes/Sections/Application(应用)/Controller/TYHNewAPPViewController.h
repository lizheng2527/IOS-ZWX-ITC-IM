//
//  TYHNewAPPViewController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/13.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TYHNewAPPViewController : UIViewController


@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * password;

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, copy) NSString * urlstr;
@property (nonatomic, copy) NSString * sourceId;

- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name;

@end
