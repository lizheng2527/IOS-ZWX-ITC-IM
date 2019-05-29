//
//  TYHCommentRecordViewController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/19.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHCommentRecordViewController : UIViewController
@property(nonatomic,copy)NSString *kind;
@property(nonatomic,copy)NSString *requestTime;

-(instancetype)initWithKind:(NSString *)kind requestTime:(NSString *)requestTime;
@end
