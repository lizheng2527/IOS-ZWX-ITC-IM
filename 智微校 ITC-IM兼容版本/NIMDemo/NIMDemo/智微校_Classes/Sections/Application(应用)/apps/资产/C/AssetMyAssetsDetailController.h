//
//  AssetMyAssetsDetailController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/10/9.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetMyAssetsDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *returnPersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnOrganizationLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnHandlePersonLabel;
@property (weak, nonatomic) IBOutlet UILabel *rerurnDateLabel;

@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@property(nonatomic,copy)NSString *returnID;

@end
