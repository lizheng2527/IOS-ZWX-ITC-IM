//
//  WHOutDetailController.m
//  NIM
//
//  Created by 中电和讯 on 2017/4/12.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WHOutDetailController.h"
#import "WHNetHelper.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "WHApplicationDetailItemCell.h"
#import "TYHWarehouseDefine.h"
#import "WHOutModel.h"
#import "NSString+NTES.h"
#import "WHApplicationDetailHeaderView.h"

@interface WHOutDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,retain)WHOutModel *mainModel;

@end

@implementation WHOutDetailController

#pragma mark - viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"申请详情";
    [self initView];
    [self createBarItem];
    
    [self requestData];
}


#pragma mark - initData
-(void)requestData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    WHNetHelper *helper = [WHNetHelper new];
    
    [helper getOutListDetailWithOutID:self.outID.length?self.outID:@"" andStatus:^(BOOL successful, WHOutModel *model) {
        
        self.mainModel = [WHOutModel new];
        self.mainModel = model;
        
        self.outCodeLabel.text = model.code;
        self.outWareHouseLabel.text = model.warehouseName;
        self.outDateLabel.text = model.productDate;
        self.applyKindLabel.text = model.outKindValue;
        self.applyUserLabel.text = model.receiverName;
        
        if (![NSString isBlankString:model.url]) {
            [self.writeBtn setTitle:@"[ 查看签字 ]" forState:UIControlStateNormal];
            [self.writeBtn setTitleColor:[UIColor TabBarColorWarehouse] forState:UIControlStateNormal];
        }
        else
        {
            [self.writeBtn setTitle:@"[ 未签字 ]" forState:UIControlStateNormal];
            [self.writeBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            self.writeBtn.userInteractionEnabled = NO;
        }
        
        [_mainTableView reloadData];
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.topLayout.constant = AdjustHeight + 12;
}

#pragma mark - initView

-(void)initView
{
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.rowHeight = 40;
    _mainTableView.bounces = NO;
    _mainTableView.separatorStyle = NO;
    _mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
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
    
     leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    
    self.navigationItem.leftBarButtonItem =leftItem;
}


#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mainModel.goodsListModelArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden2 = @"WHApplicationDetailItemCell";
    
    
    WHApplicationDetailItemCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"WHApplicationDetailItemCell" owner:self options:nil].firstObject;
    }
    WHOutDetailoodsListModel *model = _mainModel.goodsListModelArray[indexPath.row];
    cell.itemNameLabel.text = model.name;
    cell.itemCountLabel.text = model.count;
    cell.itemPriceLabel.text = model.sum;
    if (indexPath.row % 2 == 1) {
        cell.backgroundColor = [UIColor WarehouseStatisticsColor];
    }
    if (indexPath.row == _mainModel.goodsListModelArray.count - 1 && indexPath.row % 2 == 0) {
        cell.lineLabel.backgroundColor = [UIColor TabBarColorWarehouse];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
        WHApplicationDetailHeaderView *headView = [[WHApplicationDetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 48)];
        return headView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 54;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}


#pragma mark - Actions
-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)LookWriteAction:(id)sender {
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,self.mainModel.url]];
        //设置来源哪一个UIImageView
        [photos addObject:photo];
    brower.photos = photos;
    //3.设置默认显示的图片索引
    brower.currentPhotoIndex = 0;
    
    //4.显示浏览器
    [brower show];
    
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
