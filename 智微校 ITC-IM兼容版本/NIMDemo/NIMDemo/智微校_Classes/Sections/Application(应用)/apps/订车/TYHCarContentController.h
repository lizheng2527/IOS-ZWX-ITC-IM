//
//  TYHCarContentController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/24/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CheckStatus) {
    CHECKSTATUS_ASSIGNING,//默认从0开始
    CHECKSTATUS_DRAFT,
    CHECKSTATUS_PASS,
    CHECKSTATUS_UNPASS,
    CHECKSTATUS_FINISH,
    CHECKSTATUS_CANCEL,
    CHECKSTATUS_CHECK,
};
typedef NS_ENUM(NSInteger, CheckStatusMyTask) {
    CHECKSTATUS_DQR,
    CHECKSTATUS_DJS,
    CHECKSTATUS_DPJ,
    CHECKSTATUS_ALL,
};


@interface TYHCarContentController : UITableViewController

@property (nonatomic, assign) int tag;

@property (nonatomic, copy) NSString * strUrl;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, copy) NSString * carOrderId;

@end
