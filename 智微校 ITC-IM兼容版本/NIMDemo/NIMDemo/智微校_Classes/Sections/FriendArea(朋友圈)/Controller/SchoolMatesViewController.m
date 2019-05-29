//
//  SchoolMatesViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/1/4.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "SchoolMatesViewController.h"
#import "TYHSettingsCell.h"
#import "SchoolMatesHeaderView.h"
#import "FriendAreaDefine.h"
#import "AreaHelper.h"
#import "SchoolMatesModel.h"
#import <MJExtension.h>
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "YMTableViewCell.h"
#import "ContantHead.h"
#import "YMShowImageView.h"
#import "YMTextData.h"
#import "YMReplyInputView.h"
#import "WFReplyBody.h"
#import "WFMessageBody.h"
#import "WFPopView.h"
#import "WFActionSheet.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "DFImagesSendViewController.h"
#import "TYHZhuYeViewController.h"
#import "UIView+Extention.h"
#import <MBProgressHUD.h>
#import "NewStateModel.h"
#import "TYHCommentRecordViewController.h"

#import "TYHUploadNewStateController.h"
static CGFloat REFLASHMAXCENTERY = 34.0f;
static CGFloat REFLSAHINITCENTERY = -15.0f;

#define dataCount 10
#define kLocationToBottom 20
#define kAdmin [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERNAME]
#define WIDTH [UIScreen mainScreen].bounds.size.width

// APP_STATUSBAR_HEIGHT=SYS_STATUSBAR_HEIGHT+[HOTSPOT_STATUSBAR_HEIGHT]
#define APP_STATUSBAR_HEIGHT                (CGRectGetHeight([UIApplication sharedApplication].statusBarFrame))
// 工具栏（UINavigationController.UIToolbar）高度
#define NAVIGATIONBAR_HEIGHT                44
// 实时系统状态栏高度+导航栏高度，如有热点栏，其高度包含在APP_STATUSBAR_HEIGHT中。
#define STATUS_AND_NAV_BAR_HEIGHT           (APP_STATUSBAR_HEIGHT+NAVIGATIONBAR_HEIGHT)

@interface SchoolMatesViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
@property(nonatomic,retain)NSMutableArray *dataSource;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property(nonatomic,retain)NSMutableArray *photos;
@property (nonatomic, strong) UIImageView *albumReflashImageView;
@end

@implementation SchoolMatesViewController{
    NSMutableArray *_imageDataSource;
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    NSMutableArray *_tableDataSource;//tableview数据源
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    UITableView *mainTable;
    NSMutableArray *picDatasource;
    UIView *popView;
    YMReplyInputView *replyView ;
    NSInteger _replyIndex;
    NSInteger pageNum;
    NSInteger tempIndexPath;
    SchoolMatesHeaderView *headerView;
    //是否正在刷新
    BOOL isRefreshing;
    //是否可以开始刷新
    BOOL startRefreshing;
}

//-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        self.listDatasource = [NSMutableArray arrayWithCapacity:0];
//        _tableDataSource = [NSMutableArray arrayWithCapacity:0];
//        _contentDataSource = [NSMutableArray arrayWithCapacity:0];
//        picDatasource = [NSMutableArray arrayWithCapacity:0];
//        _photos = [NSMutableArray array];
//        pageNum = 1;
//        _replyIndex = -1;//代表是直接评论
//    }
//    return self;
//}

-(instancetype)initWithRecordModel: (NewStateModel *)model
{
    self = [super init];
    if(self)
    {
        self.listDatasource = [NSMutableArray arrayWithCapacity:0];
        _tableDataSource = [NSMutableArray arrayWithCapacity:0];
        _contentDataSource = [NSMutableArray arrayWithCapacity:0];
        picDatasource = [NSMutableArray arrayWithCapacity:0];
        _photos = [NSMutableArray array];
        pageNum = 1;
        _replyIndex = -1;//代表是直接评论
        _stateModel = model;
    }
        return self;
}


//-(void)setStateModel:(NewStateModel *)stateModel
//{
//    _stateModel = stateModel;
//}

#pragma mark - 数据源

