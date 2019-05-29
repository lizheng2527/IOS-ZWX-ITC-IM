//
//  WHApplicationController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/14.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHApplicationController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@property(nonatomic,retain)NSMutableArray *dataArray;
@end
