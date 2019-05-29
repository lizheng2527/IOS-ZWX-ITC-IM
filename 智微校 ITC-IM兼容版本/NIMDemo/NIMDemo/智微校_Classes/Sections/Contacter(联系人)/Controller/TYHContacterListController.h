//
//  TYHContacterListController.h
//  NIM
//
//  Created by 中电和讯 on 16/12/7.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYHContacterListController : UIViewController
//@property (weak, nonatomic) IBOutlet UISearchBar *mySearchBar;
//@property (strong, nonatomic) IBOutlet UISearchDisplayController *mySearchDisplayController;

@property (weak, nonatomic) IBOutlet UITableView *mainTableview;
@property(nonatomic,assign)NSInteger isClassOrSchool; //1 class    0 School

-(instancetype)initWithType:(NSInteger )type;
@end
