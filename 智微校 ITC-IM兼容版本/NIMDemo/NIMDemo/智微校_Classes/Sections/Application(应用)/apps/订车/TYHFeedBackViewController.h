//
//  TYHFeedBackViewController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/21/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReturnCheckSuccess3)(BOOL success);

@interface TYHFeedBackViewController : UIViewController

@property (nonatomic, copy) ReturnCheckSuccess3 returnCheckSuccess2;

@property (nonatomic, copy) NSString * urlStr;

@property (nonatomic, assign) BOOL One;

@end
