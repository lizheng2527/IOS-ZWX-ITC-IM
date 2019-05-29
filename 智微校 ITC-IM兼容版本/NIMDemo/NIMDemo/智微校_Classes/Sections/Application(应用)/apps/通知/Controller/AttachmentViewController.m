//
//  AttachmentViewController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/11/6.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import "AttachmentViewController.h"
#import "AttachmentCell.h"
#import <MJExtension.h>
#import "TYHHttpTool.h"
#import <UIImageView+WebCache.h>
#import "TYHNewDetailViewController.h"

@interface AttachmentViewController ()<UIDocumentInteractionControllerDelegate>

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@property (nonatomic, strong) NSArray * dataArray;
@property (nonatomic, strong) UIImageView * imgView;
@property (nonatomic, strong) UIProgressView * progre;
@property (nonatomic, copy) NSString * paths;


@end

@implementation AttachmentViewController


- (NSArray *)dataArray {
    
    if (_dataArray == nil) {
        self.dataArray = [[NSArray alloc] init];
        
        self.dataArray = [AttachmentModel mj_objectArrayWithKeyValuesArray:self.attachmentArray];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    //  注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"AttachmentCell" bundle:nil]  forCellReuseIdentifier:@"cell"];
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    self.tableView.bounces = NO;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static  NSString * ID = @"cell";
    
    AttachmentCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[AttachmentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    AttachmentModel * model = self.dataArray[indexPath.row];
    
    cell.nameLabel.text = model.name;
    cell.numIndex.text = [NSString stringWithFormat:@"%ld.",(long)indexPath.row + 1];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:model.name];
    NSString * str = model.name;
    NSRange range = [str rangeOfString:@"."];
    str = [str substringFromIndex:range.location];
    
    if ([str isEqualToString:@".txt"]) {
        cell.officeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_txt"];
    } else if ([str isEqualToString:@".doc"]||[str isEqualToString:@".docx"]||[str isEqualToString:@".DOC"]||[str isEqualToString:@".DOCX"]) {
        cell.officeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_doc"];
    } else if ([str isEqualToString:@".zip"]) {
        cell.officeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_zip"];
    } else if ([str isEqualToString:@".pdf"]) {
        cell.officeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_pdf"];
    } else if ([str isEqualToString:@".xls"]||[str isEqualToString:@".xlsx"]|[str isEqualToString:@".XLSX"]|[str isEqualToString:@".XLS"]) {
        cell.officeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_xls"];
    }else if ([str isEqualToString:@".ppt"]||[str isEqualToString:@".pptx"]||[str isEqualToString:@".PPT"]||[str isEqualToString:@".PPTX"]) {
        cell.officeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_ppt"];
    } else {
        cell.officeImage.image = [UIImage imageNamed:@"attach_file_icon_mailread_img"];
    }
    //attach_file_icon_mailread_ppt
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:paths]) {
        
        cell.downloadimage.image = [UIImage imageNamed:@"amd_list_item_open"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    AttachmentModel * model = self.dataArray[indexPath.row];
    
    return  [AttachmentCell cellAutoLayoutHeight:model.name];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AttachmentModel * model = self.dataArray[indexPath.row];
    
    AttachmentCell * cell = (AttachmentCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:model.name];
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:paths]) {
        
        NSURL *url = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        
        NSURL *path = [url URLByAppendingPathComponent:model.name];
        
//        NSString * str = model.name;
//        NSRange range = [str rangeOfString:@"."];
//        str = [str substringFromIndex:range.location];
        if (self.description && [_delegate respondsToSelector:@selector(tableViewDidSelectWithUrl:)]) {
            [_delegate tableViewDidSelectWithUrl:path];
        }
        
//        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:path];
//        [self.documentInteractionController setDelegate:self];
//        
//        
//        CGRect navRect = self.navigationController.navigationBar.frame;
//        
//        navRect.size = CGSizeMake(1500.0f, 40.0f);
//        
//        [_documentInteractionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];

    } else {
        
        NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:model.name];
        
        NSString * strUrl = [NSString stringWithFormat:@"%@",model.url];
        
        TYHHttpTool * http = [[TYHHttpTool alloc] init];
        
        UIApplication * app = [UIApplication sharedApplication];
        [http downloadInferface:strUrl downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (cell.progressView.hidden == YES) {
                
                cell.downloadimage.image = [UIImage imageNamed:@"amd_list_item_open"];
                NSData * data = (NSData *)responseObject;
                [data writeToFile:paths atomically:YES];
            }
        
        } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            cell.downloadimage.image = [UIImage imageNamed:@"amd_list_item_pause"];
            
        } progress:^(float progress) {
            
            if (app.applicationState == UIApplicationStateActive) {
                
                cell.downloadimage.image = [UIImage imageNamed:@"amd_list_item_pause"];
                cell.progressView.hidden = NO;
                cell.progressView.progress = progress;
                if (progress == 1) {
                    [cell.progressView setHidden:YES];
                }
            }
        }];
    }
}

#pragma mark Document Interaction Controller Delegate Methods
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

//- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
//{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"dropdownMenuDidDismiss" object:nil];
//    
//    [self removeFromParentViewController];
//}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorYellow]];
//
//    self.tableView.contentInset = UIEdgeInsetsZero;
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorYellow]];
}

@end
