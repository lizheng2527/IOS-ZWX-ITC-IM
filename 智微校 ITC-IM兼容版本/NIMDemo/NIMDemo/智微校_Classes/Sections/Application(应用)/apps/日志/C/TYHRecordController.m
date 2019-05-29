//
//  TYHRecordController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/17.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHRecordController.h"
#import "RecordMainCell.h"
#import "SDAutoLayout.h"
#import "RNewRecordController.h"
#import "RecordNetHelper.h"
#import "RecordModel.h"
#import "RRecordDetailController.h"

#import "GYZCustomCalendarPickerView.h"
#import "IDJCalendarUtil.h"

@interface TYHRecordController ()<UITableViewDelegate,UITableViewDataSource,GYZCustomCalendarPickerViewDelegate>

@property(nonatomic,retain)NSMutableArray *dataSource;
@end

@implementation TYHRecordController
{
    UILabel *timeLabel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    [self createBarItem];
    [self createApplyButton];
    [self setNavTitle:@"工作日志"];
//    [self requestData:@""];
}

#pragma mark - RequestData
-(void)requestData:(NSString *)dataString
{
    
    [SVProgressHUD showWithStatus:@"获取数据中"];
    RecordNetHelper *helper = [RecordNetHelper new];
    [helper getMyRecordListWithDate:dataString andStatus:^(BOOL successful, NSMutableArray *dataaSource) {
        _dataSource = [NSMutableArray arrayWithArray:dataaSource];
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
    _mainTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.bounces = NO;
    _mainTableview.tableFooterView = [UIView new];
    _mainTableview.separatorStyle = NO;
    [self.view addSubview:_mainTableview];
    
}

-(void)createApplyButton
{
    UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    applyButton.frame = CGRectMake(self.view.width / 2 - 45, self.view.height - 110, 90, 30);
    if (kDevice_Is_iPhoneX) {
        applyButton.frame = CGRectMake(self.view.width / 2 - 45, self.view.height - 110 - 34, 90, 30);
    }
    applyButton.layer.masksToBounds = YES;
    applyButton.layer.cornerRadius = 4.f;
    [applyButton setTitle:@"写日志" forState: UIControlStateNormal];
    [applyButton setBackgroundColor:[UIColor blueColor]];
    [applyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [applyButton addTarget:self action:@selector(addItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:applyButton];
}

-(void)createBarItem
{
    UIBarButtonItem * rightItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_ci_history"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(dateSelectAction:)];
    } else {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_ci_history"] style:UIBarButtonItemStyleDone target:self action:@selector(dateSelectAction:)];
    }
    self.navigationItem.rightBarButtonItem =rightItem;
}

- (void)setNavTitle:(NSString *)title{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 50)];
    bgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:bgView];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 100, 30)];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:16];
    titleLabel.textColor = [UIColor  whiteColor];
    [bgView addSubview:titleLabel];
    
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 100, 15)];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    timeLabel.text = dateString;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.textColor = [UIColor  whiteColor];
    timeLabel.font = [UIFont boldSystemFontOfSize:13];
    [bgView addSubview:timeLabel];
    
    self.navigationItem.titleView = bgView;
}


#pragma mark - TableViewDelegate & Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{   
    static NSString *iden = @"RecordMainCell";
    RecordMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"RecordMainCell" owner:self options:nil].firstObject;
    }
    
    cell.model = _dataSource[indexPath.row];
    cell.selectionStyle = NO;
    if (indexPath.row % 3 == 0) {
        cell.nameLabel.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:229 / 255.0 blue:0 / 255.0 alpha:1];
    }
    else if (indexPath.row % 3 == 1)
    {
        cell.nameLabel.backgroundColor = [UIColor colorWithRed:102 / 255.0 green:178 / 255.0 blue:255 / 255.0 alpha:1];
    }
    else
    {
        cell.nameLabel.backgroundColor = [UIColor colorWithRed:20 / 255.0 green:128 / 255.0 blue:255 / 255.0 alpha:1];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RRecordDetailController *recordView = [RRecordDetailController new];
    recordView.model = _dataSource[indexPath.row];
    [self.navigationController pushViewController:recordView animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 156;
}


#pragma QTCustomCalendarPickerViewDelegate
//接收日期选择器选项变化的通知
- (void)notifyNewCalendar:(IDJCalendar *)cal {
    NSString *result = @"点击";
    if ([cal isMemberOfClass:[IDJCalendar class]]) {//阳历
        
        NSString *year =[NSString stringWithFormat:@"%@",cal.year];
        NSString *month = [cal.month intValue] > 9 ? cal.month:[NSString stringWithFormat:@"0%@",cal.month];
        NSString *day = [cal.day intValue] > 9 ? cal.day:[NSString stringWithFormat:@"0%@",cal.day];
        result = [NSString stringWithFormat:@"%@-%@-%@",year,month, day];
        
    } else if ([cal isMemberOfClass:[IDJChineseCalendar class]]) {//阴历
        
        IDJChineseCalendar *_cal=(IDJChineseCalendar *)cal;
        
        NSArray *array=[_cal.month componentsSeparatedByString:@"-"];
        NSString *dateStr = @"";
        if ([[array objectAtIndex:0]isEqualToString:@"a"]) {
            dateStr = [NSString stringWithFormat:@"%@%@",dateStr,[_cal.chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1]];
        } else {
            dateStr = [NSString stringWithFormat:@"%@闰%@",dateStr,[_cal.chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1]];
        }
        result = [NSString stringWithFormat:@"%@%@",dateStr, [NSString stringWithFormat:@"%@", [_cal.chineseDays objectAtIndex:[_cal.day intValue]-1]]];
    }
    timeLabel.text = result;
    [self requestData:result];
}

#pragma mark - ClickActions

-(void)submitAction:(id)sender
{
    
}

-(void)addItemAction:(id)sender
{
    RNewRecordController *checkView =[RNewRecordController new];
    [self.navigationController pushViewController:checkView animated:YES];
}

-(void)dateSelectAction:(id)sender
{
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"选择待查询日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self requestData:@""];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
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
