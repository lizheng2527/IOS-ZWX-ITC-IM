//
//  NTESNetWorkflowViewController.m
//  NIM
//
//  Created by 中电和讯 on 2019/10/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NTESNetWorkflowViewController.h"
#import "TYHHttpTool.h"
#import "NTESWorkflowModel.h"

#import <MJExtension.h>
#define GetApplicationUrlJson @"/bd/mobile/mobileWelcome!getApplicationUrlJson.action"
@interface NTESNetWorkflowViewController ()

@end

@implementation NTESNetWorkflowViewController

//获取工作流标题列表j以及对应的url
-(void)getApplicationUrlJson:(NSString *)code andStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_DataSourceName];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    NSDictionary *dic = [NSDictionary dictionary];
    dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"dataSourceName":dataSourceName,@"appCode":code};
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",BaseURL,GetApplicationUrlJson];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        
        NSMutableArray * blockArray = [NSMutableArray arrayWithArray:[NTESWorkflowModel mj_objectArrayWithKeyValuesArray:json]];
        status(YES,blockArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray new]);
    }];
    
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


@end
