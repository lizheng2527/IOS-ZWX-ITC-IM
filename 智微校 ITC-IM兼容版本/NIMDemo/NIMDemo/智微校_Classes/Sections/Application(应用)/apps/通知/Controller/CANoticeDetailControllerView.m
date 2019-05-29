//
//  CANoticeDetailControllerView.m
//  NIM
//
//  Created by 中电和讯 on 2018/9/29.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "CANoticeDetailControllerView.h"
#import "TYHClassAttendanceController.h"
#import "NSString+NTES.h"

#import "TYHAttendanceController.h"
#import "TYHRepairMainController.h"
#import "TYHAssetViewController.h"
#import "TYHWarehouseManagementController.h"
#import "TYHNewReceptionViewController.h"
#import "lookHomeworkViewController.h"
#import "TYHNewAPPViewController.h"
#import "NoticeModel.h"


@interface CANoticeDetailControllerView ()

@end

@implementation CANoticeDetailControllerView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.title = @"课堂考勤";
    
    self.title = _navTitleString;
    [self createBarItem];
    
    _titleLabel.text = _titleString;
    
    _detailLabel.text = [NSString isBlankString:_detailString]?@"暂无详情":_detailString;
    
    

}


-(void)createBarItem
{
    UIBarButtonItem * rightItem = nil;
    
        rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"ca_icon_toapp"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(pushViewWithCode:)];

    if (!_shouldHideRightBar) {
        self.navigationItem.rightBarButtonItem =rightItem;
    }
    
}



-(void)pushViewWithCode:(NSString *)code
{
    
    NSString *str = _model.kindCode;
    
    //考勤
     if([str isEqualToString:@"ta"])
    {
        TYHAttendanceController *attView = [TYHAttendanceController new];
        [self.navigationController pushViewController:attView animated:YES];
        return ;
    }
    else if([str isEqualToString:@"ca"])
    {
        TYHClassAttendanceController *caView = [TYHClassAttendanceController new];
        [self.navigationController pushViewController:caView animated:YES];
    }
    //报修
    else if([str isEqualToString:@"re"])
    {
        
        TYHRepairMainController *attView = [TYHRepairMainController new];
        [self.navigationController pushViewController:attView animated:YES];
        return ;
    }
    //课堂考勤
    else if([str isEqualToString:@"ca"])
    {
        TYHClassAttendanceController *attView = [TYHClassAttendanceController new];
        [self.navigationController pushViewController:attView animated:YES];
        return ;
    }
    
    //资产
    else if([str isEqualToString:@"ao"])
    {
        TYHAssetViewController *assetView = [TYHAssetViewController new];
        [self.navigationController pushViewController:assetView animated:YES];
    }
    //库房,易耗品
    else if([str isEqualToString:@"sr"])
    {
        TYHWarehouseManagementController *assetView = [TYHWarehouseManagementController new];
        [self.navigationController pushViewController:assetView animated:YES];
    }
    else if([str isEqualToString:@"ar"])
    {
        
    }
    //订车
    else if([str isEqualToString:@"carmanage"]){
    
        TYHNewReceptionViewController * receptVC = [[TYHNewReceptionViewController alloc] init];
        
        receptVC.userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
        [receptVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:receptVC animated:YES];
        
    }
//    else if([str isEqualToString:@"ne"]||[str isEqualToString:@"wc"]||[str isEqualToString:@"course"]||[str isEqualToString:@"fi"]){
//
//        TYHNewAPPViewController * newAppVc = [[TYHNewAPPViewController alloc] init];
//        NSString *nodeServerUrl = [[NSUserDefaults standardUserDefaults]valueForKey: NODE_SERVER_URL];
//        NSString *nodeParam = [[NSUserDefaults standardUserDefaults]valueForKey: NODE_SERVER_PARAM];
//        NSString * url = [NSString stringWithFormat:@"%@%@%@",nodeServerUrl,model.mobileUrl,nodeParam];
//
//        //仅仅为了消息列表的跳转
//        newAppVc.sourceId = @"test";
//        [newAppVc setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:newAppVc animated:YES];
//
//    }
    //H5 公式单独处理
    else if([str isEqualToString:@"pu"]){
        
        TYHNewAPPViewController * newAppVc = [[TYHNewAPPViewController alloc] init];
        NSString *nodeServerUrl = [[NSUserDefaults standardUserDefaults]valueForKey: NODE_SERVER_URL];
        
        NSMutableString *dealNodeServerUrl = [NSMutableString stringWithString:nodeServerUrl];
        NSString *nodeServerUrlAfterDealing =[dealNodeServerUrl stringByReplacingOccurrencesOfString:@"static" withString:@"dc"];
        
        NSString *nodeParam = [[NSUserDefaults standardUserDefaults]valueForKey: NODE_SERVER_PARAM];
        NSString * url = [NSString stringWithFormat:@"%@%@?%@",nodeServerUrlAfterDealing,_model.mobileUrl,nodeParam];
        //仅仅为了消息列表的跳转
        //需要拼接userId
        newAppVc.sourceId = @"userID";
        newAppVc.userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
        [newAppVc setHidesBottomBarWhenPushed:YES];
        newAppVc.urlstr = url;
        [self.navigationController pushViewController:newAppVc animated:YES];
    }
    //作业
    else if([str isEqualToString:@"bd_module_wk"])
    {

        lookHomeworkViewController *lookView = [[lookHomeworkViewController alloc]init];
        lookView.homeworkID = _model.sourceId;
        [lookView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:lookView animated:YES];
    }
    else {
        
        TYHNewAPPViewController * newAppVc = [[TYHNewAPPViewController alloc] init];
        NSString *nodeServerUrl = [[NSUserDefaults standardUserDefaults]valueForKey: NODE_SERVER_URL];
        NSString *nodeParam = [[NSUserDefaults standardUserDefaults]valueForKey: NODE_SERVER_PARAM];
        NSString * url = [NSString stringWithFormat:@"%@%@?%@",nodeServerUrl,_model.mobileUrl,nodeParam];
        
        //仅仅为了消息列表的跳转
        newAppVc.sourceId = @"userID";
        newAppVc.userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
        [newAppVc setHidesBottomBarWhenPushed:YES];
        newAppVc.urlstr = url;
        [self.navigationController pushViewController:newAppVc animated:YES];
        
    }
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
