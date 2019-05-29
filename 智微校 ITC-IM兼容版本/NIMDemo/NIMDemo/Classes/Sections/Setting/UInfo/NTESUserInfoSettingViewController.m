//
//  NTESUserInfoSettingViewController.m
//  NIM
//
//  Created by chris on 15/9/17.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESUserInfoSettingViewController.h"
#import "NIMCommonTableData.h"
#import "NIMCommonTableDelegate.h"
#import "NTESNickNameSettingViewController.h"
#import "NTESGenderSettingViewController.h"
#import "NTESBirthSettingViewController.h"
#import "NTESMobileSettingViewController.h"
#import "NTESEmailSettingViewController.h"
#import "NTESSignSettingViewController.h"
#import "NTESUserUtil.h"
#import "SVProgressHUD.h"
#import "UIView+Toast.h"
#import "UIActionSheet+NTESBlock.h"
#import "UIImage+NTES.h"
#import "NTESFileLocationHelper.h"
#import "SDWebImageManager.h"
#import "NTESNoDisturbSettingViewController.h"

#import "UIAlertView+NTESBlock.h"
#import "TYHAppLoadSharedInstance.h"
#import "TYHAboutViewController.h"

#import "NTESColorButtonCell.h"
#import "TYHChangePwdViewController.h"
#import <AFNetworking.h>
#import "TYHLoginAjaxHandler.h"


@interface NTESUserInfoSettingViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,NIMUserManagerDelegate>

@property (nonatomic,strong) NIMCommonTableDelegate *delegator;

@property (nonatomic,copy)   NSArray *data;

@end

@implementation NTESUserInfoSettingViewController
{
    NSString *info_sex;
    NSString *info_birth;
    NSString *info_phone;
    NSString *info_email;
    NSString *info_sign;
    
    NSString *info_userName;
    NSString *info_headImageURL;
}


- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"个人信息";
    self.navigationItem.title = @"设置";
    [self getUserInfo];
    [self buildData];
    __weak typeof(self) wself = self;
    self.delegator = [[NIMCommonTableDelegate alloc] initWithTableData:^NSArray *{
        return wself.data;
    }];
    self.tableView.delegate   = self.delegator;
    self.tableView.dataSource = self.delegator;
    
    [[NIMSDK sharedSDK].userManager addDelegate:self];
    
    
}


-(void)getUserInfo
{
    info_birth = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_BIRTHDAY];
    info_birth = info_birth.length?info_birth:@"";
    
    info_sex = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_SEX];
    if (info_sex.length && [info_sex isEqualToString:@"男"]) {
        info_sex = @"1";
    }
    if (info_sex.length && [info_sex isEqualToString:@"女"]) {
        info_sex = @"2";
    }
    
    info_phone = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_MOBIENUM];
    info_phone = info_phone.length?info_phone:@"";
    
    info_sign = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_SIGNATURE];
    info_sign = info_sign.length?info_sign:@"";
    
    info_email = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_EMAIL];
    info_email = info_email.length?info_email:@"";
}

- (void)dealloc{
    [[NIMSDK sharedSDK].userManager removeDelegate:self];
}

