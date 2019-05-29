//
//  TYHChoosePlaceController.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 5/27/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "TYHChoosePlaceController.h"
#import "NSString+Empty.h"

@interface TYHChoosePlaceController ()<UITextFieldDelegate>

@property (nonatomic, strong) UITextField * textField;
@property (nonatomic, strong) NSMutableArray * array;
@property (nonatomic, strong) NSArray * reversedArray;

@property (nonatomic, strong) NSString * fileName;

@end

@implementation TYHChoosePlaceController
- (NSArray *)reversedArray {

    if (_reversedArray == nil) {
        _reversedArray = [[NSArray alloc] init];
    }
    return _reversedArray;
}

- (NSMutableArray *)array {

    if (_array == nil) {
        _array = [[NSMutableArray alloc] init];
    }
    return _array;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"到达地点";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStyleDone) target:self action:@selector(popBack)];
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 40)];
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, topView.frame.size.width - 10, 30)];
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField = textField;
    [topView addSubview:textField];
    
    self.tableView.tableHeaderView = topView;
    [self.tableView setTableFooterView:[[UIView alloc] init]];

    [self getFileName];
    
    self.reversedArray = [[self.array reverseObjectEnumerator] allObjects];
}

- (void)getFileName {
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    self.fileName = [path stringByAppendingPathComponent:@"palce.plist"];
    self.array = [NSMutableArray arrayWithContentsOfFile:self.fileName];
}
- (void)popBack {
    
    if (![NSString isBlankString:self.textField.text]) {
        
        if (![self.array containsObject:self.textField.text]) {
            
            [self.array addObject:self.textField.text];
            [self.array writeToFile:self.fileName atomically:YES];
        }
    }
    
    if (self.placeBlock) {
        self.placeBlock(self.textField.text);
    }
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.reversedArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    if (self.reversedArray.count != 0) {
        
        cell.textLabel.text = self.reversedArray[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.textField.text = cell.textLabel.text;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
