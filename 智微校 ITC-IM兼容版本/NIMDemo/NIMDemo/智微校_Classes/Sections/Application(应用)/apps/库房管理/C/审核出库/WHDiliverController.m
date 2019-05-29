//
//  WHDiliverController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/1/18.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHDiliverController.h"
#import "WHApplicationHeaderView.h"
#import "WHDiliverMainCell.h"
#import "WHApplicationItemCell.h"

#import "WHNetHelper.h"
#import "WHMyApplicationModel.h"
#import <UIView+Toast.h>

#import "WHChooseApplyUserController.h"
#import "WHChooseWareHouseController.h"

#import "ValuePickerView.h"
#import "TYHWarehouseDefine.h"
#import <MJExtension.h>
#import "NSString+Empty.h"

#import "GYZCustomCalendarPickerView.h"
#import "IDJCalendarUtil.h"

#import "AssetDrawController.h"
#import "AssetDiliverFooterView.h"

#import "ImageHandller.h"
#import "ContactModel.h"
#import "LYEmptyViewHeader.h"

#define outCodeTextFieldTag 300001
#define outNoteTextFieldTag 300002

@interface WHDiliverController ()<UITableViewDelegate,UITableViewDataSource,WHApplicationItemCellDelegate,WHDiliverMainCellDelegate,ChoosePersonDelete,UITextFieldDelegate,GYZCustomCalendarPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic,retain)NSMutableArray *dataArrayUseKind;
@property(nonatomic,retain)NSMutableArray *dataArrayChecker;
@property(nonatomic,retain)NSMutableArray *dataArrayWareHouse;

@property(nonatomic,retain)WHMyApplicationDetailModel *mainModel;
@property(nonatomic,retain)ValuePickerView *pickerView;

@property(nonatomic,retain)NSMutableArray *dataArrayDepartment;
@end

@implementation WHDiliverController
{
    NSString *outCode;
    NSString *outDate;
    NSString *outKind;
    NSString *outWareHouseID;
    NSString *outReceiveUserID;
    NSString *outNote;
    
    NSString *outKindName;
    NSString *outWareHouseName;
    
    NSString *departmentName;
    NSString *departmentID;
    
    NSInteger footerViewHeight;
    
    UIButton *leftBtn;
    UILabel *leftLabel;
    
    UIButton *rightBtn;
    UILabel *rightLabel;
    
    UIButton *addPicBtn;
    AssetDiliverFooterView *footView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self createBarItem];
    [self requestData];
    [self initPickview];
    
    footerViewHeight = 120;
    _mainTableView.sectionFooterHeight = footerViewHeight;
    [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"tmpImageDataa"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"tmpImageDataa"];
    if (imageData) {
        [addPicBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
//        addPicBtn.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
//        footerViewHeight = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height + 40;
        
        
        UIImage *image = [UIImage imageWithData:imageData];
        addPicBtn.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width);
        footerViewHeight =  image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width + 40;
        
        footView.frame = CGRectMake(footView.frame.origin.x, footView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
    }
    [_mainTableView reloadData];
}


#pragma mark - DataRequest
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"正在获取数据";
    
    WHNetHelper *helper = [[WHNetHelper alloc]init];
    [helper getApplyDiliverMainInfoWithApplyID:_applyID andStatus:^(BOOL successful, WHMyApplicationDetailModel *model) {
        
        _mainModel = [WHMyApplicationDetailModel new];
        _mainModel = model;
        
        outCode = [(WHMyDetailModel *)model.detailArray[0] code]; //设置默认code
        outReceiveUserID = [(WHMyDetailModel *)model.detailArray[0] userId]; //领用人ID
        
        [_mainTableView reloadData];
       [helper getApplyDiliverGoodsListWithApplyID:_applyID andStatus:^(BOOL successful, NSMutableArray *dataSourceUseKind, NSMutableArray *dataSourceChecker,NSMutableArray *wareHouseListArray) {
           _dataArrayUseKind = [NSMutableArray arrayWithArray:dataSourceUseKind];
           _dataArrayChecker = [NSMutableArray arrayWithArray:dataSourceChecker];
           _dataArrayWareHouse = [NSMutableArray arrayWithArray:wareHouseListArray];
           
           if (dataSourceUseKind.count) {
               outKind = [(WHMyApplicationUseKindModel *)dataSourceUseKind[0] code]; //默认类型
               outKindName = [(WHMyApplicationUseKindModel *)dataSourceUseKind[0] name];
           }
           
           outDate = [(WHMyApplicationCheckModel *)_dataArrayChecker[0] productDate]; //date
           [_mainTableView reloadData];
           
           [helper getApplyDepartmentListWithApplyID:_applyID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
               _dataArrayDepartment = [NSMutableArray arrayWithArray:dataSource];
               [hud removeFromSuperview];
           } failure:^(NSError *error) {
               [self.view makeToast:@"获取数据失败" duration:1 position:nil];
               [hud removeFromSuperview];
           }];
           
           
       } failure:^(NSError *error) {
           [self.view makeToast:@"获取数据失败" duration:1 position:nil];
           [hud removeFromSuperview];
       }];
        
        
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"获取数据失败" duration:1 position:nil];
        [hud removeFromSuperview];
    }];

}

