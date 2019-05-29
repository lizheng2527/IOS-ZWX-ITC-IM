//
//  WHChooseWareHouseController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/13.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHChooseWareHouseController.h"

#import "TYHContactCell.h"
#import "TYHContactDetailCell.h"
#import "WHAddApplicationDiliverController.h"
#import "WHDiliverController.h"

#import "UserModel.h"
#import "ContactModel.h"
#import "TYHReverseCarController.h"


@interface WHChooseWareHouseController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) BOOL isSelect;

@end

@implementation WHChooseWareHouseController

{
    UITableView *mainTableView;
}
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    [self createBarItem];
    [self setAssetDatasource:_assetDatasource];
    [mainTableView reloadData];
    self.title = self.chooseWareHouseOrDepartment == 1? @"选择出库仓库":@"选择部门";

}

#pragma mark - initData

-(void)setAssetDatasource:(NSMutableArray *)assetDatasource
{
    if (assetDatasource && assetDatasource.count > 0 ) {
        _assetDatasource = [NSMutableArray arrayWithArray:assetDatasource];
    }
    else
        _assetDatasource = [NSMutableArray array];
}

#pragma mark - initView
-(void)initView
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.tableFooterView = [UIView new];
    [self.view addSubview:mainTableView];
}

-(void)createBarItem
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7){
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView Delegate & Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]]) {
        static NSString *iden = @"TYHContactCell";
        TYHContactCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"TYHContactCell" owner:self options:nil].firstObject;
        }
        ContactModel *model = [_assetDatasource objectAtIndex:indexPath.row];
        cell.icon.image = [UIImage imageNamed:@"未展开"];
        if (![_typeString isEqualToString:@"查找"]) {
            cell.titleLabel.text = model.name;
        }
        else
            cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
        if (!model.childs)
            cell.icon.hidden = YES;
        else cell.icon.hidden = NO;
        
        return cell;
    }
    else if([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]){
        TYHContactDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYHContactDetailCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"TYHContactDetailCell" owner:self options:nil].firstObject;
        }
        
        UserModel *model = [_assetDatasource objectAtIndex:indexPath.row];
        cell.userIcon.layer.masksToBounds = YES;
        cell.userIcon.layer.cornerRadius = cell.userIcon.frame.size.width / 2;
        cell.nameLabel.text = model.name;
        return cell;
    }
    return [UITableViewCell new];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //        AssetListDetailsModel *usermodel = [_assetDatasource objectAtIndex:indexPath.row];
    
    if ([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]) {
        //            TYHContactDetailCell *cell = (TYHContactDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
        
    }
    TYHContactCell *cell = (TYHContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    ContactModel *model = [_assetDatasource objectAtIndex:indexPath.row];
    if (model.childs) {
        BOOL isAlreadyInserted = NO;
        for (ContactModel *contactModel in model.childs) {
            NSInteger index = [_assetDatasource indexOfObjectIdenticalTo:contactModel];
            isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(isAlreadyInserted) break;
        }
        if (isAlreadyInserted) {
            cell.icon.image = [UIImage imageNamed:@"未展开"];
            [self miniMizeThisRows:model.childs];
        }else{
            cell.icon.image = [UIImage imageNamed:@"展开"];
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];
            for(ContactModel *dInner in model.childs ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [_assetDatasource insertObject:dInner atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else
    {
        if ([_typeString isEqualToString:@"查找"]) {
            WHAddApplicationDiliverController *ascView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            //1是选择仓库
            if (self.chooseWareHouseOrDepartment == 1) {
                [ascView didselectedPerson:model.contactId name:model.name ];
            }
            else
            {
                //2是选择部门
                [ascView didselectedDepartment:model.contactId DepartmentName:model.name];
            }
            
            [self.navigationController popToViewController:ascView animated:YES];
        }
        else if([_typeString isEqualToString:@"添加"])
        {
            WHDiliverController *ascView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
            //1是选择仓库
            if (self.chooseWareHouseOrDepartment == 1) {
                [ascView didselectedPerson:model.contactId name:model.name goodsCountArray:model.goodsCountArray];
            }
            else
            {
                //2是选择部门
                [ascView didselectedDepartment:model.contactId DepartmentName:model.name];
            }
            [self.navigationController popToViewController:ascView animated:YES];
        }
        if ([_typeString isEqualToString:@"订车"]) {
            TYHReverseCarController *ascView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                [ascView didselectedCarDepartment:model.contactId DepartmentName:model.name ];
            [self.navigationController popToViewController:ascView animated:YES];
        }
        
        
    }
    if (model.userList) {
        BOOL isAlreadyInserted = NO;
        for (UserModel *userModel in model.userList) {
            NSInteger index = [_assetDatasource indexOfObjectIdenticalTo:userModel];
            isAlreadyInserted=(index>0 && index!=NSIntegerMax);
            if(isAlreadyInserted) break;
        }
        if (isAlreadyInserted) {
            cell.icon.image = [UIImage imageNamed:@"未展开"];
            [self miniMizeThisRowsWithUserModel:model.userList];
        }else{
            cell.icon.image = [UIImage imageNamed:@"展开"];
            NSUInteger count=indexPath.row+1;
            NSMutableArray *arCells=[NSMutableArray array];
            for(UserModel *dInner in model.userList ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [_assetDatasource insertObject:dInner atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(void)miniMizeThisRows:(NSArray*)ar{
    for (ContactModel *model in ar) {
        NSUInteger indexToRemove = [_assetDatasource indexOfObjectIdenticalTo:model];
        if (model.userList && model.userList.count > 0) {
            [self miniMizeThisRowsWithUserModel:model.userList];
        }
        if (model.childs && model.childs.count > 0) {
            [self miniMizeThisRows:model.childs];
        }
        if([_assetDatasource indexOfObjectIdenticalTo:model]!=NSNotFound) {
            [_assetDatasource removeObjectIdenticalTo:model];
            [mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                   [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                   ]
                                 withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


-(void)miniMizeThisRowsWithUserModel:(NSArray*)ar{
    for (ContactModel *model in ar) {
        
        NSUInteger indexToRemove = [_assetDatasource indexOfObjectIdenticalTo:model];
        if([_assetDatasource indexOfObjectIdenticalTo:model]!=NSNotFound) {
            [_assetDatasource removeObjectIdenticalTo:model];
            [mainTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                   [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                   ]
                                 withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


//返回行缩进 有三个方法一起配合使用才生效

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]]) {
        ContactModel *model = [_assetDatasource objectAtIndex:indexPath.row];
        return model.IndentationLevel*1;
    }
    else
    {
        ContactModel *model = [_assetDatasource objectAtIndex:indexPath.row];
        return model.IndentationLevel*1 - 1;
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_assetDatasource.count > 0&& _assetDatasource) {
        return _assetDatasource.count;
    }
    else
        return 0;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[ContactModel class]])
    {
        return 50;
    }
    else if([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]])
    {
        return 45;
    }
    else return 0;
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
