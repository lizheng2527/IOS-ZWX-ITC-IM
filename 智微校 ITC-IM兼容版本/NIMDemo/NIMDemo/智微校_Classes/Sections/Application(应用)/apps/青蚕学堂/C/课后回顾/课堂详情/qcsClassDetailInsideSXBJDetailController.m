//
//  qcsClassDetailInsideSXBJDetailCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassDetailInsideSXBJDetailController.h"
#import "QCSchoolDefine.h"

#import "qcsClassDetailInsideSXBJCell.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "QCSNetHelper.h"
#import "QCSClassDetailModel.h"

@interface qcsClassDetailInsideSXBJDetailController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView * collectionView;
@property(nonatomic,retain)NSMutableArray *itemArray;

@end

@implementation qcsClassDetailInsideSXBJDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"课堂详情";
    
    [self setUpCollectionView];
    
    [self getNewData];
}



#pragma mark - initData
- (void)getNewData {
    
    
    _itemArray = [NSMutableArray array];
    
    QCSNetHelper *helper = [QCSNetHelper new];
    [helper getClassDetailSXBJDetailListWithInteractionIdID:self.inID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        
        _itemArray = dataSource;
        
        [SVProgressHUD dismiss];
        [_collectionView reloadData];
        
    } failure:^(NSError *error) {
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
        
    }];
    
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
    
    [collectionView registerNib:[UINib nibWithNibName:@"qcsClassDetailInsideSXBJCell" bundle:nil] forCellWithReuseIdentifier:@"qcsClassDetailInsideSXBJCell"];
    
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
    
            qcsClassDetailInsideSXBJCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qcsClassDetailInsideSXBJCell" forIndexPath:indexPath];
            if (_itemArray.count) {
                cell.insideModel = _itemArray[indexPath.row];
            }
            return cell;
   
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 
            QCSClassDetailBSJLModel *model = _itemArray[indexPath.row];
            
            MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
            NSMutableArray *photos = [NSMutableArray array];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],model.downloadUrl]] ;
            [photos addObject:photo];
            brower.photos = photos;
            brower.currentPhotoIndex = 0;
            [brower show];
   
}

#pragma mark - CollectionView Layout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(SCREEN_WIDTH / 3 - 20, 140);
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
