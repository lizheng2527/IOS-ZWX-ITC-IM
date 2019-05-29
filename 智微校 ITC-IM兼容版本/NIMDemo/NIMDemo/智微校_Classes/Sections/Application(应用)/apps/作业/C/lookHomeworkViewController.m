//
//  lookHomeworkViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/28.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "lookHomeworkViewController.h"
#import "HWNetWorkHandler.h"
#import "HWDetailModel.h"
#import "HWDownloadCell.h"
#import <MJExtension.h>
#import <AVFoundation/AVFoundation.h>
#import "TYHHttpTool.h"
#import <UIView+Toast.h>
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "SubmitHomeworkViewController.h"
#import "SDAutoLayout.h"
#import <MBProgressHUD.h>
#import "CheackHomeworkViewController.h"
#define myCyanColor colorWithRed:54/255.0 green:191/255.0 blue:181/255.0 alpha:1

@interface lookHomeworkViewController ()<UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate,MBProgressHUDDelegate>

@property(nonatomic,retain)HWDetailModel *detailModel;
@property(nonatomic,retain)NSMutableArray *photos;
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@end

@implementation lookHomeworkViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [_submitButton setBackgroundColor:[UIColor myCyanColor]];
    
    // Do any additional setup after loading the view from its nib.
    [self changeLeftBar];
    [self ConfigData];
    
}

-(void)setLayout
{
    HWDetailModel *model = _dataArray[0];
    if ([self isBlankString:model.attachmentUrl]) {
    }
#define BGView self.view
#define ScrollView self.mainScrollView
    
    
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [self.view addSubview:_mainScrollView];
        
        _mainScrollView.sd_layout.leftSpaceToView(BGView,0).topSpaceToView(BGView,0).rightSpaceToView(BGView,0).bottomSpaceToView(BGView,0);
        
        
        [self.mainScrollView addSubview:_mainTableView];
        [self.view addSubview:_submitButton];
        _homeworkBGview.sd_layout.leftSpaceToView(ScrollView,0).topSpaceToView(ScrollView,0).rightSpaceToView(ScrollView,0).heightIs(135);
        
        _finishLabel.sd_layout.rightSpaceToView(ScrollView,10).topSpaceToView(ScrollView,10).widthRatioToView(ScrollView,0.3).heightRatioToView(_homeworkBGview,0.3);
        
        _submitButton.sd_layout.leftSpaceToView(BGView,0).bottomSpaceToView(BGView,0).rightSpaceToView(BGView,0).heightIs(50);
        
        _deatilLabel.sd_layout.leftSpaceToView(ScrollView,15).topSpaceToView(_homeworkBGview,10).rightSpaceToView(ScrollView,15).autoHeightRatio(0);
        
        [_deatilLabel setMaxNumberOfLinesToShow:0];
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，
            [_deatilLabel setDidFinishAutoLayoutBlock:^(CGRect frame) {
                
                _mainTableView.sd_layout.topSpaceToView(_deatilLabel,20).heightIs(80);
                
                if ([self isBlankString:model.attachmentUrl]) {
                    _mainScrollView.contentSize = CGSizeMake(0, _homeworkBGview.frame.size.height  + _deatilLabel.frame.size.height + 80);
                }
                else
                {
                    _mainScrollView.contentSize = CGSizeMake(0, _homeworkBGview.frame.size.height  + _deatilLabel.frame.size.height + _mainTableView.frame.size.height + 80);
                }
            }];
//        }); 
    });
}


