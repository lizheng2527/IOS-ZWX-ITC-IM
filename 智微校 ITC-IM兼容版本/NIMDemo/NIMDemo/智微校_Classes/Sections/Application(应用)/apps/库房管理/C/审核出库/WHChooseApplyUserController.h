//
//  WHChooseApplyUserController.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/13.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoosePersonDelete <NSObject>

- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name;

@end


typedef void (^ReturnUserNameBlock)(NSString * userIdBlock, NSString * userName);

@interface WHChooseApplyUserController : UIViewController

@property (nonatomic, weak) id<ChoosePersonDelete> delegate;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, copy) ReturnUserNameBlock  userIdBlock;
//- (void)selectIndexUserIdAndName:(ReturnUserNameBlock)userIdBlock;
@property (nonatomic) BOOL isSelect;
@property(nonatomic,assign)NSInteger isAreadyInsertNum;

@property(nonatomic,assign)BOOL isTeacherOrAdmin;
@property(nonatomic,assign)BOOL whoWillIn;

@property(nonatomic,copy)NSString *inType;
@end
