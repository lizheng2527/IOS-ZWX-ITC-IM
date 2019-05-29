//
//  SSChatController.m
//  SSChatView
//
//  Created by soldoros on 2018/9/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

//if (IOS7_And_Later) {
//    self.automaticallyAdjustsScrollViewInsets = NO;
//}

#import "SSChatController.h"
#import "SSChatKeyBoardInputView.h"
#import "SSAddImage.h"
#import "SSChatBaseCell.h"
#import "SSChatLocationController.h"
#import "SSImageGroupView.h"
#import "SSChatMapController.h"
#import "NTESPersonalCardViewController.h"
#import "SSChatHandler.h"
#import "SSChatModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>

#define pageCount 15
@interface SSChatController ()<SSChatKeyBoardInputViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SSChatBaseCellDelegate>

//承载表单的视图 视图原高度
@property (strong, nonatomic) UIView    *mBackView;
@property (assign, nonatomic) CGFloat   backViewH;

//表单
@property(nonatomic,strong)UITableView *mTableView;
@property(nonatomic,strong)NSMutableArray *datas;

@property(nonatomic,strong)NSMutableArray *chatDataArray;

//底部输入框 携带表情视图和多功能视图
@property(nonatomic,strong)SSChatKeyBoardInputView *mInputView;

//访问相册 摄像头
@property(nonatomic,strong)SSAddImage *mAddImage;

@property(nonatomic,retain)SSChatHandler *handler;

@property(nonatomic,assign)NSInteger pageNum;
@end

@implementation SSChatController

-(instancetype)init{
    if(self = [super init]){
        _chatType = SSChatConversationTypeChat;
        _datas = [NSMutableArray new];
        _chatDataArray = [NSMutableArray array];
        _pageNum = 1;
    }
    
    return self;
}

//不采用系统的旋转
- (BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _titleString;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _handler = [[SSChatHandler alloc]init];
    
    _mInputView = [SSChatKeyBoardInputView new];
    _mInputView.delegate = self;
    [self.view addSubview:_mInputView];
    
    _backViewH = SCREEN_Height-SSChatKeyBoardInputViewH-SafeAreaTop_Height-SafeAreaBottom_Height;
    
    _mBackView = [UIView new];
    _mBackView.frame = CGRectMake(0, SafeAreaTop_Height, SCREEN_Width, _backViewH);
    _mBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mBackView];
    
    _mTableView = [[UITableView alloc]initWithFrame:_mBackView.bounds style:UITableViewStylePlain];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    _mTableView.backgroundColor = SSChatCellColor;
    _mTableView.backgroundView.backgroundColor = SSChatCellColor;
    [_mBackView addSubview:self.mTableView];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    _mTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _mTableView.scrollIndicatorInsets = _mTableView.contentInset;
    if (@available(iOS 11.0, *)){
        _mTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mTableView.estimatedRowHeight = 0;
        _mTableView.estimatedSectionHeaderHeight = 0;
        _mTableView.estimatedSectionFooterHeight = 0;
    }
    
    [_mTableView registerClass:NSClassFromString(@"SSChatTextCell") forCellReuseIdentifier:SSChatTextCellId];
    [_mTableView registerClass:NSClassFromString(@"SSChatImageCell") forCellReuseIdentifier:SSChatImageCellId];
    [_mTableView registerClass:NSClassFromString(@"SSChatVoiceCell") forCellReuseIdentifier:SSChatVoiceCellId];
    [_mTableView registerClass:NSClassFromString(@"SSChatMapCell") forCellReuseIdentifier:SSChatMapCellId];
    [_mTableView registerClass:NSClassFromString(@"SSChatVideoCell") forCellReuseIdentifier:SSChatVideoCellId];
    
    __weak typeof(self) weakSelf = self;
    
    //单聊
    if(_chatType == SSChatConversationTypeChat){
        [_handler getMessageListWithUserID:_receiverID PageNum:@"0" andStatus:^(BOOL successful, NSMutableArray *chatArray) {
            NSLog(@"123");
            
            [_chatDataArray addObjectsFromArray:chatArray];
            [weakSelf.datas addObjectsFromArray:[SSChatDatas LoadingMessagesStartWithChatArray:chatArray SessionId:_receiverID]];
            [weakSelf.mTableView reloadData];
            if (weakSelf.datas.count) {
                NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:weakSelf.datas.count-1 inSection:0];
                [weakSelf.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            }
        } failure:^(NSError *error) {
        }];
//        [_datas addObjectsFromArray:[SSChatDatas LoadingMessagesStartWithChat:_sessionId]];
    }
    //群聊
    else{
        [_datas addObjectsFromArray:[SSChatDatas LoadingMessagesStartWithGroupChat:_sessionId]];
    }
    
    [_mTableView reloadData];
    
    
    //设置已读
    if (_receiverID.length) {
        [_handler setMessageReadWithReceiverID:_receiverID andStatus:^(BOOL successful, NSMutableArray *chatArray) {
        } failure:^(NSError *error) {
        }];
    }
    
    
    _mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self getMoreData];
    }];
