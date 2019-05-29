//
//  AttendanceStatisticsController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AttendanceStatisticsController.h"
#import "AttendanceStatisticsCell.h"
#import "AttendanceNetHelper.h"
#import "AttendanceModel.h"

#import "GYZCustomCalendarPickerView.h"
#import "IDJCalendarUtil.h"

@interface AttendanceStatisticsController ()<UITableViewDelegate,UITableViewDataSource,GYZCustomCalendarPickerViewDelegate>

@end

@implementation AttendanceStatisticsController
{
    NSMutableArray *dataSource;
    
    UILabel *timeLabel;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initTableView];
    [self requestData:@""];
    [self createBarItem];
    [self setNavTitle:@"考勤统计"];
    
}

//将NSDate按yyyy-MM-dd格式时间输出
-(NSString*)nsdateToString:(NSDate *)date
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString* string=[dateFormat stringFromDate:date];
    return string;
}


#pragma mark - initData
-(void)requestData:(NSString *)dateString
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取统计数据中";
    
    AttendanceNetHelper *helper = [AttendanceNetHelper new];
    [helper getAttendanceDateListWithDate:dateString andStatus:^(BOOL successful, NSMutableArray *dataArray) {
        dataSource = [NSMutableArray arrayWithArray:dataArray];
        [_mainTableview reloadData];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        dataSource = [NSMutableArray array];
        [hud removeFromSuperview];
    }];
}

#pragma mark - initView
-(void)initTableView
{
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.rowHeight = 80;
    _mainTableview.tableFooterView = [UIView new];
}


-(void)createBarItem
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
    
    UIBarButtonItem * rightItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_ci_history"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(dateSelectAction:)];
    } else {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_ci_history"] style:UIBarButtonItemStyleDone target:self action:@selector(dateSelectAction:)];
    }
    self.navigationItem.rightBarButtonItem =rightItem;
    
}



#pragma mark - TableViewDelegate & Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttendanceListModel *model = dataSource[indexPath.row];
    static NSString *iden = @"AttendanceStatisticsCell";
    AttendanceStatisticsCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"AttendanceStatisticsCell" owner:self options:nil].firstObject;
    }
    cell.model = model;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    AttendanceListModel *model = dataSource[indexPath.row];
//    CGFloat cellHeight =0;
//    //label的高度
//    CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width , MAXFLOAT);
//    CGFloat labelHeight = [model.endAddress boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14]} context:nil].size.height;
//    cellHeight += labelHeight;
//    if (cellHeight >= 85) {
//        return cellHeight + 58;
//    }else
//        return 80;
//}

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


#pragma mark - other
-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xff4c4c4c)];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorGreen]];
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


-(void)dateSelectAction:(id)sender
{
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"选择待查询日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
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
