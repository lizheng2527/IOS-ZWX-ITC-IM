//
//  TYHFeedBackCotroller.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/20/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnCheckSuccess2)(BOOL success);
@interface TYHFeedBackCotroller : UIViewController

@property (nonatomic, copy) ReturnCheckSuccess2 returnCheckSuccess2;
@property (nonatomic, copy) NSString * urlStr;

@property (nonatomic, copy) NSString * driverStr;
@property (nonatomic, copy) NSString * carNum;
//@property (nonatomic, copy) NSString * driverId;

@property (nonatomic, copy) NSString * urlStr2;
@property (nonatomic, strong) NSArray * starData;
@property (nonatomic, strong) NSArray * assignData;

@property (nonatomic, assign) BOOL One;
@end
