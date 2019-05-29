//
//  WHOutDetailController.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/12.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHOutDetailController : UIViewController

@property(nonatomic,copy)NSString *outID;

@property (weak, nonatomic) IBOutlet UILabel *outCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *outDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *outWareHouseLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyKindLabel;
@property (weak, nonatomic) IBOutlet UIButton *writeBtn;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end