#pragma mark - TableViewConfig
-(void)initView
{
    self.title = @"申领发放";
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = NO;
    _mainTableView.bounces = NO;
    
    _mainTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:nil titleStr:@"暂无数据" detailStr:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *iden1 = @"WHDiliverMainCell";
        WHDiliverMainCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHDiliverMainCell" owner:self options:nil].firstObject;
        }
        
        cell.selectionStyle = NO;
        cell.delegate = self;
        cell.tipTextfield.delegate = self;
        cell.tipTextfield.tag = outNoteTextFieldTag;
        cell.tipTextfield.text = outNote.length?outNote:@"";
        
        cell.numberTextfield.delegate = self;
        cell.numberTextfield.tag = outCodeTextFieldTag;
        
        cell.model = _mainModel.detailArray[indexPath.row];
        WHMyApplicationCheckModel *model = _dataArrayChecker[indexPath.row];
        cell.userPersonLabel.text = model.userName;
        cell.handlerPersonLabel.text = model.makerUserName;
        cell.makeDateLabel.text = model.productDate;
        [cell.outDateBtn setTitle:outDate forState:UIControlStateNormal];
        
        if (![NSString isBlankString:departmentName] && ![NSString isBlankString:departmentID]) {
            [cell.chooseDepartmentBtn setTitle:departmentName.length?departmentName:@"点击选择" forState:UIControlStateNormal];
            [cell.chooseDepartmentBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        
        
        if (_dataArrayUseKind.count) {
            [cell.applyTypeBtn setTitle:outKindName forState:UIControlStateNormal];
        }
        
        [cell.outWarehouseBtn setTitle:outWareHouseName.length?outWareHouseName:@"选择仓库" forState:UIControlStateNormal];
        if (![NSString isBlankString:outWareHouseName] && ![NSString isBlankString:outWareHouseID]) {
            [cell.outWarehouseBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *iden2 = @"WHApplicationItemCell";
        WHApplicationItemCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"WHApplicationItemCell" owner:self options:nil].firstObject;
        }
        cell.delegate = self;
        cell.itemCountTextfield.delegate = self;
        cell.itemPriceTextField.delegate = self;
        cell.itemCountTextfield.tag = indexPath.row + 40000;
        cell.itemPriceTextField.tag = indexPath.row + 50000;
        cell.itemNameLabel.text = [_mainModel.itemListArray[indexPath.row] goodsInfoName];
        cell.itemPriceTextField.text = [_mainModel.itemListArray[indexPath.row] Money];
        
        WHMyItemListModel *listModel =_mainModel.itemListArray[indexPath.row];
        cell.itemCountTextfield.text = listModel.count;
        
        WHMyItemListModel *model = _mainModel.itemListArray[indexPath.row];
        model.goodsInfoId = model.itemId;
        model.sum = model.sum?model.sum:model.Money;
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
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        WHApplicationHeaderView *headView = [[WHApplicationHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
        headView.lablel.text = @"申领物品清单";
        return headView;
    }
    return [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001f;
    }
    else return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.001f;
    }
    else return footerViewHeight;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 335;
    }
    else if(indexPath.section == 1)
        return 88;
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
    else return _mainModel.itemListArray.count;
}

