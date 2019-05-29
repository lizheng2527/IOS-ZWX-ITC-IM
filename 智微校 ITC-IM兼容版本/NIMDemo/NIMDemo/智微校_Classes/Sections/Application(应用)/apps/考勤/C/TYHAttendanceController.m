//
//  TYHAttendanceController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/23.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHAttendanceController.h"
#import "AttendanceCell.h"
#import "AttendanceNetHelper.h"
#import "AttendanceModel.h"
#import "SGPopSelectView.h"
#import "AttendanceStatisticsController.h"
#import "AttendaceBuQianController.h"
#import "AttendanceRemarkController.h"

#import <UIView+Toast.h>

#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>

#import "WXApi.h"

@interface TYHAttendanceController ()<UITableViewDelegate,UITableViewDataSource,BMKGeoCodeSearchDelegate,BMKLocationServiceDelegate,UIActionSheetDelegate,UIAlertViewDelegate>


@property (nonatomic, strong) NSMutableArray *locationSelectionsArray;
@property (nonatomic, retain) SGPopSelectView *popView;

@end

@implementation TYHAttendanceController{
    __weak NSTimer *_timer;
    __weak NSTimer *_MapTimer;
    NSMutableArray *attendanceListArray;
    
    NSString *tapStartorEndFlag;
    NSString *flag;
    NSString *flagBan;
    
    BMKGeoCodeSearch* _geocodesearch;
    BMKLocationService* _locService;
    NSString *locationString;
    NSString *roadString;
    
//    UIButton *remarksBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"考勤";
    [self createBarItem];
    [self initView];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 获取数据
-(void)requestAttendanceList
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取考勤数据";
    
    AttendanceNetHelper *helper = [AttendanceNetHelper new];
    [helper getAttendanceActionListWithStatus:^(BOOL successful, NSMutableArray *dataSource) {
        attendanceListArray = [NSMutableArray arrayWithArray:dataSource];
        [self initBtnColor];
        [_mainTableView reloadData];
        [hud removeFromSuperview];
        
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
}


-(void)doAttendanceAction
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"考勤进行中";
    
    AttendanceNetHelper *helper = [AttendanceNetHelper new];
    
    flag = attendanceListArray.count == 0 ? @"start":@"end";
    NSMutableString *strings = [NSMutableString stringWithString:roadString];
    [strings deleteCharactersInRange:NSMakeRange(0, 3)];
    [helper doAttendanceActionWithAddress:[NSString stringWithFormat:@"%@%@",strings,locationString] andFlag:flag status:^(BOOL successful, AttendanceModel *attModel) {
        if ([attModel.status isEqualToString:@"success"]) {
            [self.view makeToast:@"考勤成功" duration:1 position:nil];
            [self requestAttendanceList];
        }
        else
        {
            [self.view makeToast:@"考勤失败" duration:1 position:nil];
        }
        [hud removeFromSuperview];
    } failure:^(NSError *error) {
    [self.view makeToast:@"网络请求失败" duration:1 position:nil];
     [hud removeFromSuperview];
    }];
    
}


-(void)initonGeocodesearch
{
    
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    _locService.desiredAccuracy = kCLLocationAccuracyBest;
    
    [_locService startUserLocationService];
}

-(void)initLoacationData
{
//    self.locationSelectionsArray =[NSMutableArray arrayWithArray:@[@"金域国际",@"金域国际中心A座1金域国际中心A座1",@"金域国际中心A座2",@"金域国际中心A座3",@"金域国际中心B座",@"金域国际中心B座1"]] ;
    __block TYHAttendanceController *blockSelf = self;
    self.popView.selections = self.locationSelectionsArray;
    self.popView.locationString = roadString;
    __weak typeof(self) weakSelf = self;
    
    self.popView.selectedHandle = ^(NSInteger selectedIndex){
        NSLog(@"selected index %ld, content is %@", selectedIndex, weakSelf.locationSelectionsArray[selectedIndex]);
        blockSelf.locationLabel.text =[NSString stringWithFormat:@"%@",weakSelf.locationSelectionsArray[selectedIndex]];
        locationString = [NSString stringWithFormat:@"%@",weakSelf.locationSelectionsArray[selectedIndex]];
        [blockSelf.popView hide:NO];
        CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 9999);//
        CGSize expectSize = [blockSelf.locationLabel sizeThatFits:maximumLabelSize];
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - expectSize.width) / 2 + 12;
        blockSelf.locationIcon.frame = CGRectMake(x - 20, 211, 20, 20);
        blockSelf.locationLabel.frame = CGRectMake(x, 211, expectSize.width, 20);
        blockSelf.locationClickBtn.frame = CGRectMake(x - 30, 208, 20 + expectSize.width + 20, 27);
    };
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView:self.view];
    if (self.popView.visible && CGRectContainsPoint(self.popView.frame, p)) {
        return NO;
    }
    return YES;
}


