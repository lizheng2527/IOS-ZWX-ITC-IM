//
//  qcsHomeworkChooseTypeController.m
//  NIM
//
//  Created by 中电和讯 on 2018/5/15.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsHomeworkChooseTypeController.h"
#import "QCSchoolDefine.h"
#import "qcsClassReviewSearchCell.h"
#import "QCSMainModel.h"
#import "NSString+NTES.h"

#import "qcsHomeworkReleaseController.h"

@interface qcsHomeworkChooseTypeController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)NSMutableArray *itemArray;

@property(nonatomic,copy)NSString *chooseTypeString;

@end

@implementation qcsHomeworkChooseTypeController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择类型";
    
    // Do any additional setup after loading the view from its nib.
    [self createBarItem];
    [self setUpCollectionView];
}


- (void)setUpCollectionView {
    _itemArray = [NSMutableArray arrayWithArray:[QCSSourceHandler getHomeworkChooseTypeArray]];
    
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 6; //调节Cell间距
    flowLayout.sectionInset = UIEdgeInsetsMake(1,1,1,1);
    
    _mainCollectionView.collectionViewLayout = flowLayout;
    
    _mainCollectionView.backgroundColor = [UIColor clearColor];
    _mainCollectionView.dataSource = self;
    _mainCollectionView.delegate = self;
    _mainCollectionView.bounces = NO;
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"qcsClassReviewSearchCell" bundle:nil] forCellWithReuseIdentifier:@"qcsClassReviewSearchCell"];
    
    // 注册headView
    
    _mainCollectionView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                                 titleStr:@"暂无列表"
                                                                detailStr:@""];
}


#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    qcsClassReviewSearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"qcsClassReviewSearchCell" forIndexPath:indexPath];
    
    QCSSourceModel *model = _itemArray[indexPath.row];
    cell.nameLabel.text = model.itemTitle;
    
    if (model.isExpand) {
        cell.nameLabel.backgroundColor = [UIColor QCSThemeColor];
        cell.nameLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.nameLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.nameLabel.textColor = [UIColor grayColor];
    }
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    __weak typeof(self) weakSelf = self;

    
    QCSSourceModel *model = _itemArray[indexPath.row];
    
    if ([model.itemTitle isEqualToString:@"其他"]) {
        model.isExpand = !model.isExpand;
        [_itemArray enumerateObjectsUsingBlock:^(QCSSourceModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx <= 5 ) {
                obj.isExpand = NO;
            }
        }];
    }
    else
    {
        model.isExpand = !model.isExpand;
        [_itemArray enumerateObjectsUsingBlock:^(QCSSourceModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.itemTitle isEqualToString:@"其他"]) {
                obj.isExpand = NO;
            }
        }];
    }
    
    [self.mainCollectionView reloadData];
    
}

#pragma mark - CollectionView Layout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(75, 25);
    return itemSize;
    
}


#pragma mark - Submit

-(void)diliverAction:(id)sender
{
    
    NSMutableString *chooseStringID = [NSMutableString string];
    NSMutableString *chooseStringName = [NSMutableString string];
    [_itemArray enumerateObjectsUsingBlock:^(QCSSourceModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isExpand) {
            [chooseStringName appendFormat:@"%@ ",obj.itemTitle];
            [chooseStringID appendFormat:@"%@,",obj.typeNum];
        }
    }];
    
    if ([NSString isBlankString:chooseStringID]) {
        [self.view makeToast:@"还没有选择作业类型" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    else
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[qcsHomeworkReleaseController class]]) {
                qcsHomeworkReleaseController *releaseView = (qcsHomeworkReleaseController *)controller;
                [releaseView.chooseTypeButton setTitle:chooseStringName.length?chooseStringName:@"请选择" forState:UIControlStateNormal];
                releaseView.chooseTypeID = chooseStringID;
                releaseView.chooseTypeName = chooseStringName;
                [self.navigationController popToViewController:releaseView animated:YES];
                
            }
        }
    }
}


#pragma mark - ViewConfig
-(void)createBarItem
{
    UIBarButtonItem *
    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    //设置字体为加粗的12号系统字，自己也可以随便设置。
    [barItemInNavigationBarAppearanceProxy
     setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem * rightItem = nil;
    
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self
                                               action:@selector(diliverAction:)];
    self.navigationItem.rightBarButtonItem =rightItem;
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
