//
//  WHAddApplicationDiliverController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/28.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHAddApplicationDiliverController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *applyID;

- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name;

- (void)didselectedUser:(NSString *)userID userName:(NSString *)name;


-(void)didselectedDepartment:(NSString *)departID DepartmentName:(NSString *)name;

@property(nonatomic,retain)NSMutableArray *dataArray;
@end
