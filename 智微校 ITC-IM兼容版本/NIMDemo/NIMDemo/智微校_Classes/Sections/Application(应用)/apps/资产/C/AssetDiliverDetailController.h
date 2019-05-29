//
//  AssetDiliverDetailController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/5.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetDiliverDetailController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *assetUserPerson;
@property (weak, nonatomic) IBOutlet UILabel *assetReceiveOrganization;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,retain)NSMutableArray *dataArray;

@property(nonatomic,copy)NSString *returnID;


@property(nonatomic,copy)NSString *assetUser;
@property(nonatomic,copy)NSString *assetDepartmentName;
@property(nonatomic,copy)NSString *applicationRecordId;
@property(nonatomic,copy)NSString *departmentId;
@property(nonatomic,copy)NSString *applyUserID;

@property(nonatomic,copy)NSString *whoGoinType;
@end
