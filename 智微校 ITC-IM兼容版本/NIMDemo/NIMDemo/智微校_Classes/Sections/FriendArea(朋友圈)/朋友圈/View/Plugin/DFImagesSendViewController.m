//
//  DFImagesSendViewController.m
//  DFTimelineView
//
//  Created by Allen Zhong on 16/2/15.
//  Copyright © 2016年 Datafans, Inc. All rights reserved.
//

#import "DFImagesSendViewController.h"
#import "DFPlainGridImageView.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import "UIBarButtonItem+Lite.h"
#import "MMPopupItem.h"
#import "MMSheetView.h"
#import "MMPopupWindow.h"
#import <MJRefresh.h>
#import <TZImagePickerController.h>

#import <AssetsLibrary/AssetsLibrary.h>

#import "AreaHelper.h"
#import <MBProgressHUD.h>
#import <UIView+Toast.h>

#import "TYHChossClassViewController.h"
#define ImageGridWidth [UIScreen mainScreen].bounds.size.width*0.7

@interface DFImagesSendViewController()<DFPlainGridImageViewDelegate,TZImagePickerControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate,MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic, strong) UITextView *contentView;

@property (nonatomic, strong) DFPlainGridImageView *gridView;

@property (nonatomic, strong) UIImagePickerController *pickerController;

@property(nonatomic,retain)TYHChossClassViewController *chooseView;

@property(nonatomic, strong)UILabel *placeHolderLabel;
//获取用户所属班级ID
@property(nonatomic,copy)NSString *departmentID;

@end

@implementation DFImagesSendViewController
{
    UIBarButtonItem * rightBtn;
    UIButton *chooseClassBtn;
}

- (instancetype)initWithImages:(NSArray *) images
{
    self = [super init];
    if (self) {
        _images = [NSMutableArray array];
//        [_images addObjectsFromArray:images];
        [_images addObject:[UIImage imageNamed:@"AlbumAddBtnHL@2x"]];
        _isClassPaper = NO;
        
//        [_images addObject:[UIImage imageNamed:@"AlbumAddBtn"]];
    }
    return self;
}
//
//- (NSMutableArray *)images {
//    
//    
//    if (_images == nil) {
//        
//        NSMutableArray * array2 = [SingleManager defaultManager].imageArray;
//        if (array2.count>1) {
//            _images = [NSMutableArray arrayWithArray:array2];
//            //            NSLog(@"_dataArray == %@",_images);
//        }else{
//            
//            _images = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"AlbumAddBtnHL"], nil];
//        }
//    }
//    return _images;
//}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"新动态";
    [self initView];
    [self createLeftBar];
    
    rightBtn.enabled = NO;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (![self isBlankString:_tmpClassModel.className]) {
        [chooseClassBtn setTitle:[NSString stringWithFormat:@"发送到：%@",_tmpClassModel.className] forState:UIControlStateNormal];
    }
}

-(void)setClassArray:(NSMutableArray *)classArray
{
    _classArray = classArray;
    if (_classArray.count > 1) {
        [chooseClassBtn setTitle:@"请选择发送到的班级" forState:UIControlStateNormal];
    }
    if (_classArray.count == 1) {
        classModel *model = _classArray[0];
        _departmentID = model.classID;
        _tmpClassModel = model;
        chooseClassBtn.userInteractionEnabled = NO;
        [chooseClassBtn setTitle:[NSString stringWithFormat:@"发送到：%@",model.className] forState:UIControlStateNormal];
    }
}

