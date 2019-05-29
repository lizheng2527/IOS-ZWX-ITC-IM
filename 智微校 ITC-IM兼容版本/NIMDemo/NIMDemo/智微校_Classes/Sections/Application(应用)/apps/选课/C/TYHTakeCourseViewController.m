//
//  TYHTakeCourseViewController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/7/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHTakeCourseViewController.h"
#import "TakeCourseHeaderView.h"
#import "TakeCourseHelper.h"
#import "TakeCourseModel.h"
#import "SDAutoLayout.h"
#import "TakeCourseCell.h"
#import "TakeCourseModelHandler.h"
#import "TakeCourseDetailViewController.h"
#import "NSString+Empty.h"
#import <UIView+Toast.h>
@interface TYHTakeCourseViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UIAlertViewDelegate>

@end


@implementation TYHTakeCourseViewController
{
    __block UITableView *mainTableView;
    UILabel *ruleLabel;
    UIButton *arrowButton;
    UIImageView *arrowImageView;
    
    NSString *ecID;
    EcRuleModel *ecruleModel;
    TakeCourseModel *takeCourseModel;
    
    //以下是规则
    
    
    NSMutableString *selectCourseIDs_String; //获取提交时的courseIDs
    NSMutableString *selectEcAcIDs_String;  //获取提交时的EcAcIDs
    
}

-(void)setTempIndexPathAndModeltypeArray:(NSMutableArray *)tempIndexPathAndModeltypeArray
{
    _tempIndexPathAndModeltypeArray = [NSMutableArray arrayWithArray:tempIndexPathAndModeltypeArray];
}

-(instancetype)initWithEcID:(NSString *)EcID
{
    self = [super init];
    if (self) {
        ecID =  EcID;
    }
    return self;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选课";
//    [self initTableView];
    [self requestData];
    [self createLeftBarItem];
}

-(void)viewWillAppear:(BOOL)animated
{
    if (![NSString isBlankString:_tempIndexPathAndModeltypeArray[0]] ) {
        NSInteger indexPathSection = [_tempIndexPathAndModeltypeArray[0] integerValue];
        NSInteger indexPathRow = [_tempIndexPathAndModeltypeArray[1] integerValue];
        EcActivityCourseListModel *model = [takeCourseModel.ecElectiveGroupList[indexPathSection] ecActivityCourseList][indexPathRow];
        model.limit_type = _tempIndexPathAndModeltypeArray[2];
        NSLog(@"%@%@",_tempIndexPathAndModeltypeArray[2],model);
        
        if ([model.limit_type isEqualToString:@"已选"]) {
            model.selectedNum = [NSString stringWithFormat:@"%ld",[model.selectedNum integerValue] + 1];
            model.selected = @"1";
        }
        else
        {
            model.selectedNum = [NSString stringWithFormat:@"%ld",[model.selectedNum integerValue] - 1];
            model.selected = @"0";
        }
        [TakeCourseModelHandler returnTakeCourseModelWithDeal:takeCourseModel];
        [mainTableView reloadData];
    }
}


#pragma mark - initData
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    TakeCourseHelper *helper = [TakeCourseHelper new];
    ecruleModel = [EcRuleModel new];
    takeCourseModel = [TakeCourseModel new];
    [helper getChooseCourseWithEcID:ecID and:^(BOOL successful,TakeCourseModel *takeModel) {
        takeCourseModel = [TakeCourseModelHandler returnTakeCourseModelWithDeal:takeModel];
        ecruleModel = takeModel.ecRuleModel;

        [self initLabel];
        [self initTableView];
        [mainTableView reloadData];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
    
}


#pragma mark - initView
-(void)initTableView
{
    if (!mainTableView.superview) {
        mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 69, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 30 - 70 - 44) style:UITableViewStylePlain];
        mainTableView.delegate = self;
        mainTableView.dataSource = self;
        mainTableView.bounces = NO;
        [mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [self.view addSubview:mainTableView];
    }
}

-(void)initLabel
{
    if (!ruleLabel.superview) {
        ruleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, 100)];
        ruleLabel.textColor = [UIColor colorWithRed:24 / 255.0 green:161 / 255.0 blue:132/ 255.0 alpha:1];
        ruleLabel.numberOfLines = 0;
