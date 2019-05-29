//
//  TYHMessageListController.m
//  NIM
//
//  Created by 中电和讯 on 2018/12/4.
//  Copyright © 2018 Netease. All rights reserved.
//

#import "TYHMessageListController.h"
#import "NoticeCell.h"

#import "SSChatController.h"
#import "Define.h"
#import "UIView+SSAdd.h"
#import "SSChatHandler.h"
#import "SSChatModel.h"
#import <UIImageView+WebCache.h>
#import "LYEmptyViewHeader.h"
#import <MJRefresh.h>
#import "SSChatDatas.h"


@interface TYHMessageListController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *mTableView;
@property(nonatomic,strong)NSMutableArray *datas;

@property(nonatomic,assign)NSInteger pageNum;
@end

@implementation TYHMessageListController

-(instancetype)init{
    if(self = [super init]){
        _datas = [NSMutableArray new];
//        [_datas addObjectsFromArray:@[@{@"image":@"icon_shuru",//头像
//                                        @"title":@"用户1",
//                                        @"detail":@"我勒个去???？",
//                                        @"sectionId":@"13540033103",
//                                        @"type":@"1"
//                                        },
//                                      @{@"image":@"icon_yuying",//头像
//                                        @"title":@"用户2",
//                                        @"detail":@"啊哈?",
//                                        @"sectionId":@"13540033104",
//                                        @"type":@"1"
//                                        }]];
    }
    return self;
}

-(void)getChatPageList
{
    _pageNum = 1;
    [SVProgressHUD show];
    SSChatHandler *handler = [[SSChatHandler alloc]init];
    [handler getChatListWithUserID:@"nil" PageNum:@"1" andStatus:^(BOOL successful, NSMutableArray *chatArray) {
        [SVProgressHUD dismiss];
        
        _datas = [NSMutableArray arrayWithArray:chatArray];
        [_mTableView reloadData];
        [_mTableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [_mTableView.mj_header endRefreshing];
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
    }];
}

-(void)getMoreChatPageList
{
    _pageNum++;
    
    SSChatHandler *handler = [[SSChatHandler alloc]init];
    [handler getChatListWithUserID:@"nil" PageNum:[NSString stringWithFormat:@"%lu",_pageNum] andStatus:^(BOOL successful, NSMutableArray *chatArray) {
        
        [_datas addObjectsFromArray:chatArray];
        [_mTableView reloadData];
        [_mTableView.mj_footer endRefreshing];
        if (!chatArray.count) {
            _pageNum --;
            [self.view makeToast:@"暂无更多数据" duration:1.5 position:CSToastPositionCenter];
        }
    } failure:^(NSError *error) {
        _pageNum --;
        [_mTableView.mj_footer endRefreshing];
        [self.view makeToast:@"暂无更多数据" duration:1.5 position:CSToastPositionCenter];
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"留言列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect rect = CGRectMake(0, SafeAreaTop_Height, SCREEN_Width, SCREEN_Height-SafeAreaTop_Height-SafeAreaBottom_Height);
    
    _mTableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
//    _mTableView.separatorStyle = UITableViewCellEditingStyleNone;
    _mTableView.backgroundColor = SSChatCellColor;
    _mTableView.backgroundView.backgroundColor = SSChatCellColor;
    [self.view addSubview:self.mTableView];
    _mTableView.rowHeight = 70;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    _mTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    
    _mTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _mTableView.scrollIndicatorInsets = _mTableView.contentInset;
    if (@available(iOS 11.0, *)){
        _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
    }
    
    _mTableView.tableFooterView = [UIView new];
    
    _mTableView.ly_emptyView = [LYEmptyView emptyViewWithImageStr:@"noData"
                                                             titleStr:@"暂无留言消息"
                                                            detailStr:@""];
    

    
    _mTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getMoreChatPageList];
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"noticeCell"];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"NoticeCell" owner:self options:nil].firstObject;
    }
    
    SSChatListModel *model = _datas[indexPath.row];
    
    [cell.logImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,model.photoUrl ]] placeholderImage:[UIImage imageNamed:@"mk-photo"]];
    cell.sendUserLabel.text = model.userName;
    cell.titleLabel.attributedText = model.attContent;
//    cell.timeLabel.text =model.sendTime;
    cell.timeLabel.text = [NSTimer getChatTimeStr:[NSTimer getStampWithTime:model.sendTime]];
    
    cell.readImg.hidden = ![model.count intValue];
    cell.lineImageView.hidden = YES;
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId"];
//    if(!cell){
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellId"];
//        cell.textLabel.font = [UIFont systemFontOfSize:18];
//        cell.textLabel.textColor = [UIColor blackColor];
//        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
//        cell.detailTextLabel.textColor = [UIColor grayColor];
//    }
//    cell.imageView.image = [UIImage imageNamed:_datas[indexPath.row][@"image"]];
//    cell.textLabel.text = _datas[indexPath.row][@"title"];
//    cell.detailTextLabel.text = _datas[indexPath.row][@"detail"];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SSChatListModel *model = _datas[indexPath.row];
    SSChatController *vc = [SSChatController new];
    vc.chatType = 1;
    
    vc.sessionId = model.friendId;
    vc.titleString = model.userName;
    vc.receiverID = model.friendId;
    vc.receiverHeadIconURL = model.photoUrl;
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}




- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillLayoutSubviews];
    
//    _mTableView.contentInset = UIEdgeInsetsZero;
//
    
    _mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self getChatPageList];
    }];
    [_mTableView.mj_header beginRefreshing];
    
}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//
//}

@end
