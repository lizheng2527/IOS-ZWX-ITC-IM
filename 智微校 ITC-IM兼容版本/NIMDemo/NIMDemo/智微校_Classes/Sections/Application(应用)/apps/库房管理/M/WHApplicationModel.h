//
//  WHApplicationModel.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/6.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WHAApplyMessageModel;
@class WHAApplyReceiveKindModel;

/**
 申请model
 */
@interface WHApplicationModel : NSObject

@property(nonatomic,retain)NSMutableArray *myDepartmentListArray;
@property(nonatomic,retain)WHAApplyMessageModel *applyMessageModel;
@property(nonatomic,retain)WHAApplyReceiveKindModel *applyReceiveKindModel;

@property(nonatomic,copy)NSString *applyReason; //特别添加,避免界面跳转导致用户输入的申领原因被清空
@property(nonatomic,copy)NSString *applyNote;//同上,避免申领备注被清空

@property(nonatomic,retain)NSMutableArray *WHAApplyReceiveKindListModelArray;
@end


/**
 申请机构列表详情
 */
@interface WHAMyDepartmentListModel : NSObject

@property(nonatomic,copy)NSString *departmentId;
@property(nonatomic,retain)NSMutableArray *userList;
@property(nonatomic,retain)NSMutableArray *userListModelArray;

@property(nonatomic,copy)NSString *departmentName;

@end

/**
 审核人详情
 */
@interface WHACheckerModel : NSObject

@property(nonatomic,copy)NSString *checkUserId;
@property(nonatomic,copy)NSString *checkUserName;

@end



/**
    申领信息详情-自动填写
 */
@interface WHAApplyMessageModel : NSObject

@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *date;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;

@end


/**
 部门申领类型model
 */
@interface WHAApplyReceiveKindModel : NSObject

@property(nonatomic,copy)NSString *bmsl;
@property(nonatomic,copy)NSString *grsl;

@end

@interface WHAApplyReceiveKindListModel : NSObject
@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *name;
@end


//主页权限Model
@interface WHMainPageModel : NSObject

@property(nonatomic,copy)NSString *zwslsh;
@property(nonatomic,copy)NSString *zwCount;
@property(nonatomic,copy)NSString *sr_statistics;
@property(nonatomic,copy)NSString *sr_warehouseManage;
@property(nonatomic,copy)NSString *deptslsh;
@property(nonatomic,copy)NSString *deptCount;

@property(nonatomic,copy)NSString *myCount;
@property(nonatomic,copy)NSString *outWareCount;
@property(nonatomic,copy)NSString *provideCount;


/**
 * zwslsh : 1    总务的审核权限   1有 0无
 * zwCount : 8     总务待审核数量
 * sr_statistics : 1    查看统计权限
 * sr_warehouseManage : 1    发放物品权限
 * deptslsh : 1  部门审核权限
 * deptCount : 4    部门待审核数量
 */

@end
