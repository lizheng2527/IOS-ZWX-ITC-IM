//
//  AssetSearchConditionController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/8/27.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetSearchConditionController.h"
#import "AssetSearchController.h"
#import <UIView+Toast.h>
#import "AssetDiliverWaitController.h"
#import "LDCalendarView.h"
#import "NSDate+extend.h"
#import "AssetNetWorkHelper.h"
#import "NSString+Empty.h"
#import "SGPopSelectView_Asset.h"
#import "TYHAssetModel.h"
#import "AssetListController.h"
#import <MJExtension.h>


static int b;

@interface AssetSearchConditionController ()<UITextFieldDelegate>
@property (nonatomic, strong) LDCalendarView * calendarView;//日历控件
@property (nonatomic, strong)NSMutableArray *seletedDays;//选择的日期
@property (nonatomic, copy) NSString * dateDetail;
@property (nonatomic, copy) NSString * dateDetailBack;

@property (nonatomic, retain) SGPopSelectView_Asset *popView;
@end

@implementation AssetSearchConditionController{
        NSString *tempStr;
    
    NSMutableArray *saveSchoolArray;
    NSMutableArray *saveAreaArray;
    
    NSMutableArray *brandArray;
    NSMutableArray *guigeArray;
    
    NSMutableArray *assetWaitForDiliverArray;
    
    NSString *typeStringWithChoose;
    NSString *startDateString;
    NSString *endDateString;
    NSString *IDschool;
    NSString *IDarea;
    NSString *IDtype;
    NSString *IDBrand;
    NSString *IDguige;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self requestData];
    [self createBarItem];
    [self setTmpDataArray:_tmpDataArray];
    [self initLabelTap];
    
    startDateString = @"";
    endDateString = @"";
    typeStringWithChoose = @"";
    IDBrand = @"";
    IDtype = @"";
    IDarea = @"";
    IDguige = @"";
    IDschool = @"";
    self.popView = [[SGPopSelectView_Asset alloc] init];
}

#pragma mark -initData


-(void)setTmpDataArray:(NSMutableArray *)tmpDataArray
{
    if (tmpDataArray.count > 0 && tmpDataArray) {
        _tmpDataArray = [NSMutableArray arrayWithArray:tmpDataArray];
    }
    else
        _tmpDataArray = [NSMutableArray array];
}

-(void)setAssetArrayWithinChoose:(NSMutableArray *)assetArrayWithinChoose
{
    if (assetArrayWithinChoose.count > 0 && assetArrayWithinChoose) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[AssetListBrandModel mj_objectArrayWithKeyValuesArray:assetArrayWithinChoose]];
        
        for (AssetListBrandModel *model in array) {
            model.pattersArray = [NSMutableArray arrayWithArray:[AssetListPatternsModel mj_objectArrayWithKeyValuesArray:model.assetPatterns]];
        }
        _assetArrayWithinChoose = [NSMutableArray arrayWithArray:array];
    }
    else
        _assetArrayWithinChoose = [NSMutableArray array];
}

-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取资产数据中";
    
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
   [helper getAssetPageJsonWithCheckModel:@"CheckManage" andStatus:^(BOOL successful, NSMutableArray *locationsArray) {
       saveSchoolArray = [NSMutableArray arrayWithArray:locationsArray];
       [self.view makeToast:@"请按照顺序进行条件查找" duration:2.5 position:CSToastPositionCenter];
       [hud removeFromSuperview];
   } failure:^(NSError *error) {
       [hud removeFromSuperview];
   }];
    
}

-(void)requestAssetArrayWithLocationID:(NSString *)locationId
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"更新资产数据中";
    
    AssetNetWorkHelper *helper = [AssetNetWorkHelper new];
    [helper getAssetListJsonWithLocationID:locationId andStatus:^(BOOL successful, NSMutableArray *locationsArray) {
        assetWaitForDiliverArray = [NSMutableArray arrayWithArray:locationsArray];
        
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
}



#pragma mark - initView
-(void)initView
{
    self.title = @"按条件查找";
    
    _assetTFSaveSchool.delegate = self;
    _assetTFSaveArea.delegate = self;
    _assetTFType.delegate = self;
    _assetTFBrand.delegate = self;
    _assetTFGuige.delegate = self;
    _assetTFName.delegate = self;
    _assetTFCode.delegate = self;
//    assetBtnStartDate;
//    assetBtnEndDate;
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






#pragma mark - 选择日历
- (void)selectDate:(UIButton *)chooseBtn {
    
    [self.view endEditing:YES];
    
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
                
                if (chooseBtn.tag == 20001) {
                    _dateDetail = partStr;
                    [chooseBtn setTitle:partStr forState:UIControlStateNormal];
                } else if (chooseBtn.tag == 20002) {
                    
                    _dateDetailBack = partStr;
                    
                    int a = [LDCalendarView compareDate:weakSelf.dateDetail date:weakSelf.dateDetailBack];
                    b = a;
                    if (a <= 0) {
                         [chooseBtn setTitle:partStr forState:UIControlStateNormal];
                    } else {
                         [chooseBtn setTitle:weakSelf.dateDetail forState:UIControlStateNormal];
                        [weakSelf.view makeToast:@"选择返程时间有误已默认当前日期" duration:2 position:nil];
                    }
                }
            }
        }
    };
    
    [self.calendarView show];
    self.calendarView.defaultDates = _seletedDays;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions

