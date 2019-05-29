//
//  qcsStudyAnalyticsMainController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/26.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsStudyAnalyticsMainController.h"

#import "qcsClassReviewInsideController.h"
#import "QCSHomeLabel.h"
#import "TitleModel.h"
#import <MJExtension.h>
#import "QCSchoolDefine.h"

#import "qcsStudyAnalyticsInsideController.h"

@interface qcsStudyAnalyticsMainController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView * lineView;
@property (nonatomic, strong) QCSHomeLabel * label;
@property (nonatomic, assign) BOOL showHI;
@property (nonatomic, assign) NSInteger indexAll;

@end

@implementation qcsStudyAnalyticsMainController
{
    NSMutableArray *controllerTypeIdenArray;
}

- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        
        self.dataArray = [[NSMutableArray alloc] init];
        NSArray * array = [NSArray arrayWithObjects:@{@"title":@"大数据",@"status":@"0"},@{@"title":@"课程",@"status":@"0"},@{@"title":@"学生",@"status":@"0"},nil];
        self.dataArray = [TitleModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    // 添加子控制器
    [self setupChildVc];
    [self setupTitle];
    //    [self createBarItem];
    _showHI = YES;
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    
}

#pragma mark - initView
-(void)initView
{
    self.title = @"学情分析";
    self.view.backgroundColor = [UIColor whiteColor];
    self.topScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 50)];
    self.topScrollView.bounces = NO;
    self.topScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.topScrollView];
    self.contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, AdjustHeight+50, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 50 - AdjustHeight)];
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.contentScrollView];
    
}


// 添加子控制器
- (void)setupChildVc {
    
//    TapBigData = 1, //
//    TapClass = 2,    //
//    TapStudent = 3
    
    controllerTypeIdenArray = [NSMutableArray array];
    
    if (self.mainModel.ws_analysisSchoolGroup ||  self.mainModel.ws_analysisSchool) {
        qcsStudyAnalyticsInsideController * ContentView = [[qcsStudyAnalyticsInsideController alloc] init];
        ContentView.controllerType = @"TapBigData";
        ContentView.title = @"大数据";
        ContentView.eclassID = self.eclassID;
        ContentView.tempCourseID = self.tempCourseID;
        ContentView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
        
        ContentView.chooseStartTime =self.chooseStartTime;
        ContentView.chooseEndTime =self.chooseEndTime;
        ContentView.chooseEclassID =self.chooseEclassID;
        ContentView.chooseCourseID =self.chooseCourseID;
        ContentView.chooseStudentID =self.chooseStudentID;
        ContentView.chooseStudentName =self.chooseStudentName;
        ContentView.gradeArray = [NSMutableArray arrayWithArray:self.gradeArray];
        
        self.delegate = ContentView;
        [self addChildViewController:ContentView];
        [controllerTypeIdenArray addObject:@"TapBigData"];
        
    }
    
    if (self.mainModel.ws_analysisClass) {
        qcsStudyAnalyticsInsideController * ContentView = [[qcsStudyAnalyticsInsideController alloc] init];
        ContentView.controllerType = @"TapClass";
        ContentView.title = @"课程";
        ContentView.eclassID = self.eclassID;
        ContentView.tempCourseID = self.tempCourseID;
        ContentView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
        
        ContentView.chooseStartTime =self.chooseStartTime;
        ContentView.chooseEndTime =self.chooseEndTime;
        ContentView.chooseEclassID =self.chooseEclassID;
        ContentView.chooseCourseID =self.chooseCourseID;
        ContentView.chooseStudentID =self.chooseStudentID;
        ContentView.chooseStudentName =self.chooseStudentName;
        ContentView.gradeArray = [NSMutableArray arrayWithArray:self.gradeArray];
        
        self.delegate = ContentView;
        [self addChildViewController:ContentView];
        [controllerTypeIdenArray addObject:@"TapClass"];
    }
    
    if (self.mainModel.ws_analysisStudent) {
        qcsStudyAnalyticsInsideController * ContentView = [[qcsStudyAnalyticsInsideController alloc] init];
        ContentView.controllerType = @"TapStudent";
        ContentView.title = @"学生";
        ContentView.eclassID = self.eclassID;
        ContentView.tempCourseID = self.tempCourseID;
        ContentView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
        
        ContentView.chooseStartTime =self.chooseStartTime;
        ContentView.chooseEndTime =self.chooseEndTime;
        ContentView.chooseEclassID =self.chooseEclassID;
        ContentView.chooseCourseID =self.chooseCourseID;
        ContentView.chooseStudentID =self.chooseStudentID;
        ContentView.chooseStudentName =self.chooseStudentName;
        ContentView.gradeArray = [NSMutableArray arrayWithArray:self.gradeArray];
        
        self.delegate = ContentView;
        [self addChildViewController:ContentView];
        [controllerTypeIdenArray addObject:@"TapStudent"];
    }
    
    [[QCSchoolTagHandle sharedInstance] getCurrentViewTypeOfAnalytic:controllerTypeIdenArray[0]];
    
    _indexAll = self.childViewControllers.count - 1;
//    for (int i = 0; i <= _indexAll; i ++) {
//        qcsStudyAnalyticsInsideController * ContentView = [[qcsStudyAnalyticsInsideController alloc] init];
//        ContentView.viewTag = 1001 + i;
//        TitleModel * model = self.dataArray[i];
//        ContentView.title = model.title;
//        ContentView.eclassID = self.eclassID;
//        ContentView.tempCourseID = self.tempCourseID;
//        ContentView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
//
//        ContentView.chooseStartTime =self.chooseStartTime;
//        ContentView.chooseEndTime =self.chooseEndTime;
//        ContentView.chooseEclassID =self.chooseEclassID;
//        ContentView.chooseCourseID =self.chooseCourseID;
//        ContentView.chooseStudentID =self.chooseStudentID;
//        ContentView.chooseStudentName =self.chooseStudentName;
//        ContentView.gradeArray = [NSMutableArray arrayWithArray:self.gradeArray];
//
//        self.delegate = ContentView;
//        [self addChildViewController:ContentView];
//    }
}

