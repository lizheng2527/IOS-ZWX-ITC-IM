//
//  TYHTittleViewController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/10/20.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import "TYHTittleViewController.h"
#import "DropDownMenu.h"
#import "TitleViewCell.h"

@interface TYHTittleViewController ()

@property (nonatomic, strong) NSArray * data;
@end

@implementation TYHTittleViewController

- (NSArray *)data {

    if (_data == nil) {
        
        self.data = @[@"收件箱",@"未读",@"关注",@"发件箱"];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"TitleViewCell" bundle:nil]  forCellReuseIdentifier:@"titleCell"];
    
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
    
    TitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[TitleViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.backgroundColor = [UIColor TabBarColorYellow];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
    
    if (indexPath.row == 0) {
        cell.imgView.image = [UIImage imageNamed:@"icon_message_normal1"];
        cell.imgView.highlightedImage = [UIImage imageNamed:@"icon_message_pressed1"];
        
    } else if (indexPath.row == 1) {
        cell.imgView.image = [UIImage imageNamed:@"icon_message_unuse_normal"];
        cell.imgView.highlightedImage = [UIImage imageNamed:@"icon_message_unuse_pressed"];
        
        cell.countLabel.text = [NSString stringWithFormat:@"%ld",(long)self.count];
        cell.countLabel.highlightedTextColor = [UIColor blackColor];
        
    } else if (indexPath.row == 2) {
        cell.imgView.image = [UIImage imageNamed:@"icon_message_use_normal"];
        cell.imgView.highlightedImage = [UIImage imageNamed:@"icon_message_use_pressed"];
        
    } else if (indexPath.row == 3) {
        cell.imgView.image = [UIImage imageNamed:@"icon_message_unuse_normal"];
        cell.imgView.highlightedImage = [UIImage imageNamed:@"icon_message_unuse_pressed"];
    }
    
    cell.nameLabel.highlightedTextColor = [UIColor blackColor];
    cell.nameLabel.text = _data[indexPath.row];
    
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
