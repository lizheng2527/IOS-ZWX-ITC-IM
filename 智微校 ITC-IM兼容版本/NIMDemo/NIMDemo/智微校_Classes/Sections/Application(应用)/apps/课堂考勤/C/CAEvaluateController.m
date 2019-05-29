//
//  CAEvaluateController.m
//  NIM
//
//  Created by 中电和讯 on 2018/1/24.
//  Copyright © 2018年 Netease. All rights reserved.
//


#import "CAEvaluateController.h"
#import "ClassAttendanceNetHelper.h"
#import "ClassAttendanceModel.h"

#import "CAEvaluateItemCell.h"
#import "CAEvaluateItemHeaderView.h"
#import "CAEvaluateListCell.h"
#import "CAEvaluateListHeaderView.h"
#import "LLSwitch.h"
#import "PPNumberButton.h"


@interface CAEvaluateController ()<UITableViewDelegate,UITableViewDataSource,CAEvaluateItemCellDelegate,CAEvaluateListCellDelegate,LLSwitchDelegate>
@end

@implementation CAEvaluateController
{
    __block CAEvaluateMainModel *mainModel;
    CAEvaluateItemHeaderView *headerviewItem;
    CAEvaluateListHeaderView *headerViewList;
    
    NSMutableArray *needSubmitModelArray;
    BOOL isAddItem;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.studentName;
    isAddItem = true;
    needSubmitModelArray = [NSMutableArray array];
    
    [self getData];
    [self initTableView];
    [self initButtonView];

}

-(void)getData
{
    mainModel = [[CAEvaluateMainModel alloc]init];
    ClassAttendanceNetHelper *helper = [ClassAttendanceNetHelper new];
    [helper getEvaluationItemAndRecordWithAttendanceId:self.attendanceId studentId:self.studentId andResult:^(BOOL successful, CAEvaluateMainModel *dataModel) {
        mainModel = dataModel;
        [_mainTableView reloadData];
    }];
    
}


#pragma mark - initView
-(void)initTableView
{
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.rowHeight = 60;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = NO;
//    _mainTableView.bounces = NO;
    self.view.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
    _mainTableView.backgroundColor = [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1];
}

-(void)initButtonView
{
    NSInteger halfPoint = [UIScreen mainScreen].bounds.size.width / 2;
    
    NSInteger halfOfhalfPoint = [UIScreen mainScreen].bounds.size.width / 4;
    
    _AddScoreButton.frame = CGRectMake(0, 8, halfPoint, 50);
    _DisScoreButton.frame = CGRectMake(halfPoint, 8, halfPoint, 50);
    
    _AddScoreLineView.frame = CGRectMake(halfOfhalfPoint / 2, 56, halfOfhalfPoint, 2);
    _DisScoreLineView.frame = CGRectMake(halfOfhalfPoint * 3 - halfOfhalfPoint / 2, 56, halfOfhalfPoint, 2);
}


#pragma mark - Tableview Datasource & Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *iden = @"CAEvaluateItemCell";
        
        CAEvaluateItemCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CAEvaluateItemCell" owner:self options:nil].firstObject;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:iden];
        }
        if (isAddItem) {
            cell.model = mainModel.bonusPointListModelArray[indexPath.row];
        }else
        {
            cell.model = mainModel.deductionListModelArray[indexPath.row];
            CAEvaluateItemModel *itemModel = mainModel.deductionListModelArray[indexPath.row];
            cell.itemNumberButtonView.currentNumber = [itemModel.defaultNum integerValue];
        }
        cell.delegate = self;
        return cell;
    }
    else
    {
        static NSString *idenn = @"CAEvaluateListCell";
        
        CAEvaluateItemCell *cell = [[NSBundle mainBundle]loadNibNamed:@"CAEvaluateListCell" owner:self options:nil].firstObject;
        if (!cell) {
            cell = [tableView dequeueReusableCellWithIdentifier:idenn];
        }
        cell.model = mainModel.recordModel.detailListListModelArray[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
//    CAEvaluateItemCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.itemSelectButton.isSelected?[needSubmitModelArray addObject:cell.model]:[needSubmitModelArray removeObject:cell.model];
//    
//    if (needSubmitModelArray.count) {
//        _submitButton.hidden = NO;
//    }else _submitButton.hidden = YES;
//    
//    
//    [cell.itemSelectButton setSelected:!cell.itemSelectButton.isSelected];
//    
//    cell.itemSelectButton.isSelected?[cell.itemSelectButton setImage:[UIImage imageNamed:@"CA_radio"] forState:UIControlStateSelected]:[cell.itemSelectButton setImage:[UIImage imageNamed:@"CA_radio_nor"] forState:UIControlStateNormal];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (isAddItem) {
            return mainModel.bonusPointListModelArray.count;
        }
        else
        {
            return mainModel.deductionListModelArray.count;
        }
    }
    else
    return mainModel.recordModel.detailListListModelArray.count;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (mainModel.recordModel.detailListListModelArray.count > 0) {
        return 2;
    }
    else
    return 1;
}

