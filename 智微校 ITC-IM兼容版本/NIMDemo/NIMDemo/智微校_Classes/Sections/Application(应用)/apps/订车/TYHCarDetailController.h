//
//  TYHCarDetailController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/25/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnCheckDataArray)(NSMutableArray * dataArray);

@interface TYHCarDetailController : UIViewController

@property (nonatomic, copy) ReturnCheckDataArray returnCheckSuccess;

@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * password;

@property (nonatomic, copy) NSString * carOrderId;

@property (nonatomic, strong) NSMutableArray * dataArray;

@property (nonatomic, assign) int tag;

@property (nonatomic, copy) NSString * statusString;

@property (weak, nonatomic) IBOutlet UIButton *OptinalOneButton;
@property (weak, nonatomic) IBOutlet UIButton *OptinalTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *OptinalThreeButton;

@property (nonatomic, copy) NSString * optionalOneStr;
@property (nonatomic, copy) NSString * optionalTwoStr;
@property (nonatomic, copy) NSString * optionalThreeStr;


@end
