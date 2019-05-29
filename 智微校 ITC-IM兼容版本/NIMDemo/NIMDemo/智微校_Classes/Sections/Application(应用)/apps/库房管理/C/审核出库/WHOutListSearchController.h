//
//  WHOutListSearchController.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/21.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WHOutListSearchController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,retain)UITextField *textField;
@property(nonatomic,retain)NSMutableArray *dataSource;
@property(nonatomic,assign)BOOL isEdited;
@property(nonatomic,copy)NSString *tempString;

@end
