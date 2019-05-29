//
//  PServerApplicationDetailController.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "PServerApplicationDetailController.h"
#import "SDAutoLayout.h"
#import "TPKeyboardAvoidingTableView.h"
#import "PAddServiceApplyCell.h"

#import "ProjectNetHelper.h"

#import <MJExtension.h>
#import "RecordAttachmentCell.h"
#import "NSString+NTES.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "TYHHttpTool.h"
#import "RecordModel.h"



@interface PServerApplicationDetailController ()<UITableViewDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate>
@property(nonatomic,retain)NSMutableArray *photos;
@end

@implementation PServerApplicationDetailController
{
    NSDictionary *mainDic;
    __block NSMutableArray *attachmentListModelArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initTableView];
    self.title = @"服务申请详情";
    //    [self createApplyButton];
    [self requestData];
    _photos = [NSMutableArray array];
}

#pragma mark - RequestData
-(void)requestData
{
    [SVProgressHUD showWithStatus:@"获取详情中"];
    ProjectNetHelper *helper = [ProjectNetHelper new];
    [helper getServiceApplyDetailWithServiceApplyId:_projectID andStatus:^(BOOL successful, NSDictionary *jsonDic) {
        mainDic = jsonDic;
        NSMutableArray *downloadArray = [NSMutableArray arrayWithArray:[RecordattachmentModel mj_objectArrayWithKeyValuesArray:[jsonDic objectForKey:@"attachmentList"]]];
        if (downloadArray.count) {
            attachmentListModelArray = [NSMutableArray arrayWithArray:downloadArray];
        }
        [_mainTableview reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"获取数据失败" duration:1.5 position:CSToastPositionCenter];
    }];
}
#pragma mark - initView
-(void)initTableView
{
    _mainTableview = [[TPKeyboardAvoidingTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
    _mainTableview.delegate = self;
    _mainTableview.dataSource = self;
    _mainTableview.bounces = NO;
    _mainTableview.tableFooterView = [UIView new];
    [self.view addSubview:self.mainTableview];
}


#pragma mark - TableViewDelegate & Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *iden = @"PAddServiceApplyCell";
        PAddServiceApplyCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"PAddServiceApplyCell" owner:self options:nil].firstObject;
        }
        cell.selectionStyle = NO;
        
        for (UIView *view in cell.contentView.subviews) {
            if ([view isKindOfClass:[UITextField class]]) {
                view.userInteractionEnabled = NO;
            }
            if ([view isKindOfClass:[UITextView class]]) {
                UITextView *textView = (UITextView *)view;
                textView.editable = NO;
            }
        }
        
        cell.applyUserLabel.text = [mainDic objectForKey:@"applyerName"];
        cell.applyUserPhoneLabel.text = [mainDic objectForKey:@"phoneNum"];
        cell.projectNameLabel.text = [mainDic objectForKey:@"projectName"];
        
        [cell.chooseDateButton setTitle:[mainDic objectForKey:@"serviceTimeStart"] forState:UIControlStateNormal];
        [cell.chooseTimeButton setTitle:[mainDic objectForKey:@"serviceTimeEnd"] forState:UIControlStateNormal];
        
        cell.serviceWaysTextfield.text = [mainDic objectForKey:@"serviceWay"];
        cell.servicePlaceTextfield.text = [mainDic objectForKey:@"servicePlace"];
        cell.serviceSchoolTextfield.text = [mainDic objectForKey:@"serviceSchool"];
        cell.serviceCustomTextfield.text = [mainDic objectForKey:@"serviceObject"];
        cell.serviceLinkerTextfield.text = [mainDic objectForKey:@"linkMan"];
        cell.serviceLinkerPhoneTextfield.text = [mainDic objectForKey:@"linkManPhone"];
        cell.serviceLinkerMailTextfield.text = [mainDic objectForKey:@"linkManEmail"];
        
        
        cell.textView_Jianshu.text = [mainDic objectForKey:@"sketch"];
        cell.textView_Target.text = [mainDic objectForKey:@"serviceTarget"];
        cell.textView_Member.text = [mainDic objectForKey:@"together"];
        cell.textView_Remark.text = [mainDic objectForKey:@"remark"];
        
        return cell;
    }
    else
    {
        static NSString *idenn = @"RecordAttachmentCell";
        RecordAttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:idenn];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"RecordAttachmentCell" owner:self options:nil].firstObject;
        }
        RecordattachmentModel *attachmentModel = attachmentListModelArray[indexPath.row - 1];
        
        cell.numLabel.text = [NSString stringWithFormat:@"%ld.",(long)indexPath.row];
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
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + attachmentListModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 826;
    }else return 48;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row > 0) {
        RecordattachmentModel *attachmentModel = attachmentListModelArray[indexPath.row - 1];
        
        RecordAttachmentCell *cell = [_mainTableview cellForRowAtIndexPath:indexPath];
        
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
                    [_mainTableview reloadData];
                }
            }];
        }
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
