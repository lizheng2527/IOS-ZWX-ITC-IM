//
//  TYHScanViewController.m
//  NIM
//
//  Created by 中电和讯 on 2017/5/9.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHScanViewController.h"
#import "NSString+NTES.h"
#import "TYHHttpTool.h"


@interface TYHScanViewController ()

@end

@implementation TYHScanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册观察者
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeAibum:) name:SGQRCodeInformationFromeAibum object:nil];
    [SGQRCodeNotificationCenter addObserver:self selector:@selector(SGQRCodeInformationFromeScanning:) name:SGQRCodeInformationFromeScanning object:nil];
}

//从相册选取
- (void)SGQRCodeInformationFromeAibum:(NSNotification *)noti {
    NSString *string = noti.object;
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:string preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [self presentViewController:alertC animated:YES completion:nil];
}

//从扫描信息获取数据
- (void)SGQRCodeInformationFromeScanning:(NSNotification *)noti {

    NSDictionary *infoDic = [self dictionaryWithJsonString:noti.object];
        if ([infoDic isKindOfClass:[NSNull class]]) {
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"该二维码无效" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
        }
        else
        {
            if (infoDic.allKeys.count) {
                NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
                NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
                NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
                NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
                dataSourceName = dataSourceName.length?dataSourceName:@"";
//#define k_V3ServerURL @"http://222.128.2.27/dc"
                
                NSDictionary *userInfoDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"dataSourceName":dataSourceName,@"uuid":[infoDic objectForKey:@"u"],@"dataSource":[infoDic objectForKey:@"i"],@"userId":userID};
                NSString *requestURL = [NSString stringWithFormat:@"%@/bd/mobile/twoDimensionCodeLogin!saveUserLoginInfo.action",k_V3ServerURL];
                
                [SVProgressHUD showWithStatus:@"登录中..."];
                
                [TYHHttpTool get:requestURL params:userInfoDic success:^(id json) {
                    [self.view makeToast:@"网页登录成功" duration:1.5 position:CSToastPositionBottom];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } failure:^(NSError *error) {
                    [self.view makeToast:@"网页登录失败" duration:1.5 position:CSToastPositionBottom];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }];
            }
            else {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"该二维码无效" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:YES];
                }];
                [alertC addAction:alertA];
                [self presentViewController:alertC animated:YES completion:nil];
            }
        }
}

- (void)dealloc {
    SGQRCodeLog(@"QRCodeScanningVC - dealloc");
    [SGQRCodeNotificationCenter removeObserver:self];
}


- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
