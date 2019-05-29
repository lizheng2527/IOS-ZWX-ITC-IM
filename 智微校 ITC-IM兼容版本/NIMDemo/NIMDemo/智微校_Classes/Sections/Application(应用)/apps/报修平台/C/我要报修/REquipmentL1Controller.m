//
//  REquipmentL1Controller.m
//  NIM
//
//  Created by 中电和讯 on 17/3/13.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "REquipmentL1Controller.h"
#import "UIView+SDAutoLayout.h"
#import <Reachability.h>
#import "TYHRepairDefine.h"
#import "TYHRepairMainHeaderView.h"
#import "UIButton+Extention.h"
#import "REquipmentTypeL1Cell.h"

#import "TYHNewRepairController.h"
#import "TYHRepairMainModel.h"
#import "TYHRepairNetRequestHelper.h"
#import "REquipmentL2Controller.h"
#import "LYEmptyViewHeader.h"

@interface REquipmentL1Controller ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * collectionView;
@property(nonatomic,retain)NSMutableArray *itemArray;

@end

@implementation REquipmentL1Controller

#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设备分类";
    
    [self setUpCollectionView];
    [self createBarItem];
    [self getNewData];
}



#pragma mark - initData
- (void)getNewData {
    [SVProgressHUD showWithStatus:@"获取设备列表中"];
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    
    [helper getRepairEquipmentTypeLvOneListWithID:_groupID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
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
    
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, 50);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5; //调节Cell间距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 20, 0);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = NO;
    collectionView.backgroundColor = [UIColor RepairBGColor];
    
    [collectionView registerNib:[UINib nibWithNibName:@"REquipmentTypeL1Cell" bundle:nil] forCellWithReuseIdentifier:@"REquipmentTypeL1Cell"];
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
    
}


#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    REquipmentTypeL1Cell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"REquipmentTypeL1Cell" forIndexPath:indexPath];
    cell.model = _itemArray[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    repairEquipmentTypeModel *model = _itemArray[indexPath.row];
    REquipmentL2Controller *L2View = [REquipmentL2Controller new];
    L2View.equipmentTypeID = model.itemID;
    L2View.groupID = self.groupID;
    L2View.typeName = [NSString stringWithFormat:@"%@ - [%@]",model.name,_typeName];
    [self.navigationController pushViewController:L2View animated:YES];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 40, 50);
    return itemSize;
}


// collectionView header 的高度设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(0, 20);
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
