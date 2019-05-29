//
//  PVisitRecordDetailController.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PVisitRecordDetailController : UIViewController

@property(nonatomic,retain)UITableView *mainTableview;

@property(nonatomic,copy)NSString *projectID;
@property(nonatomic,copy)NSString *visitor;

@end
