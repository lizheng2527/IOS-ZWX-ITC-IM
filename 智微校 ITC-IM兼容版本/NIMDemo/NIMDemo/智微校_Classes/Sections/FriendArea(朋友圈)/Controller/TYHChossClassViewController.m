//
//  TYHChossClassViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/5/10.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHChossClassViewController.h"
#import "SchoolMatesViewController.h"
#import "ClassPaperViewController.h"
#import "SchoolMatesModel.h"
#import "AreaHelper.h"
#import "DFImagesSendViewController.h"
#import <MBProgressHUD.h>

@interface TYHChossClassViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate>
@property(nonatomic,retain)UIBarButtonItem *menuItem;
@end

@implementation TYHChossClassViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _settingArray = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createLeftBarItem];
    // Do any additional setup after loading the view from its nib.
    [self createView];
//    [self getData];
}
//-(void)getData
//{
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    hud.delegate = self;
//    
//    AreaHelper *helper = [[AreaHelper alloc]init];
//    [helper getOwnerClassandStatus:^(BOOL successful, NSMutableArray *array) {
//        _settingArray = array;
//        [_mainView reloadData];
//        [hud removeFromSuperview];
//    } failure:^(NSError *error) {
//        [hud removeFromSuperview];
//    }];
//}


-(void)setSettingArray:(NSMutableArray *)settingArray
{
    _settingArray = settingArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- TableViewDelegate
-(void)createView
{
    _mainView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _mainView.delegate = self;
    _mainView.dataSource  = self;
    [_mainView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.view addSubview:_mainView];
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"itemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:iden];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    classModel *model = _settingArray[indexPath.row];
    cell.textLabel.text = model.className;
    cell.textLabel.font = [UIFont systemFontOfSize:15];

    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return _settingArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    classModel *model = _settingArray[indexPath.row];
    DFImagesSendViewController
    *setPrizeVC = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
    
    //初始化其属性
    setPrizeVC.tmpClassModel
    = nil;
    //传递参数过去
    
    setPrizeVC.tmpClassModel
    = model;
    //使用popToViewController返回并传值到上一页面
    
    [self.navigationController
     popToViewController:setPrizeVC animated:true];

}


-(void)createLeftBarItem
{
        UIBarButtonItem * leftItem = nil;
    
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
            leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        } else {
            leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        }
        self.navigationItem.leftBarButtonItem =leftItem;
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark- Other
-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"选择班级";
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
