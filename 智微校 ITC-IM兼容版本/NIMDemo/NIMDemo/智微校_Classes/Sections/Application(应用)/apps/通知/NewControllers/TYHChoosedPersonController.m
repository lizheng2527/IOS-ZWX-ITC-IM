//
//  TYHChoosedPersonController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/4.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "TYHChoosedPersonController.h"
#import "InviteJoinListViewCell.h"
#import "UserModel.h"
#import <UIImageView+WebCache.h>
#import <UIView+Toast.h>


@interface TYHChoosedPersonController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic, weak) UILabel * lable2;
@end

@implementation TYHChoosedPersonController
- (NSMutableArray *)showTableView {
    
    if (_showTableView == nil) {
        _showTableView = [[NSMutableArray alloc] init];
    }
    return _showTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     self.title = @"已选接收人";
    
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    [self.tableview setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    _groupArray = [NSMutableArray arrayWithArray:_modelArray];
    _selectedArray = [NSMutableArray arrayWithArray:_tempArray];
    
    self.setArray = [NSSet setWithArray:_selectedArray];
    
    NSLog(@"111 chooseArray = %@",_tempArray);
    NSLog(@"111 selectedArray = %@",_selectedArray);
    [self.tableview reloadData];
    
    [_showTableView addObject:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ID] ];
    
    [self setRightItem];
    
//    [self creatLeftItem];
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
- (void)returnClicked {

    self.returnUserModelBlock(self.modelArray);
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return  self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *contactlistcellid = @"InviteJoinListViewCell";
    InviteJoinListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:contactlistcellid];
    if (cell == nil) {
        cell = [[InviteJoinListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:contactlistcellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellSelectBtnClickeGroup:)];
        cell.contentView.userInteractionEnabled = YES;
        [cell.contentView addGestureRecognizer:tap];
    }
    UserModel *model = [self.groupArray objectAtIndex:indexPath.row];
    cell.selecImage.frame = CGRectMake(self.view.frame.size.width - 50, 15.0f, 22.25f, 22.25f);
    cell.portraitImg.image = [self dealImageWIthVoipAccount:model.voipAccount];
    
    cell.portraitImg.layer.masksToBounds = YES;
    cell.portraitImg.layer.cornerRadius = cell.portraitImg.frame.size.width / 2;
    cell.nameLabel.text =model.name;
    cell.selecImage.tag =indexPath.row+1000;
    if ([_selectedArray containsObject:model.strId]  || [_showTableView containsObject:model.strId]) {
        cell.selecImage.image = [UIImage imageNamed:@"select_account_list_checked"];
    }
    else{
        cell.selecImage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
    }
    return cell;

}
- (void)cellSelectBtnClickeGroup:(UITapGestureRecognizer *)tap {
    
    CGPoint point = [tap locationInView:_tableview];
    NSIndexPath * indexPath = [_tableview indexPathForRowAtPoint:point];
    UIImageView * selectimage = nil;
    for (UIView * view in tap.view.subviews) {
        if (view.tag >=indexPath.row+1000) {
            selectimage = (UIImageView *)view;
            break;
        }
    }
    
    if([[self.groupArray objectAtIndex:indexPath.row] isKindOfClass:[UserModel class]]){
        
        UserModel *model = [self.groupArray objectAtIndex:indexPath.row];
        NSString *voipSrting = model.strId;
        
        if ( [_showTableView containsObject:model.strId]) {
            selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];
            [self.view makeToast:@"" duration:0.8 position:nil];
        }
        else
        {
            if ([_selectedArray containsObject:voipSrting] ) {
                selectimage.image = [UIImage imageNamed:@"select_account_list_unchecked"];
                [_selectedArray removeObject:voipSrting];
                
                self.setArray = [NSSet setWithArray:_selectedArray];
                
                if (self.modelArray.count != 0) {
                    
                
                    [self.modelArray enumerateObjectsUsingBlock:^(UserModel *models, NSUInteger idx, BOOL *stop) {
                       
                        if ([models.strId isEqualToString:voipSrting]) {
                            *stop = YES;
                            
                            [self.modelArray removeObject:models];
                            
                            [[NSUserDefaults standardUserDefaults] setValue:voipSrting forKey:USER_DEFAULT_ID];
                        }
                    }];
                }
            }
            else{
                selectimage.image = [UIImage imageNamed:@"select_account_list_checked"];
                [_selectedArray addObject:voipSrting];
                
                [self.modelArray addObject:model];
                
                self.setArray = [NSSet setWithArray:_selectedArray];
                [[NSUserDefaults standardUserDefaults] setValue:voipSrting forKey:USER_DEFAULT_ID];
            }
        }
        
        [_tableview reloadData];
        [self setRightItem];
    }
}

- (void)setRightItem {
    
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    button.frame = CGRectMake(self.view.frame.size.width - 44, 0, 40, 40);
    button.backgroundColor = [UIColor TabBarColorGreen];
    UILabel * lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
    lable1.font = [UIFont systemFontOfSize:14];
    lable1.textColor = [UIColor whiteColor];
    lable1.text = @"确定";
    lable1.textAlignment = NSTextAlignmentCenter;
    [button addSubview:lable1];
    UILabel * lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 40, 20)];
    lable2.font = [UIFont systemFontOfSize:12];
    lable2.textColor = [UIColor whiteColor];
    if (_setArray == nil) {
        
        lable2.text = @"0";
        
    } else {
        
        lable2.text = [NSString stringWithFormat:@"%d",(int)_setArray.count];
    }
    lable2.textAlignment = NSTextAlignmentCenter;
    [button addSubview:lable2];
    
    self.lable2 = lable2;
    
    [button addTarget:self action:@selector(returnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * butItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = butItem;
}


-(UIImage *)dealImageWIthVoipAccount:(NSString *)voipAccount
{
    UIImage *image = [[UIImage alloc]init];
    image = [[SDImageCache sharedImageCache]imageFromDiskCacheForKey:voipAccount];
    if (image && ![self isBlankString:voipAccount]) {
        return image;
    }
    else
        return [UIImage imageNamed:@"mk-photo"];
    
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


@end