//HeaderView

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        headerviewItem = [[CAEvaluateItemHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        headerviewItem.switchButton.delegate = self;
        headerviewItem.isAddItem = isAddItem;
        [headerviewItem.switchButton setOn:isAddItem animated:NO];
        return headerviewItem;
    }
    else
    {
        headerViewList = [[CAEvaluateListHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
        headerViewList.minusScore = mainModel.recordModel.minusScore;
        headerViewList.addScore = mainModel.recordModel.addScore;
        return headerViewList;
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}



-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


#pragma mark - CAEvaluateItemCellDelegate
//选择框事件
- (void)itemSelectButtonClicked:(CAEvaluateItemCell *)cell
{
    cell.itemSelectButton.isSelected?[needSubmitModelArray addObject:cell.model]:[needSubmitModelArray removeObject:cell.model];
    
    if (needSubmitModelArray.count) {
        _submitButton.hidden = NO;
    }else _submitButton.hidden = YES;
}

#pragma mark - CAEvaluateListCellDelegate
//删除按钮事件
- (void)itemDelButtonClicked:(CAEvaluateListCell *)cell
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认删除该条记录吗?" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        ClassAttendanceNetHelper *helper = [[ClassAttendanceNetHelper alloc]init];
        [helper delEvaluationItemAndRecordWithItemId:cell.model.itemId andResult:^(BOOL successful) {
            if (successful) {
                [self.view makeToast:@"删除该条记录成功" duration:1.0 position:CSToastPositionCenter];
                [self getData];
            }
            else [self.view makeToast:@"删除该条记录失败" duration:1.0 position:CSToastPositionCenter];
        }];
        
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alertController addAction:noAction];
    [alertController addAction:yesAction];
    
    [self presentViewController:alertController animated:yesAction completion:nil];
}

#pragma mark - LLSwitchDelegate
//switch状态切换
- (void)valueDidChanged:(LLSwitch *)llSwitch on:(BOOL)on
{
    isAddItem = on;
    [_mainTableView reloadData];
    needSubmitModelArray = [NSMutableArray array];
}

#pragma mark - ButtonClicked

- (IBAction)addScoreAction:(id)sender {
    [_AddScoreButton setTitleColor:[UIColor colorWithRed:24 / 255.0 green:182 / 255.0 blue:152 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_DisScoreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    _AddScoreLineView.hidden = NO;
    _DisScoreLineView.hidden = YES;
    
    isAddItem = YES;
    [_mainTableView reloadData];
    needSubmitModelArray = [NSMutableArray array];
    
}
- (IBAction)disScoreAction:(id)sender {
    
    [_AddScoreButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_DisScoreButton setTitleColor:[UIColor colorWithRed:24 / 255.0 green:182 / 255.0 blue:152 / 255.0 alpha:1] forState:UIControlStateNormal];
    _AddScoreLineView.hidden = YES;
    _DisScoreLineView.hidden = NO;
    
    isAddItem = NO;
    [_mainTableView reloadData];
    needSubmitModelArray = [NSMutableArray array];
    
}


#pragma mark - Private
- (IBAction)submitButtonClicked:(id)sender {
    if (!needSubmitModelArray.count) {
        [self.view makeToast:@"暂无提交项" duration:1.5 position:CSToastPositionCenter];
        return;
    }
    
    NSMutableDictionary *addDic = [NSMutableDictionary dictionary];
    [addDic setValue:_studentId.length?_studentId:@"" forKey:@"studentId"];
    [addDic setValue:_attendanceId.length?_attendanceId:@"" forKey:@"attendanceId"];
    NSMutableString *addIDString = [NSMutableString string];
    NSMutableString *addScoreString = [NSMutableString string];
    for (CAEvaluateItemModel * model in needSubmitModelArray) {
        [addIDString appendString:[NSString stringWithFormat:@"%@,",model.itemId]];
        [addScoreString appendString:[NSString stringWithFormat:@"%ld,",labs([model.score integerValue]) ]];
    }
    [addDic setValue:addIDString forKey:@"itemIdList"];
    [addDic setValue:addScoreString forKey:@"scoreList"];
    
    ClassAttendanceNetHelper *helper = [[ClassAttendanceNetHelper alloc]init];
    [helper submitEvaluationItemAndRecordSumDic:addDic andResult:^(BOOL successful) {
        
        if (successful) {
            [self getData];
            [self.view makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
            
            needSubmitModelArray = [NSMutableArray array];
            mainModel = [CAEvaluateMainModel new];
        }
        else
        {
             [self.view makeToast:@"提交失败,请重试" duration:1.0 position:CSToastPositionCenter];
        }
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
