//
//  AssetListController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/26.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetListController.h"
#import "TYHContactCell.h"
#import "TYHContactDetailCell.h"
#import "TYHAssetModel.h"
#import "AssetApplyController.h"
#import "AssetSearchConditionController.h"


@interface AssetListController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) BOOL isSelect;
@end

@implementation AssetListController
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
    self.title = @"选择资产类型";
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
        if ([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[AssetListModel class]]) {
            static NSString *iden = @"TYHContactCell";
            TYHContactCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TYHContactCell" owner:self options:nil].firstObject;
            }
            AssetListModel *model = [_assetDatasource objectAtIndex:indexPath.row];
            cell.icon.image = [UIImage imageNamed:@"未展开"];
            if (![_typeString isEqualToString:@"查找"]) {
                cell.titleLabel.text = model.name;
            }
            else
            cell.titleLabel.text = [NSString stringWithFormat:@"%@ [%@]",model.name,model.quantity];
            if (!model.childs)
            cell.icon.hidden = YES;
            else cell.icon.hidden = NO;
            
            return cell;
        }
        else if([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[AssetListDetailsModel class]]){
            TYHContactDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TYHContactDetailCell"];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"TYHContactDetailCell" owner:self options:nil].firstObject;
            }
            
            AssetListDetailsModel *model = [_assetDatasource objectAtIndex:indexPath.row];
            cell.userIcon.layer.masksToBounds = YES;
            cell.userIcon.layer.cornerRadius = cell.userIcon.frame.size.width / 2;
            cell.nameLabel.text = model.assetName;
            
            return cell;
        }
    return [UITableViewCell new];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//        AssetListDetailsModel *usermodel = [_assetDatasource objectAtIndex:indexPath.row];
    
        if ([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[AssetListDetailsModel class]]) {
//            TYHContactDetailCell *cell = (TYHContactDetailCell *)[tableView cellForRowAtIndexPath:indexPath];
            
        }
        TYHContactCell *cell = (TYHContactCell *)[tableView cellForRowAtIndexPath:indexPath];
        AssetListModel *model = [_assetDatasource objectAtIndex:indexPath.row];
        if (model.childs) {
            BOOL isAlreadyInserted = NO;
            for (AssetListModel *contactModel in model.childs) {
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
                for(AssetListModel *dInner in model.childs ) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [_assetDatasource insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
            }
        }
        else
        {
            if ([_typeString isEqualToString:@"查找"]) {
                AssetSearchConditionController *ascView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                ascView.assetArrayWithinChoose = model.assetBrandsArray;
                ascView.assetTypeWithinChooseID = model.contactId;
                ascView.assetTFType.text = [NSString stringWithFormat:@"%@ [%@]",model.name,model.quantity];
                [self.navigationController popToViewController:ascView animated:YES];
            }
            else
            {
                AssetApplyController
                *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
                takeView.TFApplyType.text = model.name;
                takeView.tfApplyTypeIDString = model.contactId;
                [self.navigationController
                 popToViewController:takeView animated:true];
            }
        }
        if (model.userList) {
            BOOL isAlreadyInserted = NO;
            for (AssetListDetailsModel *userModel in model.userList) {
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
                for(AssetListDetailsModel *dInner in model.userList ) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [_assetDatasource insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationNone];
            }
        }
}

-(void)miniMizeThisRows:(NSArray*)ar{
    for (AssetListModel *model in ar) {
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
    for (AssetListModel *model in ar) {
        
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
            if ([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[AssetListModel class]]) {
                AssetListModel *model = [_assetDatasource objectAtIndex:indexPath.row];
                return model.IndentationLevel*1;
            }
            else
            {
                AssetListModel *model = [_assetDatasource objectAtIndex:indexPath.row];
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
        if ([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[AssetListModel class]])
        {
            return 50;
        }
        else if([[_assetDatasource objectAtIndex:indexPath.row] isKindOfClass:[AssetListDetailsModel class]])
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
