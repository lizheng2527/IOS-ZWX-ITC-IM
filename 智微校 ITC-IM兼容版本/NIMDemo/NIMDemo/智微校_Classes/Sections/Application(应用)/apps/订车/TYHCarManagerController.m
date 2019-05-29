//
//  TYHCarManagerController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/24/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHCarManagerController.h"
#import "TYHCarContentController.h"
#import "TYHHomeLabel.h"
#import <MJExtension.h>
#import "TitleModel.h"

@interface TYHCarManagerController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, strong) UIImageView * lineView;
@property (nonatomic, strong) TYHHomeLabel * label;
@property (nonatomic, assign) BOOL showHI;
@property (nonatomic, assign) NSInteger defaultIndex;
@property (nonatomic, strong) NSMutableArray * dataArray;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end

@implementation TYHCarManagerController
- (NSMutableArray *)dataArray {
    
    if (_dataArray == nil) {
        
        self.dataArray = [[NSMutableArray alloc] init];
        NSString * path = [[NSBundle mainBundle] pathForResource:@"OptinalTitle.plist" ofType:nil];
        NSArray * array = [NSArray arrayWithContentsOfFile:path];
        self.dataArray = [TitleModel mj_objectArrayWithKeyValuesArray:array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //    self.title = @"订车单管理";
    self.contentScrollView.delegate = self;
    
    // 不知道怎么 topscroolview 的 子类里有 UIImageView 怎么搞的
    // 添加子控制器
    [self setupChildVc];
    // 添加标题
    [self setupTitle];
    
    // 默认显示第index个子控制器
    _showHI = YES;
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
    
    
}
// 添加子控制器
- (void)setupChildVc {
    
    NSLog(@"_indexAll = %ld",(long)_indexAll);
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    
    if (_indexAll == 5) {
        
        // 我的订车单
        NSString * baseUrl = @"/cm/carMobile!getMyOrderCarList.action";
        
        for (int i = 0; i <= _indexAll; i ++) {
            
            TYHCarContentController * carContent = [[TYHCarContentController alloc] init];
            carContent.username = _userName;
            carContent.password = _password;
            carContent.tag = 1005;
            TitleModel * model = self.dataArray[i];
            carContent.title = model.title;
            
            carContent.strUrl = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&status=%@&dataSourceName=%@&pageNum=0",k_V3ServerURL, baseUrl , _userName, _password,model.status,dataSourceName];
            [self addChildViewController:carContent];
        }
        
    } else if (_indexAll == 6) {
        NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
        dataSourceName = dataSourceName.length?dataSourceName:@"";
        // 订车单管理
        NSString * baseUrl2 = @"/cm/carMobile!getCarManageList.action";
        // 我的任务
        
        for (int i = 0; i < _indexAll; i ++) {
            
            TYHCarContentController * carContent = [[TYHCarContentController alloc] init];
            
            carContent.username = _userName;
            carContent.password = _password;
            TitleModel * model = self.dataArray[5 + i];
            carContent.title = model.title;
            carContent.strUrl = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&status=%@&operationCode=carmanage&dataSourceName=%@&pageNum=0", k_V3ServerURL,baseUrl2 , _userName, _password, model.status,dataSourceName];
            [self addChildViewController:carContent];
        }
    }else if (_indexAll == 4) {
        
        // 我的任务
        NSString * baseUrl3 = @"/cm/carMobile!getMyAssigncarList.action";
        NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
        dataSourceName = dataSourceName.length?dataSourceName:@"";
        for (int i = 0; i < _indexAll; i ++) {
            
            TYHCarContentController * carContent = [[TYHCarContentController alloc] init];
            carContent.username = _userName;
            carContent.password = _password;
            TitleModel * model = self.dataArray[11 + i];
            carContent.title = model.title;
            
            // 第一次进入的时候 就确定 cell 的布局 定义 tag 值
            carContent.tag = 1001;  // 司机
            
            carContent.strUrl = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&status=%@&dataSourceName=%@&pageNum=0", k_V3ServerURL, baseUrl3 , _userName, _password,model.status,dataSourceName];
            
            [self addChildViewController:carContent];
        }
    }
}
static CGFloat labelW;
// 添加标题
- (void)setupTitle {
    
    // 定义临时变量
    CGFloat labelY = 0;
    CGFloat labelH = self.topScrollView.frame.size.height;
    
    CGFloat labelWidth = [UIScreen mainScreen].bounds.size.width;
    if (labelWidth > 320) {
        labelW = labelWidth / 4;
    } else {
        labelW = 80;
    }
    
    NSInteger  index = self.childViewControllers.count;
    // 添加label
    for (NSInteger i = 0; i<_indexAll; i++) {
        TYHHomeLabel *label = [[TYHHomeLabel alloc] init];
        label.text = [self.childViewControllers[i] title];
        label.font = [UIFont boldSystemFontOfSize:14];
        
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        if (i != index -1) {
            
            UILabel * lab = [[UILabel alloc] initWithFrame:CGRectMake(labelW - 1, labelY + 15, 1, labelH - 30)];
            lab.backgroundColor = [UIColor TabBarColorOrange];
            [label addSubview:lab];
        }
        
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelClick:)]];
        label.tag = i;
        self.label = label;
        [self.topScrollView addSubview:label];
        
        if (i == 0) { // 最前面的label
            label.scale = 1.0;
        }
    }
    
    // 设置contentSize
    self.topScrollView.contentSize = CGSizeMake(_indexAll * labelW, 0);
    self.contentScrollView.contentSize = CGSizeMake(_indexAll * [UIScreen mainScreen].bounds.size.width, 0);
}
-(UIImageView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, AdjustHeight + 47, labelW, 3)];
        _lineView.backgroundColor = [UIColor TabBarColorOrange];
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
        index = _indexItem;
        
        offsetX = index * [UIScreen mainScreen].bounds.size.width;
        [scrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _showHI = NO;
    }
    // 让对应的顶部标题居中显示
    TYHHomeLabel *label = self.topScrollView.subviews[index];
    self.label = label;
    CGPoint titleOffset = self.topScrollView.contentOffset;
    titleOffset.x = label.center.x - width * 0.5;
    
    if (label){
        [label addSubview:self.lineView];
    } else {
        [self.lineView removeFromSuperview];
    }
    // 左边超出处理
    if (titleOffset.x < 0) titleOffset.x = 0;
    // 右边超出处理
    CGFloat maxTitleOffsetX = self.topScrollView.contentSize.width - width;
    if (titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
    [self.topScrollView setContentOffset:titleOffset animated:YES];
    
    // 让其他label回到最初的状态
    for (TYHHomeLabel *otherLabel in self.topScrollView.subviews) {
        if (otherLabel != label && [otherLabel isKindOfClass:[UILabel class]])
            otherLabel.scale = 0.0;
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
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/**
 * 只要scrollView在滚动，就会调用
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //  在 topScrollViewView 上的 UIImageView 不知道是怎么出来的
    CGFloat scale = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scale < 0 || scale > self.topScrollView.subviews.count - 1) return;
    
    // 获得需要操作的左边label
    NSInteger leftIndex = scale;
    TYHHomeLabel *leftLabel = self.topScrollView.subviews[leftIndex];
    
    //获得需要操作的右边label
    NSInteger rightIndex = leftIndex + 1;
    
    TYHHomeLabel *rightLabel = (rightIndex == self.topScrollView.subviews.count) ? nil : self.topScrollView.subviews[rightIndex];
    
    // 右边比例
    CGFloat rightScale = scale - leftIndex;
    // 左边比例
    CGFloat leftScale = 1 - rightScale;
    
    // 设置label的比例
    leftLabel.scale = leftScale;
    rightLabel.scale = rightScale;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if (kDevice_Is_iPhoneX) {
        self.topLayout.constant = 88;
    }
}
@end