-(void)getCommentData
{
    AreaHelper *helpad = [[AreaHelper alloc]init];
    
    [helpad getPersonalMomentsWithPageNum:1 andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        _listDatasource = [NSMutableArray arrayWithArray:dataSource];
        [_contentDataSource removeAllObjects];
        int flagCount = 0;
        for (SchoolMatesModel *model in dataSource) {
            WFMessageBody *messageBody = [[WFMessageBody alloc]init];
            messageBody.posterImgstr = [NSString stringWithFormat:@"%@%@",BaseURL,model.headPortraitUrl];
            messageBody.posterName = model.userName;
            if (flagCount == 0) {
                [[NSUserDefaults standardUserDefaults]setValue:model.time forKey:Area_personTime];
                [[NSUserDefaults standardUserDefaults]synchronize];
                if ([self isBlankString:[[NSUserDefaults standardUserDefaults] valueForKey:Area_personRecordTime]]) {
                    [[NSUserDefaults standardUserDefaults]setValue:model.time forKey:Area_personRecordTime];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                }
            }
            
//            NSLog(@"Area_personTime : %@",[[NSUserDefaults standardUserDefaults]valueForKey:Area_personTime]);
            
            messageBody.posterID = model.userId;
            messageBody.posterIntro = model.publishTime;
            messageBody.posterContent = [self dealWithContentString:model.content];
            messageBody.posterContentID = model.tempID;
            messageBody.posterPostImage = [self dealPicModelArray:model.picUrlsArray];
            messageBody.posterReplies = [self dealReplyModelArray:model.commentsArray];
            //             messageBody.posterReplies = [NSMutableArray arrayWithObjects:body1, nil];
            flagCount++;
            
            if (model.thumbsupsArray && model.thumbsupsArray.count > 0) {
                NSMutableArray *tmpArr = [NSMutableArray array];
                for (thumbsupsModel  *faverModel in [thumbsupsModel objectArrayWithKeyValuesArray:model.thumbsupsArray]) {
                    [tmpArr addObject:faverModel.userName];
                    if ([faverModel.userId isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERID]]) {
                        messageBody.isFavour = YES;
                    }
                }
                messageBody.posterFavour = tmpArr;
            }
            else
            {
                messageBody.posterFavour = [NSMutableArray array];
            }
            
            [_contentDataSource addObject:messageBody];
        }
        [self loadTextData];
    } failure:^(NSError *error) {
        
    }];
}
#pragma mark - 消息列表处理方法
-(NSString *)dealWithContentString:(NSString *)contentString
{
    if ([self isBlankString:contentString]) {
        return @"";
    }
    else return contentString;
}

- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

-(NSMutableArray *)dealWithContentArray:(NSMutableArray *)contentArray
{
    if (contentArray.count == 0 || contentArray == nil) {
        return [NSMutableArray arrayWithObjects:@"", nil];
    }
    else return contentArray;
}

-(NSMutableArray *)dealPicModelArray:(NSMutableArray *)picArray
{
    NSMutableArray *tmpArr = [NSMutableArray array];
    for ( picUrlsModel *picModel in [picUrlsModel objectArrayWithKeyValuesArray:picArray]) {
        [tmpArr addObject:[NSString stringWithFormat:@"%@%@",BaseURL,picModel.bigPicUrl]];
    }
    return tmpArr;
}

-(NSMutableArray *)dealPosterFaverModelArray:(NSMutableArray *)FaverModelArray
{
    if (FaverModelArray && FaverModelArray.count > 0) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (thumbsupsModel  *faverModel in [thumbsupsModel objectArrayWithKeyValuesArray:FaverModelArray]) {
            [tmpArr addObject:faverModel.userName];
        }
        return tmpArr;
    }
    else return [NSMutableArray array];
}

