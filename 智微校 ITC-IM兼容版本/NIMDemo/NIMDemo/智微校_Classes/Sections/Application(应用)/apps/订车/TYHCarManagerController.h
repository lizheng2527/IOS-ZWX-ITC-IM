//
//  TYHCarManagerController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/24/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHCarManagerController : UIViewController
// 接收偏移量的位置
@property (nonatomic, assign) NSInteger indexItem;
// 接收显示个数
@property (nonatomic, assign) NSInteger indexAll;

@property (nonatomic, copy) NSString * name;


@property (nonatomic, copy) NSString * carOrderId;

@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * password;


@property (nonatomic, assign) int uncheckTag;

@end
