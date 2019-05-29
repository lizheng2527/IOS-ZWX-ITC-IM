//
//  AttendanceRemarkController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/11/7.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AttendanceRemarkController.h"
#import "AttendanceRemarkCell.h"
#import "AttendanceRemarkAddRowFooterView.h"
#import "AttendanceModel.h"
#import "AttendanceNetHelper.h"
#import "SGPopSelectView.h"
#import <UIView+Toast.h>
#import "NSString+Empty.h"


@interface AttendanceRemarkController ()<UITableViewDelegate,UITableViewDataSource,AttendanceFooterViewDelegate,AttendanceRemarkCellDelegate,UITextFieldDelegate>
@property(nonatomic,retain)SGPopSelectView *popView;

@end

@implementation AttendanceRemarkController
{
    NSString *haveSummit;
    NSMutableArray *itemArray;
    AttendanceRemarkModel *remarkModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
    [self createBarItem];
    [self initView];
    self.title = @"外勤备注";
    _popView = [[SGPopSelectView alloc]init];
}

-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取备注信息中";
    
    AttendanceNetHelper *helper = [AttendanceNetHelper new];
    [helper getCostInfoWithStatus:^(BOOL successful, AttendanceRemarkModel *remarkBlockModel) {
        remarkModel = [AttendanceRemarkModel new];
        remarkModel = remarkBlockModel;
        itemArray = [NSMutableArray arrayWithArray:remarkModel.costModelArray];
        [_mainTableView reloadData];
        if ([remarkBlockModel.status isEqualToString:@"1"]) {
            [self YesBtnClickAction:nil];
        }
        _textView.text = remarkModel.remark;
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
}


#pragma mark - Tableview Datasource & Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"cell";
    AttendanceRemarkCostModel *model = itemArray[indexPath.row];
    AttendanceRemarkCell *cell = [[NSBundle mainBundle]loadNibNamed:@"AttendanceRemarkCell" owner:self options:nil].firstObject;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:iden];
    }
    cell.delegate = self;
    
    cell.moneyTextField.text = model.cost;
    cell.moneyTextField.delegate = self;
    cell.moneyTextField.tag = indexPath.row + 10000;
    [cell.useageBtn setTitle:model.name forState:UIControlStateNormal];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (itemArray.count == 0) {
        return 0;
    }else
    return itemArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    AttendanceRemarkAddRowFooterView *footerView = [[AttendanceRemarkAddRowFooterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footerView.delegate = self;
    return footerView;
}



#pragma mark -footerView && RemarkCell Delegate
-(void)remarkItemAdd
{
    AttendanceRemarkCostModel *model = [AttendanceRemarkCostModel new];
    model.cost = @"";
    model.name = @"";
    [itemArray addObject:model];
    [_mainTableView reloadData];
}

-(void)remarkItemDelete:(AttendanceRemarkCell *)cell
{
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    [itemArray removeObjectAtIndex:indexPath.row];
//    NSLog(@"%d",indexPath.row);
    [_mainTableView reloadData];
}

-(void)typeBtnChoose:(AttendanceRemarkCell *)cell
{
    NSIndexPath *indexPath = [_mainTableView indexPathForCell:cell];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (AttendanceRemarkCostModel *model in remarkModel.costTypeModelArray ) {
        [tmpArray addObject:[NSString stringWithFormat:@"%@              ",model.name]];
    }
    __block AttendanceRemarkController *blockSelf = self;
    self.popView.selections = tmpArray;
    self.popView.locationString = @"用途";
    self.popView.selectedHandle = ^(NSInteger selectedIndex){
        
        
        [cell.useageBtn setTitle:[NSString stringWithFormat:@"%@",[tmpArray[selectedIndex] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]] forState:UIControlStateNormal];
        AttendanceRemarkCostModel *model =  itemArray[indexPath.row];
        model.name = [NSString stringWithFormat:@"%@",[tmpArray[selectedIndex] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
        for (AttendanceRemarkCostModel *tmpModel in remarkModel.costTypeModelArray) {
            if ([model.name isEqualToString:tmpModel.name]) {
                model.code = tmpModel.code;
            }
        }
        [blockSelf.popView hide:NO];
    };
    
    CGPoint p = CGPointMake(self.view.center.x, self.view.center.y - 64);
    self.popView.frame =CGRectMake(0, 0, 100, self.popView.frame.size.height);
    [self.popView showFromView:self.view atPoint:p animated:YES];
    self.popView.center = p;
}

#pragma mark - initView
-(void)initView
{
    itemArray = [NSMutableArray array];
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.hidden = YES;
    _mainTableView.rowHeight = 50.0f;
    
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 3.0f;
    _textView.layer.borderWidth = 0.5f;
    _textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UITapGestureRecognizer *gesYes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(YesBtnClickAction:)];
    UITapGestureRecognizer *gesNo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(NoBtnClickAction:)];
    _yesLabel.userInteractionEnabled = YES;
    _noLabel.userInteractionEnabled = YES;
    [_yesLabel addGestureRecognizer:gesYes];
    [_noLabel addGestureRecognizer:gesNo];
}

-(void)createBarItem
{
    UIBarButtonItem *
    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    //设置字体为加粗的12号系统字，自己也可以随便设置。
    [barItemInNavigationBarAppearanceProxy
     setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    UIBarButtonItem * leftItem = nil;
    UIBarButtonItem * rightItem = nil;
    leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"提交" style:UIBarButtonItemStyleDone target:self
                                               action:@selector(submitAction:)];
    
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem =rightItem;
}

-(void)initPopSelectView
{
//    __block AttendanceRemarkController *blockSelf = self;
    
//    CGPoint p = [(UIButton *)button center];
//    [self.popView showFromView:self.view atPoint:p animated:YES];
//    self.popView.center = self.locationClickBtn.center;
}

#pragma mark - BtnClickActions

-(void)returnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)submitAction:(id)sender
{
    [self.view endEditing:YES];
    
    for (AttendanceRemarkCostModel *model in itemArray) {
        if ([NSString isBlankString:model.cost]) {
            [self.view makeToast:@"有报销项未填写金额" duration:1.5 position:nil];
            return;
        }
        else if([NSString isBlankString:model.name])
        {
            [self.view makeToast:@"有报销项未选择用途" duration:1.5 position:nil];
            return;
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"正在提交中";
    
    NSMutableString *coustString = [NSMutableString string];
    NSMutableString *codeString = [NSMutableString string];
    for (AttendanceRemarkCostModel *model in itemArray) {
        [coustString appendFormat:@"%@,",model.cost];
        [codeString appendFormat:@"%@,",model.code];
    }
    
    AttendanceNetHelper *helper = [AttendanceNetHelper new];
    [helper saveRemarkItemsWithRemarkText:_textView.text CoustType:codeString Coust:coustString andStatus:^(BOOL successful) {
        if (successful) {
            [self.view makeToast:@"提交成功" duration:1 position:nil];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }else
            [self.view makeToast:@"提交失败" duration:1 position:nil];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)NoBtnClickAction:(id)sender {
    [_yesBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_noBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    haveSummit = @"无";
    _mainTableView.hidden = YES;
}

- (IBAction)YesBtnClickAction:(id)sender {
    [_noBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [_yesBtn setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    haveSummit = @"有";
    _mainTableView.hidden = NO;
}



#pragma mark - Other
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    
//    [textField resignFirstResponder];
    for (int i = 0; i < itemArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        AttendanceRemarkCostModel * model = itemArray[indexPath.row];
        NSInteger tag = indexPath.row + 10000;
        if (tag == textField.tag) {
            NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
            model.cost = toBeString;
        }
        
        NSInteger loca = [textField.text rangeOfString:@"."].location;
        if (loca+2<textField.text.length&&loca>0) {
            textField.text = [textField.text substringToIndex:loca+2];
        }
        if (textField.text.length >= 9) {
            textField.text = [textField.text substringToIndex:9];
        }
    }
    return YES;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xff4c4c4c)];
    [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorGreen]];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self.popView hide:NO];
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