-(void) initView
{
    CGFloat x, y, width, heigh;
    x=10;
    y=4;
    width = self.view.frame.size.width -2*x;
    heigh = 100;
    _contentView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, width, heigh)];
    _contentView.layer.cornerRadius = 5;
    _contentView.layer.borderWidth = 1.0f;
    _contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _contentView.text = @"这一刻的想法.....";
    _contentView.scrollEnabled = YES;
    _contentView.delegate = self;
    _contentView.font = [UIFont systemFontOfSize:17];
    _placeHolderLabel = [[UILabel alloc]init];
    _placeHolderLabel.font = [UIFont boldSystemFontOfSize:12];
    _placeHolderLabel.frame = CGRectMake(x, y, 200, 20);
    _placeHolderLabel.text = @"这一刻的想法.....";
    _placeHolderLabel.textColor = [UIColor lightGrayColor];
    [_contentView addSubview:_placeHolderLabel];
    
    
    //_contentView.layer.borderColor = [UIColor redColor].CGColor;
    //_contentView.layer.borderWidth =2;
    [self.view addSubview:_contentView];
    
   
    _gridView = [[DFPlainGridImageView alloc] initWithFrame:CGRectZero];
    _gridView.delegate = self;
    [self.view addSubview:_gridView];
    
    [self refreshGridImageView];
    
}


-(void)createLeftBar
{
    UIBarButtonItem * leftItem = nil;
    rightBtn = nil;
    
    
    UIBarButtonItem *
    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    
    //设置字体为加粗的12号系统字，自己也可以随便设置。
    
    [barItemInNavigationBarAppearanceProxy
     setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:15], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];

        rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendPhotoAction)];
        rightBtn.tintColor = [UIColor whiteColor];
    } else {
        leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"发送" style:UIBarButtonItemStyleDone target:self action:@selector(sendPhotoAction)];
        rightBtn.tintColor = [UIColor whiteColor];
    }
    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem =rightBtn;
    
}

-(void)returnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)pushAction
{
    _chooseView = [[TYHChossClassViewController alloc]init];
    _chooseView.settingArray = _classArray;
    [self.navigationController pushViewController:_chooseView animated:YES];
}


-(BOOL)isEmpty
{
    [_images removeLastObject];
    if ([self isBlankString:_contentView.text] && _images.count == 0) {
        return YES;
    }
    else return NO;
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

-(void)sendPhotoAction
{
    if ([self isEmpty]) {
         [self.view makeToast:@"提交内容为空" duration:1 position:CSToastPositionCenter];
        return;
    }
    if (_isClassPaper) {
        _departmentID = _tmpClassModel.classID;
        if ([self isBlankString:_departmentID]) {
            [self.view makeToast:@"请选择班级" duration:1 position:CSToastPositionCenter];
            return;
        }
    }
    rightBtn.enabled = NO;
    [self.view endEditing:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.labelFont = [UIFont systemFontOfSize:12];
    AreaHelper *helper = [[AreaHelper alloc]init];
    if (![self isBlankString:_tmpClassModel.classID]) {
        [helper uploadClassPaperCommentWith:_contentView.text tadID:@"123" publicFlag:@"1" departmentId:_tmpClassModel.classID location:nil url:nil uploadFiles:_images andStatus:^(BOOL successful, NSMutableArray *afterUploadInfo) {
            if (successful) {
                [hud removeFromSuperview];
                [self.view endEditing:YES];
                [self.view makeToast:@"上传成功😄" duration:1 position:CSToastPositionCenter];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshFriendArea" object:nil];
                    
                });
            }
        } failure:^(NSError *error) {
            [self.view endEditing:YES];
            rightBtn.enabled = YES;
            [self.view makeToast:@"上传失败😔" duration:1 position:CSToastPositionCenter];
        }];
    }
    else
    {
        [helper uploadCommentWith:_contentView.text tadID:@"123" publicFlag:@"1" location:nil url:nil uploadFiles:_images andStatus:^(BOOL successful, NSMutableArray *afterUploadInfo) {
            if (successful) {
                [hud removeFromSuperview];
                [self.view endEditing:YES];
                [self.view makeToast:@"上传成功😄" duration:1 position:CSToastPositionCenter];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshFriendArea" object:nil];
                    
                });
            }
        } failure:^(NSError *error) {
            [self.view endEditing:YES];
            rightBtn.enabled = YES;
            [self.view makeToast:@"上传失败😔" duration:1 position:CSToastPositionCenter];
        }];
    }
   
}