#pragma mark - 处理时间



-(void)initTimeLabel
{
    _timeLabel.text = @"获取系统时间";
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(onTimerUpdate:)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
//    _timer = timer;
    
}

//地图计时器,每5秒重新定位一次,暂时不用
-(void)initMapTimer
{
    _MapTimer = [NSTimer scheduledTimerWithTimeInterval:10.0
                                                      target:self
                                                    selector:@selector(initonGeocodesearch)
                                                    userInfo:nil
                                                     repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_MapTimer forMode:NSRunLoopCommonModes];
}

-(void)setUpTimeLabelWithTime
{
    NSDate *  senddate=[NSDate date];
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    
    [dateformatter setDateFormat:@"HH:mm:ss"];
    
    NSString *  locationnString=[dateformatter stringFromDate:senddate];
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@",locationnString,[self getDateString]];
    
    //判定当前时间是否过12点
    if (attendanceListArray.count == 0) {
        if ([self dealTimeBeyond:locationnString]) {
            AttendanceListModel *model = [AttendanceListModel new];
            model.typeString = @"上班考勤";
            model.startTime = @"上班未考勤";
            model.startAddress = @"暂无";
            [attendanceListArray addObject:model];
            [self.mainTableView reloadData];
            [self initBtnColor];
            }
        }
}

//判定是否超过12点
-(BOOL )dealTimeBeyond:(NSString *)timeString
{
    NSArray *array = [timeString componentsSeparatedByString:@":"];
    NSString *HH = array[0];
    NSString *MM= array[1];
    NSString *ss = array[2];
    NSString *timeCountString = [NSString stringWithFormat:@"%@%@%@",HH,MM,ss];
    if ([timeCountString integerValue] > 120000) {
        return YES;
    }
    else
        return NO;
}


- (void)onTimerUpdate:(NSTimer *)timer {
    [self setUpTimeLabelWithTime];
}

-(NSString *)getDateString
{
    NSDate *  senddate=[NSDate date];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:senddate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

#pragma mark - 视图初始化
-(void)initView
{
    
    CGFloat orignX = [UIScreen mainScreen].bounds.size.width / 2 - 80;
    _attendanceBtn.frame = CGRectMake(orignX, 32, 160, 160);
    _attendanceBtn.layer.masksToBounds = YES;
    _attendanceBtn.layer.cornerRadius = _attendanceBtn.frame.size.width / 2;
    _attendanceBtn.layer.borderWidth = 5.0f;
    _attendanceBtn.layer.borderColor = UIColorFromRGB(0xffd8f6f1).CGColor;
    
    _locationClickBtn.layer.masksToBounds = YES;
    _locationClickBtn.layer.cornerRadius = 13;
    [_locationClickBtn setBackgroundColor:[UIColor grayColor]];
    CGPoint pointCenter = CGPointMake(_attendanceBtn.center.x, _locationClickBtn.center.y);
    _locationClickBtn.center = pointCenter;
    
    CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 9999);//
    CGSize expectSize = [_locationLabel sizeThatFits:maximumLabelSize];
    CGFloat x = ([UIScreen mainScreen].bounds.size.width - expectSize.width) / 2 + 12;
    _locationIcon.frame = CGRectMake(x - 20, 211, 20, 20);
    _locationLabel.frame = CGRectMake(x, 211, expectSize.width, 20);
    _locationClickBtn.frame = CGRectMake(x - 30, 208, 20 + expectSize.width + 20, 27);
    
    
    _timeLabel.textColor = [UIColor colorWithRed:255.0 / 255 green: 255.0 / 255 blue:255.0 / 255 alpha:0.7];
    
    [_attendanceBtn addTarget:self action:@selector(buttonClickUp:) forControlEvents:UIControlEventTouchDown];
    
    [_attendanceBtn addTarget:self action:@selector(buttonClickDown:) forControlEvents:UIControlEventTouchUpInside];
    
    [_locationClickBtn addTarget:self action:@selector(localBtnClickUp:) forControlEvents:UIControlEventTouchDown];
    
    [_locationClickBtn addTarget:self action:@selector(localBtnClickDown:) forControlEvents:UIControlEventTouchUpInside];
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];

    _remarksBtn.layer.masksToBounds = YES;
    _remarksBtn.layer.cornerRadius = 60 / 2;
    _remarksBtn.layer.borderWidth = 4.0f;
    _remarksBtn.layer.borderColor = UIColorFromRGB(0xffd8f6f1).CGColor;
    
}

