//
//  AssetApplyDetailController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/2.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetApplyDetailController.h"
#import "TYHAssetModel.h"
#import "AssetNetWorkHelper.h"
#import "NSString+Empty.h"

@interface AssetApplyDetailController ()

@end

@implementation AssetApplyDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"详情";
    [self initData];
    [self createBarItem];
    
}

-(void)setApplyID:(NSString *)applyID
{
    _applyID = applyID;
}

-(void)initData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper getApplyDetailJsonWithApplyId:_applyID andStatus:^(BOOL successful, AssetMineApplyModel *applyModel) {
        [self initViewWithModel:applyModel];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
}

-(void)initViewWithModel:(AssetMineApplyModel *)model
{
    _assetTypeLabel.text =[NSString stringWithFormat:@"资产类别: %@ ",model.assetKindName] ;
    _assetApplyDateLabel.text = [NSString stringWithFormat:@"申请日期: %@ ",model.applyDate];
    _assetApplyPersonLabel.text = [NSString stringWithFormat:@"使用人: %@ ",model.applyUserName];
    _assetApplyOraginationLabel.text = [NSString stringWithFormat:@"申请部门: %@ ",model.departmentName];
    _assetBeiApplyOraLabel.text = [NSString stringWithFormat:@"被申请校区: %@ ",model.school];
    _assetUsageNoteLabel.text = [NSString stringWithFormat:@"用途说明: %@ ",model.reason];
    _assetSetNoteLabel.text = [NSString stringWithFormat:@"配置说明: %@ ",model.demand];
    _assetApplyStateLabel.text = [NSString stringWithFormat:@"状态: %@ ",model.checkStatus];
    if (![NSString isBlankString:model.checkReason]) {
        _assetCheckLabel.text = [NSString stringWithFormat:@"审核说明: %@ ",model.checkReason];
    }
}


-(void)createBarItem
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
