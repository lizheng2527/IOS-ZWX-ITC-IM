//
//  MyRepairServiceFeedBackController.m
//  NIM
//
//  Created by 中电和讯 on 2017/4/5.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MyRepairServiceFeedBackController.h"

#import "MRADetailUpCell.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "TYHRepairNetRequestHelper.h"
#import "MyRepairApplicationModel.h"
#import <UIView+Toast.h>
#import "MRSFeedBackCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "TYHRepairDefine.h"
#import "MRSAddDetailCell.h"

#import "NSString+NTES.h"
#import <TZImagePickerController.h>
#import "ACMediaFrame.h"
#import "MRSAddFooterView.h"
#import <MJExtension.h>
#import "TYHRepairMainController.h"
#import "ETTextView.h"


static NSString *footerTitleString = @"0.00";
@interface MyRepairServiceFeedBackController ()<UITableViewDelegate,UITableViewDataSource,MRADetailUpCellDelegate,MRSAddFooterViewDelegate,MRSAddDetailCellDelegate,UITextFieldDelegate,UITextViewDelegate>

@property(nonatomic,retain)NSMutableArray *leftRepairlDetailArray;

@property(nonatomic,retain)NSMutableArray *addArray;

@property(nonatomic,retain)MRSRepairInfoModel *mrsRepairInfoModel;

@property(nonatomic,assign)NSInteger uploadImageViewHeigh;
@property(nonatomic,retain)UIView *bgView;

@property(nonatomic,retain)MRSAddFooterView *footerView;

@end

@implementation MyRepairServiceFeedBackController
{
    TPKeyboardAvoidingTableView *mainTableView;
    __block NSMutableArray *uploadImageArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    [self requestData];
    [self uploadViewInit];
    self.addArray = [NSMutableArray array];
    uploadImageArray = [NSMutableArray array];
}


#pragma mark - initView
-(void)initView
{
    self.title = @"维修反馈";
    self.view.backgroundColor = [UIColor whiteColor];
    mainTableView = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height  - 49) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    mainTableView.bounces = NO;
    mainTableView.backgroundColor = [UIColor TabBarColorGray];
    mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    mainTableView.delaysContentTouches =NO;
    [self.view addSubview:mainTableView];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[UIColor TabBarColorRepair]];
    submitBtn.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 49, [UIScreen mainScreen].bounds.size.width, 49);
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:submitBtn];
}


-(void)requestData
{
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    
    _mrsRepairInfoModel = [MRSRepairInfoModel new];
    _mrsRepairInfoModel.repairStatus = @"2";
    _mrsRepairInfoModel.faultkind = @"0";
    _mrsRepairInfoModel.faultReason = @"";
    
    [helper getMyRepairApplicationDetailWithRepairID:self.repairID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        _leftRepairlDetailArray = [NSMutableArray arrayWithArray:dataSource];
        [mainTableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [self.view makeToast:@"获取报修单数据失败" duration:1.5 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
}

#pragma mark - tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }else
    return self.addArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) {
            MRARequestInfoModel *model = _leftRepairlDetailArray[0];
            if (model.imageList.count && model.imageList.count <= 4) {
                return 222 + 7.5  + SCREEN_WIDTH / 5;
            }
            else if(model.imageList.count && model.imageList.count > 4) {
                return 222 + 7.5 + 7.5 + SCREEN_WIDTH / 5 * 2 ;
            }
            else return 222;
        }
        else if(indexPath.section == 1)
        {
            CGFloat x = [UIScreen mainScreen].bounds.size.width;
            if(x == 320)return 250 + _uploadImageViewHeigh;
            else if (x == 375) return 260 + _uploadImageViewHeigh;
            else  return 270 + _uploadImageViewHeigh;
        }
        else return 190.f;
    return 0.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if (indexPath.section == 0) {
                static NSString *idenSection0 = @"MRADetailUpCell";
                MRADetailUpCell *cell = [tableView dequeueReusableCellWithIdentifier:idenSection0];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"MRADetailUpCell" owner:self options:nil].firstObject;
                }
                cell.delegate = self;
                if (_leftRepairlDetailArray.count) {
                    cell.model = _leftRepairlDetailArray[0];
                }
                return cell;
        }
        else if(indexPath.section == 1)
            {
                static NSString *idenSection1 = @"MRSFeedBackCell";
                MRSFeedBackCell *cell = [tableView dequeueReusableCellWithIdentifier:idenSection1];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"MRSFeedBackCell" owner:self options:nil].firstObject;
                }
                cell.errorReasonTextView.delegate = self;
                cell.repairWorkerLabel.text = [_leftRepairlDetailArray[1] workerName];
                cell.model = self.mrsRepairInfoModel;
                
                if (!_bgView.superview) {
                    [cell.contentView addSubview:_bgView];
                }
                
                return cell;
            }
        else if(indexPath.section == 2)
        {
            static NSString *idenSection1 = @"MRSAddDetailCell";
            MRSAddDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:idenSection1];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"MRSAddDetailCell" owner:self options:nil].firstObject;
            }
            cell.delegate = self;
            cell.model = _addArray[indexPath.row];
            return cell;
        }
    
        return [UITableViewCell new];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        return 70.f;
    }
    else return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    _footerView = [[MRSAddFooterView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 70.f)];
    _footerView.delegate = self;
    _footerView.titleLabel.text = [NSString stringWithFormat:@"  配件总金额(元): %@",footerTitleString];
    return _footerView;
}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < imageViews.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,[imageViews objectAtIndex:i]]];
        //设置来源哪一个UIImageView
        [photos addObject:photo];
    }
    brower.photos = photos;
    //3.设置默认显示的图片索引
    brower.currentPhotoIndex = clickTag - 9999;
    
    //4.显示浏览器
    [brower show];
}

