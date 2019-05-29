//
//  TYHChooseTeacherController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/3/15.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChoosePersonDelete <NSObject>

- (void)didselectedPerson:(NSString *)urlId name:(NSString *)name;

@end


typedef void (^ReturnUserNameBlock)(NSString * userIdBlock, NSString * userName);

@interface TYHChooseTeacherController : UIViewController


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
@end
