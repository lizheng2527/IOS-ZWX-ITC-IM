//
//  RNewRecordController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RNewRecordController.h"
#import "RNewRecordCell.h"
#import "TPKeyboardAvoidingTableView.h"
#import "PickerView.h"

#import "TYHHttpTool.h"
#import "RecordNetHelper.h"

#import "ACMediaFrame.h"


@interface RNewRecordController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,assign)NSInteger uploadImageViewHeigh;
@property(nonatomic,retain)UIView *bgView;

@end

@implementation RNewRecordController
{
    RNewRecordCell *mainCell;
    NSString *planString;
    NSString *noteString;
    NSString *summarizeString;
    NSString *effectiveTimeString;
    NSString *startTimeString;
    NSString *endTimeString;
    
    __block NSMutableArray *uploadImageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    [self createBarItem];
    
    [self uploadViewInit];
    self.title = @"项目";
}

#pragma mark - initView
-(void)initTableView
{
    planString = @"";
    summarizeString = @"";
    noteString = @"";
    effectiveTimeString = @"";
    startTimeString = @"";
    endTimeString = @"";
    _uploadImageViewHeigh = 0;
    uploadImageArray = [NSMutableArray array];
    
    _mainTableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.bounces = NO;
    _mainTableview.tableFooterView = [UIView new];
    _mainTableview.separatorStyle = NO;
    [self.view addSubview:_mainTableview];
    
}

-(void)createBarItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightButton setTitle:@"提交" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton sizeToFit];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
}

// 初始化上传视图
-(void)uploadViewInit
{
    //1、得到默认布局高度（唯一获取高度方法）
    CGFloat height = [ACSelectMediaView defaultViewHeight];
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(90, 320, [UIScreen mainScreen].bounds.size.width - 100, height)];
    
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
        [_mainTableview reloadData];
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


#pragma mark - TableViewDelegate & Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"RNewRecordCell";
    RNewRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"RNewRecordCell" owner:self options:nil].firstObject;
    }
    mainCell = cell;
    
    [cell.startButton addTarget:self action:@selector(chooseStartTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell.endButton addTarget:self action:@selector(chooseEndTimeAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.workTimeTextfield.delegate = self;
    
    cell.noteTextview.delegate = self;
    cell.planTextview.delegate = self;
    cell.summarizeTextview.delegate = self;
    
    
    cell.planTextview.tag = 300001;
    cell.summarizeTextview.tag = 300002;
    cell.noteTextview.tag = 300003;
    
    cell.workTimeTextfield.text = effectiveTimeString.length?[NSString stringWithFormat:@"%@小时",effectiveTimeString]:@"";
    cell.noteTextview.text = noteString.length?noteString:@"";
    cell.planTextview.text = planString.length?planString:@"";
    cell.summarizeTextview.text = summarizeString.length?summarizeString:@"";
    if (startTimeString.length) {
        [cell.startButton setTitle:startTimeString forState:UIControlStateNormal];
    }
    if (endTimeString.length) {
        [cell.endButton setTitle:endTimeString forState:UIControlStateNormal];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 357 + _uploadImageViewHeigh;
}

#pragma mark - ClickActions

-(void)submitAction:(id)sender
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:planString forKey:@"plan"];
    [dic setValue:summarizeString forKey:@"summarize"];
    [dic setValue:noteString forKey:@"remark"];
    [dic setValue:effectiveTimeString forKey:@"effectiveTime"];
    [dic setValue:endTimeString forKey:@"workEndTime"];
    [dic setValue:startTimeString forKey:@"workStartTime"];
    [dic setValue:dateString forKey:@"date"];
    
    [SVProgressHUD showWithStatus:@"提交数据中"];
    
    RecordNetHelper *helper = [RecordNetHelper new];
    [helper saveWorkLogWithUserDic:dic UploadImageArray:uploadImageArray andStatus:^(BOOL successful, NSMutableArray *dataSource) {
        
        if (successful) {
            [self.view makeToast:@"提交成功" duration:1.5 position:CSToastPositionCenter];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        else
        {
            [self.view makeToast:@"提交失败" duration:1.5 position:CSToastPositionCenter];
        }
        [_mainTableview reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"提交失败" duration:1.5 position:CSToastPositionCenter];
    }];
    
}

-(void)chooseStartTimeAction:(id)sender
{
    PickerView *pickview = [PickerView showPickerViewInkeyWindowTopWithType:PickerViewTypeDate_Time];
    pickview.selectBlock = ^(NSObject *data, BOOL isSureBtn) {
      
//        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:data];
        
        [mainCell.startButton setTitle:dateString forState:UIControlStateNormal];
        startTimeString = dateString;
    };
}

-(void)chooseEndTimeAction:(id)sender
{
    PickerView *pickview = [PickerView showPickerViewInkeyWindowTopWithType:PickerViewTypeDate_Time];
    pickview.selectBlock = ^(NSObject *data, BOOL isSureBtn) {
        //        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *dateString = [dateFormatter stringFromDate:data];
        
        [mainCell.endButton setTitle:dateString forState:UIControlStateNormal];
        endTimeString = dateString;
    };
}



#pragma mark - UItextFieldDelegate & uitextviewDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
        NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    effectiveTimeString = toBeString;
    return YES;
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag == 300001) {
        planString = textView.text;
    }else if(textView.tag == 300002)
    {
        summarizeString = textView.text;
    }else if(textView.tag == 300003)
    {
        noteString = textView.text;
    }
    
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
