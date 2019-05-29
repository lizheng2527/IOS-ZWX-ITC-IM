//
//  PCheckSearchController.h
//  NIM
//
//  Created by 中电和讯 on 2017/12/6.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCheckSearchController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *chooseTypeButton;
@property (weak, nonatomic) IBOutlet UIButton *choosePersonButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseStartTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *chooseEndTimeButton;

- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name;

- (void)didselectedUser:(NSString *)userID userName:(NSString *)name;

@property(nonatomic,copy)NSString *projectID;

@end
