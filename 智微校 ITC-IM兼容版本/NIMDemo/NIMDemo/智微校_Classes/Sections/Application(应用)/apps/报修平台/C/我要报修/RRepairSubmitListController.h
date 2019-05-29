//
//  RRepairSubmitListController.h
//  NIM
//
//  Created by 中电和讯 on 17/3/15.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRepairSubmitListController : UIViewController

@property(nonatomic,copy)NSString *goodsID;
@property(nonatomic,copy)NSString *typeName;
@property(nonatomic,copy)NSString *groupID;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end
