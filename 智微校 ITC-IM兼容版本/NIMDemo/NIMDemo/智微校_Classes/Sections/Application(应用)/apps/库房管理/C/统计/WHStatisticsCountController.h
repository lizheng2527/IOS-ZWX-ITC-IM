//
//  WHStatisticsCountController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/8.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHStatisticsCountController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *goodsID;

-(instancetype)initWithGoodsID:(NSString *)goodID navTitle:(NSString *)navTitle;

@end