//自定义footView
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        footView = [AssetDiliverFooterView new];
        footView.userInteractionEnabled = YES;
        footView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
        footView.backgroundColor = [UIColor whiteColor];
        [self initFootView];
        
        NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"tmpImageDataa"];
        if (imageData) {
            [addPicBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
//            addPicBtn.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
//            footerViewHeight = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height + 40;
            
            UIImage *image = [UIImage imageWithData:imageData];
            addPicBtn.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width);
            footerViewHeight =  image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width + 40;
            
            
            footView.frame = CGRectMake(footView.frame.origin.x, footView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
        }
        
        return footView;
    }
    else return [UIView new];
    
}


#pragma mark - Submit



#pragma mark - Other
-(void)createBarItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(diliverAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

-(void)diliverAction:(id)sender
{
    
    if ([NSString isBlankString:outWareHouseID]) {
        [self.view makeToast:@"请选择出库仓库" duration:1.5 position:CSToastPositionCenter];
    }
    else if([NSString isBlankString:departmentID])
    {
        [self.view makeToast:@"请选择领用部门" duration:1.5 position:CSToastPositionCenter];
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.labelText = @"正在提交";
        
        WHNetHelper *helper = [[WHNetHelper alloc]init];
        [helper submitApplicationDiliverWithResultJson:[self getResultDic] andStatus:^(BOOL successful, NSMutableArray *dataSource) {
            [self.view makeToast:@"提交成功 " duration:1 position:CSToastPositionCenter];
            [hud removeFromSuperview];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            [self.view makeToast:@"提交失败 !" duration:1 position:CSToastPositionCenter];
            [hud removeFromSuperview];
        }];
    }
}

-(NSMutableDictionary *)getResultDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:_applyID forKey:@"applyReceiveId"];
    [dic setValue:outCode forKey:@"code"];
    [dic setValue:outDate forKey:@"date"];
    [dic setValue:outWareHouseID forKey:@"warehouseId"];
    [dic setValue:outKind forKey:@"outKind"];
    [dic setValue:outReceiveUserID forKey:@"receiveUserId"];
    [dic setValue:outNote forKey:@"note"];
    [dic setValue:departmentID forKey:@"department"];
    
    NSMutableArray *array = [NSMutableArray array];
    for (WHMyItemListModel *model in _mainModel.itemListArray) {
        [array addObject:model.mj_keyValues];
    }
    [dic setValue:array forKey:@"goodsInfos"];
    return dic;
}

#pragma mark - WHDiliverMainCellDelegate
-(void)applyUseKindBtnDidClick:(WHDiliverMainCell *)cell
{
    NSMutableArray *pickerDatasurce = [NSMutableArray array];
    for (WHMyApplicationUseKindModel *model in _dataArrayUseKind) {
        [pickerDatasurce addObject:model.name];
    }
    self.pickerView.dataSource = pickerDatasurce;
    
    self.pickerView.pickerTitle = @"领用类型";
    //    __weak typeof(self) weakSelf = self;
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        [cell.applyTypeBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        outKind = [(WHMyApplicationUseKindModel *)[_dataArrayUseKind objectAtIndex:[stateArr[1] integerValue] - 1] code];
        outKindName = [(WHMyApplicationUseKindModel *)_dataArrayUseKind[[stateArr[1]integerValue] -1] name];
    };
    [self.pickerView show];
}

-(void)applyOutWarehouseBtnDidClick:(WHDiliverMainCell *)cell
{
    
    WHChooseWareHouseController *chooseView = [WHChooseWareHouseController new];
    chooseView.typeString = @"添加";
    chooseView.chooseWareHouseOrDepartment = 1;
    chooseView.assetDatasource = _dataArrayWareHouse;
    [self.navigationController pushViewController:chooseView animated:YES];
    
//    WHChooseApplyUserController * baseVc = [[WHChooseApplyUserController alloc] init];
//    
//    baseVc.userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
//    baseVc.userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
//    baseVc.password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
//    baseVc.urlStr = @"/bd/mobile/baseData!getTeacherTreeIOS.action";
//    baseVc.title = @"选择申领人";
//    baseVc.whoWillIn = YES;
//    baseVc.delegate = self;
//    [self.navigationController pushViewController:baseVc animated:YES];
    
}


