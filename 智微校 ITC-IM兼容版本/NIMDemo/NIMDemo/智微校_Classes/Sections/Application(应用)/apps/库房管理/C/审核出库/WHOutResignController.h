//
//  WHOutResignController.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/12.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHOutResignController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *ApplicationUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *diliverTimeLabel;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *outID;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end
