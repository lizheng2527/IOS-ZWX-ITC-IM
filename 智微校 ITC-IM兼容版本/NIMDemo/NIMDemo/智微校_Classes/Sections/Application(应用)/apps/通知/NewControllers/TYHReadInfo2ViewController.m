//
//  TYHReadInfo2ViewController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/2/15.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHReadInfo2ViewController.h"

#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "ReadModel.h"
#import "UIView+Extention.h"
#import <UIView+Toast.h>

#import <PNChart.h>


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface TYHReadInfo2ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray * readCount;
@property (nonatomic, strong) NSMutableArray * unreadCount;

@property (nonatomic, strong) NSDictionary * dict;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *readBtn;
@property (weak, nonatomic) IBOutlet UIButton *unreadBtn;
@property (nonatomic, strong) NSMutableArray * nameArray;
@property (nonatomic,strong) PNPieChart *pieChart;
@end

@implementation TYHReadInfo2ViewController
- (NSMutableArray *)nameArray {

    if (_nameArray == nil) {
        _nameArray = [[NSMutableArray alloc] init];
    }
    return  _nameArray;
}
- (void)initData {
    
    NSString *tempUserName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    _organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    _userName = [NSString stringWithFormat:@"%@",tempUserName];
    _password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    _userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    _token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}
- (NSMutableArray *)readCount {
    
    if (_readCount == nil) {
        _readCount = [[NSMutableArray alloc] init];
    }
    return _readCount;
}
- (NSMutableArray *)unreadCount {
    
    if (_unreadCount == nil) {
        _unreadCount = [[NSMutableArray alloc] init];
    }
    return _unreadCount;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initData];
    
    [self getReadInfo];
    
    
//    [self creatLeftItem];
    
    self.title = @"阅读统计";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];

    self.readBtn.selected = YES;
    
    [self.readBtn addTarget:self action:@selector(readTableView) forControlEvents:UIControlEventTouchUpInside];
    
    self.unreadBtn.selected = NO;
    [self.unreadBtn addTarget:self action:@selector(unreadTableView) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)readTableView {

    self.readBtn.selected = YES;
    self.unreadBtn.selected = NO;
    
    [self.tableView reloadData];
    
}
- (void)unreadTableView {

    self.unreadBtn.selected = YES;
    self.readBtn.selected = NO;
    
    [self.tableView reloadData];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(self.view.width - 100 , 0, 100, 25);
    [button setTitle:@"复制名单" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xffe64f5a) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    [button setBackgroundColor:[UIColor clearColor]];
    
    [button addTarget:self action:@selector(pasteName) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.readBtn.selected == YES) {
        UIView* myView = [[UIView alloc] init];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 200, 25)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor colorWithRed:0.0 / 255 green:0/255 blue:0/255 alpha:0.1];
        titleLabel.text = @"已读人员";
        [myView addSubview:titleLabel];
        return myView;
    }
    else  {
    
        UIView* myView = [[UIView alloc] init];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 200, 25)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        myView.backgroundColor = [UIColor colorWithRed:0.0 / 255 green:0/255 blue:0/255 alpha:0.1];
        titleLabel.text = @"未读人员";
        [myView addSubview:button];
        [myView addSubview:titleLabel];
        return myView;
    };
}
- (void)pasteName {
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSString * nameStr = [self.nameArray componentsJoinedByString:@","];
    pasteboard.string = nameStr;
    [self.view makeToast:@"未读人员已剪切到剪切板" duration:1 position:nil];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.readBtn.selected == YES) {
    
        return self.readCount.count;
        
    } else {
    
        return self.unreadCount.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * ID = @"cell";
    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
   
    if (self.readBtn.selected == YES) {
        
        ReadModel * model = self.readCount[indexPath.row];
        cell.textLabel.text = model.name;
        
        cell.detailTextLabel.text = model.readingTime;
    } else if (self.unreadBtn.selected == YES) {
        
        ReadModel * model = self.unreadCount[indexPath.row];
        cell.textLabel.text = model.name;
        [self.nameArray addObject:model.name];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)getReadInfo{
    
    NSString *string = [NSString stringWithFormat:@"%@/no/noticeMobile!getReadDetailData.action",BaseURL];
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    NSString * url = [NSString stringWithFormat:@"%@?sys_username=%@&sys_auto_authenticate=true&sys_password=%@&id=%@&imToken=%@&dataSourceName=%@",string,_userName,_password,self.ID,self.token,dataSourceName];
    NSLog(@"url = %@",url);
    // 删除消息
    [TYHHttpTool get:url params:nil success:^(id json) {
        NSLog(@"json = %@",json);
        NSArray * array = json[@"readList"];
        NSArray * array2 = json[@"unReadList"];
        NSLog(@"array = %@, array2 = %@",array,array2);
        
        
        self.readCount = [ReadModel mj_objectArrayWithKeyValuesArray:array];
        self.unreadCount = [ReadModel mj_objectArrayWithKeyValuesArray:array2];

        int a =  (int)self.readCount.count + (int)self.unreadCount.count;
        NSString * nameStr = [NSString stringWithFormat:@"共发送给%d人",a];
        
        self.nameLabel.text = nameStr;
        
        
        [self createPieView];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        NSLog(@"array erorr");
    }];
}

- (void)creatLeftItem {
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    } else {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}
- (void)returnClicked {

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createPieView
{
    //设置图内饼的颜色，饼对应的百分比和饼内外的描述
    NSArray *items = @[[PNPieChartDataItem dataItemWithValue:self.readCount.count color:UIColorFromRGB(0xffe64f5a) description:nil],
                       [PNPieChartDataItem dataItemWithValue:self.unreadCount.count color:UIColorFromRGB(0xff44c06a) description:nil]
                       ];
    int a = 70;
    CGFloat width = self.view.width - 2*a;
    self.pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - width / 3 , 20, width / 3 * 2, width / 3 * 2) items:items];
    //背景色
//    self.pieChart.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    //图内描述文字颜色
    self.pieChart.descriptionTextColor = [UIColor grayColor];
    self.pieChart.userInteractionEnabled = NO;
    //图内文字字体大小
    self.pieChart.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:16.0];
    //饼内文字阴影颜色
//    self.pieChart.descriptionTextShadowColor = [UIColor orangeColor];
    //饼内是否不显示 %
    self.pieChart.showAbsoluteValues = YES;
    //是否饼图内只显示数值不显示文字
    self.pieChart.showOnlyValues = NO;
    //设置饼半径及粗细
    self.pieChart.outerCircleRadius = CGRectGetWidth(self.pieChart.bounds) / 2;//外圈大半径
    self.pieChart.innerCircleRadius = CGRectGetWidth(self.pieChart.bounds) / 6;//内圈小半径
    
    //显示
    [self.pieChart strokeChart];
    
    self.pieChart.legendStyle = PNLegendItemStyleStacked;
    //底部提示框文字字体大小
    self.pieChart.legendFont = [UIFont boldSystemFontOfSize:12.0f];
    
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