#pragma mark - 网络请求
-(void)ConfigData
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.labelFont = [UIFont systemFontOfSize:12];
    hud.labelText = @"获取数据中";
    
    _photos = [NSMutableArray array];
    _detailModel = [[HWDetailModel alloc]init];
    HWNetWorkHandler *helper = [[HWNetWorkHandler alloc]init];
    [helper getCourseDetailWithHomeworkID:_homeworkID Status:^(BOOL successful, NSMutableArray *dataSource) {
        _dataArray = [NSMutableArray arrayWithArray:dataSource];
        HWDetailModel *model = dataSource[0];
        _finishLabel.attributedText  = [self dealFinishString:model.statusName];
        _deatilLabel.text = model.content;
        
        _subjectLabel.text = model.courseName;
        _homeworkNameLabel.text = model.title;
        _homeworkDuixiang.text = model.workEclass;
        _submitEndtimeLabel.text = [NSString stringWithFormat:@"提交截止至：%@",model.endTime];
        [self setLayout];
         [self initTableView];
        [hud removeFromSuperview];
        
    } failure:^(NSError *error) {
        [hud removeFromSuperview];
    }];
}


#pragma mark - 颜色处理
-(NSMutableAttributedString *)dealFinishString:(NSString *)string
{
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    if ([string isEqualToString:@"已完成"]) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor myCyanColor]
                                 range:NSMakeRange(0, 3)];
        [_submitButton setTitle:@"查看我的作业" forState:UIControlStateNormal];
    }

    else if ([string isEqualToString:@"未完成"]) {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor]
                                 range:NSMakeRange(0, 3)];
        [_submitButton setTitle:@"提交作业" forState:UIControlStateNormal];
    }
    else if ([string isEqualToString:@"已过期"])
    {
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor]
                                 range:NSMakeRange(0, 3)];
//        [_submitButton removeFromSuperview];
        [_submitButton setBackgroundColor:[UIColor clearColor]];
        [_submitButton setTitle:@"" forState:UIControlStateNormal];
        [_submitButton setHidden:YES];
    }
    return attributedString;
    
}

-(BOOL)isBlankString:(NSString *)string {
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

#pragma mark - initTableView
-(void)initTableView{
    _mainTableView.dataSource = self;
    _mainTableView.delegate = self;
    _mainTableView.bounces = NO;
    [_mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    _mainTableView.rowHeight = 80;
    _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_mainTableView reloadData];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWDetailModel *model = _dataArray[indexPath.row];
    if ([model.attachmentUrl isEqualToString:@""]) {
        return [[UITableViewCell alloc]init];
    }
    static NSString *iden = @"HWDownloadCell";
    HWDownloadCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HWDownloadCell" owner:self options:nil].firstObject;
    }
    cell.nameLabel.text = model.attachmentName;
    cell.sizeLabel.text = model.fileSize;
    cell.fileTypeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_img"];
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:model.attachmentName];
//
    NSString * str = model.attachmentName;
    NSRange range = [str rangeOfString:@"."];
    str = [str substringFromIndex:range.location];
    
    if ([str isEqualToString:@".txt"]) {
        cell.fileTypeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_txt"];
    } else if ([str isEqualToString:@".doc"]||[str isEqualToString:@".docx"]||[str isEqualToString:@".DOC"]||[str isEqualToString:@".DOCX"]) {
        cell.fileTypeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_doc"];
    } else if ([str isEqualToString:@".zip"]) {
        cell.fileTypeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_zip"];
    } else if ([str isEqualToString:@".pdf"]) {
        cell.fileTypeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_pdf"];
    } else if ([str isEqualToString:@".xls"]||[str isEqualToString:@".xlsx"]|[str isEqualToString:@".XLSX"]|[str isEqualToString:@".XLS"]) {
        cell.fileTypeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_xls"];
    }else if ([str isEqualToString:@".ppt"]||[str isEqualToString:@".pptx"]||[str isEqualToString:@".PPT"]||[str isEqualToString:@".PPTX"]) {
        cell.fileTypeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_ppt"];
    } else {
        cell.fileTypeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_img"];
    }
    
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:paths] && ![self isBlankString:model.attachmentUrl ]) {
        cell.downloadimage.image = [UIImage imageNamed:@"amd_list_item_open"];
        cell.progressView.hidden = YES;
    }
    else
    {
        cell.downloadimage.image = [UIImage imageNamed:@"amd_list_item_download"];
    }
    return cell;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HWDetailModel *model = _dataArray[0];
    if ([self isBlankString:model.attachmentUrl]) {
        return 0;
    }
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HWDetailModel *model = _dataArray[indexPath.row];
    HWDownloadCell * cell = [tableView cellForRowAtIndexPath:indexPath];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:model.attachmentName];
    if ([fileManager fileExistsAtPath:paths] && ![self isBlankString:model.attachmentUrl]) {
        NSURL *url = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
//        NSURL *path = [url URLByAppendingPathComponent:model.attachmentName];
        NSString * str = model.attachmentName;
        NSRange range = [str rangeOfString:@"."];
        str = [str substringFromIndex:range.location];
        
        if ([model.attachmentName hasSuffix:@"jpg"] || [model.attachmentName hasSuffix:@"png"]) {
            [self.photos removeAllObjects];
            
            MJPhoto *photo = [[MJPhoto alloc]init];
            photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,model.attachmentUrl]];
            [self.photos addObject:photo];
            
            MJPhotoBrowser *brow = [[MJPhotoBrowser alloc]init];
            brow.photos = self.photos;
            [brow show];
            brow.currentPhotoIndex = 0;
        }
        else
        {
            _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL: [NSURL fileURLWithPath:paths]];
            _documentInteractionController.delegate = self;
