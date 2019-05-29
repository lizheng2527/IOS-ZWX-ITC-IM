//
//  WHApplicationDetailController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHApplicationDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *applyID;
@end
