//
//  TYHNewContacterController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/4.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHNewContacterController.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>
#import "RecentModel.h"
#import "AlwaysContactCell.h"
#import "TYHBasePersonController.h"
#import "TYHNewSendViewController.h"
#import "customModel.h"
#import "CustomTableViewCell.h"

@interface TYHNewContacterController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray * groupArray;
@property (nonatomic, strong) NSMutableArray * selectArray;
@property (nonatomic, weak) UILabel * lable2;
@property (nonatomic, strong) NSSet * setAttay;

@property (nonatomic, strong) NSArray * urlArray;
@property (nonatomic, strong) NSMutableArray * hahArray;
@end

@implementation TYHNewContacterController
- (NSArray *)urlArray {
/*
 // /no/noticeMobile!getTreeOfMyGroup.action
 // /bd/mobile/baseData!getTeacherTreeIOS.action
 // /bd/mobile/baseData!getStudentTreeIOS.action
 //  /bd/mobile/baseData!getParentTreeIOS.action
 */
    
    if (_urlArray == nil) {
        _urlArray = @[@{@"name":@"教师",
                        @"urlStr":@"/bd/mobile/baseData!getTeacherTreeIOS.action",
                        @"image":@"icon_group_teacher"
                        },
                      @{@"name":@"学生",
                        @"urlStr":@"/bd/mobile/baseData!getStudentTreeIOS.action",
                        @"image":@"icon_group_student"
                        },
                      @{@"name":@"家长",
                        @"urlStr":@"/bd/mobile/baseData!getParentTreeIOS.action",
                        @"image":@"icon_group_parent"
                        },
                      @{@"name":@"自定义",
                        @"urlStr":@"/no/noticeMobile!getTreeOfMyGroupIOS.action",
                        @"image":@"icon_group_custom"
                        }
                      ];

    }
    return _urlArray;
}

- (NSMutableArray *)showTableView {
 
    if (_showTableView == nil) {
        _showTableView = [[NSMutableArray alloc] init];
    }
    return _showTableView;
}
- (NSMutableArray *)groupArray {

    if (_groupArray == nil) {
        _groupArray = [[NSMutableArray alloc] init];
    }
    return _groupArray;
}

- (void)initData {
    
    NSString *tempUserName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    _organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    _userName = [NSString stringWithFormat:@"%@",tempUserName];
    _password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    _userId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    _token = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_TOKEN];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"选择接收人";
    
    _seletedArray = [NSMutableArray arrayWithArray:_tempArray];
    
    self.setAttay = [NSSet setWithArray:self.seletedArray];

    [self initData];
    
    [self setRightItem];
    
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self.tableview registerNib:[UINib nibWithNibName:@"AlwaysContactCell" bundle:nil] forCellReuseIdentifier:@"AlwaysContactCell"];
    [self.tableview registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"CustomTableViewCell"];

    self.tableview.rowHeight = 44;
    self.tableview.bounces = NO;
    
    
    self.hahArray = [customModel objectArrayWithKeyValuesArray:self.urlArray];
    
    
    [self getContactData];
    
//    [self creatLeftItem];
    
    [_showTableView addObject:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ID] ];
    
}
- (void)creatLeftItem {

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"title_bar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    } else {
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClicked)];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}