//            [_documentInteractionController presentPreviewAnimated:YES];
            //显示包含预览的菜单项
            [_documentInteractionController presentOptionsMenuFromRect:self.view.bounds inView:self.view animated:YES];
            
        }
    }
    else
    {
        if ([self isBlankString:model.attachmentUrl]) {
            [self.view makeToast:@"下载失败,附件可能不存在" duration:1 position:CSToastPositionCenter];
            return;
        }
        
        NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:model.attachmentName];
        NSString *downloadURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,model.attachmentUrl];
        TYHHttpTool *downloadHelper = [[TYHHttpTool alloc]init];
        [downloadHelper downloadInferface:downloadURL downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            cell.downloadimage.image = [UIImage imageNamed:@"amd_list_item_open"];
            NSData * data = (NSData *)responseObject;
            [data writeToFile:paths atomically:YES];
            
        } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            cell.downloadimage.image = [UIImage imageNamed:@"amd_list_item_pause"];
        } progress:^(float progress) {
            cell.downloadimage.image = [UIImage imageNamed:@"amd_list_item_pause"];
            cell.progressView.hidden = NO;
            cell.progressView.progress = progress;
            if (progress == 1) {
                [cell.progressView setHidden:YES];
                [tableView reloadData];
            }
        }];
    }
    
}

#pragma mark -
-(void)setHomeworkID:(NSString *)homeworkID
{
    _homeworkID = homeworkID;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - 创建返回NavBarItem
-(void)changeLeftBar
{
    UIBarButtonItem * leftItem = nil;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"HomeWork_returns"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"HomeWork_returns"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
}


-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitHomework:(id)sender {
    NSMutableArray *_images = [NSMutableArray array];
    HWDetailModel *model = _dataArray[0];
    SubmitHomeworkViewController *subView = [[SubmitHomeworkViewController alloc]initWithImages:_images andFinshString:model.statusName andHomeworkID:model.studentWorkId];
    subView.view.backgroundColor = [UIColor whiteColor];
    if ([model.statusName isEqualToString:@"已完成"]) {
        
        NSString *contentString = [model.result objectForKey:@"content"];
        NSArray *imageArray = [model.result objectForKey:@"imageList"];
        CheackHomeworkViewController *checkView = [[CheackHomeworkViewController alloc]initWithImageList:[NSMutableArray arrayWithArray:imageArray] contentString:contentString];
        
        checkView.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:checkView animated:YES];
        
    }
    else
    [self.navigationController pushViewController:subView animated:YES];
    
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear: YES];
    self.title = @"查看作业";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor myCyanColor]}];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: YES];
   
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return [self navigationController];
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