- (void)buildData{
    
    BOOL disableRemoteNotification = [UIApplication sharedApplication].currentUserNotificationSettings.types == UIUserNotificationTypeNone;
    
    NIMPushNotificationSetting *setting = [[NIMSDK sharedSDK].apnsManager currentSetting];
    BOOL enableNoDisturbing     = setting.noDisturbing;
    NSString *noDisturbingStart = [NSString stringWithFormat:@"%02zd:%02zd",setting.noDisturbingStartH,setting.noDisturbingStartM];
    NSString *noDisturbingEnd   = [NSString stringWithFormat:@"%02zd:%02zd",setting.noDisturbingEndH,setting.noDisturbingEndM];
    
    NIMUser *me = [[NIMSDK sharedSDK].userManager userInfo:[[NIMSDK sharedSDK].loginManager currentAccount]];
    
    NIMUserGender gender = [info_sex integerValue];
    
    NSArray *data = [NSArray array];
    
    if ([TYHIMHandler sharedInstance].IMShouldEnabled) {
        data = @[
                 @{
                     HeaderTitle:@"",
                     RowContent :@[
                             @{
                                 ExtraInfo     : me.userId ? me.userId : [NSNull null],
                                 CellClass     : @"NTESSettingPortraitCell",
                                 RowHeight     : @(60),
                                 CellAction    : @"onTouchPortrait:",
                                 ShowAccessory : @(YES)
                                 },
                             ],
                     FooterTitle:@""
                     },
                 @{
                     HeaderTitle:@"",
                     RowContent :@[
                             //                                  @{
                             //                                      Title      : @"昵称",
                             //                                      DetailTitle: me.userInfo.nickName.length ? me.userInfo.nickName : @"未设置",
                             //                                      CellAction : @"onTouchNickSetting:",
                             //                                      RowHeight     : @(50),
                             //                                      ShowAccessory : @(YES),
                             //                                      },
                             @{
                                 Title      : @"性别",
                                 DetailTitle: [NTESUserUtil genderString:gender],
                                 CellAction : @"onTouchGenderSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title       : @"生日",
                                 DetailTitle : info_birth.length ? info_birth : @"未设置",
                                 CellAction  : @"onTouchBirthSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title      :@"手机",
                                 DetailTitle:info_phone.length ? info_phone : @"未设置",
                                 CellAction :@"onTouchTelSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title      :@"邮箱",
                                 DetailTitle:info_email.length ? info_email : @"未设置",
                                 CellAction :@"onTouchEmailSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title      :@"签名",
                                 DetailTitle:info_sign.length ? info_sign : @"未设置",
                                 CellAction :@"onTouchSignSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title      :@"修改密码",
                                 CellAction :@"onTouchChangePWSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 }
                             ],
                     
                     FooterTitle:@""
                     },
                 @{
                     HeaderTitle:@"",
                     RowContent :@[
                             @{
                                 Title      :@"免打扰",
                                 DetailTitle:enableNoDisturbing ? [NSString stringWithFormat:@"%@到%@",noDisturbingStart,noDisturbingEnd] : @"未开启",
                                 CellAction :@"onActionNoDisturbingSetting:",
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title      :@"消息提醒",
                                 DetailTitle:disableRemoteNotification ? @"未开启" : @"已开启",
                                 },
                             ],
                     FooterTitle:@"在iPhone的“设置- 通知中心”功能，找到应用程序“智微校”，可以更改智微校新消息提醒设置"
                     },
                 
                 @{
                     HeaderTitle:@"",
                     RowContent :@[
                             @{
                                 Title      :@"关于",
                                 ShowAccessory : @(YES),
                                 CellAction :@"onTouchAbout:",
                                 },
                             ],
                     },
                 
                 @{
                     HeaderTitle:@"",
                     RowContent :@[
                             @{
                                 Title        : @"注销",
                                 CellClass    : @"NTESColorButtonCell",
                                 CellAction   : @"logoutCurrentAccount:",
                                 ExtraInfo    : @(ColorButtonCellStyleRed),
                                 ForbidSelect : @(YES)
                                 },
                             ],
                     FooterTitle:@"",
                     },
                 
                 ];
    }
    else
    {
        data = @[
                 @{
                     HeaderTitle:@"",
                     RowContent :@[
                             @{
                                 ExtraInfo     : me.userId ? me.userId : [NSNull null],
                                 CellClass     : @"NTESSettingPortraitCell",
                                 RowHeight     : @(60),
                                 CellAction    : @"onTouchPortrait:",
                                 ShowAccessory : @(YES)
                                 },
                             ],
                     FooterTitle:@""
                     },
                 @{
                     HeaderTitle:@"",
                     RowContent :@[
                             //                                  @{
                             //                                      Title      : @"昵称",
                             //                                      DetailTitle: me.userInfo.nickName.length ? me.userInfo.nickName : @"未设置",
                             //                                      CellAction : @"onTouchNickSetting:",
                             //                                      RowHeight     : @(50),
                             //                                      ShowAccessory : @(YES),
                             //                                      },
                             @{
                                 Title      : @"性别",
                                 DetailTitle: [NTESUserUtil genderString:gender],
                                 CellAction : @"onTouchGenderSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title       : @"生日",
                                 DetailTitle : info_birth.length ? info_birth : @"未设置",
                                 CellAction  : @"onTouchBirthSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title      :@"手机",
                                 DetailTitle:info_phone.length ? info_phone : @"未设置",
                                 CellAction :@"onTouchTelSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title      :@"邮箱",
                                 DetailTitle:info_email.length ? info_email : @"未设置",
                                 CellAction :@"onTouchEmailSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title      :@"签名",
                                 DetailTitle:info_sign.length ? info_sign : @"未设置",
                                 CellAction :@"onTouchSignSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 },
                             @{
                                 Title      :@"修改密码",
                                 CellAction :@"onTouchChangePWSetting:",
                                 RowHeight     : @(50),
                                 ShowAccessory : @(YES)
                                 }
                             ],
                     
                     FooterTitle:@""
                     },
                 @{
                     HeaderTitle:@"",
                     RowContent :@[
                             @{
                                 Title      :@"关于",
                                 ShowAccessory : @(YES),
                                 CellAction :@"onTouchAbout:",
                                 },
                             @{
                                 Title      :@"消息提醒",
                                 DetailTitle:disableRemoteNotification ? @"未开启" : @"已开启",
                                 },
                             ],
                     FooterTitle:@"在iPhone的“设置- 通知中心”功能，找到应用程序“智微校”，可以更改智微校新消息提醒设置"
                     },
                 
                 @{
                     HeaderTitle:@"",
                     RowContent :@[
                             @{
                                 Title        : @"注销",
                                 CellClass    : @"NTESColorButtonCell",
                                 CellAction   : @"logoutCurrentAccount:",
                                 ExtraInfo    : @(ColorButtonCellStyleRed),
                                 ForbidSelect : @(YES)
                                 },
                             ],
                     FooterTitle:@"",
                     },
                 
                 ];
    }
    
    self.data = [NIMCommonTableSection sectionsWithData:data];
}


- (void)refresh{
    [self buildData];
    [self.tableView reloadData];
}


-(void)viewWillAppear:(BOOL)animated
{
    [self getUserInfo];
    [self refresh];
}

- (void)onTouchPortrait:(id)sender{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册", nil];
        [sheet showInView:self.view completionHandler:^(NSInteger index) {
            switch (index) {
                case 0:
                    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
                    break;
                case 1:
                    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                    break;
                default:
                    break;
            }
        }];
    }else{
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册", nil];
        [sheet showInView:self.view completionHandler:^(NSInteger index) {
            switch (index) {
                case 0:
                    [self showImagePicker:UIImagePickerControllerSourceTypePhotoLibrary];
                    break;
                default:
                    break;
            }
        }];
    }
}


- (void)onTouchAbout:(id)sender{
    TYHAboutViewController *aboutView = [[TYHAboutViewController alloc]init];
    [self.navigationController pushViewController:aboutView animated:YES];
}

- (void)logoutCurrentAccount:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"退出当前帐号？" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert showAlertWithCompletionHandler:^(NSInteger alertIndex) {
        switch (alertIndex) {
            case 1:
            {
                [TYHLoginAjaxHandler logout:^(NSError *error) {
                    
                    
                    
                }];
                [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error)
                 {
                     extern NSString *NTESNotificationLogout;
                     [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
                     [[TYHAppLoadSharedInstance sharedInstance]appWebViewLoadSuccessful:NO];
                 }];
            }
                
                
                break;
            default:
                break;
        }
    }];
}

