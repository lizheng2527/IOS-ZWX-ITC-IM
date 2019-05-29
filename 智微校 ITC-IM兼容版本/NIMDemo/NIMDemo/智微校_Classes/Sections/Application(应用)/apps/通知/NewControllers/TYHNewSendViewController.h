//
//  TYHNewSendViewController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/2/22.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "ViewController.h"
#import "UserModel.h"

@interface TYHNewSendViewController : ViewController


@property (nonatomic, strong) UserModel * model;

@property (nonatomic, strong) NSMutableArray * modelArray;

@property (nonatomic, copy) NSString * nameStr;

@property (nonatomic, copy) NSString * modelId;

@property (nonatomic, copy) NSMutableArray * tempArray;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *organizationID;


@end
