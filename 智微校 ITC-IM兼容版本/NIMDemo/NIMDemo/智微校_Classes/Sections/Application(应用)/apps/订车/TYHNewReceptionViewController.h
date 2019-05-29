//
//  TYHNewReceptionViewController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/29/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LanxumManagerInteger) {
    LanxumManagerIntegerNomal,
    LanxumManagerIntegerManager,
    LanxumManagerIntegerTask
};

@interface TYHNewReceptionViewController : UIViewController

@property (nonatomic, assign) NSInteger managerInteger;

@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * password;
@end
