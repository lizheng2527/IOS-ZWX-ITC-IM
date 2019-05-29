//
//  qcsClassDetailInsideXZTDetailController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassDetailInsideXZTDetailController.h"

#import "QCSchoolDefine.h"

#import "qcsClassDetailInsideXZTDetailCell.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "QCSNetHelper.h"
#import "QCSClassDetailModel.h"

@interface qcsClassDetailInsideXZTDetailController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * collectionView;
@property(nonatomic,retain)NSMutableArray *itemArray;

@end

@implementation qcsClassDetailInsideXZTDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"答题详情";
    
    [self setUpCollectionView];
    
    [self getNewData];
}



#pragma mark - initData
- (void)getNewData {
    _itemArray = [NSMutableArray arrayWithArray:_dataSource];
    [self.collectionView reloadData];
}

#pragma mark - initView

- (void)setUpCollectionView {
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width / 2 - 20, 120);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5; //调节Cell间距
    flowLayout.sectionInset = UIEdgeInsetsMake(7,7,7,7);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(8, 8, SCREEN_WIDTH - 16, SCREEN_HEIGHT - 64 - 8) collectionViewLayout:flowLayout];
    collectionView.backgroundColor = [UIColor QCSBackgroundColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.bounces = NO;
    
    [collectionView registerNib:[UINib nibWithNibName:@"qcsClassDetailInsideXZTDetailCell" bundle:nil] forCellWithReuseIdentifier:@"qcsClassDetailInsideXZTDetailCell"];
    
    // 注册headView
    self.collectionView = collectionView;
    _collectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                             titleStr:@"暂无数据"
                                                            detailStr:@""];
    [self.view addSubview:collectionView];
    
}


#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    qcsClassDetailInsideXZTDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qcsClassDetailInsideXZTDetailCell" forIndexPath:indexPath];
    if (_itemArray.count) {
        cell.model = _itemArray[indexPath.row];
    }
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - CollectionView Layout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(SCREEN_WIDTH - 16, 70);
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
