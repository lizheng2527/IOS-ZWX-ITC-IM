//
//  qcsHomeworkSearchController.m
//  NIM
//
//  Created by 中电和讯 on 2018/5/15.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsHomeworkSearchController.h"

#import "GYZCustomCalendarPickerView.h"
#import "QCSchoolDefine.h"

#import "ValuePickerView.h"
#import "QCSMainModel.h"
#import "NSString+NTES.h"
#import "QCSNetHelper.h"

#import "qcsHomeworkMainController.h"

@interface qcsHomeworkSearchController ()<GYZCustomCalendarPickerViewDelegate>

@property(nonatomic,copy)NSString *chooseGradeID;
@property(nonatomic,copy)NSString *chooseClassID;
@property(nonatomic,copy)NSString *chooseCourseID;
@property(nonatomic,copy)NSString *chooseTypeID;


@property(nonatomic,copy)NSString *chooseStartTimeString;
@property(nonatomic,copy)NSString *chooseEndTimeString;

@property(nonatomic,assign)BOOL isChooseStartTime;

@property(nonatomic,retain)ValuePickerView *pickerView;
@end

@implementation qcsHomeworkSearchController
{
    __block NSInteger idxGrade;
    __block NSInteger idxClass;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询";
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    
    [self initPickview];
    
    self.chooseStartTimeString = [QCSSourceHandler getDateOneYearBefore];
    self.chooseEndTimeString = [QCSSourceHandler getDateToday];
    
    [self.chooseStartTimeButton setTitle:[QCSSourceHandler getDateOneYearBefore] forState:UIControlStateNormal];
    [self.chooseEndTimeButton setTitle:[QCSSourceHandler getDateToday] forState:UIControlStateNormal];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)initPickview
{
    _pickerView = [[ValuePickerView alloc]init];
    self.pickerView.pickerTitle = @"选择项";
    self.pickerView.appType = @"青蚕学堂";
    
    if (self.studentCourseArray.count) {
        QCSMainResultGradeModel *model = self.studentCourseArray[0];
        self.chooseGradeID = model.id;
        
        [self.chooseGradeButton setTitle:model.name forState:UIControlStateNormal];
        
        if (model.childrenEclassModelArray.count) {
            QCSMainChildrenEclassModel *eclassModel =  model.childrenEclassModelArray[0];
            [self.chooseClassButton setTitle:eclassModel.name forState:UIControlStateNormal];
            self.chooseClassID = eclassModel.id;
            
            if (eclassModel.childrenCourseModelArray.count) {
                QCSMainChildrenCourseModel *courseModel = eclassModel.childrenCourseModelArray[0];
                [self.chooseCourseButton setTitle:courseModel.name forState:UIControlStateNormal];
                self.chooseCourseID = courseModel.id;
            }
        }
    }
    
    NSMutableArray *sourceArray = [NSMutableArray arrayWithArray:[QCSSourceHandler getHomeworkChooseTypeArray]];
    
    QCSSourceModel *model1 =  [QCSSourceModel new];
    model1.itemTitle = @"全部";
    model1.typeNum = @"";
    model1.isExpand = NO;
    [sourceArray insertObject:model1 atIndex:0];
    
    
    [self.chooseTypeButton setTitle:[sourceArray[0] itemTitle] forState:UIControlStateNormal];
    self.chooseTypeID = [sourceArray[0] typeNum];
    
}


#pragma mark - ButtonClicked
- (IBAction)chooseGradeAction:(id)sender {
    
    NSMutableArray *array = [NSMutableArray array];
    for (QCSMainResultGradeModel *model in self.studentCourseArray) {
        [array addObject:model.name];
    }
    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        
        idxGrade = index;
        
        if (weakSelf.studentCourseArray.count) {
            QCSMainResultGradeModel *model = weakSelf.studentCourseArray[index];
            weakSelf.chooseGradeID = model.id;
        }
        [weakSelf.chooseGradeButton setTitle:stateArr[0] forState:UIControlStateNormal];
        
        
        QCSMainChildrenEclassModel *eclassModel =  [weakSelf.studentCourseArray[index] childrenEclassModelArray][0];
        [weakSelf.chooseClassButton setTitle:eclassModel.name forState:UIControlStateNormal];
        weakSelf.chooseClassID = eclassModel.id;
        
        QCSMainChildrenCourseModel *courseModel = eclassModel.childrenCourseModelArray[0];
        [weakSelf.chooseCourseButton setTitle:courseModel.name forState:UIControlStateNormal];
        weakSelf.chooseCourseID = courseModel.id;
        
    };
    
    [self.pickerView show];
    
    
    
}


- (IBAction)chooseClassAction:(id)sender {
    
    QCSMainResultGradeModel *resultModel = self.studentCourseArray[idxGrade];
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (QCSMainChildrenEclassModel *model in resultModel.childrenEclassModelArray) {
        [array addObject:model.name];
    }
    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        
        idxClass = index;
        
        QCSMainChildrenEclassModel *classModel = resultModel.childrenEclassModelArray[index];
        
        [weakSelf.chooseClassButton setTitle:stateArr[0] forState:UIControlStateNormal];
        weakSelf.chooseClassID = classModel.id;
        
        QCSMainChildrenCourseModel *courseModel  =classModel.childrenCourseModelArray[0];
        
        [weakSelf.chooseCourseButton setTitle:courseModel.name forState:UIControlStateNormal];
        weakSelf.chooseCourseID = courseModel.id;
    };
    [self.pickerView show];
}

- (IBAction)chooseCourseAction:(id)sender {
    
    QCSMainResultGradeModel *resultModel = self.studentCourseArray[idxGrade];
    QCSMainChildrenEclassModel *classModel = resultModel.childrenEclassModelArray[idxClass];
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (QCSMainChildrenCourseModel *model in classModel.childrenCourseModelArray) {
        [array addObject:model.name];
    }
    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        
        
        [weakSelf.chooseCourseButton setTitle:stateArr[0] forState:UIControlStateNormal];
        
        weakSelf.chooseCourseID = [classModel.childrenCourseModelArray[index] id];
        
    };
    
    [self.pickerView show];
    
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


- (IBAction)chooseTypeAction:(id)sender {
    

    NSMutableArray *sourceArray = [NSMutableArray arrayWithArray:[QCSSourceHandler getHomeworkChooseTypeArray]];
    
    QCSSourceModel *model1 =  [QCSSourceModel new];
    model1.itemTitle = @"全部";
    model1.typeNum = @"";
    model1.isExpand = NO;
    [sourceArray insertObject:model1 atIndex:0];
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (QCSSourceModel *model in sourceArray) {
        [array addObject:model.itemTitle];
    }
    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        
        [weakSelf.chooseTypeButton setTitle:stateArr[0] forState:UIControlStateNormal];
        
        weakSelf.chooseTypeID = [sourceArray[index] typeNum];
    };
    
    [self.pickerView show];
}

- (IBAction)searchAction:(id)sender {
    
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[qcsHomeworkMainController class]]) {
            
            qcsHomeworkMainController *tempController = (qcsHomeworkMainController *)controller;
            tempController.idGrade = self.chooseGradeID;
            tempController.idCourses = self.chooseCourseID;
            tempController.startTime = self.chooseStartTimeString;
            tempController.endTime = self.chooseEndTimeString;
            tempController.type = self.chooseTypeID;
            
            [tempController requestData];
            [self.navigationController popToViewController:tempController animated:YES];
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
