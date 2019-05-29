//
//  TYHNewDetailViewController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/12/28.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"

typedef void(^ReturnNameArrayBlock)(NSMutableArray * modelArray);

typedef void(^ReturnAttentionBlock)(BOOL atttentionFlag);
@interface TYHNewDetailViewController : UIViewController

@property (nonatomic, strong) NSMutableArray * modelArray;
@property (nonatomic, strong) NSMutableArray * modelArray2;
@property (nonatomic, copy) ReturnNameArrayBlock returnNameArrayBlock;
@property (nonatomic, copy) ReturnAttentionBlock atttentionFlag;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString * userId;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *organizationID;
@property (nonatomic, copy) NSString * result;

@property (nonatomic, strong) NoticeModel * model;
@property (nonatomic, copy) NSString * modelID;

@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (nonatomic, strong) UITableView * tableView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *sendUserLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;

@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *sendTime;
//@property (weak, nonatomic) IBOutlet UIImageView *bulbImg;
@property (weak, nonatomic) IBOutlet UIButton *showAttachbtn;
@property (copy, nonatomic) NSString * ID;
@property (weak, nonatomic) IBOutlet UIButton *deleteBigBtn;
@property (weak, nonatomic) IBOutlet UILabel *attachCount;
- (IBAction)showAttachBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *attentionBigBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

- (IBAction)deleteBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *attachmentImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;

@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

- (IBAction)attentionBtn:(id)sender;

- (IBAction)sendBtn:(id)sender;


@property(nonatomic,assign)BOOL isComeFromPushNoticeList;
@end
