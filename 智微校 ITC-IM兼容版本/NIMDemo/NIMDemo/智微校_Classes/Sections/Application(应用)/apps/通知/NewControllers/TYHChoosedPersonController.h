//
//  TYHChoosedPersonController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/4.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ReturnNameArrayBlock)(NSMutableArray * modelArray);

typedef void(^ReturnUserModelBlock)(NSMutableArray * nameArray);

@interface TYHChoosedPersonController : UIViewController

@property (nonatomic, strong) NSMutableArray * modelArray;
@property (nonatomic, copy) ReturnNameArrayBlock returnNameArrayBlock;

@property (nonatomic, copy) ReturnUserModelBlock returnUserModelBlock;
@property (nonatomic, strong) NSMutableArray * tempArray;

@property (nonatomic, strong) NSMutableArray * selectedArray;

@property (nonatomic, strong) NSMutableArray * groupArray;

@property (nonatomic, copy) NSString * modelId;
@property(nonatomic,strong)NSMutableArray *showTableView;

@property (nonatomic, strong) NSSet * setArray;
@end