-(NSMutableArray *)dealReplyModelArray:(NSMutableArray *)replyArray
{
    
    if (replyArray && replyArray.count > 0) {
        NSMutableArray *tmpArr = [NSMutableArray array];
        for (commentsModel  *commetModel in [commentsModel objectArrayWithKeyValuesArray:replyArray]) {
//            NSLog(@"------ %@",replyArray);
            WFReplyBody *body = [[WFReplyBody alloc] init];
            body.replyUser = commetModel.userName;
            body.repliedUser = @"";
            body.replyUserID = commetModel.userId;
            body.replyInfoID = commetModel.contentID;
            body.replyInfo = commetModel.content;
            [tmpArr addObject:body];
            
            if ([replyModel objectArrayWithKeyValuesArray:commetModel.replysArray].count > 0) {
                for (replyModel *replymodel in [replyModel objectArrayWithKeyValuesArray:commetModel.replysArray]) {
                    WFReplyBody *bodyTemp = [[WFReplyBody alloc]init];
                    bodyTemp.replyInfo = replymodel.content;
                    //以下一行修复评论回复的回复失败的问题，－－－该句没有语法问题
                    bodyTemp.replyInfoID = commetModel.contentID;
                    bodyTemp.replyUser = replymodel.replyUserName;
                    bodyTemp.replyUserID = replymodel.replyUserId;
                    bodyTemp.repliedUser = replymodel.targetUserName;
                    bodyTemp.repliedUserID = replymodel.targetUserId;
                    bodyTemp.replyID = replymodel.contentID;
                    [tmpArr addObject:bodyTemp];
                }
            }
        }
        return tmpArr;
    }
    else
    {
        NSMutableArray *array = [NSMutableArray array];
        return array;
    }
}




#pragma mark -加载数据
- (void)loadTextData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
        for (int i = 0 ; i < _contentDataSource.count; i ++) {
            //            WFMessageBody *messBody = [[WFMessageBody alloc]init];
            //            messBody = [_contentDataSource objectAtIndex:i];
            YMTextData *ymData = [[YMTextData alloc] init ];
            ymData.messageBody = [_contentDataSource objectAtIndex:i];
            [ymDataArray addObject:ymData];
        }
        [self calculateHeight:ymDataArray];
    });
}


#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{
    NSDate* tmpStartData = [NSDate date];
    if (pageNum == 1) {
        _tableDataSource = [NSMutableArray array];
    }
    for (YMTextData *ymData in dataArray) {
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:WIDTH withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:WIDTH withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        
        ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
        
        [_tableDataSource addObject:ymData];
    }
    
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time = %f", deltaTime);
    dispatch_async(dispatch_get_main_queue(), ^{
        [mainTable reloadData];
    });
}

- (void)backToPre{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void) initTableview{
    mainTable = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    [self.view addSubview:mainTable];
}


- (void)viewDidLoad {
    //     [self getCommentData];
    //    [self setupDownRefresh];  //上来先刷新数据  ，下拉刷新数据
    
    [super viewDidLoad];
    [self changeLeftBar];
    [self initTableview];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupDownRefresh];   //上拉加载数据
    [self setupUpRefresh];
    
    startRefreshing = NO;
    isRefreshing = NO;
    [self.view addSubview:self.albumReflashImageView];
    
}

-(void)changeLeftBar
{
    UIBarButtonItem * leftItem = nil;
    UIBarButtonItem * rightItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"btn_sendcircle"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClickedhhah)];
    } else {
        rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_sendcircle"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClickedhhah)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem =rightItem;
}



-(void)returnClickedhhah
{
//    NSMutableArray *_images = [NSMutableArray array];
////        [_images addObject:[UIImage imageNamed:@"AlbumAddBtnHL@2x"]];
//    
//    DFImagesSendViewController *connn = [[DFImagesSendViewController alloc]initWithImages:_images];
//    connn.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
//    [self.navigationController pushViewController:connn animated:YES];
    
    
    TYHUploadNewStateController *uploadView = [TYHUploadNewStateController new];
    [self.navigationController pushViewController:uploadView animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  _tableDataSource.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
    BOOL unfold = ym.foldOrNot;
    return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (ym.favourHeight == 0?0:kReply_FavourDistance);
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    headerView = [[SchoolMatesHeaderView alloc]init];
    headerView.areaNameLabel.text = kAdmin;
    headerView.bgImageView.image = [UIImage imageNamed:@"head_1"];
    UITapGestureRecognizer *guesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(zhuyeAction:)];
    UITapGestureRecognizer *smallBGViewguesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(smallBgViewAction:)];
    [headerView.smallBgView addGestureRecognizer:smallBGViewguesture];
    headerView.userIcon.userInteractionEnabled = YES;
    if ([_stateModel.count isEqualToString:@"0"]) {
        [headerView.smallBgView removeFromSuperview];
    }
    [headerView.userIcon addGestureRecognizer:guesture];
    [headerView.smallUserIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseURL,_stateModel.headUrl]] placeholderImage:[UIImage imageNamed:@"mk-photo"]];
    
    headerView.smallTitleLabel.text = [NSString stringWithFormat:@"%@条消息",_stateModel.count];
    headerView.userIcon.image = [self dealImageWIthVoipAccount:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_VOIP]];
    return headerView;
}

