//
//  WHGoodsDetailListController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/9.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHGoodsDetailListController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *goodsID;

@property(nonatomic,retain)NSMutableArray *tmpDataArray;
@end
