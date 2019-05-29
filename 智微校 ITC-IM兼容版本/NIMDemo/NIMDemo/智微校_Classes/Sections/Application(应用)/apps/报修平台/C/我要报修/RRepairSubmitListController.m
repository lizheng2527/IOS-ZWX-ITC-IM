//
//  RRepairSubmitListController.m
//  NIM
//
//  Created by 中电和讯 on 17/3/15.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RRepairSubmitListController.h"
#import "TYHRepairNetRequestHelper.h"
#import <UIView+Toast.h>
#import "TYHRepairMainModel.h"
#import "RAPlaceModel.h"
#import "TYHRepairDefine.h"
#import "TYHRepairMainController.h"
#import "RepairApplicationErrorCell.h"
#import "RAErrorCollectionView.h"
#import "RepairApplicationAddCell.h"
#import "RepairApplicationPlaceCell.h"
#import "ValuePickerView.h"

#import "NSString+NTES.h"
#import <TZImagePickerController.h>

#import "ACMediaFrame.h"
#import <MJExtension.h>
#import "NTESUITextField.h"


static NSInteger schoolIdx;
static NSInteger buildingIdx;
static NSInteger floorIdx;

@interface RRepairSubmitListController ()<UITableViewDelegate,UITableViewDataSource,RepairApplicationPlaceCellDelegate,UITextViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain)NSMutableArray *userInfoArray;
@property(nonatomic,retain)NSMutableArray *placeArray;
@property(nonatomic,retain)NSMutableArray *errorArray;

@property(nonatomic,retain)ValuePickerView *pickerView;

@property(nonatomic,copy)NSString *schoolID;
@property(nonatomic,copy)NSString *buildingID;
@property(nonatomic,copy)NSString *floorID;
@property(nonatomic,copy)NSString *roomID;

@property(nonatomic,assign)NSInteger uploadImageViewHeigh;
@property(nonatomic,retain)UIView *bgView;
@end

@implementation RRepairSubmitListController
{
    NSString *malfunctionDescribe;
    NSString *telNum;
    
    NSString *areaSchoolString;
    NSString *areaBuildingString;
    NSString *areaFloorString;
    NSString *areaRoomString;
    
    __block NSMutableArray *uploadImageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"报修单";
    
    telNum = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_MOBIENUM];
    uploadImageArray = [NSMutableArray array];
    NSString *phoneNum = [NSString stringWithFormat:@"联系电话: " ];
    _userInfoArray = [NSMutableArray array];
    NSString *userName =[NSString stringWithFormat:@"报修人: %@",[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERNAME] ]; ;
    [_userInfoArray addObject:userName];
    [_userInfoArray addObject:phoneNum];
    
    [self tableViewConfig];
    [self createBarItem];
    [self initPickview];
    _uploadImageViewHeigh = 0;
    [self uploadViewInit];
    
    [self requestData];
    
}

#pragma mark - RequestData
-(void)requestData
{
    [SVProgressHUD showWithStatus:@"获取数据中"];
    
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    [helper getMalfunctionPlaceListWithGoodsID:_goodsID.length?_goodsID:@"" andStatus:^(BOOL successful, NSMutableArray *placeSource,NSMutableArray *errorSource) {
        _placeArray = [NSMutableArray arrayWithArray:placeSource];
        _errorArray = [NSMutableArray arrayWithArray:errorSource];
        
        if (placeSource.count) {
            _roomID = [placeSource[0] schoolID];
            //设置building
            if ([placeSource[0] buildingListModelArray].count) {
                _roomID = [[placeSource[0] buildingListModelArray][0] buildingID];
                //设置floor
                if ([[placeSource[0] buildingListModelArray][0] floorListModelArray].count) {
                    _roomID = [[[placeSource[0] buildingListModelArray][0] floorListModelArray][0]floorID];
                    //设置room
                    if ([[[placeSource[0] buildingListModelArray][0] floorListModelArray][0] roomListModelArray].count) {
                        _roomID = [[[[placeSource[0] buildingListModelArray][0] floorListModelArray][0] roomListModelArray][0] roomID];
                    }}}}
        
        [SVProgressHUD dismiss];
        [_mainTableView reloadData];
    } failure:^(NSError *error) {
        
        [SVProgressHUD dismiss];
        [self.view makeToast:@"获取数据失败,请重试" duration:1.5 position:CSToastPositionCenter];
    }];
}