#pragma mark - UploadViewInit
// 初始化上传视图
-(void)uploadViewInit
{
    //1、得到默认布局高度（唯一获取高度方法）
    CGFloat height = [ACSelectMediaView defaultViewHeight];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(10, 40, [UIScreen mainScreen].bounds.size.width - 90, height - 20)];
    
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
        [mainTableView reloadData];
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


#pragma mark - SubmitAction
-(void)submitAction:(id)sender
{
    NSLog(@"%@=%@=%@=====%@",self.mrsRepairInfoModel.repairStatus,self.mrsRepairInfoModel.faultkind,self.mrsRepairInfoModel.faultReason,self.addArray);
    
    if (![self submitValidate]) {
        return;
    }
    else
    {
        TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
        [SVProgressHUD showWithStatus:@"正在提交中"];
        
        [helper submitMyServerFeedBackWithResultJson:[self getPostDic] ImageArray:uploadImageArray andStatus:^(BOOL successful, NSMutableArray *dataSource) {
            
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
        }];
    }
}


-(NSMutableDictionary *)getPostDic
{
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    
    [postDic setValue:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERID] forKey:@"workerId"];
    [postDic setValue:self.repairID forKey:@"repairId"];
    [postDic setValue:self.mrsRepairInfoModel.repairStatus forKey:@"repairStatus"];
    [postDic setValue:self.mrsRepairInfoModel.faultkind forKey:@"faultkind"];
    [postDic setValue:self.mrsRepairInfoModel.faultReason forKey:@"faultReason"];
    [postDic setValue:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID] forKey:@"userId"];
    
    NSMutableArray *keyValuesArray = [NSMutableArray array];
    for (MRSAddModel *model in self.addArray) {
        [keyValuesArray addObject:model.mj_keyValues];
    }
    NSMutableDictionary *addDic = [NSMutableDictionary dictionary];
    [addDic setValue:footerTitleString forKey:@"totalCost"];
    [addDic setObject:keyValuesArray.mj_JSONString forKey:@"consumItems"];
    [postDic setValue:addDic.mj_JSONString forKey:@"consumItems"];
    
//    workerId	20160702182427668420778801064131
//    sys_username	gaoyacun
//    repairStatus	2
//    faultReason	安卓测试
//    sys_password	670b14728ad9902aecba32e22fa4f6bd
//    dataSourceName	dataSource1
//    consumItems	{"consumItems":[{"count":"1","name":"苹果手机","price":"6588","subtotal":"6588.00"}],"totalCost":"6588.00"}
//    repairId	20170523165329439703816381903320
//    faultkind	0
//    repairCost
//    sys_auto_authenticate	true
    
    return postDic;
}

-(BOOL)submitValidate
{
    if (self.addArray.count) {
        for (MRSAddModel *model in self.addArray) {
            if ([NSString isBlankString:model.name] || [NSString isBlankString:model.price] || [NSString isBlankString:model.count]) {
                [self.view makeToast:@"存在配件明细项未填写!" duration:1.0 position:CSToastPositionCenter];
                return NO;
            }
        }
    }
    return YES;
}

#pragma mark - MRSAddFooterViewDelegate
-(void)partsItemAdd
{
    MRSAddModel *model  = [MRSAddModel new];
    
    [self.addArray addObject:model];
    [mainTableView setContentOffset:CGPointMake(0, CGFLOAT_MAX)];
    [mainTableView reloadData];
}

#pragma mark - MRSAddDetailCellDelegate
-(void)closeBtnClick:(MRSAddDetailCell *)cell
{
    NSIndexPath *indexPath = [mainTableView indexPathForCell:cell];
    [_addArray removeObjectAtIndex:indexPath.row];
    [self cellTextFieldValueChanged];
    [mainTableView reloadData];
}

//监控添加的Cell_Textfiled的改变,计算金额汇总
-(void)cellTextFieldValueChanged
{
    __block float sumCount = 0;
    
    [self.addArray enumerateObjectsUsingBlock:^(MRSAddModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![NSString isBlankString:obj.subtotal]) {
            sumCount += [obj.subtotal floatValue];
        }
    }];
    _footerView.titleLabel.text = [NSString stringWithFormat:@"  配件总金额(元): %.2f",sumCount];
    footerTitleString = [NSString stringWithFormat:@"%.2f",sumCount];
}


#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(ETTextView *)textView
{
    self.mrsRepairInfoModel.faultReason = textView.text;
}


#pragma mark -Other
-(void)viewWillAppear:(BOOL)animated
{
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    footerTitleString = [NSString stringWithFormat:@"%.2f",0.00];
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
