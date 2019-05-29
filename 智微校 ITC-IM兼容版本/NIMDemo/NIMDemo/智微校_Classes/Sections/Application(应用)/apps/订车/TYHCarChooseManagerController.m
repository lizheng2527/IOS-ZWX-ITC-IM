//
//  TYHCarChooseManagerController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/25/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHCarChooseManagerController.h"
#import "TYHCarDetailController.h"
#import "TYHCarStatusController.h"
#import "TYHHomeLabel.h"

@interface TYHCarChooseManagerController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView * lineView;
@property (nonatomic, strong) TYHHomeLabel * label;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayout;

@end

@implementation TYHCarChooseManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"订车单";
    self.contentScrollView.delegate = self;
    // 添加子控制器
    [self setupChildVc];
    
    // 添加标题
    [self setupTitle];
    
    // 默认显示第index个子控制器
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}
// 添加子控制器
- (void)setupChildVc {

    TYHCarDetailController * detailVc = [[TYHCarDetailController alloc] init];
    detailVc.title =@"订车单详情";
    
    detailVc.carOrderId = self.carOrderId;
    detailVc.OptinalOneButton = self.optionalOne;
    detailVc.OptinalTwoButton= self.optionalTwo;
    detailVc.OptinalThreeButton = self.optionalThree;
    detailVc.dataArray  = self.dataArray;
    
    detailVc.optionalOneStr = self.optionalOneStr;
    detailVc.optionalTwoStr= self.optionalTwoStr;
    detailVc.optionalThreeStr = self.optionalThreeStr;
    detailVc.tag = self.tag; // 1001 司机
    
    [self addChildViewController:detailVc];
    
    
    TYHCarStatusController * statusVc = [[TYHCarStatusController alloc] init];
    statusVc.title = @"订车单状态";
    statusVc.carOrderId = self.carOrderId;
    statusVc.tag = self.tag; // 1001 司机
    [self addChildViewController:statusVc];
    
}
// 添加标题
- (void)setupTitle {

    CGFloat labelW = [UIScreen mainScreen].bounds.size.width/2;
    CGFloat labelY = 0;
    CGFloat labelH = self.topScrollView.frame.size.height;
    
    NSInteger index = self.childViewControllers.count;
    for (NSInteger i = 0; i < index; i ++) {
    
        TYHHomeLabel * label = [[TYHHomeLabel alloc] init];
        label.text = [self.childViewControllers[i] title];
        
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        if (i != index - 1) {
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
    
    self.topScrollView.contentSize = CGSizeMake(index * labelW, 0);
    self.contentScrollView.contentSize = CGSizeMake(index * labelW * 2, 0);
}
-(UIImageView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 47, [UIScreen mainScreen].bounds.size.width/2, 3)];
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
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {

    CGFloat width = scrollView.frame.size.width;
    CGFloat hight = scrollView.frame.size.height;
    CGFloat offsetx = scrollView.contentOffset.x;
    
    // 当前控制器需要显示的索引
    NSInteger index = offsetx / width;
    // 让对应的顶部标题居中显示
    TYHHomeLabel *label = self.topScrollView.subviews[index];
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
    // 设置头部滚动位置
    [self.topScrollView setContentOffset:titleOffset animated:YES];
    [self scrollViewDidScroll:scrollView];
    
    UIViewController *willShowVc = self.childViewControllers[index];
    
    // 如果当前位置的位置已经显示过了，就直接返回
//    if ([willShowVc isViewLoaded]) return;
    
    willShowVc.view.frame = CGRectMake(offsetx, 0, width, hight);
    
    [scrollView addSubview:willShowVc.view];
}
// 手指松开 ScrollView 后 ScrollView停止加速完成就会调用这个方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {

    [self scrollViewDidEndScrollingAnimation:scrollView];
}

// 只要滚动就走这里  这里用来调整字体的颜色
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
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
