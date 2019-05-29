//
//  QCSchoolMainController.m
//  NIM
//
//  Created by 中电和讯 on 2018/3/30.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "QCSchoolMainController.h"
#import "QCSchoolDefine.h"
#import "QCSchoolCommonItemCell.h"
#import "QCSchoolMainItemCell.h"
#import "QCSchoolCommonHeaderView.h"
#import "QCSSourceHandler.h"
#import "SDCycleScrollView.h"
#import "QCSNetHelper.h"

#import "qcsStudyAnalyticsMainController.h"
#import "qcsStudyAnalyticStudentController.h"

#import "NSString+NTES.h"
#import "UIView+SDAutoLayout.h"

#import "qcsClassReviewMainController.h"
#import "qcsClassReviewInsideStudentController.h"

#import "qcsHomeworkMainController.h"
//#import "qcsHWTeacherController.h"


#import "QCSStudyAnalyticsModel.h"

@interface QCSchoolMainController ()<UICollectionViewDelegate,UICollectionViewDataSource,SDCycleScrollViewDelegate>

@property(nonatomic,retain)NSMutableArray *bigDataArray;

@end

@implementation QCSchoolMainController
{
    QCSMainModel *mainModel;
    
    QCSStudyAnalyticsModel *mainAnalyticModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"青蚕学堂";
    
    [self setUpCircleImageViews];
    [self setUpCollectionView];
    
    [self getConfigData];
    
}


-(void)getConfigData
{
    mainModel = [QCSMainModel new];
    mainAnalyticModel = [QCSStudyAnalyticsModel new];
    
    [SVProgressHUD setContainerView:self.view];
//    [SVProgressHUD showWithStatus:@"获取数据中"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    QCSNetHelper *helper = [[QCSNetHelper alloc]init];
    [helper getQCSchoolBaseInfoWithType:@"" andStatus:^(BOOL successful, QCSMainModel *Model) {
        mainModel = Model;
        [_mainCollectionView reloadData];
        [SVProgressHUD dismiss];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }    failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    self.bigDataArray = [NSMutableArray array];
    [helper getStudyAnalyticsQueryData:^(BOOL successful, QCSStudyAnalyticsModel *tempMainAnalyticModel) {
//        self.bigDataArray = [NSMutableArray arrayWithArray:mainAnalyticModel.shcoolDataModelArray];
        
        mainAnalyticModel = tempMainAnalyticModel;

        [SVProgressHUD dismiss];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        [self.view makeToast:@"获取统计数据失败" duration:1.5 position:CSToastPositionCenter];
    }];
    
}

-(void)setUpCircleImageViews
{
    
//    NSArray *titles = @[@"1111 ",@"222",@"333",@"444",];
    
//    "2";  //教师
//     "0"; //学生
//     "1"; //家长
    
    // 情景一：采用本地图片实现
    NSString *kindImageName;
    if ([[[NSUserDefaults standardUserDefaults]valueForKey: USER_DEFAULT_KIND] isEqualToString:@"2"]) {
        kindImageName = @"icon_pics_teacher";
    }
    else if([[[NSUserDefaults standardUserDefaults]valueForKey: USER_DEFAULT_KIND] isEqualToString:@"0"])
    {
        kindImageName = @"icon_pics_student";
    }
    else if([[[NSUserDefaults standardUserDefaults]valueForKey: USER_DEFAULT_KIND] isEqualToString:@"1"])
    {
        kindImageName = @"icon_pics_parent";
    }
    else
    {
        kindImageName = @"icon_pics_teacher";
    }
    NSArray *imageNames = @[kindImageName,];
                            // 本地图片请填写全名

    
//    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 275) delegate:self placeholderImage:[UIImage imageNamed:@"qc_icon_pics"]];
    
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 210) shouldInfiniteLoop:YES imageNamesGroup:imageNames];
    
//    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//    cycleScrollView2.titlesGroup = titles;
//    cycleScrollView2.currentPageDotColor = [UIColor orangeColor]; // 自定义分页控件小圆标颜色
    [self.view addSubview:cycleScrollView2];
    
    //         --- 模拟加载延迟
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        cycleScrollView2.image = imagesURLStrings;
//    });
    
}