-(void) refreshGridImageView
{
    CGFloat x, y, width, heigh;
    x=10;
    y = CGRectGetMaxY(_contentView.frame)+10;
    width  = ImageGridWidth;
    heigh = [DFPlainGridImageView getHeight:_images maxWidth:width];
    _gridView.frame = CGRectMake(x, y, width, heigh);
    [_gridView updateWithImages:_images];
    
    if (_isClassPaper) {
        if (chooseClassBtn.superview) {
            [chooseClassBtn removeFromSuperview];
        }
        chooseClassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        chooseClassBtn.frame = CGRectMake(_gridView.frame.origin.x
                                          , _gridView.frame.origin.y + _gridView.frame.size.height + 10, self.view.frame.size.width - 20, 30);
        chooseClassBtn.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:chooseClassBtn];
        [chooseClassBtn setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
        chooseClassBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        
        if ([self isBlankString:_tmpClassModel.className] ) {
            [chooseClassBtn setTitle:@"请选择发送到的班级" forState:UIControlStateNormal];
        }
        else
        {
            [chooseClassBtn setTitle:[NSString stringWithFormat:@"发送到：%@",_tmpClassModel.className] forState:UIControlStateNormal];
        }
        [chooseClassBtn addTarget:self action:@selector(pushAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if(_images.count > 1 )
    {
        rightBtn.enabled = YES;
    }
    else
    {
        if ([self isBlankString:_contentView.text]) {
            rightBtn.enabled = NO;
        }
    }
}


#pragma mark - DFPlainGridImageViewDelegate

-(void)onClick:(NSUInteger)index
{

    if (_images.count <9 && index == _images.count-1) {
        [self chooseImage];
    }else{
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        
        NSMutableArray *photos = [NSMutableArray array];
        NSUInteger count;
        if (_images.count > 9)  {
            count = 9;
        }else{
            count = _images.count - 1;
        }
        
        for (int i=0; i<count; i++) {
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.image = [_images objectAtIndex:i];
            [photos addObject:photo];
        }
        browser.photos = photos;
        browser.currentPhotoIndex = index;
        [browser show];
        
    }
}


-(void)onLongPress:(NSUInteger)index
{
    
    if (_images.count <9 && index == _images.count-1) {
        return;
    }
    
    MMPopupItemHandler block = ^(NSInteger i){
        switch (i) {
            case 0:
                [_images removeObjectAtIndex:index];
                [self refreshGridImageView];
                break;
            default:
                break;
        }
    };
    
    NSArray *items = @[MMItemMake(@"删除", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    [sheetView show];

}



-(void) chooseImage
{
    [self.view endEditing:YES];
    MMPopupItemHandler block = ^(NSInteger index){
        switch (index) {
            case 0:
                [self takePhoto];
                break;
            case 1:
                [self pickFromAlbum];
                break;
            default:
                break;
        }
    };
    
    NSArray *items = @[MMItemMake(@"拍照", MMItemTypeNormal, block),
                       MMItemMake(@"从相册选取", MMItemTypeNormal, block)];
    
    MMSheetView *sheetView = [[MMSheetView alloc] initWithTitle:@"" items:items];
    
    [sheetView show];


}


-(void) takePhoto
{
    _pickerController = [[UIImagePickerController alloc] init];
    _pickerController.delegate = self;
    _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_pickerController animated:YES completion:nil];
    
}

-(void) pickFromAlbum
{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:(10-_images.count) delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - TZImagePickerControllerDelegate


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets
{
    NSLog(@"%@", photos);
    
    for (UIImage *image in photos) {
        [_images insertObject:image atIndex:(_images.count-1)];
    }
    
    [self refreshGridImageView];
    
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos
{
    
}

#pragma mark - UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];

    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [_images insertObject:image atIndex:(_images.count-1)];
    
    [self refreshGridImageView];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [_placeHolderLabel removeFromSuperview];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *tempString = [textView.text  substringWithRange:range];
    if (![self isBlankString:text]) {
        rightBtn.enabled = YES;
    }
    else    if(textView.text.length == tempString.length && !(_images.count > 1)){
        rightBtn.enabled = NO;
    }
    else if (![self isBlankString:[NSString stringWithFormat:@"%@%@",textView.text,text]])
    {
         rightBtn.enabled = YES;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_contentView resignFirstResponder];
}

@end