#pragma mark - TableView Delegate&Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *iden = @"sectionOneCellIden";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
            cell.textLabel.font = [UIFont systemFontOfSize:16];
        }
        cell.textLabel.text = _userInfoArray[indexPath.row];
        cell.selectionStyle = NO;
        if (indexPath.row == 1) {
            NTESUITextField *phoneTextField = [[NTESUITextField alloc]initWithFrame:CGRectMake(96, 7, SCREEN_WIDTH - 96 - 8, 30)];
            phoneTextField.delegate = self;
            phoneTextField.placeholder = @"请输入电话号码";
            phoneTextField.borderStyle = UITextBorderStyleRoundedRect;
            phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
            phoneTextField.text = telNum.length?telNum:@"";
            phoneTextField.delegate = self;
            [cell.contentView addSubview:phoneTextField];
        }
        return cell;
    }
    else if(indexPath.section == 1)
    {
        static NSString *iden2 = @"sectionTwoCellIden";
        RepairApplicationErrorCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"RepairApplicationErrorCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = NO;
        cell.goodsNameLabel.text = self.typeName;
//        RAErrorCollectionView *CollectionView = [[RAErrorCollectionView alloc] initWithFrame:CGRectMake(90, 0, [UIScreen mainScreen].bounds.size.width - 90, [self returnCollectionFrameHigh]) collectionViewItemSize:CGSizeMake(0, 25) withBtnArray:self.errorArray];
//        [cell.contentView addSubview:CollectionView];
        
        cell.errorDescribleTextView.delegate = self;
        cell.errorDescribleTextView.text = malfunctionDescribe.length?malfunctionDescribe:@"";
        
        return cell;
    }
    else if(indexPath.section == 2)
    {
        static NSString *iden2 = @"sectionThreeCellIden";
        RepairApplicationPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"RepairApplicationPlaceCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = NO;
        cell.placeArray = [NSMutableArray arrayWithArray:self.placeArray];
        cell.delegate = self;
        
        if (![NSString isBlankString:areaSchoolString]) {
             [cell.chooseSchoolBtn setTitle:areaSchoolString forState:UIControlStateNormal];
        }
        if (![NSString isBlankString:areaBuildingString]) {
             [cell.chooseBuildingBtn setTitle:areaBuildingString forState:UIControlStateNormal];
        }
        if (![NSString isBlankString:areaFloorString]) {
             [cell.chooseFloorBtn setTitle:areaFloorString forState:UIControlStateNormal];
        }
        if (![NSString isBlankString:areaRoomString]) {
             [cell.chooseRoomBtn setTitle:areaRoomString forState:UIControlStateNormal];
        }
        return cell;
    }
    else if(indexPath.section == 3)
    {
        static NSString *iden2 = @"sectionFourCellIden";
        RepairApplicationAddCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"RepairApplicationAddCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = NO;
        
        if (!_bgView.superview) {
            [cell.contentView addSubview:_bgView];
        }
        return cell;
    }
    return [UITableViewCell new];
//    RepairApplicationErrorCell
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }
    else if(indexPath.section == 1)
//        return 81 + [self returnCollectionFrameHigh];
        return 128;
    else if(indexPath.section == 2)
        return 178;
    else if(indexPath.section == 3)
        return 70 + _uploadImageViewHeigh;
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    else return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return 0;
    }
    else
    return 5;
}

