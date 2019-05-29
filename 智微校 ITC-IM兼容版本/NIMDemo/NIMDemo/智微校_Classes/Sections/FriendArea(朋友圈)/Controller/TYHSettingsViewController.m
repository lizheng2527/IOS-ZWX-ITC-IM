//
//  TYHSettingsViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/10.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import "TYHSettingsViewController.h"
#import "TYHSettingsCell.h"
#import <UIButton+WebCache.h>
#import "TYHNoticeController.h"
#import "SchoolMatesViewController.h"
#import "ClassPaperViewController.h"
#import "AreaHelper.h"
#import "NewStateModel.h"
#import <UIImageView+WebCache.h>
@interface TYHSettingsViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain)UIBarButtonItem *menuItem;
@property(nonatomic,retain)__block NSMutableArray *StateArray;
@end

@implementation TYHSettingsViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _settingArray = @[@"校友圈",@"班级墙报"];
    }
    return self;
}


-(void)getNewState
{
    AreaHelper *helper = [[AreaHelper alloc]init];
    [helper getNewStateWithStatus:^(BOOL successful, NSMutableArray *dataSource) {
        _StateArray = [NSMutableArray arrayWithArray:dataSource];
        [_mainView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
    // Do any additional setup after loading the view from its nib.
    
    //    [self.navigationController changeNavigationBarWithTitle:@"nwwi" showBackBtn:YES];
    //    self.title = @"设置";
    
    [self getNewState];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentView:) name:@"PresentView" object:nil];
}

- (void)presentView:(NSNotificationCenter *)notice {
    
    TYHNoticeController * noticeVc = [[TYHNoticeController alloc] init];
    noticeVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController  pushViewController:noticeVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark- TableViewDelegate
-(void)createView
{
    _mainView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _mainView.delegate = self;
    _mainView.dataSource  = self;
    [self.view addSubview:_mainView];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"mainSettingCell";
    TYHSettingsCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TYHSettingsCell" owner:self options:nil].firstObject;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        if (indexPath.section == 0) {
            cell.settingLabel.text = _settingArray[indexPath.row];
            cell.itemIcon.image = [UIImage imageNamed:@"icon_schoolcircle"];
            //逻辑逻辑
            
            if (![[(NewStateModel *)_StateArray[0] count] isEqualToString:@"0"]) {
                cell.nnewContent_Image.hidden = NO;
                [cell.nnewContent_Image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,[(NewStateModel *)_StateArray[0] headUrl]]] placeholderImage:[UIImage imageNamed:@"mk-photo"]];
                cell.nnewContent_Label.hidden = NO;
            }
            if (![[(NewStateModel *)_StateArray[2] count] isEqualToString:@"0"]) {
                cell.nnewLikeOrComment_Label.hidden = NO;
                cell.nnewLikeOrComment_Label.text = [(NewStateModel *)_StateArray[2] count];
            }
        }
        if (indexPath.section == 1) {
            cell.settingLabel.text = _settingArray[1];
            cell.itemIcon.image = [UIImage imageNamed:@"icon_classcircle"];
            
            //逻辑逻辑
            if (![[(NewStateModel *)_StateArray[1] count] isEqualToString:@"0"]) {
                cell.nnewContent_Image.hidden = NO;
                [cell.nnewContent_Image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,[(NewStateModel *)_StateArray[1] headUrl]]] placeholderImage:[UIImage imageNamed:@"mk-photo"]];
                cell.nnewContent_Label.hidden = NO;
            }else
            {
                cell.nnewContent_Image.hidden = YES;
                cell.nnewContent_Label.hidden = YES;
            }
            if (![[(NewStateModel *)_StateArray[3] count] isEqualToString:@"0"]) {
                cell.nnewLikeOrComment_Label.hidden = NO;
                cell.nnewLikeOrComment_Label.text = [(NewStateModel *)_StateArray[3] count];
            }
            else
            {
                cell.nnewLikeOrComment_Label.hidden = YES;
            }
        }
//        cell.stateModel = model;
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    else
        return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        SchoolMatesViewController *schoolmateView = [[SchoolMatesViewController alloc]initWithRecordModel:_StateArray[2]];
        
        [schoolmateView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:schoolmateView animated:YES];
    }
    else if (indexPath.section == 1)
    {
        ClassPaperViewController *paperView = [[ClassPaperViewController alloc]initWithRecordModel:_StateArray[3]];
        [paperView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:paperView animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0.1f;
    }
    else
        return 5;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return 2;
}


#pragma mark- Other
-(void)viewWillAppear:(BOOL)animated
{
    self.title = @"圈子";
    
//    [[NSNotificationCenter defaultCenter]postNotificationName:NewCommentOrReplyNotifion object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNewState) name:NewCommentOrReplyNotifion object:nil];
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
