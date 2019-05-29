//
//  WHStatisticsHouseController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/8.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHStatisticsHouseController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *goodsID;
@property(nonatomic,copy)NSString *houseType; //是出库详情还是入库详情
- (void)setNavTitle:(NSString *)title secondTitle:(NSString *)secondTitle;

-(instancetype)initWithGoodsID:(NSString *)goodID requestType:(NSString *)requestType;
@end