-(void)initBtnColor
{
    if (attendanceListArray.count == 0) {
        [_attendanceBtn setBackgroundColor:UIColorFromRGB(0xff00bb9c)];
        _attendanceBtn.layer.borderColor = UIColorFromRGB(0xffd8f6f1).CGColor;
        _titleLabel.text = @"上班考勤";
        _backGroundView.image = [UIImage imageNamed:@"bg_checkin"];
    }
    else
    {
        [_attendanceBtn setBackgroundColor:UIColorFromRGB(0xffed9435)];
        _attendanceBtn.layer.borderColor = UIColorFromRGB(0xfff9f0e6).CGColor;
        _titleLabel.text = @"下班考勤";
        _backGroundView.image = [UIImage imageNamed:@"bg_checkin"];
    }
}

#pragma mark - TableViewDatasource & Delegate
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AttendanceListModel *model = attendanceListArray[indexPath.row];
    static NSString *iden = @"AttendanceCell";
    AttendanceCell *cell = [[NSBundle mainBundle]loadNibNamed:@"AttendanceCell" owner:self
                                                      options:nil].firstObject;
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:iden];
    }
    if ([model.typeString isEqualToString:@"上班考勤"]) {
        if (![model.startTime isEqualToString:@"上班未考勤"]) {
            [cell.refreshBtn addTarget:self action:@selector(doStartAttendanceAction) forControlEvents:UIControlEventTouchUpInside];
        }
        else
            [cell.refreshBtn addTarget:self action:@selector(doStartAttendanceAction_Buqian) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        [cell.refreshBtn addTarget:self action:@selector(doStartAttendanceAction) forControlEvents:UIControlEventTouchUpInside];
    }
    cell.cellModel = model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到微信好友",@"分享到微信朋友圈", nil];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享到微信好友", nil];
    
    AttendanceListModel *model = attendanceListArray[indexPath.row];
    if ([model.typeString isEqualToString:@"上班考勤"]) {
        if ([model.startTime isEqualToString:@"上班未考勤"]) {
            [self.view makeToast:@"没有您的上班考勤记录" duration:1 position:nil];
        }
        else
        {
            tapStartorEndFlag = @"上班考勤";
            [sheet showInView:self.view];
        }
    }
    else
    {
        tapStartorEndFlag = @"下班考勤";
        [sheet showInView:self.view];
    }
   
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return attendanceListArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma mark - 设置Btn点击效果
-(void)buttonClickDown:(UIButton *)button{
    if (attendanceListArray.count == 0) {
        [_attendanceBtn setBackgroundColor:UIColorFromRGB(0xff00bb9c)];
        _attendanceBtn.layer.borderColor = UIColorFromRGB(0xffd8f6f1).CGColor;
    }
    else
    {
        [button setBackgroundColor:UIColorFromRGB(0xffed9435)];
        button.layer.borderColor = UIColorFromRGB(0xfff9f0e6).CGColor;
    }
}
-(void)buttonClickUp:(UIButton *)button{
    [button setBackgroundColor:UIColorFromRGB(0xff4c4c4c)];
    button.layer.borderColor = UIColorFromRGB(0xffd4e4fd).CGColor;
    [self doAttendanceAction];
}

