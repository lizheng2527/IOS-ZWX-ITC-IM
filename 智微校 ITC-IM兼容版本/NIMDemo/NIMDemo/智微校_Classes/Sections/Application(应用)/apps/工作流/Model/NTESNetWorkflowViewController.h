//
//  NTESNetWorkflowViewController.h
//  NIM
//
//  Created by 中电和讯 on 2019/10/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESWorkflowModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface NTESNetWorkflowViewController : UIViewController
//获取工作流标题列表j以及对应的url
-(void)getApplicationUrlJson:(NSString *)code andStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
