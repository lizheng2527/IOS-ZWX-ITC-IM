//
//  TYHAddFriendViewController.h
//  TYHxiaoxin
//
//  Created by 大存神 on 15/9/9.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHAddFriendViewController : UIViewController
@property(nonatomic,retain)UITextField *textField;
@property(nonatomic,retain)UITableView *mainTableView;
@property(nonatomic,retain)NSMutableArray *dataSource;
@property(nonatomic,assign)BOOL isEdited;
@property(nonatomic,copy)NSString *tempString;


@property(nonatomic,retain)NSArray *filterData;

@end
