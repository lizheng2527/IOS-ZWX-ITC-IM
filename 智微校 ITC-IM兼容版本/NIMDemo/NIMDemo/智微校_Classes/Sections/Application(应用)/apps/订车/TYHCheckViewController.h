//
//  TYHCheckViewController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/12/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnCheckSuccess)(BOOL success);

@interface TYHCheckViewController : UIViewController

@property (nonatomic, copy) ReturnCheckSuccess returnCheckSuccess;

@property (nonatomic, copy) NSString * carOrderId;
@property (nonatomic, copy) NSString * urlStr;

@property (nonatomic, assign) BOOL One;

@end