#pragma mark - RepairApplicationPlaceCellDelegate
-(void)chooseSchool:(RepairApplicationPlaceCell *)cell
{
    NSMutableArray *array = [NSMutableArray array];
    for (RASchoolModel *model in _placeArray) {
        [array addObject:model.name];
    }
    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        schoolIdx = index;
        //设置school
        [cell.chooseSchoolBtn setTitle:stateArr[0] forState:UIControlStateNormal];
        areaSchoolString = stateArr[0];
        weakSelf.schoolID = [weakSelf.placeArray[index] schoolID];
        //设置building
        if ([weakSelf.placeArray[index] buildingListModelArray].count) {
            cell.chooseBuildingBtn.userInteractionEnabled = YES;
            [cell.chooseBuildingBtn setTitle:[[weakSelf.placeArray[index] buildingListModelArray][0] name] forState:UIControlStateNormal];
            areaBuildingString = [[weakSelf.placeArray[index] buildingListModelArray][0] name];
            weakSelf.buildingID = [[weakSelf.placeArray[index] buildingListModelArray][0] buildingID];
            //设置floor
            if ([[weakSelf.placeArray[index] buildingListModelArray][0] floorListModelArray].count) {
                cell.chooseFloorBtn.userInteractionEnabled = YES;
                weakSelf.floorID = [[[weakSelf.placeArray[index] buildingListModelArray][0] floorListModelArray][0] floorID];
                [cell.chooseFloorBtn setTitle:[[[weakSelf.placeArray[index] buildingListModelArray][0] floorListModelArray][0] name] forState:UIControlStateNormal];
                areaFloorString = [[[weakSelf.placeArray[index] buildingListModelArray][0] floorListModelArray][0] name];
                //设置room
                if ([[[weakSelf.placeArray[index] buildingListModelArray][0] floorListModelArray][0] roomListModelArray].count) {
                    cell.chooseRoomBtn.userInteractionEnabled = YES;
                    weakSelf.roomID = [[[[weakSelf.placeArray[index] buildingListModelArray][0] floorListModelArray][0] roomListModelArray][0] roomID];
                    [cell.chooseRoomBtn setTitle:[[[[weakSelf.placeArray[index] buildingListModelArray][0] floorListModelArray][0] roomListModelArray][0] name] forState:UIControlStateNormal];
                    areaRoomString = [[[[weakSelf.placeArray[index] buildingListModelArray][0] floorListModelArray][0] roomListModelArray][0] name];
                }
                else
                {
                    cell.chooseRoomBtn.userInteractionEnabled = NO;
                    [cell.chooseRoomBtn setTitle:@"" forState:UIControlStateNormal];
                    areaRoomString = @"";
                }
            }else
            {
                cell.chooseFloorBtn.userInteractionEnabled = NO;
                [cell.chooseFloorBtn setTitle:@"" forState:UIControlStateNormal];
                areaFloorString = @"";
                cell.chooseRoomBtn.userInteractionEnabled = NO;
                [cell.chooseRoomBtn setTitle:@"" forState:UIControlStateNormal];
                areaRoomString = @"";
            }
        }
        else {
            cell.chooseBuildingBtn.userInteractionEnabled = NO;
            [cell.chooseBuildingBtn setTitle:@"" forState:UIControlStateNormal];
            areaBuildingString = @"";
            cell.chooseFloorBtn.userInteractionEnabled = NO;
            [cell.chooseFloorBtn setTitle:@"" forState:UIControlStateNormal];
            areaFloorString = @"";
            cell.chooseRoomBtn.userInteractionEnabled = NO;
            [cell.chooseRoomBtn setTitle:@"" forState:UIControlStateNormal];
            areaRoomString = @"";
        }
    };
    [self.pickerView show];
}


-(void)chooseBuilding:(RepairApplicationPlaceCell *)cell
{
    
    NSMutableArray *array = [NSMutableArray array];
    for (RAPlaceModel *model in [_placeArray[schoolIdx] buildingListModelArray]) {
        [array addObject:model.name];
    }

    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        buildingIdx = index;
        
        //设置building
            cell.chooseBuildingBtn.userInteractionEnabled = YES;
            [cell.chooseBuildingBtn setTitle:[[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] name] forState:UIControlStateNormal];
        areaBuildingString = [[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] name];
            weakSelf.buildingID = [[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] buildingID];
            //设置floor
            if ([[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] floorListModelArray].count) {
                cell.chooseFloorBtn.userInteractionEnabled = YES;
                weakSelf.floorID = [[[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] floorListModelArray][0] floorID];
                [cell.chooseFloorBtn setTitle:[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] floorListModelArray][0] name] forState:UIControlStateNormal];
                areaFloorString = [[[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] floorListModelArray][0] name];
                //设置room
                if ([[[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] floorListModelArray][0] roomListModelArray].count) {
                    cell.chooseRoomBtn.userInteractionEnabled = YES;
                    weakSelf.roomID = [[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] floorListModelArray][0] roomListModelArray][0] roomID];
                    [cell.chooseRoomBtn setTitle:[[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] floorListModelArray][0] roomListModelArray][0] name] forState:UIControlStateNormal];
                    areaRoomString = [[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][index] floorListModelArray][0] roomListModelArray][0] name];
                }
                else
                {
                    cell.chooseRoomBtn.userInteractionEnabled = NO;
                    [cell.chooseRoomBtn setTitle:@"" forState:UIControlStateNormal];
                    areaRoomString = @"";
                }
            }else
            {
                cell.chooseFloorBtn.userInteractionEnabled = NO;
                [cell.chooseFloorBtn setTitle:@"" forState:UIControlStateNormal];
                areaFloorString = @"";
                cell.chooseRoomBtn.userInteractionEnabled = NO;
                [cell.chooseRoomBtn setTitle:@"" forState:UIControlStateNormal];
                areaRoomString = @"";
            }
    };
    [self.pickerView show];
}