-(void)zhuyeAction:(id )sender
{
    TYHZhuYeViewController *zhuyeView = [[TYHZhuYeViewController alloc]initWithVoipAccount:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERID] userName:kAdmin headIconImage:nil teacherOrUser:0];
    [self.navigationController pushViewController:zhuyeView animated:YES];
}

-(void)smallBgViewAction:(id)sender
{
    NSString *requestTime = [[NSUserDefaults standardUserDefaults]valueForKey:Area_personRecordTime];
    TYHCommentRecordViewController *recordView = [[TYHCommentRecordViewController alloc]initWithKind:@"0" requestTime:requestTime];
    recordView.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:recordView
                                         animated:YES];
    [headerView.smallBgView removeFromSuperview];
}

-(void)headIconClick:(YMTableViewCell *)cell
{
    NSIndexPath *indexPath = [mainTable indexPathForCell:cell];
    WFMessageBody *body = [[WFMessageBody alloc]init];
    YMTableViewCell *tmpCell = [mainTable cellForRowAtIndexPath:indexPath];
    YMTextData *data = _tableDataSource[indexPath.row];
    body = data.messageBody;
    TYHZhuYeViewController *zhuyeView = [[TYHZhuYeViewController alloc]initWithVoipAccount:body.posterID userName:body.posterName headIconImage:tmpCell.userHeaderImage.image teacherOrUser:0];
    [self.navigationController pushViewController:zhuyeView animated:YES];
}


-(UIImage *)dealImageWIthVoipAccount:(NSString *)voipAccount
{
    UIImage *image = [[UIImage alloc]init];
    image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:voipAccount];
    if (image && ![self isBlankString:voipAccount]) {
        return image;
    }
    else
        return [UIImage imageNamed:@"mk-photo"];
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ILTableViewCell";
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //     YMTableViewCell *cell = (YMTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.delButton addTarget:self action:@selector(delCellAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.stamp = indexPath.row;
    cell.replyBtn.appendIndexPath = indexPath;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 216.0f;
}


#pragma mark - 按钮动画

- (void)replyAction:(YMButton *)sender{
    
    CGRect rectInTableView = [mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    [self.operationView showAtView:mainTable rect:targetRect isFavour:ym.hasFavour];
    
}


- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        WS(ws);
        
        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
            switch (operationType) {
                case WFOperationTypeLike:
                    
                    [ws addLike];
                    break;
                case WFOperationTypeReply:
                    [ws replyMessage: nil];
                    break;
                default:
                    break;
            }
        };
    }
    return _operationView;
}

#pragma mark - 赞
- (void)addLike{
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:_selectedIndexPath.row];
    WFMessageBody *m = ymData.messageBody;
    if (m.isFavour == YES ) {//此时该取消赞
        [AreaHelper DelLikeWithCommentID:m.posterContentID];
        [m.posterFavour removeObject:kAdmin];
        m.isFavour = NO;
    }else{
        [m.posterFavour addObject:kAdmin];
        [AreaHelper addLikeWithCommentID:m.posterContentID];
        m.isFavour = YES;
    }
    ymData.messageBody = m;
    
    //清空属性数组。否则会重复添加
    
    [ymData.attributedDataFavour removeAllObjects];
    
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:ymData];
    
    [mainTable reloadData];
    
}


