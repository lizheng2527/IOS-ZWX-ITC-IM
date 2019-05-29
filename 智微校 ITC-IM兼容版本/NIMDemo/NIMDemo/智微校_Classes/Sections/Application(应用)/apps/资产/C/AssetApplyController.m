//
//  AssetApplyController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/22.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetApplyController.h"
#import "LDCalendarView.h"
#import <UIView+Toast.h>
#import "NSDate+extend.h"
#import "AssetNetWorkHelper.h"
#import "AssetListController.h"
#import "SGPopSelectView_Asset.h"
#import "TYHAssetModel.h"
#import "NSString+Empty.h"
#import "AssetNetWorkHelper.h"
#import "SDAutoLayout.h"


static int b;

@interface AssetApplyController ()<UITextFieldDelegate>
@property (nonatomic, strong) LDCalendarView * calendarView;//日历控件
@property (nonatomic, strong)NSMutableArray *seletedDays;//选择的日期
@property (nonatomic, copy) NSString * dateDetail;
@property (nonatomic, copy) NSString * dateDetailBack;

@property (nonatomic, strong) NSArray *selections;
@property (nonatomic, retain) SGPopSelectView_Asset *popView;

@end

@implementation AssetApplyController
{
    NSString *tempStr;
    
    NSMutableArray *auditorArray;
    NSMutableArray *schoolArray;
    NSMutableArray *userDepartmentArray;
    NSMutableArray *assetListArray;
}


#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createBarItem];
    self.title = @"资产申请";
    [self initSelectView];
    [self initTextField];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
    
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    
    NSString *  locationnString=[dateformatter stringFromDate:senddate];
    
    _TFApplyDate.text = locationnString;
    
   
    
}



#pragma mark -initData

-(void)initSelectView
{
     _popView = [[SGPopSelectView_Asset alloc]init];
    if (_popView.superview) {
        [_popView hide:YES];
    }
//    self.selections = @[@"Shake It Off",@"All About that Bass",@"Animals",@"Take Me To Church",@"Out Of The Woods",@"Centuries",@"I'm Not the Only One",@"Burnin' It Down"];
//    __block AssetApplyController *blockSelf = self;
//    self.popView = [[SGPopSelectView alloc] init];
//    self.popView.selections = self.selections;
//    __weak typeof(self) weakSelf = self;
//    self.popView.selectedHandle = ^(NSInteger selectedIndex){
////        NSLog(@"selected index %ld, content is %@", selectedIndex, weakSelf.selections[selectedIndex]);
////        
////        blockSelf.TFApplyBuMen.text = blockSelf.popView.selections[selectedIndex];
////        
////        if ([blockSelf.popView.selectArray containsObject:userDepartmentArray[selectedIndex]]) {
////            
////        }
//        auditorArray = [NSMutableArray arrayWithArray:schoolArray[selectedIndex]];
//        [blockSelf.popView hide:YES];
//    };
}

