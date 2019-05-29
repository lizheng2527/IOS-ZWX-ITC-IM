//
//  TYHNoticeController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/10/22.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TYHMessageHeaderView;

@interface TYHNoticeController : UIViewController
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property(nonatomic,copy)NSString *token;
@property (nonatomic, assign) BOOL attentionFlag;

@property(nonatomic,retain)TYHMessageHeaderView *headerView;
@end
