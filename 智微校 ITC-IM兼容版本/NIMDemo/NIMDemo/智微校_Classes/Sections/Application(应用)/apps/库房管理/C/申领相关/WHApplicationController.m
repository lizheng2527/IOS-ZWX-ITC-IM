//
//  WHApplicationController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/14.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHApplicationController.h"
#import "WHApplicationHeaderView.h"
#import "WHApplicationMainCell.h"
#import "WHApplicationItemCell.h"
#import "WHGoodsKindListController.h"

#import "WHApplicationModel.h"
#import "WHGoodsModel.h"
#import "WHNetHelper.h"

#import <UIView+Toast.h>
#import <MJExtension.h>
#import "NSString+Empty.h"

#import "ValuePickerView.h"

#import "GYZCustomCalendarPickerView.h"
#import "IDJCalendarUtil.h"

#define reasonTextFieldTag 20001
#define tipsTextFieldTag 20002
#define applyNumTextFieldTag 20003
@interface WHApplicationController ()<UITableViewDelegate,UITableViewDataSource,WHApplicationItemCellDelegate,WHApplicationMainCellDelegate,UITextFieldDelegate,GYZCustomCalendarPickerViewDelegate>

@property(nonatomic,retain)WHApplicationModel *mainModel;

@property(nonatomic,retain)ValuePickerView *pickerView;

@property(nonatomic,assign)NSInteger orgChooseIndex;

@end

@implementation WHApplicationController
{
    NSString *submitApplyCode;
    NSString *submitApplyDate;
    NSString *submitApplyOrgID;
    NSString *submitApplyCheckerID;
    NSString *submitApplyKind;
    NSString *submitApplyReason;
    NSString *submitApplyNote;
    
    NSString *submitApplyOrgName;
    NSString *submitApplyCheckerName;
    NSString *submitApplyKindName;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self createBarItem];
    
    [self requestData];
    [self initPickview];
    
}



#pragma mark - DataConfig
-(void)setDataArray:(NSMutableArray *)dataArray
{
    if (dataArray.count ) {
        _dataArray = [NSMutableArray arrayWithArray:dataArray];
        [_mainTableView reloadData];
    }
    else _dataArray = [NSMutableArray array];
}

-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    WHNetHelper *helper = [[WHNetHelper alloc]init];
    [helper getApplicationInfo:^(BOOL successful, WHApplicationModel *model) {
        
        _mainModel = [[WHApplicationModel alloc]init];
        _mainModel = model;
        
        submitApplyCode = model.applyMessageModel.code;
        submitApplyDate = model.applyMessageModel.date;
        
        if (model.myDepartmentListArray.count) {
            submitApplyOrgID = [model.myDepartmentListArray[0] departmentId];
            submitApplyOrgName = [model.myDepartmentListArray[0] departmentName];
            if ([model.myDepartmentListArray[0] userListModelArray].count) {
                submitApplyCheckerID = [[model.myDepartmentListArray[0] userListModelArray][0] checkUserId];
                submitApplyCheckerName = [[model.myDepartmentListArray[0] userListModelArray][0] checkUserName];
            }
        }
        
        if (model.WHAApplyReceiveKindListModelArray.count) {
            submitApplyKind = [(WHAApplyReceiveKindListModel *)model.WHAApplyReceiveKindListModelArray[0] code];
            submitApplyKindName = [(WHAApplyReceiveKindListModel *)model.WHAApplyReceiveKindListModelArray[0] name];
        }
        
        submitApplyNote = @"";
        submitApplyReason = @"";
        
        [_mainTableView reloadData];
        [hud removeFromSuperview];
        
    } failure:^(NSError *error) {
        
        [self.view makeToast:@"获取数据失败" duration:1 position:CSToastPositionCenter];
        [hud removeFromSuperview];
        
    }];
}


#pragma mark - TableViewConfig
-(void)initView
{
    self.title = @"申领单";
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = NO;
    _mainTableView.bounces = NO;
    
}

