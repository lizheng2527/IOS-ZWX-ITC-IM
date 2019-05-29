//
//  MRFeedBackController.m
//  NIM
//
//  Created by 中电和讯 on 2017/4/10.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRFeedBackController.h"
#import "LHRatingView.h"
#import "ETTextView.h"
#import "TYHRepairNetRequestHelper.h"
#import "NSString+NTES.h"

#import "MRFeedBackListCell.h"
#import <TZImagePickerController.h>
#import "ACMediaFrame.h"
#import "MyRepairApplicationModel.h"


@interface MRFeedBackController ()<ratingViewDelegate,UIGestureRecognizerDelegate,UITextViewDelegate,UITableViewDelegate,UITableViewDataSource,MRFeedBackListCellDelegate>

@property(nonatomic,retain)LHRatingView *ratingView_Speed;
@property(nonatomic,retain)LHRatingView *ratingView_Attitude;
@property(nonatomic,retain)LHRatingView *ratingView_Level;
@property(nonatomic,retain)LHRatingView *ratingView_Quality;

@property(nonatomic,retain)LHRatingView *ratingView_Evaluate;

@property(nonatomic,assign)NSInteger uploadImageViewHeigh;
@property(nonatomic,retain)UIView *bgView;


@end

@implementation MRFeedBackController
{
    BOOL isYes;

    NSString *speedStr;
    NSString *attitudeStr;
    NSString *technicalLevelStr;
    NSString *qualityStr;
    NSString *scoreStr;
    
    NSString *suggestionText;
    
    
    __block NSMutableArray *uploadImageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"报修反馈评价";

    [self getFeedBackContentList];
    
    uploadImageArray = [NSMutableArray array];
    [self viewConfig];
    [self uploadViewInit];
    isYes = true;
    [self.textView resignFirstResponder];
}