#pragma mark - 真の评论
- (void)replyMessage:(YMButton *)sender{
    
    if (replyView) {
        return;
    }
    
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    replyView.delegate = self;
    replyView.replyTag = _selectedIndexPath.row;
    [self.view addSubview:replyView];
}

#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    [mainTable reloadData];
    
}

#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
    //2.告诉图片浏览器显示所有的图片
    NSMutableArray *photos = [NSMutableArray array];
    for (int i = 0 ; i < imageViews.count; i++) {
        //传递数据给浏览器
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[imageViews objectAtIndex:i]]];
        //设置来源哪一个UIImageView
        [photos addObject:photo];
    }
    
    brower.photos = photos;
    //3.设置默认显示的图片索引
    brower.currentPhotoIndex = clickTag - 9999;
    
    //4.显示浏览器
    [brower show];
    
}

#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = b.replyInfo;
}

#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    [self.operationView dismiss];
    
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:kAdmin]) {
        WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionIndex = index;
        [actionSheet showInView:self.view];
    }else{
        //回复
        if (replyView) {
            return;
        }
        replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
        replyView.delegate = self;
        replyView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
        replyView.replyTag = index;
        [self.view addSubview:replyView];
    }
}

#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    YMTextData *ymData = nil;
    if (_replyIndex == -1) {
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.replyUserID = [[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERID];
        body.repliedUser = @"";
        body.replyInfo = replyText;
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        //添加评论
        
        [AreaHelper AddCommentWithCommentID:m.posterContentID andContent:replyText];
        
    }else{
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = kAdmin;
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyUserID = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex]replyUserID];
        body.replyInfoID = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex]replyInfoID];
        body.replyInfo = replyText;
        //回复评论
        [AreaHelper saveCommentReplyWithCommentID:body.replyInfoID kind:@"0" content:replyText andTargetUserId:body.replyUserID];
        
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
    }
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    [mainTable reloadData];
}

- (void)destorySelf{
    //  NSLog(@"dealloc reply");
    
    [replyView removeFromSuperview];
    replyView = nil;
    _replyIndex = -1;
    
}

- (void)actionSheet:(WFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //delete
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionSheet.actionIndex];
        WFMessageBody *m = ymData.messageBody;
        WFReplyBody *model = m.posterReplies[_replyIndex];
        if ([self isBlankString:model.replyID]) {
            [AreaHelper deleteMomentCommentWithCommentID:model.replyInfoID kind:@"0'"];
        }
        else
        {
            [AreaHelper DelCommentWithReplyID:model.replyID kind:@"0"];
        }
        
        [m.posterReplies removeObjectAtIndex:_replyIndex];
        ymData.messageBody = m;
        [ymData.completionReplySource removeAllObjects];
        [ymData.attributedDataReply removeAllObjects];
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        [_tableDataSource replaceObjectAtIndex:actionSheet.actionIndex withObject:ymData];
        
        [mainTable reloadData];
        
    }else{
        
    }
    _replyIndex = -1;
}

- (void)dealloc{
    
    NSLog(@"销毁");
    
}



-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCommentData) name:@"refreshFriendArea" object:nil];
    self.title = @"校友圈";
    
}


-(void)delCellAction:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除动态" message:@"真的要删除这一条动态吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认",nil];
    [alert show];
    YMTableViewCell * cell = (YMTableViewCell *)[[sender superview] superview];
    NSIndexPath * path = [mainTable indexPathForCell:cell];
    tempIndexPath = path.row;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }
    else
    {
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:tempIndexPath];
        WFMessageBody *body = ymData.messageBody;
        [AreaHelper DelCommentWithCommentID:body.posterContentID];
        [_tableDataSource removeObjectAtIndex:tempIndexPath];
        [mainTable reloadData];
        tempIndexPath = 0;
        
    }
}

#pragma mark  -----  下拉刷新新数据
- (void)setupDownRefresh {
    
    // 1.添加刷新控件
    mainTable.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewStatus)];
    // 2.进入刷新状态
    [mainTable.header beginRefreshing];
}