-(void)requestData
{
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper getApplicationJsonWithOperationCode:@"CheckManage" andStatus:^(BOOL successful, NSMutableArray *assetListArray_Temp,NSMutableArray *schoolDatasource,NSMutableArray *departmentDatasource) {
        auditorArray = [NSMutableArray array];
        assetListArray = [NSMutableArray arrayWithArray:assetListArray_Temp];
        schoolArray = [NSMutableArray arrayWithArray:schoolDatasource];
        userDepartmentArray = [NSMutableArray arrayWithArray:departmentDatasource];
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark -initView

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

  -(void)initTextField
{
    _TFApplyDate.delegate = self;
    _TFApplyNeed.delegate = self;
    _TFApplyType.delegate = self;
    _TFApplyBuMen.delegate = self;
    _TFApplyUsage.delegate = self;
    _TFApplyPerson.delegate = self;
    _TFApplySchoolArea.delegate = self;
    
    _applyDateBtn.layer.borderWidth = 0.5f;
    _applyDateBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
}


#pragma mark -Actions
//提交申请单

- (IBAction)SubmitApplicationList:(id)sender {
    
//    http://117.78.48.224:12000/zddc/ao/assetMobile!saveApplication.action
    
    if ([NSString isBlankString:_TFApplyDate.text]) {
        [self.view makeToast:@"请选择申请日期" duration:1 position:CSToastPositionCenter];
        return;
    }
    else if ([NSString isBlankString:_tfApplyBuMenIDString]) {
        [self.view makeToast:@"请选择申请部门" duration:1 position:CSToastPositionCenter];
        return;
    }
    else if ([NSString isBlankString:_tfApplyTypeIDString]) {
        [self.view makeToast:@"请选择资产类型" duration:1 position:CSToastPositionCenter];
        return;
    }
    else if ([NSString isBlankString:_tfApplySchoolIDString]) {
        [self.view makeToast:@"请选择被申请校区" duration:1 position:CSToastPositionCenter];
        return;
    }
    else if ([NSString isBlankString:_tfApplyPersonIDString]) {
        [self.view makeToast:@"请选择审核人" duration:1 position:CSToastPositionCenter];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"正在提交申请";
    
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper summitApplicationWithReason:_TFApplyUsage.text applyDate:_TFApplyDate.text schoolId:_tfApplySchoolIDString departmentId:_tfApplyBuMenIDString demand:_TFApplyNeed.text assetKindId:_tfApplyTypeIDString checkPersonID:_tfApplyPersonIDString andStatus:^(BOOL successful, NSMutableArray *dataSource)  {
        [hud removeFromSuperview];
        [self.view makeToast:@"申请资产成功" duration:1 position:CSToastPositionCenter];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
         [hud removeFromSuperview];
         [self.view makeToast:@"申请资产失败" duration:1 position:CSToastPositionCenter];
    }];
    
//    _TFApplyUsage;
//    _TFApplyPerson;
    
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)currentDate:(UIDatePicker *)date {
    // 获取选择的时间
    NSDate *select = [date date]; // 获取被选中的时间
    //    NSLog(@"select = %@",select);
    NSDateFormatter *selectDateFormatter = [[NSDateFormatter alloc] init];
    selectDateFormatter.dateFormat = @"HH:mm"; // 设置时间和日期的格式
    NSString *dateAndTime = [selectDateFormatter stringFromDate:select];
    // 把date类型转为设置好格式的string类型
    // 这是中间变量
    tempStr = dateAndTime;
    // 同一天比较 时间 不同天比较天
}

#pragma mark === 选择日历
- (void)selectDate:(UITextField *)applyDateTF {
    
    [self.view endEditing:YES];
     [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
//    [_TFApplyDate resignFirstResponder];
//    [_TFApplyUsage resignFirstResponder];
//    [_TFApplyNeed resignFirstResponder];
    if (!_calendarView) {
        _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT)];
        [self.view addSubview:_calendarView];
    }
    
    __weak typeof(self) weakSelf = self;
    _calendarView.complete = ^(NSArray *result) {
        
        if (result) {
            weakSelf.seletedDays = [result mutableCopy];
            
            for (NSNumber *interval in weakSelf.seletedDays) {
                
                NSString * partStr = [NSDate stringWithTimestamp:interval.doubleValue/1000.0 format:@"YYYY-MM-dd"];
                
                if (applyDateTF.tag == 2001) {
                    _dateDetail = partStr;
                    applyDateTF.text = partStr;
                } else if (applyDateTF.tag == 2002) {
                    
                    _dateDetailBack = partStr;
                    
                    int a = [LDCalendarView compareDate:weakSelf.dateDetail date:weakSelf.dateDetailBack];
                    b = a;
                    if (a <= 0) {
                        applyDateTF.text = partStr;
                    } else {
                        applyDateTF.text = weakSelf.dateDetail;
                        [weakSelf.view makeToast:@"选择返程时间有误已默认当前日期" duration:2 position:nil];
                    }
                }
            }
        }
    };
    
    [self.calendarView show];
    self.calendarView.defaultDates = _seletedDays;

}



-(void)textFieldDidBeginEditing:(UITextField *)textField
{
//    self.popView = [[SGPopSelectView alloc] init];
    __block AssetApplyController *blockSelf = self;
    
    if (textField == _TFApplyDate) {
        [self.TFApplyDate resignFirstResponder];
        [self.view endEditing:YES];
        [self selectDate:_TFApplyDate];
    }
    else if(textField == _TFApplyBuMen)
    {
//        NSMutableArray *dataArray = [NSMutableArray array];
//        for (AssetApplyUserDepartmentsModel *model in userDepartmentArray) {
//            [dataArray addObject:model.userDepartmentsName];
//        }
        if (userDepartmentArray.count == 0 || !userDepartmentArray) {
            return;
        }

        self.popView.selectArray = [NSMutableArray arrayWithArray:userDepartmentArray];
        CGPoint p = CGPointMake(self.view.center.x,self.view.center.y - 44 - 90);
        [self.popView showFromView:self.view atPoint:p animated:YES];
         self.popView.frame = CGRectMake(_TFApplyBuMen.frame.origin.x, _TFApplyBuMen.frame.origin.y, _popView.frame.size.width, _popView.frame.size.height);
        [_TFApplyBuMen resignFirstResponder];
        [self.view endEditing:YES];
        
        self.popView.selectedHandle = ^(NSInteger selectedIndex){
       blockSelf.TFApplyBuMen.text = blockSelf.popView.selections[selectedIndex];
            _tfApplyBuMenIDString = [userDepartmentArray[selectedIndex] userDepartmentsID];
            [blockSelf.popView hide:YES];
        };
        
    }
    
    else if(textField == _TFApplyType  )
    {
        AssetListController *listView = [AssetListController new];
        listView.assetDatasource = assetListArray;
        listView.typeString = @"申请";
        [self.navigationController pushViewController:listView animated:YES];

        [_TFApplyType resignFirstResponder];
        [self.view endEditing:YES];
    }
    
    else if(textField == _TFApplySchoolArea)
    {
        if (schoolArray.count == 0 || !schoolArray) {
            return;
        }
        
        self.popView.selectArray = [NSMutableArray arrayWithArray:schoolArray];
        CGPoint p = CGPointMake(self.view.center.x,self.view.center.y - 44 - 90);
        [self.popView showFromView:self.view atPoint:p animated:YES];
        
        self.popView.frame = CGRectMake(_TFApplySchoolArea.frame.origin.x, _TFApplySchoolArea.frame.origin.y, _popView.frame.size.width, _popView.frame.size.height);
        
        [_TFApplySchoolArea resignFirstResponder];
        [self.view endEditing:YES];
        
        self.popView.selectedHandle = ^(NSInteger selectedIndex){
            blockSelf.TFApplySchoolArea.text = blockSelf.popView.selections[selectedIndex];
            auditorArray = [NSMutableArray arrayWithArray:[schoolArray[selectedIndex] auditorsArray]];
            
            _tfApplySchoolIDString = [schoolArray[selectedIndex] schoolID];
            [blockSelf.popView hide:YES];
            _tfApplyPersonIDString = @"";
            blockSelf.TFApplyPerson.text = @"";
        };
    }
    
    else if(textField == _TFApplyPerson)
    {
        [_TFApplyPerson resignFirstResponder];
        [self.view endEditing:YES];
        if (auditorArray.count == 0 || !auditorArray) {
            [self.view makeToast:@"暂无审核人" duration:1.5 position:CSToastPositionCenter];
            return;
        }
        self.popView.selectArray = [NSMutableArray arrayWithArray:auditorArray];
        CGPoint p = CGPointMake(self.view.center.x,self.view.center.y - 44 - 90);
        [self.popView showFromView:self.view atPoint:p animated:YES];
        self.popView.center = p;
        self.popView.frame = CGRectMake(_TFApplyPerson.frame.origin.x, _TFApplyPerson.frame.origin.y, _popView.frame.size.width, _popView.frame.size.height);
        self.popView.selectedHandle = ^(NSInteger selectedIndex){
            blockSelf.TFApplyPerson.text = blockSelf.popView.selections[selectedIndex];
            _tfApplyPersonIDString = [auditorArray[selectedIndex] auditorID];
            [blockSelf.popView hide:YES];
        };
    }
}




#pragma mark - other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.view];
    if (self.popView.visible && CGRectContainsPoint(self.popView.frame, p)) {
        return NO;
    }
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.popView hide:YES];
    [self.view endEditing:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
//    _mainScrollview.contentSize = CGSizeMake(320, 0);
//    _mainScrollview.frame = CGRectMake(0, 0, 320, 335);
    _widthConstant.constant = [UIScreen mainScreen].bounds.size.width - 40 - 8 - 85;
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
