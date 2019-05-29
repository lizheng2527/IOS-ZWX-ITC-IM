//
//  TYHNewContacterController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/4.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef void (^ReturnTextArrayBlock)(NSMutableArray *arrayText);

@interface TYHNewContacterController : UIViewController

@property (nonatomic, strong) NSMutableArray * modelArray;

@property (nonatomic, copy) ReturnTextArrayBlock returnTextArrayBlock;
@property (nonatomic, strong) NSString * modelId;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *organizationID;

@property (nonatomic, strong) NSMutableArray * showTableView;


@property (nonatomic, strong) NSMutableArray * seletedArray;
@property (nonatomic, strong) NSMutableArray * nameArray;
@property (nonatomic, strong) NSMutableArray * tempArray;
@property (weak, nonatomic) IBOutlet UITableView *tableview;



@end
