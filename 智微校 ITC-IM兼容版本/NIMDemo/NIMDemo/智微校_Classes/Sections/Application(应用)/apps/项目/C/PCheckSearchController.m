//
//  PCheckSearchController.m
//  NIM
//
//  Created by 中电和讯 on 2017/12/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PCheckSearchController.h"
#import "PCheckSearchListController.h"

#import "ValuePickerView.h"

#import "GYZCustomCalendarPickerView.h"
#import "IDJCalendarUtil.h"
#import "WHChooseApplyUserController.h"


@interface PCheckSearchController ()<GYZCustomCalendarPickerViewDelegate,ChoosePersonDelete>

@property(nonatomic,retain)ValuePickerView *pickerView;

@end

@implementation PCheckSearchController
{
    BOOL isStartTime;
    NSString *choosePersonName;
    NSString *choosePersonID;
    NSString *chooseStartTime;
    NSString *chooseEndTime;
    NSString *chooseType;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"记录搜索";
    
    _pickerView = [[ValuePickerView alloc]init];
    isStartTime = YES;
    chooseType = @"1";
    [self.chooseTypeButton setTitle:@"拜访申请" forState: UIControlStateNormal];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)chooseTypeAction:(id)sender {
    
    __weak typeof(self) weakSelf = self;
    
    NSMutableArray *pickerDatasurce = [NSMutableArray arrayWithObjects:@"拜访申请",@"服务申请",@"服务记录", nil];
    
    self.pickerView.dataSource = pickerDatasurce;
    
    self.pickerView.pickerTitle = @"记录类型";
    //    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [weakSelf.chooseTypeButton setTitle:stateArr[0] forState:UIControlStateNormal];
        
        if ([stateArr[0] isEqualToString:@"拜访申请"]) {
            chooseType = @"1";
        }else if ([stateArr[0] isEqualToString:@"服务申请"]) {
            chooseType = @"2";
        }else if([stateArr[0] isEqualToString:@"服务记录"]) {
            chooseType = @"3";
        }
    };
    [self.pickerView show];
    
}


- (IBAction)choosePersonAction:(id)sender {
 
    WHChooseApplyUserController * baseVc = [[WHChooseApplyUserController alloc] init];
    baseVc.userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    baseVc.userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    baseVc.password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    baseVc.urlStr = @"/bd/mobile/baseData!getTeacherTree.action";
    baseVc.title = @"选择服务人员";
    baseVc.whoWillIn = YES;
    baseVc.delegate = self;
    baseVc.inType = @"项目";
    
    [self.navigationController pushViewController:baseVc animated:YES];
    
}


- (IBAction)chooseStartTimeAction:(id)sender {
    isStartTime = YES;
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"选择待查询日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
    
}

- (IBAction)chooseEndTimeAction:(id)sender {
    isStartTime = NO;
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"选择待查询日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
}



- (IBAction)beginSearchAction:(id)sender {
    PCheckSearchListController *searchView = [PCheckSearchListController new];
    searchView.projectID = _projectID;
    searchView.startTime = chooseStartTime;
    searchView.endTime = chooseEndTime;
    searchView.typeID = chooseType;
    
    [self.navigationController pushViewController:searchView animated:YES];
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
    
    if (isStartTime) {
        [self.chooseStartTimeButton setTitle:result forState:UIControlStateNormal];
        chooseStartTime = result;
    }else
    {
        [self.chooseEndTimeButton setTitle:result forState:UIControlStateNormal];
        chooseEndTime = result;
    }
    
}


- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name {
    choosePersonID = urlId;
    choosePersonName = name;
    [self.choosePersonButton setTitle:name forState:UIControlStateNormal];
}

- (void)didselectedUser:(NSString *)userID userName:(NSString *)name
{
    choosePersonID = userID;
    choosePersonName = name;
    [self.choosePersonButton setTitle:name forState:UIControlStateNormal];
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