-(void)applyDepartmentBtnDidClick:(WHDiliverMainCell *)cell
{
    WHChooseWareHouseController *chooseView = [WHChooseWareHouseController new];
    chooseView.typeString = @"添加";
    chooseView.chooseWareHouseOrDepartment = 2;
    chooseView.assetDatasource = _dataArrayDepartment;
    [self.navigationController pushViewController:chooseView animated:YES];
    
}

- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name goodsCountArray:(NSMutableArray *)goodsArray{
    outWareHouseID = urlId;
    outWareHouseName = name;
    
    [_mainModel.itemListArray enumerateObjectsUsingBlock:^(WHMyItemListModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [goodsArray enumerateObjectsUsingBlock:^(ContactGoodsCountModel  *goodObj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([goodObj.goodsID isEqualToString:obj.itemId]) {
                if ([goodObj.goodsCount integerValue] >=0 && [goodObj.goodsCount integerValue] <= [obj.count integerValue]) {
                    obj.count = goodObj.goodsCount;
                }
                obj.maxCount = goodObj.goodsCount;
            }
        }];
        obj.hasChooseWareHouse = YES;
    }];
    [_mainTableView reloadData];
}

-(void)didselectedDepartment:(NSString *)departID DepartmentName:(NSString *)name
{
    departmentID = departID;
    departmentName = name;
    [_mainTableView reloadData];
    
}


-(void)applyDateBtnDidClick:(WHDiliverMainCell *)cell
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
    outDate = result;
    [_mainTableView reloadData];
}



#pragma mark - WHApplicationItemCellDelegate
-(void)itemWillDel:(WHApplicationItemCell *)cell
{
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    [_mainModel.itemListArray removeObjectAtIndex:indexPath.row];
    [_mainTableView reloadData];
    
}

-(void)itemWillAdd:(WHApplicationItemCell *)cell
{
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    WHMyItemListModel *model = _mainModel.itemListArray[indexPath.row];
    if (model.hasChooseWareHouse ) {
        
        NSString *numString = cell.itemCountTextfield.text;
        NSInteger num = [numString integerValue];
        num ++;
        
        if (num > [model.maxCount integerValue]) {
            [self.view makeToast:[NSString stringWithFormat:@"当前仓库该物品数量为:%@,已超出!",model.maxCount] duration:1.5 position:CSToastPositionCenter];
            num--;
        }
        
        cell.itemCountTextfield.text = [NSString stringWithFormat:@"%ld",(long)num];
        
        model.count = [NSString stringWithFormat:@"%ld",(long)num];
        
    }else
    {
        [self.view makeToast:@"请先选择出库仓库" duration:1.5 position:CSToastPositionCenter];
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
    WHMyItemListModel *model = _mainModel.itemListArray[indexPath.row];
    model.count = [NSString stringWithFormat:@"%ld",(long)num];
}


#pragma mark - TextFieldDelegate
#pragma mark - TextFiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    
    if (textField.tag == outCodeTextFieldTag) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        outCode = toBeString;
        for (WHMyDetailModel *model in _mainModel.detailArray) {
            model.code = toBeString;//pok //
        }
        return YES;
    }
    else if (textField.tag == outNoteTextFieldTag) {
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        outNote = toBeString;
        return YES;
    }
    else
    {
        for (int i = 0; i < _mainModel.itemListArray.count; i++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:1];

            WHMyItemListModel * model = _mainModel.itemListArray[indexPath.row];
            NSInteger tagCount = indexPath.row + 40000;
            NSInteger tagPrice = indexPath.row + 50000;
            if (tagCount == textField.tag) {
                NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                model.count = [NSString stringWithFormat:@"%@",toBeString];
                return YES;
            }
            if (tagPrice == textField.tag) {
                NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
                model.sum = [NSString stringWithFormat:@"%@",toBeString];
                return YES;
            }
        }
    }
    return YES;
    
}

