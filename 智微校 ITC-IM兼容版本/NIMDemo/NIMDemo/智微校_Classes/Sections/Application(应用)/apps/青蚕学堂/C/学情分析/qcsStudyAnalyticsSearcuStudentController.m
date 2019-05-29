//
//  qcsStudyAnalyticsSearcuStudentController.m
//  NIM
//
//  Created by 中电和讯 on 2018/5/2.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsStudyAnalyticsSearcuStudentController.h"

#import "ValuePickerView.h"
#import "QCSMainModel.h"
#import "GYZCustomCalendarPickerView.h"
#import "QCSchoolDefine.h"


#import "qcsClassReviewInsideStudentController.h"
#import "NSString+NTES.h"
#import "qcsClassReviewSearchCell.h"
#import "QCSNetHelper.h"

#import "qcsStudyAnalyticsMainController.h"


@interface qcsStudyAnalyticsSearcuStudentController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property(nonatomic,retain)NSMutableArray *itemArray;

@property(nonatomic,retain)ValuePickerView *pickerView;

@property(nonatomic,copy)NSString *chooseGradeID;
@property(nonatomic,copy)NSString *chooseClassID;

@property(nonatomic,copy)NSString *chooseStudentID;
@property(nonatomic,copy)NSString *chooseStudentName;

@end

@implementation qcsStudyAnalyticsSearcuStudentController
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
        
        if (model.childrenEclassModelArray.count) {
            QCSMainChildrenEclassModel *eclassModel =  model.childrenEclassModelArray[0];
            [self.chooseClassButton setTitle:eclassModel.name forState:UIControlStateNormal];
            self.chooseClassID = eclassModel.id;
            
            [self getUserListWithId:self.chooseClassID];
        }
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
        
        
        QCSMainChildrenEclassModel *eclassModel =  [weakSelf.gradeArray[index] childrenEclassModelArray][0];
        [weakSelf.chooseClassButton setTitle:eclassModel.name forState:UIControlStateNormal];
        weakSelf.chooseClassID = eclassModel.id;
        
        [weakSelf getUserListWithId:weakSelf.chooseClassID];
    };
    
    [self.pickerView show];
    
}


- (IBAction)chooseClassAction:(id)sender {
    
    QCSMainResultGradeModel *resultModel = self.gradeArray[idxGrade];
    
    
    NSMutableArray *array = [NSMutableArray array];
    for (QCSMainChildrenEclassModel *model in resultModel.childrenEclassModelArray) {
        [array addObject:model.name];
    }
    self.pickerView.dataSource = array;
    __weak typeof(self) weakSelf = self;
    
    self.pickerView.valueDidSelect = ^(NSString *value){
        NSArray * stateArr = [value componentsSeparatedByString:@"/"];
        NSInteger index = [stateArr[1] integerValue] - 1;
        
        QCSMainChildrenEclassModel *classModel = resultModel.childrenEclassModelArray[index];
        
        [weakSelf.chooseClassButton setTitle:stateArr[0] forState:UIControlStateNormal];
        weakSelf.chooseClassID = classModel.id;
        
        [weakSelf getUserListWithId:weakSelf.chooseClassID];
    };
    
    [self.pickerView show];
    
    
}



- (IBAction)searchAction:(id)sender {
    
    if ([NSString isBlankString:self.chooseClassID]) {
        [self.view makeToast:@"请选择课程" duration:1.5 position:CSToastPositionCenter];
        return;
    }else if([NSString isBlankString:self.chooseStudentID])
    {
        [self.view makeToast:@"请选择学生" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    else
    {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[qcsStudyAnalyticsMainController class]]) {
                qcsStudyAnalyticsMainController *tempController = (qcsStudyAnalyticsMainController *)controller;
                
                tempController.chooseEclassID = self.chooseClassID;
                tempController.chooseStudentName = [ self.chooseStudentName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                tempController.chooseStudentID = self.chooseStudentID;
                
                NSDictionary *dic = @{@"chooseEclassID":self.chooseClassID,@"chooseStudentName":[ self.chooseStudentName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"chooseStudentID":self.chooseStudentID};
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"AnalysticShouldRefrshStudent" object:nil userInfo:[NSDictionary dictionaryWithDictionary:dic]];
                
                [self.navigationController popToViewController:tempController animated:YES];
            }
        }
        
    }

}



-(void)getUserListWithId:(NSString *)id
{
    
    QCSNetHelper *helper = [QCSNetHelper new];
    [helper getUserModelArrayWithEclassId:self.chooseClassID status:^(NSMutableArray *dataSource) {
        _itemArray = [NSMutableArray arrayWithArray:dataSource];
        [_mainCollectionView reloadData];
    }];
    
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
    
    QCSMainUserModel *model = _itemArray[indexPath.item];
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
    
    __weak typeof(self) weakSelf = self;
    
    [_itemArray enumerateObjectsUsingBlock:^(QCSMainUserModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (indexPath.item == idx) {
            obj.Selected = YES;
            self.chooseStudentName = obj.name;
            self.chooseStudentID = obj.id;
        }else obj.Selected = NO;
    }];
    [_mainCollectionView reloadData];
    
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
