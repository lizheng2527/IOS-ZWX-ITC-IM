//
//  qcsClassReviewSearchStudentController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassReviewSearchStudentController.h"

#import "ValuePickerView.h"
#import "QCSMainModel.h"
#import "GYZCustomCalendarPickerView.h"
#import "QCSchoolDefine.h"


#import "qcsClassReviewInsideStudentController.h"
#import "NSString+NTES.h"
#import "qcsClassReviewSearchCell.h"
#import "QCSNetHelper.h"

#import "qcsClassReviewMainController.h"


@interface qcsClassReviewSearchStudentController ()<GYZCustomCalendarPickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)NSMutableArray *itemArray;

@property(nonatomic,retain)ValuePickerView *pickerView;

@property(nonatomic,copy)NSString *chooseGradeID;
@property(nonatomic,copy)NSString *chooseClassID;
@property(nonatomic,copy)NSString *chooseCourseID;

@property(nonatomic,copy)NSString *chooseStartTimeString;
@property(nonatomic,copy)NSString *chooseEndTimeString;
@property(nonatomic,copy)NSString *chooseStudentID;
@property(nonatomic,copy)NSString *chooseStudentName;


@property(nonatomic,assign)BOOL isChooseStartTime;

@end

@implementation qcsClassReviewSearchStudentController
{
    __block NSInteger idxGrade;
    __block NSInteger idxClass;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询";
    // Do any additional setup after loading the view from its nib.
    
    [self initPickview];
    
    self.chooseStartTimeString = [QCSSourceHandler getDateOneYearBefore];
    self.chooseEndTimeString = [QCSSourceHandler getDateToday];
    
    [self.chooseStartTimeButton setTitle:[QCSSourceHandler getDateOneYearBefore] forState:UIControlStateNormal];
    [self.chooseEndTimeButton setTitle:[QCSSourceHandler getDateToday] forState:UIControlStateNormal];
    
    [self setUpCollectionView];
    
    [self getNewData];
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
                
                [self getUserListWithId:self.chooseClassID];
            }
        }
    }
}


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
        
        [weakSelf getUserListWithId:weakSelf.chooseClassID];
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
        
        [weakSelf getUserListWithId:weakSelf.chooseClassID];
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
    
    if (array.count) {
        
    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
        self.pickerView.valueDidSelect = ^(NSString *value){
            NSArray * stateArr = [value componentsSeparatedByString:@"/"];
            NSInteger index = [stateArr[1] integerValue] - 1;
            
            [weakSelf.chooseCourseButton setTitle:stateArr[0] forState:UIControlStateNormal];
            
            weakSelf.chooseCourseID = [classModel.childrenCourseModelArray[index] id];
            
            //        [weakSelf getUserListWithId:weakSelf.chooseCourseID];
        };
        
        [self.pickerView show];
    }
    else
    {
        [self.view makeToast:@"暂无数据" duration:1.5 position:CSToastPositionCenter];
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
        [self.view makeToast:@"请选择课程" duration:1.5 position:CSToastPositionCenter];
        return;
    }else if([NSString isBlankString:self.chooseStudentID])
    {
        [self.view makeToast:@"请选择学生" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    else
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[qcsClassReviewMainController class]]) {
                qcsClassReviewMainController *tempController = (qcsClassReviewMainController *)controller;
                
                tempController.chooseEndTime = self.chooseEndTimeString;
                tempController.chooseStartTime = self.chooseStartTimeString;
                tempController.chooseCourseID = self.chooseCourseID;
                tempController.chooseEclassID = self.chooseClassID;
                tempController.chooseStudentName = self.chooseStudentName;
                tempController.chooseStudentID = self.chooseStudentID;
                
                
                NSDictionary *dic = @{@"chooseEndTime":self.chooseEndTimeString,@"chooseStartTime":self.chooseStartTimeString,@"chooseCourseID":self.chooseCourseID.length?self.chooseCourseID:@"",@"chooseEclassID":self.chooseClassID,@"chooseStudentName":self.chooseStudentName,@"chooseStudentID":self.chooseStudentID};
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"shouldRefrshStudent" object:nil userInfo:[NSDictionary dictionaryWithDictionary:dic]];
                
                [self.navigationController popToViewController:tempController animated:YES];
            }
        }
        
    }
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:[qcsClassReviewMainController class]]) {
//                qcsClassReviewMainController *tempController = (qcsClassReviewMainController *)controller;
//                tempController.chooseEndTime = self.chooseEndTimeString;
//                tempController.chooseStartTime = self.chooseStartTimeString;
//                tempController.chooseCourseID = self.chooseID;
//
//                [tempController getChooseData];
//                [self.navigationController popViewControllerAnimated:tempController];
//            }
//        }
    
}



-(void)getUserListWithId:(NSString *)id
{
    QCSNetHelper *helper = [QCSNetHelper new];
    [helper getUserModelArrayWithEclassId:self.chooseClassID status:^(NSMutableArray *dataSource) {
        _itemArray = [NSMutableArray arrayWithArray:dataSource];
        [_mainCollectionView reloadData];
    }];
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






#pragma mark - initData
- (void)getNewData {
//    _itemArray = [NSMutableArray arrayWithArray:_dataSource];
    [_mainCollectionView reloadData];
}

#pragma mark - initView

- (void)setUpCollectionView {
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 6; //调节Cell间距
    flowLayout.sectionInset = UIEdgeInsetsMake(1,1,1,1);
    
    _mainCollectionView.collectionViewLayout = flowLayout;
    
    _mainCollectionView.backgroundColor = [UIColor clearColor];
    _mainCollectionView.dataSource = self;
    _mainCollectionView.delegate = self;
    _mainCollectionView.bounces = NO;
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"qcsClassReviewSearchCell" bundle:nil] forCellWithReuseIdentifier:@"qcsClassReviewSearchCell"];
    
    // 注册headView
    
    _mainCollectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                             titleStr:@"暂无学生列表"
                                                            detailStr:@""];
    
}


#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    qcsClassReviewSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qcsClassReviewSearchCell" forIndexPath:indexPath];
    
    QCSMainUserModel *model = _itemArray[indexPath.item];
    if (model.Selected) {
        cell.nameLabel.backgroundColor = [UIColor QCSThemeColor];
        cell.nameLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.nameLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.nameLabel.textColor = [UIColor grayColor];
    }
    cell.nameLabel.text = model.name;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    qcsClassReviewSearchCell *cell = (qcsClassReviewSearchCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    __weak typeof(self) weakSelf = self;
    
    [_itemArray enumerateObjectsUsingBlock:^(QCSMainUserModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (indexPath.item == idx) {
            obj.Selected = YES;
            self.chooseStudentName = obj.name;
            self.chooseStudentID = obj.id;
        }else obj.Selected = NO;
    }];
    [_mainCollectionView reloadData];

}

#pragma mark - CollectionView Layout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(75, 25);
    return itemSize;
    
}



#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
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
