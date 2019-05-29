//
//  MRDetailController.m
//  NIM
//
//  Created by 中电和讯 on 17/3/27.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRDetailController.h"

#import "MRADetailCell.h"
#import "TYHRepairNetRequestHelper.h"
#import "MyRepairApplicationModel.h"
#import <UIView+Toast.h>

#import "MRADetailSeviceCell.h"
#import "MRADetailBottomCell.h"
#import "MRADetailUpCell.h"
#import "MRFeedBackScoreCell.h"


#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "UITableView+FDTemplateLayoutCell.h"

@interface MRDetailController ()<UITableViewDelegate,UITableViewDataSource,MRADetailUpCellDelegate,MRADetailBottomCellDelegate,MRFeedBackScoreCellDelegate>

@property(nonatomic,retain)NSMutableArray *leftRepairlDetailArray;
@property(nonatomic,retain)NSMutableArray *rightServerRecordArray;
@end

@implementation MRDetailController
{
    UITableView *mainTableView;
}
#pragma mark - viewDiaLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initView];
    
    [self requestData];
}

#pragma mark - initData
-(void)setViewTag:(NSInteger)viewTag
{
    _viewTag = viewTag;
}

-(void)requestData
{
    [SVProgressHUD showWithStatus:@"正在获取数据"];
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    
    if (self.viewTag == 1001) {
        [helper getMyRepairApplicationDetailWithRepairID:self.repairID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
            _leftRepairlDetailArray = [NSMutableArray arrayWithArray:dataSource];
            [mainTableView reloadData];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            [self.view makeToast:@"获取报修单数据失败" duration:1.5 position:CSToastPositionCenter];
            [SVProgressHUD dismiss];
        }];
    }
    else
    {
        [helper getMyRepairApplicationServerDetailWithRepairID:self.repairID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
            _rightServerRecordArray = [NSMutableArray arrayWithArray:dataSource];
            [mainTableView reloadData];
            [SVProgressHUD dismiss];
        } failure:^(NSError *error) {
            [SVProgressHUD dismiss];
            [self.view makeToast:@"获取维修过程数据失败" duration:1.5 position:CSToastPositionCenter];
        }];
    }
}

#pragma mark - initView
-(void)initView
{
    self.view.backgroundColor = [UIColor whiteColor];
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44 - 70) style:UITableViewStylePlain];
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = NO;
    mainTableView.bounces = NO;
    mainTableView.backgroundColor = [UIColor TabBarColorGray];
    mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    mainTableView.delaysContentTouches =NO;
    [self.view addSubview:mainTableView];
    
    [mainTableView registerNib:[UINib nibWithNibName:@"MRADetailUpCell" bundle:nil] forCellReuseIdentifier:@"MRADetailUpCell"];
    [mainTableView registerNib:[UINib nibWithNibName:@"MRADetailBottomCell" bundle:nil] forCellReuseIdentifier:@"MRADetailBottomCell"];
    
    
}



#pragma mark -tableView Datasource&Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (self.viewTag) {
        case 1001:
        {
            return 1;
        }
            break;
        case 1002:
        {
            return _rightServerRecordArray.count;
        }
            break;
        default:
            return 0;
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewTag == 1001) {
        if (indexPath.section == 0) {
                return [tableView fd_heightForCellWithIdentifier:@"MRADetailUpCell" cacheByIndexPath:indexPath configuration:^(MRADetailUpCell *cell) {
                    // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
                    cell.model = _leftRepairlDetailArray[0];
                }];
        }
        
        else if(indexPath.section == 1)
        {
            
            return [tableView fd_heightForCellWithIdentifier:@"MRADetailBottomCell" cacheByIndexPath:indexPath configuration:^(MRADetailBottomCell *cell) {
                // 配置 cell 的数据源，和 "cellForRow" 干的事一致，比如：
                cell.model = _leftRepairlDetailArray[1];
            }];
            
            
//            MRAServerInfoModel *model = _leftRepairlDetailArray[1];
//            NSInteger addHeight = 0;
//            if (model.goodsSumModelArray.count > 1) {
//                addHeight = (model.goodsSumModelArray.count - 1) * 16;
//            }
//            if (model.repairImageList.count && model.repairImageList.count <= 4) {
//                return 222 + 7.5  + SCREEN_WIDTH / 5 + addHeight;
//            }
//            else if(model.repairImageList.count && model.repairImageList.count > 4) {
//                return 222 + 7.5 + 7.5 + SCREEN_WIDTH / 5 * 2 + addHeight;
//            }
//            else return 222 + addHeight;
        }
        else
        {
            MRAFeedBackInfoModel *model = _leftRepairlDetailArray[2];
            if (model.repairImageList.count && model.repairImageList.count <= 4) {
                return 350 + 7.5  + SCREEN_WIDTH / 5;
            }
            else if(model.repairImageList.count && model.repairImageList.count > 4) {
                return 350 + 7.5 + 7.5 + SCREEN_WIDTH / 5 * 2 ;
            }
            else return 350;
        }
    }
    return 70.f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.viewTag == 1001) {
        return _leftRepairlDetailArray.count;
    }
    return 1;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (self.viewTag) {
        case 1001:
        {
            if (indexPath.section == 0) {
                static NSString *idenSection0 = @"MRADetailUpCell";
                MRADetailUpCell *cell = [tableView dequeueReusableCellWithIdentifier:idenSection0];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"MRADetailUpCell" owner:self options:nil].firstObject;
                }
                cell.delegate = self;
                if (_leftRepairlDetailArray.count) {
                    cell.model = _leftRepairlDetailArray[0];
                }
                return cell;
            }
            else if(indexPath.section == 1)
            {
                static NSString *idenSection1 = @"MRADetailBottomCell";
                MRADetailBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:idenSection1];
                if (!cell) {
                    cell = [[NSBundle mainBundle]loadNibNamed:@"MRADetailBottomCell" owner:self options:nil].firstObject;
                }
                cell.delegate = self;
                if (_leftRepairlDetailArray.count) {
                    cell.model = _leftRepairlDetailArray[1];
                }
                return cell;
            }else
             {
                 static NSString *idenSection2 = @"MRFeedBackScoreCell";
                 MRFeedBackScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:idenSection2];
                 if (!cell) {
                     cell = [[NSBundle mainBundle]loadNibNamed:@"MRFeedBackScoreCell" owner:self options:nil].firstObject;
                 }
                 cell.delegate = self;
                 if (_leftRepairlDetailArray.count) {
                     cell.model = _leftRepairlDetailArray[2];
                 }
                 return cell;
             }
        }
            break;
        case 1002:
        {

            //未接单
            static NSString *iden2 = @"MRADetailSeviceCell";
            MRADetailSeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:iden2];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"MRADetailSeviceCell" owner:self options:nil].firstObject;
            }
            cell.model = _rightServerRecordArray[indexPath.row];
            if (indexPath.row + 1 == _rightServerRecordArray.count) {
                cell.lineLabel.hidden = YES;
            }
            return cell;
        }
            break;
        default:
            return [UITableViewCell new];
            break;
    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < imageViews.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,[imageViews objectAtIndex:i]]];
        //设置来源哪一个UIImageView
        [photos addObject:photo];
    }
    brower.photos = photos;
    //3.设置默认显示的图片索引
    brower.currentPhotoIndex = clickTag - 9999;
    
    //4.显示浏览器
    [brower show];
}


#pragma mark -Actions



#pragma mark -Other
-(void)viewWillAppear:(BOOL)animated
{
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
