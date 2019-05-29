//
//  qcsStudyAnalyticsSearcuClassController.m
//  NIM
//
//  Created by 中电和讯 on 2018/5/2.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsStudyAnalyticsSearcuClassController.h"

#import "ValuePickerView.h"
#import "QCSMainModel.h"
#import "GYZCustomCalendarPickerView.h"
#import "QCSchoolDefine.h"


#import "qcsClassReviewInsideStudentController.h"
#import "NSString+NTES.h"
#import "qcsClassReviewSearchCell.h"
#import "QCSNetHelper.h"

#import "qcsStudyAnalyticsMainController.h"


@interface qcsStudyAnalyticsSearcuClassController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)NSMutableArray *itemArray;

@property(nonatomic,retain)ValuePickerView *pickerView;

@property(nonatomic,copy)NSString *chooseGradeID;
@property(nonatomic,copy)NSString *chooseClassID;


@end

@implementation qcsStudyAnalyticsSearcuClassController
{
    NSInteger idxGrade;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"学生查询";
    // Do any additional setup after loading the view from its nib.
    
    [self initPickview];
    
    [self setUpCollectionView];
    
    [self getNewData];
}

-(void)initPickview
{
    _pickerView = [[ValuePickerView alloc]init];
    self.pickerView.pickerTitle = @"选择项";
    self.pickerView.appType = @"青蚕学堂";
    
    if (self.gradeArray.count) {
        QCSMainResultGradeModel *model = self.gradeArray[0];
        self.chooseGradeID = model.id;
        [self.chooseGradeButton setTitle:model.name forState:UIControlStateNormal];
        
        [self getClassListWithIndex:0];
    }
}


- (IBAction)chooseGradeAction:(id)sender {
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (QCSMainResultGradeModel *model in self.gradeArray) {
        [array addObject:model.name];
    }
    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        
        idxGrade = index;
        
        if (weakSelf.gradeArray.count) {
            QCSMainResultGradeModel *model = weakSelf.gradeArray[index];
            weakSelf.chooseGradeID = model.id;
        }
        [weakSelf.chooseGradeButton setTitle:stateArr[0] forState:UIControlStateNormal];
        
        [weakSelf getClassListWithIndex:index];
    };
    
    [self.pickerView show];
    
}



- (IBAction)searchAction:(id)sender {
    
    __block NSMutableString *selectString = [NSMutableString string];
    
    
    [_itemArray enumerateObjectsUsingBlock:^(QCSMainChildrenEclassModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.Selected) {
            [selectString appendFormat:@"%@,",obj.id];
        }
    }];
    if ([NSString isBlankString:selectString]) {
         [self.view makeToast:@"请选择班级" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    else
    {
        
        self.chooseClassID = [NSString removeLastOneChar:selectString];
        
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[qcsStudyAnalyticsMainController class]]) {
                qcsStudyAnalyticsMainController *tempController = (qcsStudyAnalyticsMainController *)controller;
                
                tempController.chooseEclassID = self.chooseClassID;
                
                NSDictionary *dic = @{@"chooseEclassID":self.chooseClassID};
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"AnalysticShouldRefrshClass" object:nil userInfo:[NSDictionary dictionaryWithDictionary:dic]];
                
                [self.navigationController popToViewController:tempController animated:YES];
            }
        }
        
    }
    
}



-(void)getClassListWithIndex:(NSInteger )index
{
    _itemArray = [NSMutableArray array];
    QCSMainResultGradeModel *model = self.gradeArray[index];
    [model.childrenEclassModelArray enumerateObjectsUsingBlock:^(QCSMainChildrenEclassModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.Selected = NO;
        [_itemArray addObject:obj];
    }];
    [_mainCollectionView reloadData];
    
}



#pragma mark - initData
- (void)getNewData {
    //    _itemArray = [NSMutableArray arrayWithArray:_dataSource];
    [_mainCollectionView reloadData];
}

#pragma mark - initView

- (void)setUpCollectionView {
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
                                                                 titleStr:@"暂无学生列表"
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
    
    QCSMainChildrenEclassModel *model = _itemArray[indexPath.item];
    if (model.Selected) {
        cell.nameLabel.backgroundColor = [UIColor QCSThemeColor];
        cell.nameLabel.textColor = [UIColor whiteColor];
    }
    else
    {
        cell.nameLabel.backgroundColor = [UIColor groupTableViewBackgroundColor];
        cell.nameLabel.textColor = [UIColor grayColor];
    }
    cell.nameLabel.text = model.name;
    
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    qcsClassReviewSearchCell *cell = (qcsClassReviewSearchCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    __block NSInteger num = 0;
    [_itemArray enumerateObjectsUsingBlock:^(QCSMainChildrenEclassModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.Selected) {
            num ++;
        }
    }];
    
    if (num < 16) {
        QCSMainChildrenEclassModel *model = _itemArray[indexPath.row];
        model.Selected = !model.Selected;
        [_mainCollectionView reloadData];
    }else
    {
        [self.view makeToast:@"您最多可以选择16个班级" duration:1.5 position:CSToastPositionCenter];
    }
    
    
}

#pragma mark - CollectionView Layout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize itemSize = CGSizeMake(75, 25);
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
