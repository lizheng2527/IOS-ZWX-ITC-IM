//
//  TYHNewAppController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/13.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHNewAppController.h"
#import "PublicDefine.h"
#import "AppModel.h"
#import "TYHNewAPPViewController.h"
#import <UIButton+WebCache.h>
#import <UIView+Toast.h>
#import "TYHNewNoticeViewController.h"
#import "TYHNoticeController.h"
#import "UIView+Extention.h"
#import "NewAppCell.h"
#import "TYHNewReceptionViewController.h"
#import "HomeWorkViewController.h"
#import "TYHTranscriptViewController.h"
#import "TakeCourseBeignViewController.h"
#import "TYHAttendanceController.h"
#import "TYHAssetViewController.h"
#import "TYHKeYanController.h"
#import "TYHWarehouseManagementController.h"
#import "AppModelArrayHandler.h"
#import "NSString+NTES.h"

#import "TakeCourseBeignViewController.h"
#import "TYHAppHeaderView.h"
#import "TYHRepairMainController.h"

#define LX_LIMITED_MOVEMENT 1
static  NSString * TYHHeaderCell =  @"TYHHeaderCell";

@interface TYHNewAppController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, assign) BOOL isTeacherOrAdmin;
@property (nonatomic, assign) BOOL isNoJiaZhang;
@property (nonatomic, copy) NSString * userId;
@property (nonatomic, copy) NSString * userName;
@property (nonatomic, copy) NSString * password;
@property (nonatomic, retain) UIBarButtonItem *menuItem;

@property (nonatomic, strong) NSMutableArray * appModelArray;

@end

@implementation TYHNewAppController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = @"应用";
    [self initData];
    [self createBannerView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if(width > 370)
    {
        flowLayout.itemSize = CGSizeMake(self.view.width/4, self.view.width/4);
    }
    else
    {
        flowLayout.itemSize = CGSizeMake(self.view.width/3, self.view.width/3);
    }
    
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0 , [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) collectionViewLayout:flowLayout];
    
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = YES;
    
    [collectionView registerNib:[UINib nibWithNibName:@"NewAppCell" bundle:nil] forCellWithReuseIdentifier:@"NewAppCell"];
    // 注册headView
    
    [collectionView registerClass:[TYHAppHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TYHHeaderCell];
    
    collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView = collectionView;
    
    [self.view addSubview:collectionView];
    
}


-(void)createBannerView
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"AppBanner"  ofType:@"jpg"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, self.view.width, 178);
//    [self.view addSubview:imageView];
}

- (void)initData {
    
    _userId = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERID];
    
    _userName = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *V3Pwd = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    if ([NSString isBlankString:V3Pwd]) {
        V3Pwd = @"";
    }
    _password = V3Pwd;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_KIND] isEqualToString:@"1"]  || [[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_KIND] isEqualToString:@"2"]   || [[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_KIND] isEqualToString:@"4"] ) {
        _isTeacherOrAdmin = NO;
    }
    else
    {
        _isTeacherOrAdmin = YES;
    }
    if  ([[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_KIND] isEqualToString:@"2"]   || [[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_KIND] isEqualToString:@"4"] ) {
        _isNoJiaZhang = NO;
    } else {
        _isNoJiaZhang = YES;
    }
    
    AppModelArrayHandler *handler = [AppModelArrayHandler new];
    _appModelArray = [NSMutableArray arrayWithArray:[handler getSectionArray]];
}