-(void)localBtnClickDown:(UIButton *)button{
    [button setBackgroundColor:[UIColor grayColor]];
    CGPoint p = [(UIButton *)button center];
    [self.popView showFromView:self.view atPoint:p animated:YES];
    self.popView.center = self.locationClickBtn.center;
    }
-(void)localBtnClickUp:(UIButton *)button{
    [button setBackgroundColor:UIColorFromRGB(0xff4c4c4c)];
//    b14eccaf987d526f7c0a1cde03f6d902
}


-(void)doStartAttendanceAction
{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"更新考勤" message:@"更新考勤会覆盖上一次考勤的时间和地点" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
    [alertView show];
}

-(void)doStartAttendanceAction_Buqian
{
    
    NSString *endTimeString = @"";
    if (attendanceListArray.count) {
        for(AttendanceListModel *model  in attendanceListArray)
        {
            if ([model.typeString isEqualToString:@"下班考勤"]) {
                endTimeString = model.endTime;
            }
        }
    }
    
    AttendaceBuQianController *bqView = [AttendaceBuQianController new];
    bqView.address = locationString;
    bqView.endTime = endTimeString;
    bqView.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:bqView animated:YES];
}


-(void)goDateListAction
{
    AttendanceStatisticsController *ascView = [AttendanceStatisticsController new];
    ascView.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:ascView animated:YES];
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goToRemarkView:(id)sender {
    AttendanceRemarkController *remarkView = [AttendanceRemarkController new];
    remarkView.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:remarkView animated:YES];
}



#pragma mark - other
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0xff4c4c4c)];
     [self.navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
    self.popView = [[SGPopSelectView alloc] init];
    [self initTimeLabel];
    [self requestAttendanceList];
    [self initonGeocodesearch];
    [self initMapTimer];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestAttendanceList) name:@"buqianRefresh" object:nil];
    
    //临时注释translucent
    self.navigationController.navigationBar.translucent = NO;
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
    
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"统计" style:UIBarButtonItemStyleDone target:self
                                               action:@selector(goDateListAction)];
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem =rightItem;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_timer invalidate];
    _timer = nil;
    [_MapTimer invalidate];
    _MapTimer = nil;
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorGreen]];
    _geocodesearch.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
     [_locService stopUserLocationService];
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.popView hide:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 百度地图Delegate

-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        self.locationSelectionsArray = [NSMutableArray array];

        _locationLabel.text = _locationLabel.text.length > 0 ?_locationLabel.text:[NSString stringWithFormat:@"%@",@"正在定位您的地址"];
//        locationString = _locationLabel.text;
        roadString = result.address;
        for (BMKPoiInfo *poiModel in result.poiList) {
                if (![poiModel.city isEqualToString:@"北京市"]) {
                    [self.locationSelectionsArray addObject:[NSString stringWithFormat:@"%@(%@)",poiModel.name,poiModel.city]];
                }
                else
                    [self.locationSelectionsArray addObject:poiModel.name];
            }
        
        NSArray *locationArray = [NSArray arrayWithArray:self.locationSelectionsArray];
        
        for (NSString *string in locationArray) {
            if ([string isEqualToString:@"金域华府东住总·万科"] || [string isEqualToString:@"世纪鸿源"] || [string isEqualToString:@"住总万科金域国际中心"] || [string isEqualToString:@"金域国际中心A座"]) {
                [self.locationSelectionsArray insertObject:@"中电和讯科技有限公司" atIndex:0];
                break;
            }
        }

        NSString *tmpString = locationString;
        
        if (self.locationSelectionsArray.count > 0) {
            
            _locationLabel.text =[NSString stringWithFormat:@"%@",self.locationSelectionsArray[0]];
            locationString = _locationLabel.text;
            
            for (NSString *tmpAddressString in self.locationSelectionsArray) {
                //判定是否还在当前地址列表
                if ([tmpAddressString isEqualToString:tmpString]) {
                    locationString = tmpString;
                    _locationLabel.text = locationString;
                    break;
                }
            }
        }
        
        {
        CGSize maximumLabelSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 20, 9999);//
        CGSize expectSize = [_locationLabel sizeThatFits:maximumLabelSize];
        CGFloat x = ([UIScreen mainScreen].bounds.size.width - expectSize.width) / 2 + 12;
        _locationIcon.frame = CGRectMake(x - 20, 211, 20, 20);
        _locationLabel.frame = CGRectMake(x, 211, expectSize.width, 20);
        _locationClickBtn.frame = CGRectMake(x - 30, 208, 20 + expectSize.width + 20, 27);
        }
        self.popView.selections = self.locationSelectionsArray;
        self.popView.locationString = roadString;
        [self initLoacationData];
    }
    
}