//    [_mTableView.mj_header beginRefreshing];
}



-(void)getMoreData
{
    
    _pageNum++;
    __weak typeof(self) weakSelf = self;
    
    [_mTableView.mj_header beginRefreshing];
    
    //单聊
    if(_chatType == SSChatConversationTypeChat){
        [_handler getMessageListWithUserID:_receiverID PageNum:[NSString stringWithFormat:@"%lu",_pageNum] andStatus:^(BOOL successful, NSMutableArray *chatArray) {
            
            
            //先把新的数据添加到数组tempDataArray里
            NSMutableArray *tempDataArray = [NSMutableArray array];
            [tempDataArray addObjectsFromArray:[SSChatDatas LoadingMessagesStartWithChatArray:chatArray SessionId:_receiverID]];
            
            //把数据源中已经存在的数据再次加入tempDataArray。
            if (_datas.count) {
                [tempDataArray addObjectsFromArray:_datas];
            }
            if(!chatArray.count)
            {
                _pageNum--;
            }
            
            _datas = [NSMutableArray arrayWithArray:tempDataArray];
            
            if (_datas.count > pageCount) {
                //根据当前请求的数据的个数，找到indexPath
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:chatArray.count  inSection:0];
                //先刷新 tableView，再次执行 scrollTo 方法 这点很重要。
                //注意 UITableViewScrollPositionTop 参数的设置
                [_mTableView reloadData];
                [_mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }else{
                //如果是第一个请求，默认滚动到最底部, 注意容错处理。
                [_mTableView reloadData];
                [self tableViewScrollToBottom];
            }
            
            [_mTableView.mj_header endRefreshing];
        } failure:^(NSError *error) {
            _pageNum --;
            [_mTableView.mj_header endRefreshing];
        }];
    }
    
}

- (void)tableViewScrollToBottom
{
    if (self.datas.count==0)
    { return; }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_datas.count-1 inSection:0];
    [_mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _datas.count==0?0:1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datas.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [(SSChatMessagelLayout *)_datas[indexPath.row] cellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SSChatMessagelLayout *layout = _datas[indexPath.row];
    SSChatBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:layout.message.cellString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.layout = layout;
    return cell;
}


//视图归位
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_mInputView SetSSChatKeyBoardInputViewEndEditing];
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_mInputView SetSSChatKeyBoardInputViewEndEditing];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillLayoutSubviews];
//    self.navigationController.navigationBar.translucent = YES;
    _mTableView.contentInset = UIEdgeInsetsZero;
    _mTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DealNotificationUserInfo:) name:@"MessageNotification" object:nil];
}