#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)theCollectionView numberOfItemsInSection:(NSInteger)theSectionIndex {
    AppMainModel *model = _appModelArray[theSectionIndex];
    return model.sectionModelArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NewAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NewAppCell" forIndexPath:indexPath];
    AppMainModel *mainModel = _appModelArray[indexPath.section];
    AppModel * model = mainModel.sectionModelArray[indexPath.item];
    
    cell.imageView.image = [UIImage imageNamed:model.imageStr];
    cell.labelName.text = model.name;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    AppMainModel *mainModel = _appModelArray[indexPath.section];
    
    AppModel *model = mainModel.sectionModelArray[indexPath.item];
    
    if ([model.name isEqualToString:@"我的通知"]) {
        
        TYHNewNoticeViewController * noticeVc = [[TYHNewNoticeViewController alloc] init];
        noticeVc.userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
        [noticeVc setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:noticeVc animated:YES];
    }
    else if ([model.name isEqualToString:@"资产管理"]) {
        TYHAssetViewController * receptVC = [[TYHAssetViewController alloc] init];
        [receptVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:receptVC animated:YES];
    }
    else if([model.name isEqualToString:@"青蚕学堂"])
    {
        NSURL * myURL_APP_A = [NSURL URLWithString:@"PushXLTWithZWX://"];
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
            [[UIApplication sharedApplication] openURL:myURL_APP_A];
        }
        else
        {
            UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"未安装青蚕学堂,是否前去下载" preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.pgyer.com/xlt-iOS"]];
            }]];
            [self presentViewController: alertController animated: YES completion: nil];
        }
    }
    else if ([model.name isEqualToString:@"订车管理"]) {
        TYHNewReceptionViewController * receptVC = [[TYHNewReceptionViewController alloc] init];
        
        receptVC.userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
        
        [receptVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:receptVC animated:YES];
    }
    else if([model.name isEqualToString:@"成绩单"])
    {
        TYHTranscriptViewController *transcriptView = [[TYHTranscriptViewController alloc]init];
        [transcriptView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:transcriptView animated:YES];
    }
    else if([model.name isEqualToString:@"考勤"])
    {
        TYHAttendanceController *aView = [TYHAttendanceController new];
        [aView setHidesBottomBarWhenPushed:YES];
        aView.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:aView animated:YES];
    }
    else if([model.name isEqualToString:@"学生选课"])
    {
        TakeCourseBeignViewController *aView = [TakeCourseBeignViewController new];
        [aView setHidesBottomBarWhenPushed:YES];
        aView.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:aView animated:YES];
    }
    else if([model.name isEqualToString:@"报修"])
    {
        TYHRepairMainController *repairView = [TYHRepairMainController new];
        [repairView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:repairView animated:YES];
    }
    else if([model.name isEqualToString:@"教科研"])
    {
        TYHKeYanController *keyanView = [TYHKeYanController new];
        [keyanView setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:keyanView animated:YES];
    }
    else if([model.name isEqualToString:@"易耗品管理"])
    {
        TYHWarehouseManagementController * receptVC = [[TYHWarehouseManagementController alloc] init];
        [receptVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:receptVC animated:YES];
    }
    
    
    
    
    
//    else if( [model.name isEqualToString:@"加值班管理"] || [model.name isEqualToString:@"公务接待"] || [model.name isEqualToString:@"新闻"])
//    {
//        TYHTempAppController *transcriptView = [[TYHTempAppController alloc]init];
//        transcriptView.appItemtype = model.name;
//        [transcriptView setHidesBottomBarWhenPushed:YES];
//        [self.navigationController pushViewController:transcriptView animated:YES];
//    }
    else if([model.name isEqualToString:@"作业统计"])
    {
        NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
        dataSourceName = dataSourceName.length?dataSourceName:@"";
        TYHNewAPPViewController * newAppVc = [[TYHNewAPPViewController alloc] init];
        NSString *urlString = [NSString stringWithFormat:@"%@/il/homeWork!mobileWorkStatisticsIndex.action?operationCode=il_statistics&sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,_userName,_password,dataSourceName];
        newAppVc.userId = _userId;
        newAppVc.urlstr = urlString;
        [newAppVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newAppVc animated:YES];
    }
    
    else {
        
        
        TYHNewAPPViewController * newAppVc = [[TYHNewAPPViewController alloc] init];
        newAppVc.userName = _userName;
        newAppVc.password = _password;
        
        NSString * url;  // 9988 im
        if ([model.name isEqualToString:@"校园公告"] || [model.name isEqualToString:@"系统公告"]||[model.name isEqualToString:@"工资"]||[model.name isEqualToString:@"食堂订餐"] || [model.name isEqualToString:@"调查问卷"] || [model.name isEqualToString:@"作业"]) {
            // 2级工资
            NSString * IMURL = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_BASEURL];
            newAppVc.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"LoginID"];
            url = [NSString stringWithFormat:@"%@/%@?",IMURL,model.baseUrl];
        }else {
            newAppVc.userId = _userId;
            url = [NSString stringWithFormat:@"%@/%@?",k_V3ServerURL,model.baseUrl];
        }
        newAppVc.urlstr = url;
        [newAppVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:newAppVc animated:YES];
    }
}

#pragma mark - Header
// collectionView header 的高度设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    TYHAppHeaderView *header = (TYHAppHeaderView *)[collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TYHHeaderCell forIndexPath:indexPath];
    AppMainModel *model = _appModelArray[indexPath.section];
    header.titleLabel.text = model.sectionName;
    return header;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _appModelArray.count;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:0.8];
//    self.navigationController.navigationBar.translucent = NO; //translucent 临时注释
    [[NSNotificationCenter defaultCenter]postNotificationName:NewCommentOrReplyNotifion object:nil];
    [SVProgressHUD dismiss];
}

@end
