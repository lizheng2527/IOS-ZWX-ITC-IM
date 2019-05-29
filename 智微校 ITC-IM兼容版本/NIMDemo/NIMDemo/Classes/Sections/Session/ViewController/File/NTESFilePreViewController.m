//
//  NTESFilePreViewController.m
//  NIM
//
//  Created by chris on 15/4/21.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESFilePreViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface NTESFilePreViewController ()<UIDocumentInteractionControllerDelegate>

@property(nonatomic,strong)NIMFileObject *fileObject;

@property(nonatomic,strong)UIDocumentInteractionController *interactionController;

@property(nonatomic,assign)BOOL isDownLoading;

@end

@implementation NTESFilePreViewController

- (instancetype)initWithFileObject:(NIMFileObject*)object{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _fileObject = object;
    }
    return self;
}

- (void)dealloc{
    [[NIMSDK sharedSDK].resourceManager cancelTask:_fileObject.path];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.fileObject.displayName;
    self.fileNameLabel.text   = self.fileObject.displayName;
    NSString *filePath = self.fileObject.path;
    self.progressView.hidden = YES;
    [self.actionBtn addTarget:self action:@selector(touchUpBtn) forControlEvents:UIControlEventTouchUpInside];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self.actionBtn setTitle:@"打开" forState:UIControlStateNormal];
    }else{
        [self.actionBtn setTitle:@"下载文件" forState:UIControlStateNormal];
    }
}

- (void)touchUpBtn{
    NSString *filePath = self.fileObject.path;
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [self openWithOtherApp];
    }else{
        if (self.isDownLoading) {
            [[NIMSDK sharedSDK].resourceManager cancelTask:filePath];
            self.progressView.hidden   = YES;
            self.progressView.progress = 0.0;
            [self.actionBtn setTitle:@"下载文件" forState:UIControlStateNormal];
            self.isDownLoading         = NO;
        }else{
            [self downLoadFile];
        }
    }
}

#pragma mark - 文件下载

- (void)downLoadFile{
    NSString *url = self.fileObject.url;
    __weak typeof(self) wself = self;
    [[NIMSDK sharedSDK].resourceManager download:url filepath:self.fileObject.path progress:^(float progress) {
        wself.isDownLoading = YES;
        wself.progressView.hidden = NO;
        wself.progressView.progress = progress;
        [wself.actionBtn setTitle:@"取消下载" forState:UIControlStateNormal];
    } completion:^(NSError *error) {
        wself.isDownLoading = NO;
        wself.progressView.hidden = YES;
        if (!error) {
            [wself.actionBtn setTitle:@"打开" forState:UIControlStateNormal];
        }else{
            wself.progressView.progress = 0.0f;
            [wself.actionBtn setTitle:@"下载失败，点击重新下载" forState:UIControlStateNormal];
        }
    }];
}


#pragma mark - 其他应用打开

- (void)openWithOtherApp{
    
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: [NSURL fileURLWithPath:self.fileObject.path]];
    
    interactionController.delegate = self;
    [interactionController presentPreviewAnimated:YES];
    CGRect navRect =self.navigationController.navigationBar.frame;
    navRect.size =CGSizeMake(1500.0f,40.0f);
    //显示包含预览的菜单项
    [interactionController presentOptionsMenuFromRect:navRect inView:self.view animated:YES];
}

#pragma mark Document Interaction Controller Delegate Methods
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorGreen]];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [self.navigationController.navigationBar setBarTintColor:[UIColor TabBarColorGreen]];
}


@end