-(void)chooseFloor:(RepairApplicationPlaceCell *)cell
{
    __weak typeof(self) weakSelf = self;

    NSMutableArray *array = [NSMutableArray array];
    for (RAPlaceModel *model in [[_placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray]) {
        [array addObject:model.name];
    }
    self.pickerView.dataSource = array;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        floorIdx = index;
        //设置floor
            weakSelf.floorID = [[[weakSelf.placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] floorID];
            [cell.chooseFloorBtn setTitle:[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] name] forState:UIControlStateNormal];
            areaFloorString = [[[weakSelf.placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] name];
        
            //设置room
            if ([[[weakSelf.placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] roomListModelArray].count) {
                cell.chooseRoomBtn.userInteractionEnabled = YES;
                weakSelf.roomID = [[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] roomListModelArray][0] roomID];
                [cell.chooseRoomBtn setTitle:[[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] roomListModelArray][0] name] forState:UIControlStateNormal];
                areaRoomString = [[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] roomListModelArray][0] name];
            }
            else
            {
                cell.chooseRoomBtn.userInteractionEnabled = NO;
                [cell.chooseRoomBtn setTitle:@"" forState:UIControlStateNormal];
                areaRoomString = @"";
            }
    };
    [self.pickerView show];
    
}

-(void)chooseClass:(RepairApplicationPlaceCell *)cell
{
    __weak typeof(self) weakSelf = self;

    NSMutableArray *array = [NSMutableArray array];
    for (RAPlaceModel *model in [[[_placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] roomListModelArray]) {
        [array addObject:model.name];
    }
    self.pickerView.dataSource = array;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
            weakSelf.roomID = [[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] roomListModelArray][index] roomID];
            [cell.chooseRoomBtn setTitle:[[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] roomListModelArray][index] name] forState:UIControlStateNormal];
        areaRoomString = [[[[weakSelf.placeArray[schoolIdx] buildingListModelArray][buildingIdx] floorListModelArray][floorIdx] roomListModelArray][index] name];
    };
    [self.pickerView show];
}

#pragma mark - BtnClick
-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitApplicationAction:(id)sender {
    
    if(![self submitValidate])
    return;
    else
    {
        
        TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
        [SVProgressHUD showWithStatus:@"正在提交中"];
        _submitButton.userInteractionEnabled = NO;
        
        
        [helper submitRepairApplicationWithResultJson:[self getPostDic] ImageArray:uploadImageArray andStatus:^(BOOL successful, NSMutableArray *dataSource) {
            [SVProgressHUD dismiss];
            [self.view makeToast:@"申请提交成功" duration:1 position:CSToastPositionCenter];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[TYHRepairMainController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }
            });
            
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [self.view makeToast:@"申请提交失败 !" duration:1 position:CSToastPositionCenter];
            _submitButton.userInteractionEnabled = YES;
        }];
    }
}

-(NSMutableDictionary *)getPostDic
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    
    [postDic setValue:malfunctionDescribe.mj_JSONString forKey:@"malfunctionDescribe"];
    [postDic setValue:telNum forKey:@"telNumber"];
    [postDic setValue:_roomID forKey:@"malfunctionPlaceId"];
    [postDic setValue:self.goodsID forKey:@"malfunctionIds"];
    [postDic setValue:self.groupID.length?self.groupID:@"" forKey:@"groupId"];
    [postDic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID] forKey:@"userId"];
    
    return postDic;
}

