//
//  TYHZhuYeDetailViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/3/3.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHZhuYeDetailViewController.h"

#import "TYHSettingsCell.h"
#import "SchoolMatesHeaderView.h"
#import "FriendAreaDefine.h"
#import "AreaHelper.h"
#import "SchoolMatesModel.h"
#import <MJExtension.h>
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


#define dataCount 10
#define kLocationToBottom 20
#define kAdmin [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERNAME]
#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface TYHZhuYeDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UIAlertViewDelegate>
@property(nonatomic,retain)NSMutableArray *dataSource;
@property (nonatomic,strong) WFPopView *operationView;
@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
@property(nonatomic,retain)NSMutableArray *photos;

@end

@implementation TYHZhuYeDetailViewController{
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
    NSString *myCommentID;
}

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.listDatasource = [NSMutableArray array];
        _tableDataSource = [NSMutableArray array];
        _contentDataSource = [NSMutableArray array];
        picDatasource = [NSMutableArray array];
        _photos = [NSMutableArray array];
        pageNum = 1;
        _replyIndex = -1;//代表是直接评论
    }
    return self;
}
//通过个人发表说说的详情列表进入
-(instancetype)initWithCommentID:(NSString *)commentID ClassAdminOrNomorUser:(BOOL)ClassAdminOrNomorUser className:(NSString *)className
{
    self = [super init];
    if (self) {
        myCommentID = commentID;
        _ClassAdminOrNomorUser = ClassAdminOrNomorUser;
        _className = className;
    }
    return self;
}
//通过评论的通知列表进入
-(instancetype)initWithCommentID:(NSString *)commentID ClassAdminOrNomorUser:(BOOL)ClassAdminOrNomorUser headUrl:(NSString *)headUrl
{
    self = [super init];
    if (self) {
        myCommentID = commentID;
        _ClassAdminOrNomorUser = ClassAdminOrNomorUser;
        _UserIconURL = headUrl;
    }
    return self;
}
#pragma mark - 数据源

-(void)getCommentData
{
    AreaHelper *helpad = [[AreaHelper alloc]init];
    
    [helpad getUserMomentsDetailWithMomentID:myCommentID andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        _listDatasource = [NSMutableArray arrayWithArray:dataSource];
        
        [_contentDataSource removeAllObjects];
        
        for (SchoolMatesModel *model in self.listDatasource) {
            
            WFMessageBody *messageBody = [[WFMessageBody alloc]init];
            messageBody.posterImgstr = [NSString stringWithFormat:@"%@%@",BaseURL,model.headPortraitUrl];
            messageBody.posterName = model.userName;
            messageBody.posterID = model.userId;
            messageBody.posterIntro = model.publishTime;
            messageBody.posterContent = [self dealWithContentString:model.content];
            messageBody.posterContentID = model.tempID;
            messageBody.posterPostImage = [self dealPicModelArray:model.picUrlsArray];
            messageBody.posterReplies = [self dealReplyModelArray:model.commentsArray];
            //             messageBody.posterReplies = [NSMutableArray arrayWithObjects:body1, nil];
            
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
                    bodyTemp.replyInfoID = replymodel.contentID;
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
            WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
            YMTextData *ymData = [[YMTextData alloc] init ];
            ymData.messageBody = messBody;
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
    mainTable = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    mainTable.backgroundColor = [UIColor clearColor];
    // mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.bounces = NO;
    [mainTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    mainTable.separatorStyle = NO;
    [self.view addSubview:mainTable];
    
}


- (void)viewDidLoad {
         [self getCommentData];
    
    [super viewDidLoad];
    [self changeLeftBar];
    [self initTableview];
    self.view.backgroundColor = [UIColor whiteColor];
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



-(UIImage *)dealImageWIthVoipAccount:(NSString *)voipAccount
{
    UIImage *image = [[UIImage alloc]init];
    image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:voipAccount];
    if (image && ![self isBlankString:voipAccount]) {
        return image;
    }
    else
    {
        if (_ClassAdminOrNomorUser) {
            return [UIImage imageNamed:@"defult_classhead"];
        }
        else
        {
            return [UIImage imageNamed:@"mk-photo"];
        }
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"ILTableViewCell";
    YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //     YMTableViewCell *cell = (YMTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        
        cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    cell.stamp = indexPath.row;
    cell.replyBtn.appendIndexPath = indexPath;
    [cell.replyBtn addTarget:self action:@selector(replyAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.delegate = self;
    [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
    [cell.replyBtn removeFromSuperview];
    [cell.delButton removeFromSuperview];
    if (_ClassAdminOrNomorUser) {
        cell.userHeaderImage.image = [UIImage imageNamed:@"defult_classhead"];
        cell.userNameLbl.text = _className;
    }
    return cell;
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
    
//    _replyIndex = replyIndex;
//    
//    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
//    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
//    if ([b.replyUser isEqualToString:kAdmin]) {
//        WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        actionSheet.actionIndex = index;
//        [actionSheet showInView:self.view];
//        
//        
//        
//    }else{
//        //回复
//        if (replyView) {
//            return;
//        }
//        replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
//        replyView.delegate = self;
//        replyView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@:",b.replyUser];
//        replyView.replyTag = index;
//        [self.view addSubview:replyView];
//    }
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


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = @"动态详情";
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


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.operationView dismiss];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)headIconClick:(YMTableViewCell *)cell
{

}



-(void)changeLeftBar
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
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