-(void)DealNotificationUserInfo:(NSNotification *)userInfo
{
    NSDictionary *userInfoDic = [NSDictionary dictionaryWithDictionary:userInfo.object];
    
//    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:nil, nil];
//        [alert show];
    
    
    if (userInfoDic.allKeys) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:[userInfoDic objectForKey:@"aps"]];
        NSString *strrrr = [dic objectForKey:@"sound"];
        NSDictionary *dictemp = [self dictionaryWithJsonString:strrrr];
        
        
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictemp
//                                                           options:NSJSONWritingPrettyPrinted
//                                                             error:nil];
//
//        NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:str delegate:nil cancelButtonTitle:@"yes" otherButtonTitles:nil, nil];
//        [alert show];
        
        
        SSChatMessageModel *model =[SSChatMessageModel new];

        model.id = [dictemp objectForKey:@"id"];
//        NSString *code = [[dic objectForKey:@"alert"] objectForKey:@"code"];
        model.sendTime = [dictemp objectForKey:@"sendTime"];
        model.sendUserId = [dictemp objectForKey:@"sendUserId"];
//        model.content = [dictemp objectForKey:@"content"];
        model.content = [dic objectForKey:@"alert"];
        model.kind = @"0";
        model.photoUrl = _receiverHeadIconURL.length?_receiverHeadIconURL:@"";
        
        NSMutableArray *chatArray = [NSMutableArray arrayWithObjects:model, nil];

        if ([model.sendUserId isEqualToString:_receiverID]) {

            [self.datas addObjectsFromArray:[SSChatDatas LoadingMessagesStartWithChatArray:chatArray SessionId:_receiverID]];
            [self.mTableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
            [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        }
    }
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err)
    {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:@"MessageNotification"];
}