static CGFloat labelW;
// 添加标题
- (void)setupTitle {
    
    // 定义临时变量
    CGFloat labelY = 0;
    CGFloat labelH = self.topScrollView.frame.size.height;
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width;
    
    labelW = labelWidth / (_indexAll + 1);
    
    NSInteger  index = self.childViewControllers.count;
    // 添加label
    for (NSInteger i = 0; i<=_indexAll; i++) {
        CGFloat labelX = i * labelW;
        QCSHomeLabel *label = [[QCSHomeLabel alloc] initWithFrame:CGRectMake(labelX, labelY, labelW, labelH)];
        label.text = [self.childViewControllers[i] title];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        
        //添加间隔竖线
        //        if (i != index -1) {
        //
        //            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(labelW - 1, labelY + 15, 1, labelH - 30)];
        //            lab.backgroundColor = [UIColor QCSThemeColor];
        //            [label addSubview:lab];
        //        }
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
        label.tag = i;
        self.label = label;
        [self.topScrollView addSubview:label];
        
        if (i == 0) { // 最前面的label
            //            label.scale = 1.0;
        }
    }
    
    // 设置contentSize
    self.topScrollView.contentSize = CGSizeMake((_indexAll + 1) * labelW, 0);
    self.contentScrollView.contentSize = CGSizeMake((_indexAll + 1) * [UIScreen mainScreen].bounds.size.width, 0);
    
}
-(UIImageView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 46, labelW, 3)];
        _lineView.backgroundColor = [UIColor whiteColor];
    }
    return _lineView;
}
/**
 * 监听顶部label点击
 */