//        ruleLabel.textColor = [UIColor grayColor];
        ruleLabel.font = [UIFont boldSystemFontOfSize:16];
        ruleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        ruleLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer  *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(arrowAction)];
        [ruleLabel addGestureRecognizer:ges];
        ruleLabel.text = [TakeCourseModelHandler dealRuleStringWithTakeCourseModel:takeCourseModel];
        CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 9999);//
        CGSize expectSize = [ruleLabel sizeThatFits:maximumLabelSize];
        ruleLabel.frame = CGRectMake(10, 10, expectSize.width - 20, expectSize.height);
        [self.view addSubview:ruleLabel];
        [self initArrowButtonAndArrowImageview];
    }
}

-(void)initArrowButtonAndArrowImageview
{
    arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 5, 40, 40);
    arrowButton.layer.masksToBounds = YES;
    arrowButton.layer.cornerRadius = arrowButton.frame.size.width / 2;
    [arrowButton setBackgroundImage:[UIImage imageNamed:@"icon_rule"] forState:UIControlStateNormal];
    [arrowButton addTarget:self action:@selector(arrowAction) forControlEvents:UIControlEventTouchUpInside];
    arrowButton.selected = YES;
    [self.view addSubview:arrowButton];
    
    arrowImageView = [[UIImageView alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 50, 45, 20, 20)];
    arrowImageView.image = [UIImage imageNamed:@"ic_expand_more_black_12dp"];
    [self.view addSubview:arrowImageView];
}
-(void)createLeftBarItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(submitCourse) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}


#pragma mark - tableview datasource delegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray  *cModelArray = [takeCourseModel.ecElectiveGroupList[indexPath.section] ecActivityCourseList];
    EcActivityCourseListModel *cModel = cModelArray[indexPath.row];
    
    static NSString *iden = @"TakeCourseCell";
    TakeCourseCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"TakeCourseCell" owner:self options:nil].firstObject;
        cell.courseStatusImage.tag = indexPath.row + indexPath.section + 1000;
        cell.model = cModel;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectBtnClicked:)];
        [cell.courseStatusImage addGestureRecognizer:tap];
        [cell.detailButton addTarget:self action:@selector(cellBtnClicked:event:) forControlEvents:UIControlEventTouchUpInside];
        cell.detailButton.tag = indexPath.row + indexPath.section + 2000;
    }
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        TakeCourseHeaderView *headerView = [[TakeCourseHeaderView alloc]init];
        headerView.titleLabel.text= [takeCourseModel.ecElectiveGroupList[section] groupName];
        return headerView;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EcActivityCourseListModel *model = [takeCourseModel.ecElectiveGroupList[indexPath.section] ecActivityCourseList][indexPath.row];
    
    if ([model.limit_type isEqualToString:@"学分上限"] || [model.limit_type isEqualToString:@"选课上限"] || [model.limit_type isEqualToString:@"课时上限"] || [model.limit_type isEqualToString:@"时间冲突"] || [model.limit_type isEqualToString:@"已满"] || [model.limit_type isEqualToString:@"选课冲突"] || [model.limit_type isEqualToString:@"已封版"]) {
        return;
    }
    else
    {
        if ([model.selected isEqualToString:@"0"]) {
            model.selected = @"1";
            model.selectedNum = [NSString stringWithFormat:@"%ld",[model.selectedNum integerValue] + 1];
            [TakeCourseModelHandler returnTakeCourseModelWithDeal:takeCourseModel];
        }
        else
        {
            model.selected = @"0";
            model.selectedNum = [NSString stringWithFormat:@"%ld",[model.selectedNum integerValue] - 1];
            [TakeCourseModelHandler returnTakeCourseModelWithDeal:takeCourseModel];
        }
    }
    [mainTableView reloadData];
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return 110;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
        return 30.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [takeCourseModel.ecElectiveGroupList[section] ecActivityCourseList].count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [takeCourseModel.ecElectiveGroupList count];
}


#pragma mark - AlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.delegate = self;
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.labelText = @"正在提交选课";
        TakeCourseHelper *netHelper = [TakeCourseHelper new];
        [netHelper saveEcCourseWithCourseIDs:selectCourseIDs_String ecActivityIDs:ecID and:^(BOOL successful, NSMutableArray *dataSource) {
            [hud removeFromSuperview];
            [self requestData];
            [self.view makeToast:@"提交选课成功" duration:1 position:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"saveCourseSuccessful" object:nil];
        } failure:^(NSError *error) {
            [hud removeFromSuperview];
            [self.view makeToast:@"提交选课失败" duration:1 position:nil];
        }];
    }
}

