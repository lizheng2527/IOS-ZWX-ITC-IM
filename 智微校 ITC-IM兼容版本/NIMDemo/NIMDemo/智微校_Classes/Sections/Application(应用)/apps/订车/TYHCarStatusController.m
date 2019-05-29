//
//  TYHCarStatusController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/25/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHCarStatusController.h"
#import "StatusDetailCell.h"
#import "statusModel.h"
#import "TYHHttpTool.h"
#import <MJExtension.h>


static NSString * cellID = @"StatusDetailCell";

@interface TYHCarStatusController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataArray;
@end

@implementation TYHCarStatusController

- (NSMutableArray *)dataArray {

    if (_dataArray == nil) {
        self.dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initData];
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0f green:240/255.0f blue:240/255.0f alpha:1.0];
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    
    self.tableView.separatorStyle = NO;
//    [self.tableView setRowHeight:91];
    [self.tableView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellReuseIdentifier:cellID];
    
    [self getNewStatus];
}
- (void)initData {
    
    _userName = [[NSUserDefaults standardUserDefaults] objectForKey:USER_DEFAULT_LOGINNAME];
    NSString *V3Pwd = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    if ([self isBlankString:V3Pwd]) {
        V3Pwd = @"";
    }
    _password = V3Pwd;
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
- (void)getNewStatus {
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    // getAssignCarStatus
    NSString * urlStr;
    if (self.tag == 1001) { // 司机详情状态
//        urlStr = [NSString stringWithFormat:@"%@/cm/carMobile!getAssignCarStatus.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&id=%@&dataSourceName=%@",k_V3ServerURL,_userName,_password,_carOrderId,dataSourceName];
        
        urlStr = [NSString stringWithFormat:@"%@/cm/carMobile!getOrderCarStatus.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&id=%@&dataSourceName=%@",k_V3ServerURL,_userName,_password,_carOrderId,dataSourceName];
        
    } else {
        
        urlStr = [NSString stringWithFormat:@"%@/cm/carMobile!getOrderCarStatus.action?sys_auto_authenticate=true&sys_username=%@&sys_password=%@&id=%@&dataSourceName=%@",k_V3ServerURL,_userName,_password,_carOrderId,dataSourceName];
    }
    
    [TYHHttpTool get:urlStr params:nil success:^(id json) {
        
//        NSLog(@"%@",json);
        self.dataArray = [statusModel mj_objectArrayWithKeyValuesArray:json];
//        NSLog(@"%@",self.dataArray);
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
       
//        NSLog(@"%@",error);
        
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray.count == 0) {
        return self.view.frame.size.height;
    }
    return 91.0f;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section  {
    
    if (self.dataArray.count == 0) {
    
        return 1;
    }
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataArray.count == 0) {
        
        static NSString *noMessageCellid = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:noMessageCellid];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:noMessageCellid];
            UILabel *noMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, self.view.frame.size.height / 2 - 50,[UIScreen mainScreen].bounds.size.width, 50.0f)];
            noMsgLabel.text = @"无数据";
            noMsgLabel.font = [UIFont systemFontOfSize:17];
            noMsgLabel.textColor = [UIColor darkGrayColor];
            noMsgLabel.textAlignment = NSTextAlignmentCenter;
            [cell.contentView setBackgroundColor:[UIColor colorWithRed:246/255.0f green:246/255.0f blue:246/255.0f alpha:1]];
            [cell.contentView addSubview:noMsgLabel];
            tableView.showsVerticalScrollIndicator = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }


    StatusDetailCell * cell  = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[StatusDetailCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:cellID];
     }
    statusModel * model = self.dataArray[indexPath.row];
    statusModel * model2 =[self.dataArray lastObject];
    
    cell.name.text = model.name;
    NSString * status = model.status;
    if ([status isEqualToString:@"1"]) {
        // 待审核
        cell.statusImage.image = [UIImage imageNamed:@"待派车d"];
        
    } else if ([status isEqualToString:@"2"]) {
        // 订车单已修改  审核修改
        cell.statusImage.image = [UIImage imageNamed:@"审核已修改"];
        
    } else if ([status isEqualToString:@"3"]) {
        // 审核通过
        cell.statusImage.image = [UIImage imageNamed:@"已出车d"];
        
    } else if ([status isEqualToString:@"4"]) {
        // 已结束派车
        cell.statusImage.image = [UIImage imageNamed:@"待审核d"];
        
    } else if ([status isEqualToString:@"5"]) {
        cell.statusImage.image = [UIImage imageNamed:@"已派车d"];
        
    } else if ([status isEqualToString:@"0"]) {
        cell.statusImage.image = [UIImage imageNamed:@""];
        
    }
    
    if ([model isEqual:model2]) {
        cell.lineImage.hidden = YES;
    } else {
        
        cell.lineImage.hidden = NO;
    }
    
    cell.opTime.text = model.opTime;
    cell.note.text = model.note;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    StatusDetailCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    UIView * imageView = [[UIView alloc] init];
    imageView.backgroundColor = [UIColor TabBarColorOrange];
    cell.selectedBackgroundView = imageView;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
