//
//  TYHAddPersonController.h
//  NIMKit
//
//  Created by 中电和讯 on 16/12/26.
//  Copyright © 2016年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHAddPersonController : UIViewController
@property (retain, nonatomic)UITableView *mainTableview;

@property(nonatomic,retain)NSMutableArray *selectPersonArray;

@property(nonatomic,assign)NSInteger type; // 0是默认组织机构,1是班级分组
@end
