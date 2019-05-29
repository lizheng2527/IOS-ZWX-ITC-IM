//
//  WHGoodsKindListController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/9.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHGoodsKindListController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,retain)NSMutableArray *goodsArray;

@property(nonatomic,copy)NSString *warehouseID;
@end
