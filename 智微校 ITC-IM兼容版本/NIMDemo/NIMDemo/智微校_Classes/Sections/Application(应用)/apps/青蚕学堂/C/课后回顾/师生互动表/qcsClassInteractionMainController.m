//
//  qcsClassInteractionMainController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/8.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassInteractionMainController.h"
#import "QCSMainModel.h"
#import "QCSNetHelper.h"


#import <PNChart.h>


@interface qcsClassInteractionMainController ()

@property (nonatomic,strong) PNPieChart *pieChart;

@property(nonatomic,retain)NSMutableArray *chartSource;
@end

@implementation qcsClassInteractionMainController
{
    UILabel *noDatalabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"师生互动表";
    // Do any additional setup after loading the view from its nib.
//    [self createPieView];
    
    [self getData];
}

-(void)getData
{
    
    noDatalabel = [[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 35, [UIScreen mainScreen].bounds.size.height / 2 - 50, 70, 40)];
    noDatalabel.text = @"暂无数据";
    noDatalabel.textColor = [UIColor grayColor];
    noDatalabel.font = [UIFont boldSystemFontOfSize:15];
    [self.view addSubview:noDatalabel];
    
    _chartSource = [NSMutableArray array];
    
    [SVProgressHUD showWithStatus:@"获取数据中"];
    
    QCSNetHelper *helper = [QCSNetHelper new];
    [helper getITeacherAndStudentInteractionWithID:self.wisdomclassId andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        _chartSource = dataSource;
        [SVProgressHUD dismiss];
        [noDatalabel removeFromSuperview];
        
        [self createPieView];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
    }];
    
}




-(void)createPieView
{
    NSMutableArray *colorArray = [NSMutableArray array];
    [colorArray addObject:UIColorFromRGB(0xffFF934E)];
    [colorArray addObject:UIColorFromRGB(0xff61A2FE)];
    [colorArray addObject:UIColorFromRGB(0xffF3746B)];
    [colorArray addObject:UIColorFromRGB(0xff6BB4DF)];
    [colorArray addObject:UIColorFromRGB(0xff5ECB88)];
    [colorArray addObject:UIColorFromRGB(0xff62D6C9)];
    [colorArray addObject:PNHealYellow];
    [colorArray addObject:PNMauve];
    [colorArray addObject:PNLightGreen];
    [colorArray addObject:PNStarYellow];
    [colorArray addObject:PNLightGrey];
    
    NSMutableArray *items = [NSMutableArray array];
    [_chartSource enumerateObjectsUsingBlock:^(QCSMainInteractionModel  *model, NSUInteger idx, BOOL * _Nonnull stop) {

        [items addObject:[PNPieChartDataItem dataItemWithValue:[model.cnt integerValue] color:[colorArray objectAtIndex:idx] description:model.type]];
    }];
    
    
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(50, 135, SCREEN_WIDTH - 100, SCREEN_WIDTH - 100) items:items];
    self.pieChart.descriptionTextColor = [UIColor whiteColor];
    self.pieChart.descriptionTextFont = [UIFont fontWithName:@"Avenir-Medium" size:11.0];
    self.pieChart.descriptionTextShadowColor = [UIColor clearColor];
    self.pieChart.showAbsoluteValues = NO;
    self.pieChart.showOnlyValues = NO;
    
    [self.pieChart strokeChart];
    
    
    self.pieChart.legendStyle = PNLegendItemStyleSerial;
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:13.0f];
    
    UIView *legend = [self.pieChart getLegendWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 20];
    [legend setFrame:CGRectMake(15, [UIScreen mainScreen].bounds.size.height - 130, [UIScreen mainScreen].bounds.size.width - 30, legend.frame.size.height)];
    [self.view addSubview:legend];
    
    [self.view addSubview:self.pieChart];
    
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