-(BOOL)submitValidate
{
    if ([NSString isBlankString:malfunctionDescribe]) {
        [self.view makeToast:@"请添加故障描述" duration:1.0 position:CSToastPositionCenter];
        return NO;
    }
    else if ([NSString isBlankString:telNum]) {
        [self.view makeToast:@"请输入电话号码" duration:1.0 position:CSToastPositionCenter];
        return NO;
    }
//    else if (![NSString isMobileNumber:telNum]) {
//        [self.view makeToast:@"请输入正确的电话号码" duration:1.0 position:CSToastPositionCenter];
//        return NO;
//    }
    else if ([NSString isBlankString:_roomID]) {
        [self.view makeToast:@"请选择报修地点" duration:1.0 position:CSToastPositionCenter];
        return NO;
    }
    else
    return YES;
}


- (IBAction)cancelSubmitAction:(id)sender {
    
}

#pragma mark - ViewConfig
-(void)tableViewConfig
{
    _mainTableView.bounces = NO;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.backgroundColor = [UIColor RepairBGColor];
    self.view.backgroundColor = [UIColor RepairBGColor];
//    [self tableViewHeadviewConfig];
}

-(void)tableViewHeadviewConfig
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
    view.backgroundColor = [UIColor RepairBGColor];
    _mainTableView.sectionHeaderHeight = 5;
    _mainTableView.tableHeaderView = view;
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

// 初始化上传视图
-(void)uploadViewInit
{
    //1、得到默认布局高度（唯一获取高度方法）
    CGFloat height = [ACSelectMediaView defaultViewHeight];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(90, 0, [UIScreen mainScreen].bounds.size.width - 90, height)];
    
    //2、初始化
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height)];
    
    //3、选择媒体类型：ACMediaType
    mediaView.type = ACMediaTypePhotoAndCamera;
    
    mediaView.mediaArray = [NSMutableArray array];
    mediaView.imageMaxCount = 6;
    //是否需要显示图片上的删除按钮
    //mediaView.showDelete = NO;
    
    //5、随时获取新的布局高度
    [mediaView observeViewHeight:^(CGFloat value) {
        _bgView.height = value ;
        _uploadImageViewHeigh = (value - 40) / 2;
        if (_uploadImageViewHeigh < 60) {
            _uploadImageViewHeigh = 0;
        }
        [_mainTableView reloadData];
//        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
//        [_mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    //6、随时获取已经选择的媒体文件
    [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        uploadImageArray = [NSMutableArray arrayWithArray:list];
    }];
    _bgView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:mediaView];
}

#pragma mark - Other

-(void)initPickview
{
    _pickerView = [[ValuePickerView alloc]init];
    self.pickerView.pickerTitle = @"选择故障地点";
}


//计算CollectionView Frame 的高度
-(CGFloat)returnCollectionFrameHigh
{
    NSMutableArray *heighArray = [NSMutableArray array];
    
    for (RAErrorModel *model in _errorArray) {
        UIFont *font = [UIFont systemFontOfSize:14];
        CGSize size = CGSizeMake(MAXFLOAT, 25.0f);
        CGSize buttonSize = [model.name boundingRectWithSize:size
                                                     options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                  attributes:@{ NSFontAttributeName:font}
                                                     context:nil].size;
        [heighArray addObject:[NSString stringWithFormat:@"%f",buttonSize.width + 10]];
    }

    __block CGFloat calculateHeight = 0;
    __block CGFloat heighFlag = 1;
    __block CGFloat frameHeight = 37;
    [heighArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat height = [obj floatValue];
        calculateHeight += height;
        if(calculateHeight > [UIScreen mainScreen].bounds.size.width - 90)
        {
            heighFlag ++;
            calculateHeight = height;
            frameHeight += 25;
        }
    }];
    return  frameHeight;
}


#pragma mark - TextViewDelegate TextFieldDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    malfunctionDescribe = textView.text;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        telNum = toBeString;
    return YES;
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