- (void)loadNewStatus {
    [self getCommentData];
    pageNum = 1;
    [mainTable.header endRefreshing];
}
#pragma mark  -----  上拉加载
- (void)setupUpRefresh {
    mainTable.footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreStatus)];
}
// 主要走这里
- (void)loadMoreStatus {
    
    pageNum ++;
    AreaHelper *helpad = [[AreaHelper alloc]init];
    [helpad getPersonalMomentsWithPageNum:pageNum andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        [_contentDataSource removeAllObjects];
        for (SchoolMatesModel *model in dataSource) {
            WFMessageBody *messageBody = [[WFMessageBody alloc]init];
            messageBody.posterImgstr = [NSString stringWithFormat:@"%@%@",BaseURL,model.headPortraitUrl];
            messageBody.posterName = model.userName;
            messageBody.posterIntro = model.publishTime;
            messageBody.posterContent = [self dealWithContentString:model.content];
            messageBody.posterContentID = model.tempID;
            messageBody.posterID = model.userId;
            messageBody.posterPostImage = [self dealPicModelArray:model.picUrlsArray];
            
            WFReplyBody *body1 = [[WFReplyBody alloc] init];
            body1.replyUser = kAdmin;
            body1.repliedUser = @"";
            body1.replyInfo = kContentText1;
            messageBody.posterReplies = [self dealReplyModelArray:model.commentsArray];
            
            if (model.thumbsupsArray && model.thumbsupsArray.count > 0) {
                NSMutableArray *tmpArr = [NSMutableArray array];
                for (thumbsupsModel  *faverModel in [thumbsupsModel mj_objectArrayWithKeyValuesArray:model.thumbsupsArray]) {
                    [tmpArr addObject:faverModel.userName];
                    if ([faverModel.userId isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:USER_DEFAULT_USERID]]) {
                        messageBody.isFavour = YES;
                    }
                }
                messageBody.posterFavour = tmpArr;
            }
            else
            {
                messageBody.posterFavour = [NSMutableArray array];
            }
            [_contentDataSource addObject:messageBody];
        }
        [self loadTextData];
        [mainTable.footer endRefreshing];
    } failure:^(NSError *error) {
        [mainTable.footer endRefreshing];
    }];
}


#pragma mark - 菊花判定

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.operationView dismiss];
    //    CGPoint point = mainTable.contentOffset;
    //
    //    if (point.y<0) {
    //
    //        if (isRefreshing) {
    //            return;
    //        }
    //        CGFloat rate  = point.y/10;
    //        CGFloat centerY = REFLSAHINITCENTERY+fabs(point.y) - STATUS_AND_NAV_BAR_HEIGHT +40;
    //
    //        if (centerY>REFLASHMAXCENTERY) {
    //
    //            self.albumReflashImageView.centerY = REFLASHMAXCENTERY;
    //
    //            startRefreshing = YES;
    //        }else{
    //            self.albumReflashImageView.centerY = centerY;
    //            startRefreshing = NO;
    //        }
    //        //旋转刷新图标
    //        self.albumReflashImageView.transform = CGAffineTransformMakeRotation(rate);
    //    }
    
}


-(void)startRotate{
    if (![self.albumReflashImageView.layer animationForKey:@"animation"]) {
        CABasicAnimation *animationImage = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animationImage.fromValue = [NSNumber numberWithFloat:0];
        animationImage.toValue = [NSNumber numberWithFloat:M_PI *2.0];
        animationImage.duration = 1;
        
        animationImage.repeatCount =HUGE_VALF;
        animationImage.fillMode = kCAFillModeForwards;
        [self.albumReflashImageView.layer addAnimation:animationImage forKey:@"animation"];
        
        [self performSelector:@selector(endRotate) withObject:nil afterDelay:2];
        
        isRefreshing = YES;
    }
}

-(void)endRotate{
    //上升隐藏
    [UIView animateWithDuration:0.2 animations:^{
        self.albumReflashImageView.centerY = REFLSAHINITCENTERY;
    } completion:^(BOOL finished) {
        startRefreshing = NO;
        isRefreshing = NO;
        [self.albumReflashImageView.layer removeAllAnimations];
    }];
    
    
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
