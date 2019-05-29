//
//  WHDiliverController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHDiliverController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *applyID;

- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name goodsCountArray:(NSMutableArray *)goodsArray;

-(void)didselectedDepartment:(NSString *)departID DepartmentName:(NSString *)name;
@end
