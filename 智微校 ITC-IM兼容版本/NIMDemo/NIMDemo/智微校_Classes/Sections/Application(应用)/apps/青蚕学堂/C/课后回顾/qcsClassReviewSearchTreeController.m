//
//  qcsClassReviewSearchTreeController.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/13.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassReviewSearchTreeController.h"

#import "TYHContactCell.h"
#import "TYHContactDetailCell.h"

#import "QCSMainModel.h"

#import "qcsClassReviewSearchController.h"
#import "QCSchoolDefine.h"

@interface qcsClassReviewSearchTreeController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic) BOOL isSelect;

@property(nonatomic,retain)NSMutableArray *chooseArray;

@end

@implementation qcsClassReviewSearchTreeController
#pragma mark - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initView];
    self.title = @"课程选择";
    
    [self getTreeData];
}

#pragma mark - initData
-(void)getTreeData
{
    _itemDatasource = [NSMutableArray arrayWithArray:[QCSSourceHandler getTreeArrayAfterDeal:self.studentCourseArray]];
    [_mainTableview reloadData];
}

#pragma mark - initView
-(void)initView
{
    _chooseArray = [NSMutableArray array];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.tableFooterView = [UIView new];
}



-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - tableView Delegate & Datasource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_itemDatasource objectAtIndex:indexPath.row] isKindOfClass:[JXZTreeMainModel class]]) {
        static NSString *iden = @"TYHContactCell";
        TYHContactCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"TYHContactCell" owner:self options:nil].firstObject;
        }
        ///
        JXZTreeMainModel *model = [_itemDatasource objectAtIndex:indexPath.row];
        cell.titleLabel.text = model.name;
        
        if (!model.childs) {
            cell.icon.hidden = YES;
        }else
        {
            cell.icon.hidden = NO;
        }
        
        return cell;
    }
    else if([[_itemDatasource objectAtIndex:indexPath.row] isKindOfClass:[JXZTreeDetailModel class]]){
        TYHContactDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYHContactDetailCell"];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"TYHContactDetailCell" owner:self options:nil].firstObject;
        }
        
        JXZTreeDetailModel *model = [_itemDatasource objectAtIndex:indexPath.row];
        cell.nameLabel.text = model.name;
        
        
        return cell;
    }
    return [UITableViewCell new];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TYHContactCell *cell = (TYHContactCell *)[tableView cellForRowAtIndexPath:indexPath];
    JXZTreeMainModel *model = [_itemDatasource objectAtIndex:indexPath.row];
    if (model.childs) {
        
        BOOL isAlreadyInserted = NO;
        for (JXZTreeMainModel *contactModel in model.childs) {
            NSInteger index = [_itemDatasource indexOfObjectIdenticalTo:contactModel];
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
            for(JXZTreeMainModel *dInner in model.childs ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [_itemDatasource insertObject:dInner atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else
    {

        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[qcsClassReviewSearchController class]]) {
                qcsClassReviewSearchController *currentController = (qcsClassReviewSearchController *)controller;
                currentController.chooseCourseID = model.contactId;
                currentController.chooseEclassID = model.parentMobileID;
                currentController.chooseName = model.name;
                [currentController.chooseClassButton setTitle:model.name forState:UIControlStateNormal];
                [self.navigationController popToViewController:currentController animated:YES];
            }
        }
        
        
        //            AssetApplyController
        //            *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        //            takeView.TFApplyType.text = model.name;
        //            takeView.tfApplyTypeIDString = model.contactId;
        //            [self.navigationController
        //             popToViewController:takeView animated:true];
    }
    if (model.userList) {
        BOOL isAlreadyInserted = NO;
        for (JXZTreeDetailModel *userModel in model.userList) {
            NSInteger index = [_itemDatasource indexOfObjectIdenticalTo:userModel];
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
            for(JXZTreeDetailModel *dInner in model.userList ) {
                [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                [_itemDatasource insertObject:dInner atIndex:count++];
            }
            [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

-(void)miniMizeThisRows:(NSArray*)ar{
    for (JXZTreeMainModel *model in ar) {
        NSUInteger indexToRemove = [_itemDatasource indexOfObjectIdenticalTo:model];
        if (model.userList && model.userList.count > 0) {
            [self miniMizeThisRowsWithUserModel:model.userList];
        }
        if (model.childs && model.childs.count > 0) {
            [self miniMizeThisRows:model.childs];
        }
        if([_itemDatasource indexOfObjectIdenticalTo:model]!=NSNotFound) {
            [_itemDatasource removeObjectIdenticalTo:model];
            [_mainTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


-(void)miniMizeThisRowsWithUserModel:(NSArray*)ar{
    for (JXZTreeMainModel *model in ar) {
        
        NSUInteger indexToRemove = [_itemDatasource indexOfObjectIdenticalTo:model];
        if([_itemDatasource indexOfObjectIdenticalTo:model]!=NSNotFound) {
            [_itemDatasource removeObjectIdenticalTo:model];
            [_mainTableview deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


//返回行缩进 有三个方法一起配合使用才生效

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_itemDatasource objectAtIndex:indexPath.row] isKindOfClass:[JXZTreeMainModel class]]) {
        JXZTreeMainModel *model = [_itemDatasource objectAtIndex:indexPath.row];
        return model.IndentationLevel*1;
    }
    else
    {
        JXZTreeMainModel *model = [_itemDatasource objectAtIndex:indexPath.row];
        return model.IndentationLevel*1 - 1;
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_itemDatasource.count > 0&& _itemDatasource) {
        return _itemDatasource.count;
    }
    else
        return 0;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[_itemDatasource objectAtIndex:indexPath.row] isKindOfClass:[JXZTreeMainModel class]])
    {
        return 45;
    }
    else if([[_itemDatasource objectAtIndex:indexPath.row] isKindOfClass:[JXZTreeDetailModel class]])
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