- (void)labelClick:(UITapGestureRecognizer *)tap
{
    // 取出被点击label的索引
    NSInteger index = tap.view.tag;
    
    if (self.topScrollView.subviews[index]){
        
        self.label = self.topScrollView.subviews[index];
        [self.label addSubview:self.lineView];
        
    } else {
        
        [self.lineView removeFromSuperview];
    }
    // 让底部的内容scrollView滚动到对应位置
    [self setButtomContentView:index];
    
    NSString *type = controllerTypeIdenArray[index];
    [[QCSchoolTagHandle sharedInstance]getCurrentViewTypeOfAnalytic:type];
//    [[QCSchoolTagHandle sharedInstance]getCurrentViewTagOfAnalytic:1001+index ];

}
- (void)setButtomContentView:(NSInteger)index {
    
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = index * self.contentScrollView.frame.size.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
/**
 * scrollView结束了滚动动画以后就会调用这个方法（比如- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;方法执行的动画完毕后）
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 一些临时变量
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 当前位置需要显示的控制器的索引
    NSInteger index = offsetX / width;
    
    if (_showHI) {
        // 偏移量
        index = self.defaultIndex;
        
        offsetX = index * [UIScreen mainScreen].bounds.size.width;
        [scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _showHI = NO;
    }
    // 让对应的顶部标题居中显示
    QCSHomeLabel *label = self.topScrollView.subviews[index];
    self.label = label;
    
    
    CGPoint titleOffset = self.topScrollView.contentOffset;
    titleOffset.x = label.center.x - width * 0.5;
    
    if (label){
        [label addSubview:self.lineView];
    } else
    {
        [self.lineView removeFromSuperview];
    }
    
    // 左边超出处理
    if (titleOffset.x < 0) titleOffset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.topScrollView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
    [self.topScrollView setContentOffset:titleOffset animated:YES];
    
    // 让其他label回到最初的状态
    for (QCSHomeLabel *otherLabel in self.topScrollView.subviews) {
        if (otherLabel != label && [otherLabel isKindOfClass:[UILabel class]])
            //            otherLabel.scale = 1.0;
            otherLabel.textColor = [UIColor QCSTitleTextColor];
    }
    
    // 取出需要显示的控制器
    UIViewController *willShowVc = self.childViewControllers[index];
    willShowVc.view.backgroundColor = [UIColor clearColor];
    [willShowVc viewWillAppear:YES];
    
    // 如果当前位置的位置已经显示过了，就直接返回
    //    if ([willShowVc isViewLoaded]) return;
    
    // 添加控制器的view到contentScrollView中;  // 第一次 宽高 600 550
    willShowVc.view.frame = CGRectMake(offsetX, 0, width, height);
    [scrollView addSubview:willShowVc.view];
    
}

/**
 * 手指松开scrollView后，scrollView停止减速完毕就会调用这个
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat offsetX = scrollView.contentOffset.x;
    // 当前位置需要显示的控制器的索引
    
    NSInteger index = offsetX / width;
    
    NSString *type = controllerTypeIdenArray[index];
    [[QCSchoolTagHandle sharedInstance]getCurrentViewTypeOfAnalytic:type];
//    [[QCSchoolTagHandle sharedInstance]getCurrentViewTagOfAnalytic:1001+index ];
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 * 只要scrollView在滚动，就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scale < 0 || scale > self.topScrollView.subviews.count - 1) return;
    
    // 获得需要操作的左边label
    NSInteger leftIndex = scale;
    QCSHomeLabel *leftLabel = self.topScrollView.subviews[leftIndex];
    
    //获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    
    QCSHomeLabel *rightLabel = (rightIndex == self.topScrollView.subviews.count) ? nil : self.topScrollView.subviews[rightIndex];
    
    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;
    
    // 设置label的比例
    [(QCSHomeLabel *)leftLabel setScale:(CGFloat)leftScale];
    //  在 topScrollViewView 上的 UIImageView 不知道是怎么出来的
    for (id view in scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            return;
        }
    }
    [(QCSHomeLabel *)rightLabel setScale:(CGFloat)rightScale];
}



#pragma mark Other

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear: animated];
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
