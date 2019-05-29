//
//  qcsClassReviewSearchController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassReviewSearchController.h"
#import "ValuePickerView.h"
#import "QCSMainModel.h"
#import "GYZCustomCalendarPickerView.h"
#import "QCSchoolDefine.h"

#import "qcsClassReviewSearchTreeController.h"

#import "qcsClassReviewInsideStudentController.h"
#import "NSString+NTES.h"
#import "qcsClassReviewInsideController.h"
#import "qcsClassReviewMainController.h"


@interface qcsClassReviewSearchController ()<GYZCustomCalendarPickerViewDelegate>

@property(nonatomic,retain)ValuePickerView *pickerView;



@property(nonatomic,copy)NSString *chooseStartTimeString;
@property(nonatomic,copy)NSString *chooseEndTimeString;

@property(nonatomic,assign)BOOL isChooseStartTime;

@end

@implementation qcsClassReviewSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"查询";
    
    [self initPickview];
    
    self.chooseStartTimeString = [QCSSourceHandler getDateOneYearBefore];
    self.chooseEndTimeString = [QCSSourceHandler getDateToday];
    
    [self.chooseStartTimeButton setTitle:[QCSSourceHandler getDateOneYearBefore] forState:UIControlStateNormal];
    [self.chooseEndTimeButton setTitle:[QCSSourceHandler getDateToday] forState:UIControlStateNormal];
    
    
    if (self.studentCourseArray.count && [self.userType isEqualToString:@"student"]) {
        QCSMainChildrenCourseModel *model = self.studentCourseArray[0];
        self.chooseCourseID = model.id;
        [self.chooseClassButton setTitle:model.name forState:UIControlStateNormal];
    }
    
}

-(void)initPickview
{
    _pickerView = [[ValuePickerView alloc]init];
    self.pickerView.pickerTitle = @"选择课程";
    self.pickerView.appType = @"青蚕学堂";
}

- (IBAction)chooseCourseAction:(id)sender {
    
    
     if ([self.userType isEqualToString:@"student"]) {
         
         NSMutableArray *array = [NSMutableArray array];
         for (QCSMainChildrenCourseModel *model in self.studentCourseArray) {
             [array addObject:model.name];
         }
         self.pickerView.dataSource = array;
         __weak typeof(self) weakSelf = self;
         
         self.pickerView.valueDidSelect = ^(NSString *value){
             NSArray * stateArr = [value componentsSeparatedByString:@"/"];
             NSInteger index = [stateArr[1] integerValue] - 1;
             weakSelf.chooseName = stateArr[0];
             
             if (weakSelf.studentCourseArray.count) {
                 QCSMainChildrenCourseModel *model = weakSelf.studentCourseArray[index];
                 weakSelf.chooseCourseID = model.id;
             }
             [weakSelf.chooseClassButton setTitle:weakSelf.chooseName forState:UIControlStateNormal];
         };
         [self.pickerView show];
     }
    
    else
    {
        
        qcsClassReviewSearchTreeController *qcView = [qcsClassReviewSearchTreeController new];
        qcView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
        
        [self.navigationController pushViewController:qcView animated:YES];
    }
}

- (IBAction)chooseStartTimeAction:(id)sender {
    
    _isChooseStartTime = YES;
    
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"请选择日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
    
}
- (IBAction)chooseEndTimeAction:(id)sender {
    _isChooseStartTime = NO;
    
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"请选择日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
}


- (IBAction)searchAction:(id)sender {
    
    if ([NSString isBlankString:self.chooseCourseID]) {
        [self.view makeToast:@"请选择待查询课程" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    if ([self.userType isEqualToString:@"student"]) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[qcsClassReviewInsideStudentController class]]) {
                qcsClassReviewInsideStudentController *tempController = (qcsClassReviewInsideStudentController *)controller;
                tempController.chooseEndTime = self.chooseEndTimeString;
                tempController.chooseStartTime = self.chooseStartTimeString;
                tempController.chooseCourseID = self.chooseCourseID;
                
                [tempController getChooseData];
                [self.navigationController popToViewController:tempController animated:YES];
            }
        }
    }else
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[qcsClassReviewMainController class]]) {
                qcsClassReviewMainController *tempController = (qcsClassReviewMainController *)controller;
                
                tempController.chooseEndTime = self.chooseEndTimeString;
                tempController.chooseStartTime = self.chooseStartTimeString;
                tempController.chooseCourseID = self.chooseCourseID;
                tempController.chooseEclassID = self.chooseEclassID;

                tempController.viewTag = 1001;
                
                NSDictionary *dic = @{@"chooseEndTime":self.chooseEndTimeString,@"chooseStartTime":self.chooseStartTimeString,@"chooseCourseID":self.chooseCourseID,@"chooseEclassID":self.chooseEclassID};

                [[NSNotificationCenter defaultCenter]postNotificationName:@"shouldRefrshClass" object:nil userInfo:[NSDictionary dictionaryWithDictionary:dic]];
                
                
                
                [self.navigationController popToViewController:tempController animated:YES];
            }
        }
    }
    
}


#pragma QTCustomCalendarPickerViewDelegate
//接收日期选择器选项变化的通知
- (void)notifyNewCalendar:(IDJCalendar *)cal {
    NSString *result = @"";
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
    
    if (_isChooseStartTime) {
        [self.chooseStartTimeButton setTitle:result forState:UIControlStateNormal];
        self.chooseStartTimeString = result;
    }
    else
    {
        [self.chooseEndTimeButton setTitle:result forState:UIControlStateNormal];
        self.chooseEndTimeString = result;
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
