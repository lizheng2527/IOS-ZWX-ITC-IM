//
//  PProjectApprovalCheckController.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/17.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PProjectApprovalCheckController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *passBtn;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;

@property (weak, nonatomic) IBOutlet UIButton *unPassBtn;
@property (weak, nonatomic) IBOutlet UILabel *unPassLabel;

@property (weak, nonatomic) IBOutlet UITextView *reasonTextView;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *chooseBtn;


- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name;

- (void)didselectedUser:(NSString *)userID userName:(NSString *)name;

@property(nonatomic,copy)NSString *projectID;

@end