///**
// *用户位置更新后，会调用此函数
// *@param userLocation 新的用户位置
// */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location.coordinate.latitude != 0) {
        [_locService stopUserLocationService];
    }
    
        BMKGeoCodeSearch *search = [[BMKGeoCodeSearch alloc]init];
        search.delegate = self;
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [search reverseGeoCode:reverseGeocodeSearchOption];
    
    
}

//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
//{
//    //NSLog(@"heading is %@",userLocation.heading);
//    myUserLocation =[ BMKUserLocation new];
//    myUserLocation = userLocation;
//    NSLog(@"%@",userLocation);
//}


/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)didStopLocatingUser
{
    NSLog(@"stop locate");
}

- (void)dealloc {
    if (_geocodesearch != nil) {
        _geocodesearch = nil;
    }
    if (_locService != nil) {
        _locService = nil;
    }
}




#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERNAME];
    
//    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"HH:mm:ss"];
    
    NSString *timeString = @"";
    NSString *addressString = @"";
    
    
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO;//不使用文本信息
    sendReq.scene = 0;//0 = 好友列表 1 = 朋友圈 2 = 收藏
    
    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    urlMessage.title = @"考勤报告";
    
    if ([tapStartorEndFlag isEqualToString:@"上班考勤"]) {
        AttendanceListModel *model = attendanceListArray[0];
        timeString = model.startTime;
        addressString = model.startAddress;
        flagBan = @"上班";
        urlMessage.title = @"上班考勤报告";//分享标题
    }
    else if([tapStartorEndFlag isEqualToString:@"下班考勤"])
    {
        if (attendanceListArray.count == 2) {
            AttendanceListModel *model = attendanceListArray[1];
            timeString = model.endTime;
            addressString = model.endAddress;
            flagBan = @"下班";
            urlMessage.title = @"下班考勤报告";//分享标题
        }
    }
    
    urlMessage.description = [NSString stringWithFormat:@"%@于%@在%@打卡%@",userName,timeString,addressString,flagBan];//分享描述
    [urlMessage setThumbImage:[UIImage imageNamed:@"icon_kaoqin"]];//分享图片,使用SDK的setThumbImage方法可压缩图片大小
    
    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = @"https://www.pgyer.com/zhwx-iOS";//分享链接
    
    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;
    
    if(buttonIndex == 0)
    {
        //发送分享信息
        sendReq.scene = 0;
        [WXApi sendReq:sendReq];
    }
//    else if(buttonIndex == 1)
//    {
//        //发送分享信息
//        sendReq.scene = 1;
//        [WXApi sendReq:sendReq];
//    }
    else
    {
        
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSLog(@"111");
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.labelText = @"考勤进行中";
        
        AttendanceNetHelper *helper = [AttendanceNetHelper new];
        NSMutableString *strings = [NSMutableString stringWithString:roadString];
        [strings deleteCharactersInRange:NSMakeRange(0, 3)];
        [helper doAttendanceActionWithAddress:[NSString stringWithFormat:@"%@%@",strings,locationString] andFlag:@"start" status:^(BOOL successful, AttendanceModel *attModel) {
            if ([attModel.status isEqualToString:@"success"]) {
                [self.view makeToast:@"考勤成功" duration:1 position:nil];
                [self requestAttendanceList];
            }
            else
            {
                [self.view makeToast:@"考勤失败" duration:1 position:nil];
            }
            [hud removeFromSuperview];
        } failure:^(NSError *error) {
            [self.view makeToast:@"网络请求失败" duration:1 position:nil];
            [hud removeFromSuperview];
        }];
    }
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