#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *iden1 = @"WHApplicationMainCell";
        WHApplicationMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHApplicationMainCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = _mainModel;
        cell.applyTipTF.delegate = self;
        cell.applyTipTF.tag = tipsTextFieldTag;
        cell.applyReasonTF.tag = reasonTextFieldTag;
        cell.applyReasonTF.delegate = self;
        cell.applyNumTextField.delegate = self;
        cell.applyNumTextField.tag = applyNumTextFieldTag;
        
        cell.applyTipTF.text = submitApplyNote;
        cell.applyReasonTF.text = submitApplyReason;
        
        
        [cell.applyOrgBtn setTitle:submitApplyOrgName forState:UIControlStateNormal];
        [cell.applyCheckerBtn setTitle:submitApplyCheckerName forState:UIControlStateNormal];
        [cell.applyTypeBtn setTitle:submitApplyKindName forState:UIControlStateNormal];
        
        [cell.applyDateBtn setTitle:submitApplyDate.length?submitApplyDate:_mainModel.applyMessageModel.date forState:UIControlStateNormal];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *iden2 = @"WHApplicationItemCell";
        WHApplicationItemCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHApplicationItemCell" owner:self options:nil].firstObject;
        }
        WHGoodsDetailModel *model = _dataArray[indexPath.row];
        cell.itemNameLabel.text = model.name;
        cell.itemCountTextfield.text = model.count;
        cell.itemPriceTextField.hidden = YES;
        cell.itemPriceNameLabel.hidden = YES;
        cell.delegate = self;
        
        cell.itemCountTextfield.delegate = self;
        cell.itemCountTextfield.tag = indexPath.row + 40000;
        
        
        return cell;
    }
    else return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        WHApplicationHeaderView *headView = [[WHApplicationHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        headView.backgroundColor = [UIColor whiteColor];
        return headView;
    }
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    else return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 308;
    }
    else if(indexPath.section == 1)
        return 93;
    else return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    return 1;
    else return _dataArray.count;
}


#pragma mark - Other
-(void)initPickview
{
    _pickerView = [[ValuePickerView alloc]init];
}

-(void)createBarItem
{
//    UIBarButtonItem *
//    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
//    //设置字体为加粗的12号系统字，自己也可以随便设置。
//    [barItemInNavigationBarAppearanceProxy
//     setTitleTextAttributes:[NSDictionary
//                             dictionaryWithObjectsAndKeys:[UIFont
//                                                           boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
//
//    UIBarButtonItem * leftItem = nil;
//    UIBarButtonItem * rightItem = nil;
//
//    leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
//    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self
//                                               action:@selector(diliverAction:)];
//
//    self.navigationItem.leftBarButtonItem =leftItem;
//    self.navigationItem.rightBarButtonItem =rightItem;
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(diliverAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)diliverAction:(id)sender
{
    
    if ([NSString isBlankString:submitApplyCode])
    {
        [self.view makeToast:@"请输入申领单号,建议格式为时间+编号,如20170426001这种" duration:2 position:CSToastPositionCenter];
        return;
    }
    
    

    
    else if (!(_dataArray.count > 0)) {
        [self.view makeToast:@"请选择商品" duration:1 position:CSToastPositionCenter];
        return;
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.labelText = @"获取数据中";
        
        WHNetHelper *helper = [[WHNetHelper alloc]init];
        
        
        [helper submitApplicationWithResultJson:[self getPostDic] andStatus:^(BOOL successful, NSMutableArray *dataSource) {
            
            [self.view makeToast:@"申请提交成功" duration:1 position:CSToastPositionCenter];
            [hud removeFromSuperview];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            [self.view makeToast:@"申请提交失败 !" duration:1 position:CSToastPositionCenter];
            [hud removeFromSuperview];
        }];
    }
}


-(NSMutableDictionary *)getPostDic
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    NSMutableArray *goodsInfoArray = [NSMutableArray array];
    
    [postDic setValue:submitApplyCode forKey:@"code"];
    [postDic setValue:submitApplyDate forKey:@"date"];
    [postDic setValue:submitApplyKind forKey:@"kind"];
    [postDic setValue:submitApplyNote.length?submitApplyNote:@"" forKey:@"note"];
    [postDic setValue:submitApplyReason.length?submitApplyReason:@"" forKey:@"reason"];
    [postDic setValue:submitApplyOrgID forKey:@"departmentId"];
    [postDic setValue:submitApplyCheckerID.length?submitApplyCheckerID:@"" forKey:@"deptCheckUserId"];
    [postDic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID] forKey:@"userId"];
    
    for (WHGoodsDetailModel *model in _dataArray) {
        model.goodsInfoId = model.goodsID;
        if ([NSString isBlankString:model.count] || [model.count integerValue] <= 0) {
            model.count = [NSString stringWithFormat:@"%d",0];
        }
        [goodsInfoArray addObject:model.mj_keyValues];
    }
    [postDic setValue:goodsInfoArray forKey:@"goodsInfos"];
    return postDic;
}

