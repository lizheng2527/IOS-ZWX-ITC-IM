//
//  TYHNewRepairController.m
//  NIM
//
//  Created by 中电和讯 on 17/3/9.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "TYHNewRepairController.h"
#import "UIView+SDAutoLayout.h"
#import <Reachability.h>
#import "TYHRepairDefine.h"
#import "TYHRepairMainHeaderView.h"
#import "UIButton+Extention.h"
#import "REquipmentTypeCollectionCell.h"

#import "TYHNewRepairController.h"
#import "TYHRepairMainModel.h"
#import "TYHRepairNetRequestHelper.h"

#import "REquipmentL1Controller.h"

#import "SGQRCode.h"
#import <AVFoundation/AVFoundation.h>
#import "RRequipmentScanController.h"
#import "LYEmptyViewHeader.h"

@interface TYHNewRepairController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * collectionView;
@property(nonatomic,retain)NSMutableArray *itemArray;

@end

@implementation TYHNewRepairController


#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"维修组";
    
    [self setUpCollectionView];
    [self createBarItem];
    [self getNewData];
}



#pragma mark - initData
- (void)getNewData {
    [SVProgressHUD showWithStatus:@"获取设备列表中"];
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    [helper getRepairEquipmentTeamList:^(BOOL successful, NSMutableArray *dataSource) {
        _itemArray = [NSMutableArray arrayWithArray:dataSource];
        [self shouldCreateNoData:dataSource];
        [_collectionView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"获取设备列表失败" duration:1.5 position:CSToastPositionCenter];
    }];
}


#pragma mark - initView

- (void)setUpCollectionView {
    self.view.backgroundColor = [UIColor RepairBGColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake(240, 80);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 20; //调节Cell间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = NO;
    
    
    [collectionView registerNib:[UINib nibWithNibName:@"REquipmentTypeCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"REquipmentTypeCollectionCell"];
    // 注册headView
 
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    self.collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:nil titleStr:@"暂无数据" detailStr:nil];

}

-(void)shouldCreateNoData:(NSMutableArray *)array
{
    
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
    
//    UIBarButtonItem * rightItem = nil;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_scan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(scanAction:)];
//    } else {
//        rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_scan"] style:UIBarButtonItemStyleDone target:self action:@selector(scanAction:)];
//    }
//    self.navigationItem.rightBarButtonItem =rightItem;
    
}

-(void)scanAction:(id)sender
{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //2处,下面还有
//                        RRequipmentScanController *vc = [[RRequipmentScanController alloc] init];
//                        [self.navigationController pushViewController:vc animated:YES];
                        
                        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"该功能暂未开通" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                        }];
                        [alertC addAction:alertA];
                        [self presentViewController:alertC animated:YES completion:nil];
                        
                    });
                    
                    SGQRCodeLog(@"当前线程 - - %@", [NSThread currentThread]);
                    // 用户第一次同意了访问相机权限
                    SGQRCodeLog(@"用户第一次同意了访问相机权限");
                    
                } else {
                    
                    // 用户第一次拒绝了访问相机权限
                    SGQRCodeLog(@"用户第一次拒绝了访问相机权限");
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            //2处
//            RRequipmentScanController *vc = [[RRequipmentScanController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"该功能暂未开通" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            }];
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}


#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    REquipmentTypeCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"REquipmentTypeCollectionCell" forIndexPath:indexPath];
    cell.model = _itemArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    repairEquipmentTypeModel *model = _itemArray[indexPath.row];
    REquipmentL1Controller *L1View = [REquipmentL1Controller new];
    L1View.groupID = model.itemID;
    L1View.typeName = model.name;
    [self.navigationController pushViewController:L1View animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(240, 80);
    return itemSize;
}


// collectionView header 的高度设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 60);
}

#pragma mark - Action
-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Other
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorRepair]];
    //    [self getNewData];
    [self.view endEditing:YES];
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