#pragma mark - Other
-(void)initPickview
{
    _pickerView = [[ValuePickerView alloc]init];
    _pickerView.pickerTitle = @"标题";
}


-(void)initFootView
{
    //yes:Left   no:Right
    leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftBtn.frame = CGRectMake(20, 10, 20, 20);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(LeftBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:leftBtn];
    
    leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(20 + 20 + 5, 10, 80, 20)];
    leftLabel.text = @"上传签字";
    leftLabel.font = [UIFont boldSystemFontOfSize:13];
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(LeftBtnAction:)];
    leftLabel.userInteractionEnabled = YES;
    [leftLabel addGestureRecognizer:leftTap];
    leftLabel.textColor = [UIColor darkGrayColor];
    leftLabel.userInteractionEnabled = YES;
    [footView addSubview:leftLabel];
    
    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(115 + 30, 10, 20, 20);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(RightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:rightBtn];
    
    rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(rightBtn.frame.origin.x + rightBtn.frame.size.width + 5, 10, 80, 20)];
    rightLabel.text = @"后续补签";
    rightLabel.font = [UIFont boldSystemFontOfSize:13];
    rightLabel.textColor = [UIColor darkGrayColor];
    rightLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(RightBtnAction:)];
    rightLabel.userInteractionEnabled = YES;
    [rightLabel addGestureRecognizer:rightTap];
    [footView addSubview:rightLabel];
    
    addPicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addPicBtn.frame = CGRectMake(30, 40, 70, 70);
    [addPicBtn setBackgroundImage:[UIImage imageNamed:@"AlbumAddBtnHL@2x"] forState:UIControlStateNormal];
    [addPicBtn addTarget:self action:@selector(AddPicAction:) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:addPicBtn];
    
}


-(void)LeftBtnAction:(id)sender
{
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
    footerViewHeight = 120;
    NSData *imageData = [[NSUserDefaults standardUserDefaults]objectForKey:@"tmpImageDataa"];
    if (imageData) {
        [addPicBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
//        addPicBtn.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height);
//        footerViewHeight = [UIScreen mainScreen].bounds.size.width * [UIScreen mainScreen].bounds.size.width / [UIScreen mainScreen].bounds.size.height + 40;
        UIImage *image = [UIImage imageWithData:imageData];
        addPicBtn.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width);
        footerViewHeight =  image.size.height * [UIScreen mainScreen].bounds.size.width / image.size.width + 40;
        
        footView.frame = CGRectMake(footView.frame.origin.x, footView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
    }
    addPicBtn.hidden = NO;
    footView.frame = CGRectMake(footView.frame.origin.x, footView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
}

-(void)RightBtnAction:(id)sender
{
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected"] forState:UIControlStateNormal];
        [leftBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected"] forState:UIControlStateNormal];
        footerViewHeight = 40;
        addPicBtn.hidden = YES;
        footView.frame = CGRectMake(footView.frame.origin.x, footView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, footerViewHeight);
}

-(void)AddPicAction:(id)sender
{
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择发放方式" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *pickerCon = [[UIImagePickerController alloc]init];
        pickerCon.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerCon.allowsEditing = YES;//是否可编辑
        pickerCon.delegate = self;
        [self presentViewController:pickerCon animated:YES completion:nil];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"手写" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AssetDrawController *drawView = [AssetDrawController new];
        drawView.type = 1;
        [self presentViewController:drawView animated:YES completion:nil];
        
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    
    [self presentViewController: alertController animated: YES completion: nil];
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
     UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];//获取原始照片
    
    UIImage *drawImageNeedDeal = [UIImage new];
    
    drawImageNeedDeal = image;
    
    drawImageNeedDeal = [ImageHandller imageNeedAddTextYiHaoPin:drawImageNeedDeal Test:@"#低值易耗品"];
    
    //临时注释,陈经纶不注释
//        drawImageNeedDeal = [ImageHandller addImage:drawImageNeedDeal addMsakImage:[UIImage imageNamed:@"logo_cjl"]];
    
    NSData *tmpImageData = UIImagePNGRepresentation(drawImageNeedDeal);
    [[NSUserDefaults standardUserDefaults]setObject:tmpImageData forKey:@"tmpImageDataa"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