- (void)refreshData{
    [self buildData];
    [self.tableView reloadData];
}

- (void)onActionNoDisturbingSetting:(id)sender {
    NTESNoDisturbSettingViewController *vc = [[NTESNoDisturbSettingViewController alloc] initWithNibName:nil bundle:nil];
    __weak typeof(self) wself = self;
    vc.handler = ^(){
        [wself refreshData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)showImagePicker:(UIImagePickerControllerSourceType)type{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate      = self;
    picker.sourceType    = type;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)onTouchNickSetting:(id)sender{
    NTESNickNameSettingViewController *vc = [[NTESNickNameSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchGenderSetting:(id)sender{
    NTESGenderSettingViewController *vc = [[NTESGenderSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchBirthSetting:(id)sender{
    NTESBirthSettingViewController *vc = [[NTESBirthSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchTelSetting:(id)sender{
    NTESMobileSettingViewController *vc = [[NTESMobileSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchEmailSetting:(id)sender{
    NTESEmailSettingViewController *vc = [[NTESEmailSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)onTouchSignSetting:(id)sender{
    NTESSignSettingViewController *vc = [[NTESSignSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
                      
-(void)onTouchChangePWSetting:(id)sender
    {
        TYHChangePwdViewController *changeView = [TYHChangePwdViewController new];
        [self.navigationController pushViewController:changeView animated:YES];
    }


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:^{
        [self uploadImage:image];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - NIMUserManagerDelagate
- (void)onUserInfoChanged:(NIMUser *)user
{
    if ([user.userId isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]]) {
        [self refresh];
    }
}


#pragma mark - Private
- (void)uploadImage:(UIImage *)image{
    
    if ([TYHIMHandler sharedInstance].IMShouldEnabled) {
        UIImage *imageForAvatarUpload = [image imageForAvatarUpload];
        NSString *fileName = [NTESFileLocationHelper genFilenameWithExt:@"jpg"];
        NSString *filePath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
        NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 1.0);
        BOOL success = data && [data writeToFile:filePath atomically:YES];
        __weak typeof(self) wself = self;
        if (success) {
            [SVProgressHUD show];
            [[NIMSDK sharedSDK].resourceManager upload:filePath progress:nil completion:^(NSString *urlString, NSError *error) {
                [SVProgressHUD dismiss];
                if (!error && wself) {
                    [[NIMSDK sharedSDK].userManager updateMyUserInfo:@{@(NIMUserInfoUpdateTagAvatar):urlString} completion:^(NSError *error) {
                        if (!error) {
                            [[SDWebImageManager sharedManager] saveImageToCache:imageForAvatarUpload forURL:[NSURL URLWithString:urlString]];
                            
                            NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
                            NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
                            NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
                            NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3ID];
                            
                            
                            NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload,0.1);
                            
                            NSString *string = [NSString stringWithFormat:@"%@/bd/user/saveHeadPortrait",BaseURL];
                            NSMutableDictionary * params = [NSMutableDictionary dictionary];
                            params[@"sys_username"] = [NSString stringWithFormat:@"%@%@%@," ,userName,@"%2C",organizationID];
                            params[@"sys_auto_authenticate"]= @"true";
                            params[@"id"]= [NSString stringWithFormat:@"%@",userID];
                            params[@"sys_password"]= [NSString stringWithFormat:@"%@",password];
                            params[@"uploadFileNames"] = @"image0.png";
                            
                            AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
                            manager.requestSerializer = [AFJSONRequestSerializer serializer];
                            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
                            
                            [manager POST:string parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                
                                [formData appendPartWithFileData:data name:@"uploadFiles" fileName:@"image0.png" mimeType:@"image/png"];
                            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                
                                [self.view makeToast:@"设置头像成功" duration:1 position:nil];
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                [self.view makeToast:@"设置头像失败" duration:1 position:nil];
                            }];
                            
                            [[SDWebImageManager sharedManager] saveImageToCache:imageForAvatarUpload forURL:[NSURL URLWithString:urlString]];
                            [wself refresh];
                            
                            [wself refresh];
                        }else{
                            [wself.view makeToast:@"设置头像失败，请重试"
                                         duration:2
                                         position:CSToastPositionCenter];
                        }
                    }];
                }else{
                    [wself.view makeToast:@"图片上传失败，请重试"
                                 duration:2
                                 position:CSToastPositionCenter];
                }
            }];
        }else{
            [self.view makeToast:@"图片保存失败，请重试"
                        duration:2
                        position:CSToastPositionCenter];
        }
    }else
    {
        UIImage *imageForAvatarUpload = [image imageForAvatarUpload];
        NSString *fileName = [NTESFileLocationHelper genFilenameWithExt:@"jpg"];
        NSString *filePath = [[NTESFileLocationHelper getAppDocumentPath] stringByAppendingPathComponent:fileName];
        NSData *data = UIImageJPEGRepresentation(imageForAvatarUpload, 0.8);
        BOOL success = data && [data writeToFile:filePath atomically:YES];
        __weak typeof(self) wself = self;
        
        if (success) {
            [SVProgressHUD show];
            
            NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
            NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
            NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
            NSString *userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
            
            
            NSString *string = [NSString stringWithFormat:@"%@/bd/mobile/mobileWelcome!saveHeadPortrait.action?sys_username=%@&sys_auto_authenticate=true&sys_password=%@",BaseURL,userName,password];
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            params[@"sys_username"] = [NSString stringWithFormat:@"%@" ,userName];
            params[@"sys_auto_authenticate"]= @"true";
            params[@"id"]= [NSString stringWithFormat:@"%@",userID];
            params[@"sys_password"]= [NSString stringWithFormat:@"%@",password];
            params[@"uploadFileNames"] = @"image0.png";
            AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:string parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                [SVProgressHUD dismiss];
                [formData appendPartWithFileData:data name:@"uploadFiles" fileName:@"image0.png" mimeType:@"image/png"];
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                
                [[NSUserDefaults standardUserDefaults]setObject:data
                                                         forKey:USER_DEFAULT_HEADIMAGE_DATA];
                [self.view makeToast:@"设置头像成功" duration:1 position:CSToastPositionCenter];
                [wself refresh];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD dismiss];
                [self.view makeToast:@"设置头像失败" duration:1 position:CSToastPositionCenter];
            }];
            
        }
    }
    
    
    
    
  
}

#pragma mark - 旋转处理 (iOS7)
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
}

@end