- (IBAction)addGoodsAction:(id)sender {
    WHGoodsKindListController *klView = [WHGoodsKindListController new];
    klView.goodsArray = [NSMutableArray arrayWithArray:_dataArray];
    [self.navigationController pushViewController:klView animated:YES];
}


#pragma mark - WHApplicationMainCellDelegate
-(void)applyTypeBtnDidClick:(WHApplicationMainCell *)cell
{
    NSMutableArray *pickerDatasurce = [NSMutableArray array];
    for (WHAApplyReceiveKindListModel *model in _mainModel.WHAApplyReceiveKindListModelArray) {
        [pickerDatasurce addObject:model.name];
    }
    
    self.pickerView.dataSource = pickerDatasurce;

    self.pickerView.pickerTitle = @"领用类型";
    //    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [cell.applyTypeBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        submitApplyKind = [(WHAApplyReceiveKindListModel *)[_mainModel.WHAApplyReceiveKindListModelArray objectAtIndex:[stateArr[1] integerValue] - 1] code];
        submitApplyKindName = [(WHAApplyReceiveKindListModel *)_mainModel.WHAApplyReceiveKindListModelArray[[stateArr[1]integerValue] -1] name];
    };
    [self.pickerView show];
}

-(void)applyCheckerBtnDidClick:(WHApplicationMainCell *)cell
{
    NSMutableArray *array = [NSMutableArray array];

    if (_mainModel.myDepartmentListArray && _mainModel.myDepartmentListArray.count) {
        for (WHACheckerModel *model in [_mainModel.myDepartmentListArray[_orgChooseIndex] userListModelArray]) {
            [array addObject:model.checkUserName];
        }
    }
    
    if (array.count) {
        self.pickerView.dataSource = array;
    }else
    {
        [self.view makeToast:@"暂时无法获取审核人" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    self.pickerView.pickerTitle = @"部门审核人";
    
//    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [cell.applyCheckerBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        submitApplyCheckerID = [[[_mainModel.myDepartmentListArray[_orgChooseIndex] userListModelArray] objectAtIndex:[stateArr[1] integerValue] - 1] checkUserId];
        submitApplyCheckerName = [[[_mainModel.myDepartmentListArray[_orgChooseIndex] userListModelArray] objectAtIndex:[stateArr[1] integerValue] - 1] checkUserName];
    };
    [self.pickerView show];
}

-(void)applyOrgBtnDidClick:(WHApplicationMainCell *)cell
{
    NSMutableArray *array = [NSMutableArray array];
    
    for (WHAMyDepartmentListModel *model in _mainModel.myDepartmentListArray) {
        [array addObject:model.departmentName];
    }
    
    if (array && array.count) {
    self.pickerView.dataSource = array;
    
        self.pickerView.pickerTitle = @"申领部门";
        __weak typeof(self) weakSelf = self;
        self.pickerView.valueDidSelect = ^(NSString *value){
            NSArray * stateArr = [value componentsSeparatedByString:@"/"];
            [cell.applyOrgBtn setTitle:stateArr[0] forState:UIControlStateNormal];
            
            
            weakSelf.orgChooseIndex = [stateArr[1] integerValue] - 1;   //-1才是正确的index
            
            NSLog(@"chosse index is%ld",(long)weakSelf.orgChooseIndex);
            
            submitApplyOrgID = [weakSelf.mainModel.myDepartmentListArray[weakSelf.orgChooseIndex] departmentId]; //给部门ID赋值
            submitApplyOrgName = [weakSelf.mainModel.myDepartmentListArray[weakSelf.orgChooseIndex] departmentName];
            
            if ([weakSelf.mainModel.myDepartmentListArray[weakSelf.orgChooseIndex] userListModelArray].count ) {
                cell.applyCheckerBtn.userInteractionEnabled = YES;
                [cell.applyCheckerBtn setTitle:[[weakSelf.mainModel.myDepartmentListArray[weakSelf.orgChooseIndex] userListModelArray][0] checkUserName] forState:UIControlStateNormal];
                
                submitApplyCheckerID = [[weakSelf.mainModel.myDepartmentListArray[weakSelf.orgChooseIndex] userListModelArray][0] checkUserId]; //给审核人ID赋值
                submitApplyCheckerName = [[weakSelf.mainModel.myDepartmentListArray[weakSelf.orgChooseIndex] userListModelArray][0] checkUserName];
                
            }
            else
            {
                cell.applyCheckerBtn.userInteractionEnabled = NO;
                [cell.applyCheckerBtn setTitle:@"暂无" forState:UIControlStateNormal];
                submitApplyCheckerID = @""; //审核人ID置空
            }
        };
        [self.pickerView show];
    }else
        [self.view makeToast:@"暂无申领部门" duration:1.5 position:CSToastPositionCenter];
    
    
}

-(void)applyDateBtnDidClick:(WHApplicationMainCell *)cell
{
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"添加日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
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
    submitApplyDate = result;
    [_mainTableView reloadData];
}



#pragma mark - WHApplicationItemCellDelegate
-(void)itemWillDel:(WHApplicationItemCell *)cell
{
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    if (_dataArray[indexPath.row]) {
        [_dataArray removeObjectAtIndex:indexPath.row];
    }
    [_mainTableView reloadData];
}

-(void)itemWillAdd:(WHApplicationItemCell *)cell
{
    
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    
    if (_dataArray[indexPath.row]) {
        WHGoodsDetailModel *model = _dataArray[indexPath.row];
        
        NSString *numString = cell.itemCountTextfield.text;
        NSInteger num = [numString integerValue];
        num ++;
        
        if (num > [model.inventory integerValue]) {
            [self.view makeToast:[NSString stringWithFormat:@"当前仓库该物品数量为:%@,已超出!",model.inventory] duration:1.5 position:CSToastPositionCenter];
            num--;
        }
        
        cell.itemCountTextfield.text = [NSString stringWithFormat:@"%ld",(long)num];
        
        model.count = [NSString stringWithFormat:@"%ld",(long)num];
    }
    
}

-(void)itemWillDiscrease:(WHApplicationItemCell *)cell
{
    NSString *numString = cell.itemCountTextfield.text;
    NSInteger num = [numString integerValue];
    num --;
    if (num <= 0) {
        num = 0;
    }
    cell.itemCountTextfield.text = [NSString stringWithFormat:@"%ld",(long)num];
    
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    if (_dataArray[indexPath.row]) {
        WHGoodsDetailModel *model = _dataArray[indexPath.row];
        model.count = [NSString stringWithFormat:@"%ld",(long)num];
    }
}

#pragma mark - TextFiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
        if (textField.tag == reasonTextFieldTag) {
            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            submitApplyReason = toBeString;
            _mainModel.applyReason = toBeString;
            return YES;
    }
        else if (textField.tag == tipsTextFieldTag) {
            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            submitApplyNote = toBeString;
            _mainModel.applyNote = toBeString;
            return YES;
            }
    else if(textField.tag == applyNumTextFieldTag)
    {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        submitApplyCode = toBeString;
        _mainModel.applyMessageModel.code = submitApplyCode;
    }
    else
    {
        for (int i = 0; i < _dataArray.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];
            
            WHGoodsDetailModel * model = _dataArray[indexPath.row];
            NSInteger tagCount = indexPath.row + 40000;
            
            if (tagCount == textField.tag) {
                NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                if ([toBeString integerValue] > [model.inventory integerValue]) {
                    
                    NSString *maxString = [NSString stringWithFormat:@"该物品最大值为%@,已经超出 ! ",model.inventory];
                    [self.view makeToast:maxString duration:1.5 position:CSToastPositionCenter];
                    
                    model.count = model.inventory;
                    [_mainTableView reloadData];
                }
                else
                    model.count = toBeString;
                
                return YES;
            }
        }
    }
    
    return YES;

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == reasonTextFieldTag) {
        submitApplyReason = textField.text;
        _mainModel.applyReason = textField.text;
        
    }
    else if (textField.tag == tipsTextFieldTag) {
        submitApplyNote = textField.text;
        _mainModel.applyNote = textField.text;
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