- (IBAction)chooseStatrDateAction:(id)sender {
    UIButton *button = sender;
    [self selectDate:button];
    startDateString = button.titleLabel.text;
}

- (IBAction)chooseEndDataAction:(id)sender {
    UIButton *button = sender;
    [self selectDate:button];
    endDateString = button.titleLabel.text;
}

- (IBAction)searchAction:(id)sender {
    
    
    AssetSearchController *searchView = [AssetSearchController new];
    searchView.dataArray = [NSMutableArray arrayWithArray:_tmpDataArray];
    IDtype = _assetTypeWithinChooseID;
    searchView.IDBrand = IDBrand;
    searchView.IDguige = IDguige;
    searchView.IDarea = IDarea;
    searchView.IDtype = IDtype;
    searchView.IDschool = IDschool;
    searchView.startDateString = _assetBtnStartDate.titleLabel.text;
    searchView.endDateString = _assetBtnEndDate.titleLabel.text;
    searchView.typeStringWithChoose = typeStringWithChoose;
    
    searchView.searchCodeString = _assetTFCode.text;
    searchView.searchNameString = _assetTFName.text;
    
    [self.navigationController pushViewController:searchView animated:YES];
}

-(void)returnClick:(id)sender
{
    AssetDiliverWaitController
    *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    takeView.dataArray = [NSMutableArray arrayWithArray:_tmpDataArray];
    [self.navigationController
     popToViewController:takeView animated:true];
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



#pragma mark - initHeadLabelTap
-(void)initLabelTap
{
    _assetSeriseLabel.userInteractionEnabled = YES;
    _assetAllTypeLabel.userInteractionEnabled = YES;
    _assetUnSeriseLabel.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *allTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(assetAllChooseAction:)];
    [self.assetAllTypeLabel addGestureRecognizer:allTapGes];
    
    UITapGestureRecognizer *unSeriseTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(assetUnSeriseChooseAction:)];
    [self.assetUnSeriseLabel addGestureRecognizer:unSeriseTapGes];
    
    UITapGestureRecognizer *seriseTapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(assetSeriseChooseAction:)];
    [self.assetSeriseLabel addGestureRecognizer:seriseTapGes];
}


#pragma mark - initHeadTapView全部/非成套/成套