#pragma mark - Action
-(void)cellSelectBtnClicked:(UITapGestureRecognizer *)tap{
    
    CGPoint point = [tap locationInView:mainTableView];
    NSIndexPath * indexPath = [mainTableView indexPathForRowAtPoint:point];
    UIImageView * selectimage = nil;
    for (UIView * view in tap.view.subviews) {
        if (view.tag >=indexPath.row+1000 + indexPath.section) {
            selectimage = (UIImageView *)view;
            break;
        }
    }
    EcActivityCourseListModel *model = [takeCourseModel.ecElectiveGroupList[indexPath.section] ecActivityCourseList][indexPath.row];
    if ([model.limit_type isEqualToString:@"已满"]) {
        return;
    }
    UIAlertView *limitAlertView = [[UIAlertView alloc]initWithTitle:@"提示" message:model.limit_alertString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    
    [limitAlertView show];
    NSLog(@"section: %ld row: %ld",(long)indexPath.section,(long)indexPath.row);
        [mainTableView reloadData];
    
}

- (void)cellBtnClicked:(id)sender event:(id)event
{
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:mainTableView];
    NSIndexPath *indexPath= [mainTableView indexPathForRowAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        EcActivityCourseListModel *model = [takeCourseModel.ecElectiveGroupList[indexPath.section] ecActivityCourseList][indexPath.row];
        TakeCourseDetailViewController *dView = [[TakeCourseDetailViewController alloc]init];
        dView.isTakeCourseViewGoin = YES;
        dView.ecActivityCourseId = model.ecActivityID;
        dView.typeString = model.limit_type;
        NSArray *array = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%ld",(long)indexPath.section], [NSString stringWithFormat:@"%ld",(long)indexPath.row],[NSString stringWithFormat:@"%@",model.limit_type],nil];
        dView.indexPathRowArray = [NSMutableArray arrayWithArray:array];
        dView.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:dView animated:YES];
    }
}


-(void)submitCourse
{
//    saveEcCourseWithCourseIDs
    selectCourseIDs_String = [NSMutableString string];
    selectEcAcIDs_String = [NSMutableString string];
    NSMutableString *selectCourseNamesString = [NSMutableString string];
    int tempNameFlag = 0;
    for (ecElectiveGroupListModel *gModel in takeCourseModel.ecElectiveGroupList) {
        for (EcActivityCourseListModel *cModel in gModel.ecActivityCourseList) {
            if ([cModel.selected isEqualToString:@"1"]) {
                if (tempNameFlag == 0) {
                    [selectCourseNamesString appendFormat:@"%@",cModel.courseDisplayName ];
                    [selectCourseIDs_String appendString:cModel.courseId];
                    [selectEcAcIDs_String appendString:cModel.ecActivityID];
                }
                else
                {
                    [selectCourseNamesString appendFormat:@",%@",cModel.courseDisplayName ];
                    [selectCourseIDs_String appendFormat:@",%@",cModel.courseId];
                    [selectEcAcIDs_String appendFormat:@",%@",cModel.ecActivityID];
                }
                tempNameFlag ++;
            }
        }
    }
    if ([NSString isBlankString:[NSString stringWithFormat:@"%@",selectCourseNamesString]] ) {
        selectCourseNamesString = [NSMutableString stringWithString:@""];
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请选择课程" message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
//        [alertView show];
//        return;
    }
    NSString *lowChooseString = [TakeCourseModelHandler haveSelectedLowestCourse:takeCourseModel];
    
    if (![NSString isBlankString:lowChooseString])
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"选课规则冲突" message:lowChooseString delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"选课确认" message:[NSString stringWithFormat:@"确认选择:%@吗?",selectCourseNamesString] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}

-(void)arrowAction
{
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 8, 9999);//labelsize的最大值
    //关键语句
    CGSize expectSize = [ruleLabel sizeThatFits:maximumLabelSize];
    //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
    ruleLabel.frame = CGRectMake(10, 10, expectSize.width - 20, expectSize.height);
    if (arrowButton.selected == YES) {
        
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];//改变它的frame的x,y的值
        arrowImageView.image = [UIImage imageNamed:@"ic_expand_less_black_12dp"];
        arrowButton.selected = NO;
        mainTableView.frame = CGRectMake(0, expectSize.height + 13, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 30 - expectSize.height - 44 - 10);
        [UIView commitAnimations];
        
    }
    else
    {
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationDelegate:self];//改变它的frame的x,y的值
        arrowImageView.image = [UIImage imageNamed:@"ic_expand_more_black_12dp"];
        arrowButton.selected = YES;
        mainTableView.frame = CGRectMake(0, 69, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 30 - 70 - 44);
        [UIView commitAnimations];
    }
}

@end