- (void)setRightItem {

    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(self.view.frame.size.width - 44, 0, 50, 35);
    button.backgroundColor = [UIColor colorWithRed:28/255.0 green:168/255.0 blue:248/255.0 alpha:0.9];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 3.f;
    
    UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.textColor = [UIColor whiteColor];
    lable1.text = @"确定";
    lable1.textAlignment = NSTextAlignmentCenter;
    [button addSubview:lable1];
    UILabel * lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 50, 15)];
    lable2.font = [UIFont systemFontOfSize:12];
    lable2.textColor = [UIColor whiteColor];
    if (_setAttay == nil) {
        
        lable2.text = @"0";
    } else {
    
        lable2.text = [NSString stringWithFormat:@"%d",(int)_setAttay.count];
    }
    lable2.textAlignment = NSTextAlignmentCenter;
    [button addSubview:lable2];
    
    self.lable2 = lable2;
    
    [button addTarget:self action:@selector(returnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * butItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    self.navigationItem.rightBarButtonItem = butItem;
}
- (NSMutableArray *)modelArray {

    if (_modelArray == nil) {
        self.modelArray = [[NSMutableArray alloc] init];
    }
    return _modelArray;
}
- (void)returnClicked {

    TYHNewSendViewController * sendVc = [[TYHNewSendViewController alloc] init];
    
    sendVc.modelArray = self.modelArray;
    
    [self.navigationController pushViewController:sendVc animated:YES];
}

- (void)getContactData {
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    //  最近联系人
    // /no/noticeMobile!getRecentReceiveUser.action
    NSString *string = [NSString stringWithFormat:@"%@/no/noticeMobile!getRecentReceiveUser.action",BaseURL];
    //  获取自定义分组
    NSString * url = [NSString stringWithFormat:@"%@?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&userId=%@&imToken=%@&dataSourceName=%@",string,_userName,_password,_userId,self.token,dataSourceName];
    NSLog(@"url === = =  %@",url);
    [TYHHttpTool get:url params:nil success:^(id json) {
        
        self.groupArray = [UserModel mj_objectArrayWithKeyValuesArray:json];
        
        [self.tableview reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _hahArray.count;
    }else {
        if (_groupArray.count >30) {
            return 30;
        }
        return _groupArray.count;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1){
        
        UIView* myView = [[UIView alloc] init];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 200, 25)];
        titleLabel.font = [UIFont systemFontOfSize:14];
        titleLabel.backgroundColor = [UIColor clearColor];
        myView.backgroundColor = [UIColor TabBarColorYellow];
        titleLabel.text = @"最近联系人";
        
        [myView addSubview:titleLabel];
        return myView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        static NSString *sessioncellid = @"CustomTableViewCell";
        
        CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sessioncellid];
        if (cell == nil) {
            
            cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sessioncellid];
            
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        customModel * model = _hahArray[indexPath.row];
        NSLog(@"%@",model.image);
        cell.labelName.text = model.name;
        cell.imageName.image = [UIImage imageNamed:model.image];
        return cell;
        
    } else {
        static NSString *sessioncellid = @"AlwaysContactCell";
        AlwaysContactCell *cell = [tableView dequeueReusableCellWithIdentifier:sessioncellid];
        if (cell == nil) {
            
            cell = [[AlwaysContactCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sessioncellid];
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectBtnClickeGroup:)];
        cell.contentView.userInteractionEnabled = YES;
        [cell.contentView addGestureRecognizer:tap];
        
        UserModel * model = _groupArray[indexPath.row];
        
        cell.nameLabel.text = model.name;
        cell.selectImage.tag =indexPath.row+1000;
        
        if ([_seletedArray containsObject:model.strId]  || [_showTableView containsObject:model.strId]) {
            cell.selectImage.image = [UIImage imageNamed:@"select_account_list_checked"];
        }
        else{
            
            cell.selectImage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
        }
        return cell;
    }
    return nil;
    
}
- (void)cellSelectBtnClickeGroup:(UITapGestureRecognizer *)tap {

    
    CGPoint point = [tap locationInView:self.tableview];
    NSIndexPath * indexPath = [self.tableview indexPathForRowAtPoint:point];
    
    UIImageView * selectimage = nil;
    for (UIView * view in tap.view.subviews) {
        if (view.tag >=indexPath.row+1000) {
            selectimage = (UIImageView *)view;
            break;
        }
    }
    
    UserModel * model = _groupArray[indexPath.row];
    NSString * voipSrting = model.strId;
    
    if ([_seletedArray containsObject:voipSrting]) {
        
        selectimage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
        [_seletedArray removeObject:voipSrting];
        
        if (self.modelArray.count != 0) {
            
            
            [self.modelArray enumerateObjectsUsingBlock:^(UserModel *models, NSUInteger idx, BOOL *stop) {
                
                if ([models.strId isEqualToString:voipSrting]) {
                    *stop = YES;
                    [self.modelArray removeObject:models];
                }
            }];
        }
        
        [[NSUserDefaults standardUserDefaults] setValue:voipSrting forKey:USER_DEFAULT_ID];
        
        self.setAttay = [NSSet setWithArray:self.seletedArray];
    }
    else{
        
        selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];
        [_seletedArray addObject:voipSrting];
        
        [self.modelArray addObject:model];
        
        self.setAttay = [NSSet setWithArray:self.seletedArray];
        
        [[NSUserDefaults standardUserDefaults] setValue:voipSrting forKey:USER_DEFAULT_ID];
    }
    
    
    [self.tableview reloadData];

    self.lable2.text = [NSString stringWithFormat:@"%d",(int)_setAttay.count];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0) {
    
        TYHBasePersonController * teachVc = [[TYHBasePersonController alloc] init];
        
        customModel * model = _hahArray[indexPath.row];
        
        teachVc.userId = self.userId;
        teachVc.userName = self.userName;
        teachVc.password = self.password;
        teachVc.urlStr = model.urlStr;
        teachVc.token = self.token;
        teachVc.title = model.name;
        
        teachVc.returnTextArrayBlock = ^(NSMutableArray * arrayText){
            
            [self.seletedArray  addObjectsFromArray:arrayText];
            
            self.setAttay = [NSSet setWithArray:self.seletedArray];
            
            [self setRightItem];
        };
        
        
        teachVc.returnUserModelBlock = ^(NSMutableArray * modelArray){
            
            _modelArray = [NSMutableArray arrayWithArray:modelArray];
            NSMutableArray * hahArray = [NSMutableArray array];
            
            for (UserModel * model in modelArray) {
                
                [hahArray addObject:model.strId];
            }
            self.tempArray = hahArray;
        };
        
        teachVc.chooseArray = self.seletedArray;
        teachVc.modelArray = self.modelArray;
        
        teachVc.tempSelectGroupArray = self.tempSelectGroupArray;
        teachVc.tempSelectGroupModelArray = self.tempSelectGroupModelArray;
        [self.navigationController pushViewController:teachVc animated:YES];
    }else {
        
        
        

    }
}


-(void)viewWillAppear:(BOOL)animated
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.navigationController.navigationBar.translucent = NO;
}
//
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    self.navigationController.navigationBar.translucent = YES;
//}

@end