-(void)getFeedBackContentList
{
    TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
    [helper getMyRepairApplicationFeedBackContentListWithReportId:_repairID andStatus:^(BOOL successful, MRAFeedBackInfoModel *feedBackModel) {
        speedStr = feedBackModel.speedStr;
        attitudeStr = feedBackModel.attitudeStr;
        technicalLevelStr = feedBackModel.technicalLevelStr;
        qualityStr = feedBackModel.qualityStr;
        scoreStr = feedBackModel.scoreStr;
        suggestionText = feedBackModel.suggestion;
        isYes = [feedBackModel.repairFlag integerValue];
        
        [_mainTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
    
}


#pragma mark - viewConfig
// 初始化上传视图
-(void)uploadViewInit
{
    //1、得到默认布局高度（唯一获取高度方法）
    CGFloat height = [ACSelectMediaView defaultViewHeight];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(102, 395, [UIScreen mainScreen].bounds.size.width - 102 - 10, height)];
    
    //2、初始化
    ACSelectMediaView *mediaView = [[ACSelectMediaView alloc] initWithFrame:CGRectMake(0, 0, _bgView.frame.size.width, _bgView.frame.size.height)];
    
    //3、选择媒体类型：ACMediaType
    mediaView.type = ACMediaTypePhotoAndCamera;
    
    mediaView.mediaArray = [NSMutableArray array];
    mediaView.imageMaxCount = 6;
    //是否需要显示图片上的删除按钮
    //mediaView.showDelete = NO;
    
    //5、随时获取新的布局高度
    [mediaView observeViewHeight:^(CGFloat value) {
        _bgView.height = value ;
        _uploadImageViewHeigh = (value - 40) / 2;
        if (_uploadImageViewHeigh < 60) {
            _uploadImageViewHeigh = 0;
        }
        [_mainTableView reloadData];
        //        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
        //        [_mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    //6、随时获取已经选择的媒体文件
    [mediaView observeSelectedMediaArray:^(NSArray<ACMediaModel *> *list) {
        uploadImageArray = [NSMutableArray arrayWithArray:list];
    }];
    _bgView.backgroundColor = [UIColor clearColor];
    [_bgView addSubview:mediaView];
}




#pragma mrak - TableViewDelegate&DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idenSection0 = @"MRFeedBackListCell";
    MRFeedBackListCell *cell = [tableView dequeueReusableCellWithIdentifier:idenSection0];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"MRFeedBackListCell" owner:self options:nil].firstObject;
    }
    cell.delegate = self;
    
    _ratingView_Speed = cell.ratingView_Speed;
    _ratingView_Attitude = cell.ratingView_Attitude;
    _ratingView_Level = cell.ratingView_Level;
    _ratingView_Quality = cell.ratingView_Quality;
    _ratingView_Evaluate = cell.ratingView_Evaluate;
    _ratingView_Speed.delegate = self;
    _ratingView_Attitude.delegate = self;
    _ratingView_Level.delegate = self;
    _ratingView_Quality.delegate = self;
    _ratingView_Evaluate.delegate = self;
    
    _ratingView_Speed.score = [speedStr integerValue];
    _ratingView_Attitude.score = [attitudeStr integerValue];
    _ratingView_Level.score = [technicalLevelStr integerValue];
    _ratingView_Quality.score = [qualityStr integerValue];
    _ratingView_Evaluate.score = [scoreStr integerValue];
    
    cell.textView.text = suggestionText.length?suggestionText:@"";
    
    cell.textView.delegate = self;
    
    if (!isYes) {
        [cell.yesButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
        [cell.noButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    }
    
    if (!_bgView.superview) {
        [cell.contentView addSubview:_bgView];
    }
    
    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 480 + _uploadImageViewHeigh / 3 * 2;
}

#pragma mark - CellDelegate
-(void)yesBtnClick:(MRFeedBackListCell *)cell
{
    [cell.noButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [cell.yesButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    isYes = true;
}

-(void)noBtnClick:(MRFeedBackListCell *)cell
{
    [cell.yesButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected" ] forState:UIControlStateNormal];
    [cell.noButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected" ] forState:UIControlStateNormal];
    isYes = NO;
}


#pragma mark - initView
-(void)viewConfig
{
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.separatorStyle = NO;
    
    speedStr = @"";
    attitudeStr = @"";
    technicalLevelStr = @"";
    qualityStr = @"";
    scoreStr = @"";
    suggestionText = @"";
}

#pragma mark - ratingViewDelegate
- (void)ratingView:(LHRatingView *)view score:(CGFloat)score
{
    if ([view isEqual:_ratingView_Speed]) {
        speedStr = [NSString stringWithFormat:@"%f",score];
    }
    else if ([view isEqual:_ratingView_Attitude]) {
        attitudeStr = [NSString stringWithFormat:@"%f",score];
    }
    else if ([view isEqual:_ratingView_Level]) {
        technicalLevelStr = [NSString stringWithFormat:@"%f",score];
    }
    else if ([view isEqual:_ratingView_Quality]) {
        qualityStr = [NSString stringWithFormat:@"%f",score];
    }
    else if ([view isEqual:_ratingView_Evaluate]) {
        scoreStr = [NSString stringWithFormat:@"%f",score];
    }
}


-(NSMutableDictionary *)getSubmitDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:attitudeStr forKey:@"attitudeStr"];
    [dic setValue:technicalLevelStr forKey:@"technicalLevelStr"];
    [dic setValue:qualityStr forKey:@"qualityStr"];
    [dic setValue:scoreStr forKey:@"scoreStr"];
    [dic setValue:speedStr forKey:@"speedStr"];
    [dic setValue:suggestionText forKey:@"suggestion"];
    [dic setValue:self.repairID.length?self.repairID:@"" forKey:@"reportId"];
    [dic setValue:isYes?@"1":@"0" forKey:@"repairFlag"];
    
    return dic;
}

#pragma mark - SubmitAction
- (IBAction)submitAction:(id)sender {
    
    if ([NSString isBlankString:attitudeStr] || [NSString isBlankString:qualityStr] || [NSString isBlankString:technicalLevelStr] || [NSString isBlankString:scoreStr] || [NSString isBlankString:speedStr]) {
        [self.view makeToast:@"部分评分不完整,请重新评分" duration:1.5 position:CSToastPositionCenter];
    }
    else
    {
        [SVProgressHUD showWithStatus:@"正在提交反馈评价"];
        TYHRepairNetRequestHelper *helper = [TYHRepairNetRequestHelper new];
        [helper saveMyRepairApplicationFeedbackWithFeedbackDic:[self getSubmitDic] imageArray:uploadImageArray andStatus:^(BOOL successful, NSMutableArray *dataSource) {
            [self.view makeToast:@"评价成功" duration:1.5 position:CSToastPositionCenter];
            [SVProgressHUD dismiss];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        } failure:^(NSError *error) {
            [self.view makeToast:@"评价提交失败" duration:1.5 position:CSToastPositionCenter];
            [SVProgressHUD dismiss];
        }];
    }
}


#pragma mark - textViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    suggestionText = textView.text;
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
