//
//  qcsClassStasticInsideController.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface qcsClassStasticInsideController : UIViewController

@property(nonatomic,assign)NSInteger viewTag;
@property(nonatomic,copy)NSString *viewTitle;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *wisdomclassId;

@end