- (void)setUpCollectionView {
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5; //调节Cell间距
    
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 210, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 210) collectionViewLayout:flowLayout];
    
    _mainCollectionView.dataSource = self;
    _mainCollectionView.delegate = self;
    _mainCollectionView.bounces = NO;
    _mainCollectionView.showsVerticalScrollIndicator = NO;
    
    
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"QCSchoolCommonItemCell" bundle:nil] forCellWithReuseIdentifier:@"QCSchoolCommonItemCell"];
    [_mainCollectionView registerNib:[UINib nibWithNibName:@"QCSchoolMainItemCell" bundle:nil] forCellWithReuseIdentifier:@"QCSchoolMainItemCell"];
    
    // 注册headView
    [self.mainCollectionView registerClass:[QCSchoolCommonHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QCSchoolCommonHeaderView"];
    
    _mainCollectionView.backgroundColor = [UIColor QCSBackgroundColor];
    [self.view addSubview:_mainCollectionView];
}


#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        NSString *userType = mainModel.isStudentOrParent?@"student":@"teacher";
        
        return [QCSSourceHandler getMainItemSourceWithUserKind:userType].count;
    }
    else return 3;
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        QCSchoolMainItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QCSchoolMainItemCell" forIndexPath:indexPath];
        
        NSString *userType = mainModel.isStudentOrParent?@"student":@"teacher";
        
        cell.model = [[QCSSourceHandler getMainItemSourceWithUserKind:userType] objectAtIndex:indexPath.row];
        return cell;
    }
    else
    {
        QCSchoolCommonItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QCSchoolCommonItemCell" forIndexPath:indexPath];
        cell.model = [[QCSSourceHandler getCommonItemSource ] objectAtIndex:indexPath.row];
        return cell;
    }
    
    return [UICollectionViewCell new];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    QCSNetHelper *helper = [[QCSNetHelper alloc]init];
    
    if (indexPath.section == 0) {
        if (mainModel.isStudentOrParent) {
        //课后回顾 - 学生或家长
            if (indexPath.item == 0 ) {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [helper getQCSchoolBaseInfoWithType:@"" andStatus:^(BOOL successful, QCSMainModel *Model) {
                    
                    __block NSString *courseIDString = @"";
                    [Model.stuCoursesModelArray enumerateObjectsUsingBlock:^(QCSMainChildrenCourseModel   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if (idx == 0) {
                            courseIDString = obj.id;
                        }
                    }];
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    qcsClassReviewInsideStudentController  *qcView = [qcsClassReviewInsideStudentController new];
                    qcView.eclassID = Model.eclassId;
                    qcView.tempCourseID = courseIDString;
                    qcView.studentCourseArray = [NSMutableArray arrayWithArray:Model.stuCoursesModelArray];
                    qcView.studentId = Model.studentId;
                    [self.navigationController pushViewController:qcView animated:YES];
                    
                } failure:^(NSError *error) {
                }];
                
        }
         //学情分析 - 学生或家长
        else if(indexPath.row == 3)
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [helper getQCSchoolBaseInfoWithType:@"" andStatus:^(BOOL successful, QCSMainModel *Model) {
                qcsStudyAnalyticStudentController *studentView = [qcsStudyAnalyticStudentController new];
                studentView.eclassID = Model.eclassId;
                studentView.studentID = Model.studentId;
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [self.navigationController pushViewController:studentView animated:YES];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
        }
             //课后作业 - 学生家长
        else if(indexPath.row == 2)
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            qcsHomeworkMainController *homeView = [qcsHomeworkMainController new];
            [self.navigationController pushViewController:homeView animated:YES];
        }
        else
        {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.view makeToast:@"开发中" duration:1.5 position:CSToastPositionCenter];
            return;
        }
    }
    else
    {
        //课后回顾 - 教师
        if (indexPath.row == 1) {
            if (mainModel.ws_classroomreview) {
                if ([[[NSUserDefaults standardUserDefaults]valueForKey: USER_DEFAULT_KIND] isEqualToString:@"0"]) {
                    
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    
                    [helper getQCSchoolBaseInfoWithType:@"" andStatus:^(BOOL successful, QCSMainModel *Model) {
                        qcsClassReviewMainController *classReviewController = [qcsClassReviewMainController new];
                        classReviewController.defaultIndex = 0;
                        classReviewController.eclassID = Model.tempEclassID;
                        classReviewController.tempCourseID = Model.tempCourseID;
                        
                        classReviewController.studentCourseArray = [NSMutableArray arrayWithArray:Model.resultGradeModelArray];
                        
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        
                        [self.navigationController pushViewController:classReviewController animated:YES];
                    } failure:^(NSError *error) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                    }];
                    
                }
            }
            else
            {
                [self.view makeToast:@"暂无权限" duration:1.5 position:CSToastPositionCenter];
                return;
            }
            //学情分析 - 教师
        }
        
        else if(indexPath.row == 2)
        {
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            [helper getQCSchoolBaseInfoWithType:@"" andStatus:^(BOOL successful, QCSMainModel *Model) {
                qcsHomeworkMainController *homeView = [qcsHomeworkMainController new];
                homeView.studentCourseArray = [NSMutableArray arrayWithArray:Model.resultGradeModelArray];
                homeView.view.backgroundColor = [UIColor whiteColor];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController pushViewController:homeView animated:YES];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
            
            
        }
        else if(indexPath.row == 4)
        {
            
            if(mainModel.ws_classanalysis)
            {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                
                [helper getQCSchoolBaseInfoWithType:@"" andStatus:^(BOOL successful, QCSMainModel *Model) {
                    qcsStudyAnalyticsMainController *studyView = [qcsStudyAnalyticsMainController new];
                    studyView.eclassID = Model.tempEclassID;
                    
                    __block NSMutableString *eclassIDs = [NSMutableString string];
                    if (Model.resultGradeModelArray.count && [Model.resultGradeModelArray[0] childrenEclassModelArray].count) {
                        [[Model.resultGradeModelArray[0] childrenEclassModelArray] enumerateObjectsUsingBlock:^(QCSMainChildrenEclassModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (idx < 16) {
                                [eclassIDs appendFormat:@"%@,",obj.id];
                            }
                        }];
                    }
                    studyView.tempCourseID = [NSString removeLastOneChar:eclassIDs];
                    
                    studyView.gradeArray = [NSMutableArray arrayWithArray:Model.resultGradeModelArray];
                    
                    studyView.bigDataArray = [NSMutableArray arrayWithArray:mainAnalyticModel.shcoolDataModelArray];
                    studyView.mainModel = mainAnalyticModel;
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    [self.navigationController pushViewController:studyView animated:YES];
                } failure:^(NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                }];
                
                
                
            }
            else
            {
                [self.view makeToast:@"暂无权限" duration:1.5 position:CSToastPositionCenter];
                return;
            }
        }
        else
        {
            [self.view makeToast:@"开发中" duration:1.5 position:CSToastPositionCenter];
            return;
        }
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        QCSchoolCommonHeaderView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QCSchoolCommonHeaderView" forIndexPath:indexPath];
        header.titleOfLabel.text = @"";
        header.imgaeView.hidden = YES;
        return header;
    }
    else
    {
        QCSchoolCommonHeaderView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"QCSchoolCommonHeaderView" forIndexPath:indexPath];
        header.titleOfLabel.text = @"常用应用";
        header.backgroundColor = [UIColor whiteColor];
        return header;
    }
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGSize itemSize;
        NSInteger num = mainModel.isStudentOrParent ? 2 : 3;
        if (kDevice_Is_iPhoneX) {
            itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2 - 10, (SCREEN_HEIGHT -60 - 28 -64 - 210- 14 - 10 - 34) / num);
        }
        else
        {
            itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/2 - 10, (SCREEN_HEIGHT -60 - 28 -64 - 210- 14 - 10) / num);
        }
        return itemSize;
    }
    else
    {
        CGSize itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width/3, 60);
        return itemSize;
    }
    
}


// collectionView header 的高度设置
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(0, 0.01);
    }else
    return CGSizeMake(0, 28);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(7,7,7,7);
    }else return UIEdgeInsetsMake(0,0,0,0);
}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor QCSThemeColor]];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    UIImageView  *_lineView = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
    _lineView.hidden = YES;
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    
    return nil;
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

