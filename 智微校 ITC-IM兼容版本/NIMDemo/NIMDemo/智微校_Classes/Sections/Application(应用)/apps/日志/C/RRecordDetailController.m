//
//  RRecordDetailController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RRecordDetailController.h"
#import "RecordModel.h"
#import "SDAutoLayout.h"
#import "RecordAttachmentCell.h"
#import "NSString+NTES.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "TYHHttpTool.h"




@interface RRecordDetailController ()<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate>

@property(nonatomic,retain)NSMutableArray *photos;

@end

@implementation RRecordDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title = _model.userName;
    [self initTableView];
    
    self.photos = [NSMutableArray array];
}


#pragma mark - initView
-(void)initTableView
{
    _attachmentTableview.delegate = self;
    _attachmentTableview.dataSource = self;
    _attachmentTableview.bounces = NO;
    _attachmentTableview.tableFooterView = [UIView new];
//    _attachmentTableview.separatorStyle = NO;
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    _remarkLabel.text = _model.remark;
    _dateTimeLabel.text = dateString;
    [_startTimeButton setTitle:_model.workStartTime forState:UIControlStateNormal];
    [_endTimeButton setTitle:_model.workStartTime forState:UIControlStateNormal];
    _effectiveLabel.text = _model.effectiveTime;
    _planLabel.text = _model.plan;
    _summarizeLabel.text = _model.summarize;
    
}



#pragma mark - TableViewDelegate & Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden = @"RecordAttachmentCell";
    RecordAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"RecordAttachmentCell" owner:self options:nil].firstObject;
    }
    RecordattachmentModel *attachmentModel = _model.attachmentListModelArray[indexPath.row];
    
    cell.numLabel.text = [NSString stringWithFormat:@"%ld.",(long)indexPath.row + 1];
    cell.desLabel.text = attachmentModel.name;
    
    
    cell.itemTypeIcon.image = [UIImage imageNamed:@"attach_file_icon_mailread_img"];
    
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:attachmentModel.name];
    //
    NSString * str = attachmentModel.name;
    NSRange range = [str rangeOfString:@"."];
    str = [str substringFromIndex:range.location];
    
    if ([str isEqualToString:@".txt"]) {
        cell.itemTypeIcon.image = [UIImage imageNamed:@"attach_file_icon_mailread_txt"];
    } else if ([str isEqualToString:@".doc"]||[str isEqualToString:@".docx"]||[str isEqualToString:@".DOC"]||[str isEqualToString:@".DOCX"]) {
        cell.itemTypeIcon.image = [UIImage imageNamed:@"attach_file_icon_mailread_doc"];
    } else if ([str isEqualToString:@".zip"]) {
        cell.itemTypeIcon.image = [UIImage imageNamed:@"attach_file_icon_mailread_zip"];
    } else if ([str isEqualToString:@".pdf"]) {
        cell.itemTypeIcon.image = [UIImage imageNamed:@"attach_file_icon_mailread_pdf"];
    } else if ([str isEqualToString:@".xls"]||[str isEqualToString:@".xlsx"]|[str isEqualToString:@".XLSX"]|[str isEqualToString:@".XLS"]) {
        cell.itemTypeIcon.image = [UIImage imageNamed:@"attach_file_icon_mailread_xls"];
    }else if ([str isEqualToString:@".ppt"]||[str isEqualToString:@".pptx"]||[str isEqualToString:@".PPT"]||[str isEqualToString:@".PPTX"]) {
        cell.itemTypeIcon.image = [UIImage imageNamed:@"attach_file_icon_mailread_ppt"];
    } else {
        cell.itemTypeIcon.image = [UIImage imageNamed:@"attach_file_icon_mailread_img"];
    }
    
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:paths] && ![NSString isBlankString:attachmentModel.url ]) {
        cell.downloadStatusIcon.image = [UIImage imageNamed:@"amd_list_item_open"];
        cell.downloadProgress.hidden = YES;
    }
    else
    {
        cell.downloadStatusIcon.image = [UIImage imageNamed:@"amd_list_item_download"];
    }
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.attachmentListModelArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RecordattachmentModel *attachmentModel = _model.attachmentListModelArray[indexPath.row];
    
    RecordAttachmentCell *cell = [_attachmentTableview cellForRowAtIndexPath:indexPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:attachmentModel.name];
    if ([fileManager fileExistsAtPath:paths] && ![NSString isBlankString:attachmentModel.url]) {
        NSURL *url = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *path = [url URLByAppendingPathComponent:attachmentModel.name];
        NSString * str = attachmentModel.name;
        NSRange range = [str rangeOfString:@"."];
        str = [str substringFromIndex:range.location];
        
        if ([attachmentModel.name hasSuffix:@"jpg"] || [attachmentModel.name hasSuffix:@"png"]) {
            [self.photos removeAllObjects];
            
            MJPhoto *photo = [[MJPhoto alloc]init];
            photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",k_V3ServerURL,attachmentModel.url]];
            [self.photos addObject:photo];
            
            MJPhotoBrowser *brow = [[MJPhotoBrowser alloc]init];
            brow.photos = self.photos;
            [brow show];
            brow.currentPhotoIndex = 0;
        }
        else
        {
            
            UIDocumentInteractionController *interactionController =
            [UIDocumentInteractionController interactionControllerWithURL: [NSURL fileURLWithPath:paths]];
            interactionController.delegate = self;
            [interactionController presentPreviewAnimated:YES];
            CGRect navRect =self.navigationController.navigationBar.frame;
            navRect.size =CGSizeMake(1500.0f,40.0f);
            
            //显示包含预览的菜单项
            [interactionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
            
        }
    }
    else
    {
        if ([NSString isBlankString:attachmentModel.url]) {
            [self.view makeToast:@"下载失败,附件可能不存在" duration:1 position:CSToastPositionCenter];
            return;
        }
        
        NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:attachmentModel.name];
        NSString *downloadURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,attachmentModel.url];
        TYHHttpTool *downloadHelper = [[TYHHttpTool alloc]init];
        [downloadHelper downloadInferface:downloadURL downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            cell.downloadStatusIcon.image = [UIImage imageNamed:@"amd_list_item_open"];
            NSData * data = (NSData *)responseObject;
            [data writeToFile:paths atomically:YES];
            
        } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            cell.downloadStatusIcon.image = [UIImage imageNamed:@"amd_list_item_pause"];
        } progress:^(float progress) {
            cell.downloadStatusIcon.image = [UIImage imageNamed:@"amd_list_item_pause"];
            cell.downloadProgress.hidden = NO;
            cell.downloadProgress.progress = progress;
            if (progress == 1) {
                [cell.downloadProgress setHidden:YES];
                [_attachmentTableview reloadData];
            }
        }];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}


#pragma mark Document Interaction Controller Delegate Methods
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
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