#pragma SSChatKeyBoardInputViewDelegate 底部输入框代理回调
//点击按钮视图frame发生变化 调整当前列表frame
-(void)SSChatKeyBoardInputViewHeight:(CGFloat)keyBoardHeight changeTime:(CGFloat)changeTime{
 
    CGFloat height = _backViewH - keyBoardHeight;
    [UIView animateWithDuration:changeTime animations:^{
        self.mBackView.frame = CGRectMake(0, SafeAreaTop_Height, SCREEN_Width, height);
        self.mTableView.frame = self.mBackView.bounds;
        if (_datas.count) {
            NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
            [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    } completion:^(BOOL finished) {
        
    }];
    
}


//发送文本 列表滚动至底部
-(void)SSChatKeyBoardInputViewBtnClick:(NSString *)string{
    
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"text":string};
    
//    [weakSelf sendMessage:dic messageType:SSChatMessageTypeText];
    
    [_handler sendMessageWithContent:string ReceiveID:_receiverID andStatus:^(BOOL successful, NSMutableArray *chatAray) {
        [weakSelf sendMessage:dic messageType:SSChatMessageTypeText];
    } failure:^(NSError *error) {
        [weakSelf.view makeToast:@"留言发送失败" duration:2 position:CSToastPositionCenter];
    }];
    
}


//发送语音
-(void)SSChatKeyBoardInputViewBtnClick:(SSChatKeyBoardInputView *)view sendVoice:(NSData *)voice time:(NSInteger)second{

    NSDictionary *dic = @{@"voice":voice,
                          @"second":@(second)};
    [self sendMessage:dic messageType:SSChatMessageTypeVoice];
}


//多功能视图点击回调  图片10  视频11  位置12
-(void)SSChatKeyBoardInputViewBtnClickFunction:(NSInteger)index{
    
    if(index==10 || index==11){
        if(!_mAddImage) _mAddImage = [[SSAddImage alloc]init];

        [_mAddImage getImagePickerWithAlertController:self modelType:SSImagePickerModelImage + index-10 pickerBlock:^(SSImagePickerWayStyle wayStyle, SSImagePickerModelType modelType, id object) {
            
            if(index==10){
                UIImage *image = (UIImage *)object;
                NSLog(@"%@",image);
                NSDictionary *dic = @{@"image":image};
                [self sendMessage:dic messageType:SSChatMessageTypeImage];
            }
            
            else{
                NSString *localPath = (NSString *)object;
                NSLog(@"%@",localPath);
                NSDictionary *dic = @{@"videoLocalPath":localPath};
                [self sendMessage:dic messageType:SSChatMessageTypeVideo];
            }
        }];
        
    }else{
        SSChatLocationController *vc = [SSChatLocationController new];
        vc.locationBlock = ^(NSDictionary *locationDic, NSError *error) {
            [self sendMessage:locationDic messageType:SSChatMessageTypeMap];
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}


//发送消息
-(void)sendMessage:(NSDictionary *)dic messageType:(SSChatMessageType)messageType{

    [SSChatDatas sendMessage:dic sessionId:_sessionId messageType:messageType messageBlock:^(SSChatMessagelLayout *layout, NSError *error, NSProgress *progress) {
        
        [self.datas addObject:layout];
        [self.mTableView reloadData];
        NSIndexPath *indexPath = [NSIndexPath     indexPathForRow:self.datas.count-1 inSection:0];
        [self.mTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        
    }];
}


#pragma SSChatBaseCellDelegate 点击图片 点击短视频
-(void)SSChatImageVideoCellClick:(NSIndexPath *)indexPath layout:(SSChatMessagelLayout *)layout{
    
    NSInteger currentIndex = 0;
    NSMutableArray *groupItems = [NSMutableArray new];
    
    for(int i=0;i<self.datas.count;++i){
        
        NSIndexPath *ip = [NSIndexPath indexPathForRow:i inSection:0];
        SSChatBaseCell *cell = [_mTableView cellForRowAtIndexPath:ip];
        SSChatMessagelLayout *mLayout = self.datas[i];
        
        SSImageGroupItem *item = [SSImageGroupItem new];
        if(mLayout.message.messageType == SSChatMessageTypeImage){
            item.imageType = SSImageGroupImage;
            item.fromImgView = cell.mImgView;
            item.fromImage = mLayout.message.image;
        }
        else if (mLayout.message.messageType == SSChatMessageTypeVideo){
            item.imageType = SSImageGroupVideo;
            item.videoPath = mLayout.message.videoLocalPath;
            item.fromImgView = cell.mImgView;
            item.fromImage = mLayout.message.videoImage;
        }
        else continue;
        
        item.contentMode = mLayout.message.contentMode;
        item.itemTag = groupItems.count + 10;
        if([mLayout isEqual:layout])currentIndex = groupItems.count;
        [groupItems addObject:item];
        
    }
    
    SSImageGroupView *imageGroupView = [[SSImageGroupView alloc]initWithGroupItems:groupItems currentIndex:currentIndex];
    [self.navigationController.view addSubview:imageGroupView];
    
    __block SSImageGroupView *blockView = imageGroupView;
    blockView.dismissBlock = ^{
        [blockView removeFromSuperview];
        blockView = nil;
    };
    
    [self.mInputView SetSSChatKeyBoardInputViewEndEditing];
}

#pragma SSChatBaseCellDelegate 点击定位
-(void)SSChatMapCellClick:(NSIndexPath *)indexPath layout:(SSChatMessagelLayout *)layout{
    
    SSChatMapController *vc = [SSChatMapController new];
    vc.latitude = layout.message.latitude;
    vc.longitude = layout.message.longitude;
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - CellDelegate
-(void)SSChatHeaderImgCellClick:(NSInteger)index indexPath:(NSIndexPath *)indexPath
{
    
    SSChatMessagelLayout *layout = _datas[indexPath.row];
    NSString *userId = @"";
   if( layout.message.messageFrom == SSChatMessageFromMe)
   {
       userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
   }
    else if( layout.message.messageFrom == SSChatMessageFromOther)
    {
        userId = layout.message.sessionId;
    }
    NTESPersonalCardViewController *personView = [[NTESPersonalCardViewController alloc]initWithUserId:userId];
    personView.headURL = layout.message.headerImgurl;
    [self.navigationController pushViewController:personView animated:YES];
    
}

@end
