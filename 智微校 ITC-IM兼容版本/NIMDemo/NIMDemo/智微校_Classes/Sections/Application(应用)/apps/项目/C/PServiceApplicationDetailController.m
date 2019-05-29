//
//  PServiceApplicationDetailController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/28.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PServiceApplicationDetailController.h"
#import "PServiceApplyDetailCell.h"
#import <MJExtension.h>
#import "ProjectNetHelper.h"


@interface PServiceApplicationDetailController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PServiceApplicationDetailController
{
    NSDictionary *mainDic;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.title = @"服务申请详情";
//    [self createApplyButton];
    [self requestData];
}

#pragma mark - RequestData
-(void)requestData
{
    [SVProgressHUD showWithStatus:@"获取详情中"];
    ProjectNetHelper *helper = [ProjectNetHelper new];
    [helper getCheckDetailWithProjectID:_projectApplyID andStatus:^(BOOL successful, NSDictionary *jsonDic) {
        mainDic = jsonDic;
        [_mainTableview reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
    }];
    
}

#pragma mark - initView
-(void)initTableView
{
    _mainTableview = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.bounces = NO;
//    _mainTableview.rowHeight = 168;
    _mainTableview.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableview];
}


//-(void)createApplyButton
//{
//    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    applyButton.frame = CGRectMake(self.view.width / 2, self.view.height - 30, 60, 20);
//    [applyButton setTitle:@"申请立项" forState: UIControlStateNormal];
//    [applyButton setBackgroundColor:[UIColor lightGrayColor]];
//
//    [self.view addSubview:applyButton];
//}

#pragma mark - TableViewDelegate & Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"PServiceApplyDetailCell";
    PServiceApplyDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"PServiceApplyDetailCell" owner:self options:nil].firstObject;
    }
    
    
    cell.applyPersonLabel.text = [mainDic objectForKey:@"applyerName"];
    cell.applyPersonPhoneLabel.text = [mainDic objectForKey:@"phoneNum"];
    cell.projectNameLabel.text = [mainDic objectForKey:@"projectName"];

    cell.serviceJianshuLabel.text = [mainDic objectForKey:@"sketch"];
    cell.serviceBeginTimeLabel.text = [mainDic objectForKey:@"serviceTimeStart"];
    cell.serviceEndTimeLabel.text = [mainDic objectForKey:@"serviceTimeEnd"];
    cell.serviceWaysLabel.text = [mainDic objectForKey:@"serviceWay"];
    cell.serviceAreaLabel.text = [mainDic objectForKey:@"servicePlace"];
    cell.serviceSchoolOrCompanyLabel.text = [mainDic objectForKey:@"serviceSchool"];
    cell.serviceCustomLabel.text = [mainDic objectForKey:@"serviceObject"];
    cell.serviceClientPersonLabel.text = [mainDic objectForKey:@"linkMan"];
    cell.serviceClientPhoneLabel.text = [mainDic objectForKey:@"linkManPhone"];
    cell.serviceClientMailLabel.text = [mainDic objectForKey:@"linkManEmail"];
    cell.serviceTargetLabel.text = [mainDic objectForKey:@"serviceTarget"];
    cell.serviceMemberLabel.text = [mainDic objectForKey:@"together"];
    cell.serviceRemarkLabel.text = [mainDic objectForKey:@"remark"];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    _mainTableview.rowHeight = UITableViewAutomaticDimension;//设置cell的高度为自动计算，只有才xib或者storyboard上自定义的cell才会生效，需要在xib中设置好约束
//    _mainTableview.estimatedRowHeight = 600;//必须设置好预估值
//    return _mainTableview.rowHeight + 100;
    return 650;
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 600;
//}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
