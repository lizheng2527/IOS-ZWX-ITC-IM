//
//  NTESWorkflowTitleViewController.m
//  NIM
//
//  Created by 中电和讯 on 2019/10/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NTESWorkflowTitleViewController.h"
#import "DropDownMenu.h"
#import "NTESWorkflowViewCell.h"
#import "NTESWorkflowViewController.h"

@interface NTESWorkflowTitleViewController ()
@property (nonatomic, strong) NSArray * data;
@end

@implementation NTESWorkflowTitleViewController

- (NSArray *)data {
    
    if (_data == nil) {
        
        self.data = [_tempdata copy];
    }
    return _data;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 44;
    [self.tableView registerNib:[UINib nibWithNibName:@"NTESWorkflowViewCell" bundle:nil]  forCellReuseIdentifier:@"titleCell"];
}
- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_index inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.data.count;
}



-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"titleCell";
    
    NTESWorkflowViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[NTESWorkflowViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor TabBarColorGreen];
//    cell.backgroundColor = UIColor.[UIColor colorWithRed:24 / 255.0 green:171 / 255.0 blue:142/ 255.0 alpha:0.8];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
//    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
//    if (indexPath.row == 0) {
//        cell.imgView.image = [UIImage imageNamed:@"icon_message_normal1"];
//        cell.imgView.highlightedImage = [UIImage imageNamed:@"icon_message_pressed1"];
//
//    } else if (indexPath.row == 1) {
//        cell.imgView.image = [UIImage imageNamed:@"icon_message_unuse_normal"];
//        cell.imgView.highlightedImage = [UIImage imageNamed:@"icon_message_unuse_pressed"];
//
//        cell.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
//        cell.countLabel.highlightedTextColor = [UIColor blackColor];
//
//    } else if (indexPath.row == 2) {
//        cell.imgView.image = [UIImage imageNamed:@"icon_message_use_normal"];
//        cell.imgView.highlightedImage = [UIImage imageNamed:@"icon_message_use_pressed"];
//
//    } else if (indexPath.row == 3) {
//        cell.imgView.image = [UIImage imageNamed:@"icon_message_unuse_normal"];
//        cell.imgView.highlightedImage = [UIImage imageNamed:@"icon_message_unuse_pressed"];
//    }
    
    
    cell.nameLabel.text = _data[indexPath.row];
    if (_index == indexPath.row) {
        cell.nameLabel.highlightedTextColor = [UIColor whiteColor];
    }else{
        cell.nameLabel.highlightedTextColor = [UIColor blackColor];
    }
//    cell.lineLabel.backgroundColor = [UIColor whiteColor];
//    cell.lineLabel.text = @"";
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.drop) {
        [self.drop dismiss];
    }
    if (_delegate) {
        [_delegate selectAtIndexPath:indexPath title:_data[indexPath.row]];
    }
}
@end
