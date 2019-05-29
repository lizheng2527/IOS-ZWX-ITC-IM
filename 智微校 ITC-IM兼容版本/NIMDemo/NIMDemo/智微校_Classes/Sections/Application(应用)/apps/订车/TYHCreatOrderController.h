//
//  TYHCreatOrderController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/15/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarDataModel.h"

@interface TYHCreatOrderController : UIViewController
@property (nonatomic, strong) CarDataModel * carModel;
@property (nonatomic, copy) NSString * urlStr;
@property (nonatomic, copy) NSString * carOrderId;
@property (nonatomic, copy) NSString * usename;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * count;
@end
