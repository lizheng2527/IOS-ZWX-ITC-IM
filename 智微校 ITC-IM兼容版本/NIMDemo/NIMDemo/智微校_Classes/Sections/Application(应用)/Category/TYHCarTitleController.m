//
//  TYHCarTitleController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/15/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHCarTitleController.h"
#import "DropDownMenu.h"
#import <MJExtension.h>
#import "TYHSchoolCell.h"

@interface TYHCarTitleController ()

@end

@implementation TYHCarTitleController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.bounces = NO;
    self.tableView.rowHeight = 44;
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TYHSchoolCell" bundle:nil] forCellReuseIdentifier:@"titleCell"];
}
- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:_index inSection:0];
    [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    TYHSchoolCell * cell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    cell.imageview.hidden = NO;
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, 44.0)];
    customView.backgroundColor = [UIColor whiteColor];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor orangeColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:16];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    headerLabel.text = @"选择校区";
    [customView addSubview:headerLabel];
    
    return customView;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"titleCell";
    
    TYHSchoolCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.frame = tableView.frame;
    if (!cell) {
        cell = [[TYHSchoolCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
        cell.frame = tableView.frame;
    }
    cell.backgroundColor = [UIColor colorWithRed:246.0/255.f green:246.0/255.f blue:246.0/255.f alpha:1.0];
    NSString * schoolName = self.dataArray[indexPath.row];
    cell.nameLabel.text = schoolName;
    cell.nameLabel.highlightedTextColor = [UIColor blackColor];
    
    if ([schoolName isEqualToString:self.dataArray[_index]]) {
        cell.imageview.hidden = NO;
    } else {
        cell.imageview.hidden = YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.drop) {
        [self.drop dismiss];
    }
    if (_delegate) {
        [_delegate selectAtIndexPath:indexPath title:_dataArray[indexPath.row]];
    }
}

@end