- (IBAction)assetAllChooseAction:(id)sender {
    [_assetSeriseBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_assetUnSeriseBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_assetAllTypeBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    typeStringWithChoose = @"";
}

- (IBAction)assetUnSeriseChooseAction:(id)sender {
    
    [_assetSeriseBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_assetUnSeriseBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    [_assetAllTypeBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    typeStringWithChoose = @"0";
}

- (IBAction)assetSeriseChooseAction:(id)sender {
    [_assetSeriseBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    [_assetUnSeriseBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_assetAllTypeBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    typeStringWithChoose = @"1";
}


#pragma mark - TextField Delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    __block AssetSearchConditionController *blockSelf = self;
    
    if(textField == _assetTFSaveSchool)
    {
        if (saveSchoolArray.count == 0 || !saveSchoolArray) {
            return;
        }
        
        self.popView.selectArray = [NSMutableArray arrayWithArray:saveSchoolArray];
        CGPoint p = CGPointMake(self.view.center.x,self.view.center.y - 44 - 90);
        [self.popView showFromView:self.view atPoint:p animated:YES];
//        self.popView.center = p;
         self.popView.frame = CGRectMake(_assetTFSaveSchool.frame.origin.x, _assetTFSaveSchool.frame.origin.y, _popView.frame.size.width, _popView.frame.size.height);
        
        [_assetTFSaveSchool resignFirstResponder];
        [self.view endEditing:YES];
        
        self.popView.selectedHandle = ^(NSInteger selectedIndex){
            blockSelf.assetTFSaveSchool.text = blockSelf.popView.selections[selectedIndex];
            saveAreaArray = [NSMutableArray arrayWithArray:[saveSchoolArray[selectedIndex] classesArray]];
            
            IDschool = [saveSchoolArray[selectedIndex] schoolID];
            [blockSelf.popView hide:YES];
            
            blockSelf.assetTFSaveArea.text = @"";
            blockSelf.assetTFType.text = @"";
            blockSelf.assetTFBrand.text = @"";
            blockSelf.assetTFGuige.text = @"";
            IDtype = @"";
            IDBrand = @"";
            IDguige = @"";
            IDarea = @"";
        };
    }
    
    else if(textField == _assetTFSaveArea)
    {
        if (saveAreaArray.count == 0 || !saveAreaArray) {
            return;
        }
        self.popView.selectArray = [NSMutableArray arrayWithArray:saveAreaArray];
        CGPoint p = CGPointMake(self.view.center.x,self.view.center.y - 44 - 90);
        [self.popView showFromView:self.view atPoint:p animated:YES];
//        self.popView.center = p;
        
        self.popView.frame = CGRectMake(_assetTFSaveArea.frame.origin.x, _assetTFSaveArea.frame.origin.y, _popView.frame.size.width, _popView.frame.size.height);
        
        [_assetTFSaveArea resignFirstResponder];
        [self.view endEditing:YES];
        __block NSString *tmpString;
        self.popView.selectedHandle = ^(NSInteger selectedIndex){
            blockSelf.assetTFSaveArea.text = blockSelf.popView.selections[selectedIndex];
            tmpString = [saveAreaArray[selectedIndex] auditorID];
            [blockSelf requestAssetArrayWithLocationID:tmpString];
            [blockSelf.popView hide:YES];
            
            IDarea = [saveAreaArray[selectedIndex] auditorID];
            
            blockSelf.assetTFType.text = @"";
            blockSelf.assetTFBrand.text = @"";
            blockSelf.assetTFGuige.text = @"";
            IDtype = @"";
            IDBrand = @"";
            IDguige = @"";
        };
    }
    else if(textField == _assetTFType)
    {
        AssetListController *listView = [AssetListController new];
        listView.assetDatasource = assetWaitForDiliverArray;
        listView.typeString = @"查找";
        [self.navigationController pushViewController:listView animated:YES];
        IDtype = _assetTypeWithinChooseID;
        [_assetTFType resignFirstResponder];
        [self.view endEditing:YES];
        blockSelf.assetTFBrand.text = @"";
        blockSelf.assetTFGuige.text = @"";
        IDBrand = @"";
        IDguige = @"";
    }
   else if(textField == _assetTFBrand)
    {
        if (_assetArrayWithinChoose.count == 0 || !_assetArrayWithinChoose) {
            return;
        }
        
        self.popView.selectArray = [NSMutableArray arrayWithArray:_assetArrayWithinChoose];
        CGPoint p = CGPointMake(self.view.center.x,self.view.center.y - 44 - 90);
        [self.popView showFromView:self.view atPoint:p animated:YES];
        
        self.popView.frame = CGRectMake(_assetTFBrand.frame.origin.x, _assetTFBrand.frame.origin.y, _popView.frame.size.width, _popView.frame.size.height);
        
        [_assetTFBrand resignFirstResponder];
        [self.view endEditing:YES];
        
        self.popView.selectedHandle = ^(NSInteger selectedIndex){
            blockSelf.assetTFBrand.text = blockSelf.popView.selections[selectedIndex];
            guigeArray = [NSMutableArray arrayWithArray:[_assetArrayWithinChoose[selectedIndex] pattersArray]];
            
            //            _tfApplySchoolIDString = [schoolArray[selectedIndex] schoolID];
            IDBrand = [_assetArrayWithinChoose[selectedIndex] brandID];
            [blockSelf.popView hide:YES];
            blockSelf.assetTFGuige.text = @"";
            IDguige = @"";
        };
    }
    
    else if(textField == _assetTFGuige)
    {
        if (guigeArray.count == 0 || !guigeArray) {
            return;
        }
        self.popView.selectArray = [NSMutableArray arrayWithArray:guigeArray];
        CGPoint p = CGPointMake(self.view.center.x,self.view.center.y - 44 - 90);
        [self.popView showFromView:self.view atPoint:p animated:YES];
        self.popView.frame = CGRectMake(_assetTFGuige.frame.origin.x, _assetTFGuige.frame.origin.y, _popView.frame.size.width, _popView.frame.size.height);
        [_assetTFGuige resignFirstResponder];
        [self.view endEditing:YES];
        self.popView.selectedHandle = ^(NSInteger selectedIndex){
            blockSelf.assetTFGuige.text = blockSelf.popView.selections[selectedIndex];
            IDguige = [guigeArray[selectedIndex]  PatternsID];
            [blockSelf.popView hide:YES];
        };
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
