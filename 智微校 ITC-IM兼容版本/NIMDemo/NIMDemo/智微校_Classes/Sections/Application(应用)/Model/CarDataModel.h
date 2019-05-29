//
//  CarDataModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/15/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarDataModel : NSObject
/*
 "fullFlag": true,
 "limitCount": 3,
 "carPicUrl": "/component/attachment!showPic.action?checkUser=false&period=&downloadToken=201604071953480189068062078940326210e537ab7425ada8f8cd2430ccb36f&configCode=carManagePic",
 "carId": "20160407195411220530147588478587",
 "carNum": "B4113",
 "carName": "阿斯顿.马丁",
 "aggignData" // 数组模型
  "assignCount": 4
 */

@property (nonatomic, copy) NSString *fullFlag;
@property (nonatomic, copy) NSString *limitCount;
@property (nonatomic, copy) NSString *carPicUrl;
@property (nonatomic, copy) NSString *carId;
@property (nonatomic, copy) NSString *carNum;
@property (nonatomic, copy) NSString *carName;

// 模型数组
@property (nonatomic, copy) NSArray *aggignData;
@property (nonatomic, copy) NSString *assignCount;

@end
