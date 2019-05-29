//
//  ContactModelListHelper.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/24.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import "ContactModelListHelper.h"
#import <AFNetworking.h>
#import "ContactModel.h"
#import "UserModel.h"
#import <SDWebImage/SDWebImageManager.h>
#import "TYHHttpTool.h"

#define BaseURL [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_BASEURL"]

@implementation ContactModelListHelper



-(void)BaseData
{
    _userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DEFAULT_LOGINNAME"];
    _password = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DEFAULT_PASSWORD"];
    _organizationID = [[NSUserDefaults standardUserDefaults] valueForKey:@"USER_DEFAULT_ORIGANIZATION_ID"];
    _voipAcount = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_VOIP"];
    _baseUrlString = BaseURL;
    _dataSource = [NSMutableArray array];
    
    _nameSource = [NSMutableArray array];
}

- (void)getContactCompletionWIthSchool:(void (^)(BOOL, NSMutableArray *))completion
{
    [self BaseData];
    NSString *ContactUrl = [_baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/bd/organization/getDepartmentTreeJsonForIOS?sys_username=%@%@%@&sys_auto_authenticate=true&organizationId=%@&sys_password=%@",_userName,@"%2C",_organizationID,_organizationID,_password]];
//    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    [manager GET:ContactUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSMutableArray *mArray = [NSMutableArray array];
            
            mArray = [self handleContactList:responseObject];
            completion(YES,mArray);
            
        }else{
            completion(NO,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    //    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    //    [TYHHttpTool get:@"http://202.108.31.101:9999/im/bd/organization/getDepartmentTreeJsonForIOS?sys_username=gaoyacun%2C20160923155525448419150856081234&sys_auto_authenticate=true&organizationId=20160923155525448419150856081234&sys_password=000000" params:nil success:^(id json) {
    //        if (json) {
    //            NSMutableArray *mArray = [NSMutableArray array];
    //            mArray = [self handleContactList:json];
    //            completion(YES,mArray);
    //        }else{
    //            completion(NO,[NSMutableArray array]);
    //        }
    //
    //    } failure:^(NSError *error) {
    //        
    //    }];
}


- (void)getContactCompletionNoticeContact:(NSString *)strUrl block:(void (^)(BOOL, NSMutableArray *))completion
{
    
    [self BaseData];
    strUrl = [strUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSLog(@"School URL %@",strUrl);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    [manager GET:strUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSMutableArray *mArray = [NSMutableArray array];
            mArray = [self handleContactList:responseObject];
            completion(YES,mArray);
            
        }else{
            completion(NO,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (NSMutableArray *)handleContactList:(NSMutableArray *)array;
{
    NSMutableArray *totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    static NSUInteger indentation = 0;
    
    for (NSDictionary *dic in array) {
        ContactModel *contactModel = [[ContactModel alloc] init];
        contactModel.IndentationLevel = indentation;
        contactModel.contactId = dic[@"id"];
        contactModel.name = dic[@"name"];
        contactModel.parentId = dic[@"parentId"];
        NSMutableArray *childsArray = [dic objectForKey:@"childs"];
        if (childsArray && childsArray.count > 0) {
            contactModel.childs = [self addSubContact:childsArray withContactModel:contactModel andIndentation:indentation];
        }
        NSMutableArray *userListArray = [dic objectForKey:@"userList"];
        if (userListArray && userListArray.count >0) {
            contactModel.userList = [self addSubUserList:userListArray withContactModel:contactModel andIndentation:indentation];
        }
        //        if ([contactModel.parentId isEqualToString:@"0"]) {
        //            [totalArray addObject:contactModel];
        //        }
        [totalArray addObject:contactModel];
    }
    return totalArray;
}

- (NSMutableArray *)addSubContact:(NSMutableArray *)childsArray withContactModel:(ContactModel *)model andIndentation:(NSUInteger)indentation
{
    indentation ++;
    model.childs = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *dic in childsArray) {
        NSString *parentId = [dic objectForKey:@"parentId"];
        if ([model.contactId isEqualToString:parentId]) {
            ContactModel *contactModel = [[ContactModel alloc] init];
            contactModel.IndentationLevel = indentation;
            contactModel.contactId = [dic objectForKey:@"id"];
            
            contactModel.name = [dic objectForKey:@"name"];
            contactModel.parentId = [dic objectForKey:@"parentId"];
            [model.childs addObject:contactModel];
            NSMutableArray *subArray = [dic objectForKey:@"childs"];
            if (subArray && subArray.count > 0) {
                contactModel.childs = [self addSubContact:subArray withContactModel:contactModel andIndentation:indentation];
            }
            NSMutableArray *userListArray = [dic objectForKey:@"userList"];
            if (userListArray && userListArray.count >0) {
                contactModel.userList = [self addSubUserList:userListArray withContactModel:contactModel andIndentation:indentation];
            }
        }
    }
    return model.childs;
}


- (NSMutableArray *)addSubUserList:(NSMutableArray *)userListArray withContactModel:(ContactModel *)model andIndentation:(NSUInteger)indentation
{
    indentation ++;
    model.userList = [[NSMutableArray alloc] initWithCapacity:0];
    for (NSDictionary *userDic in userListArray) {
        UserModel *userModel = [[UserModel alloc] init];
        userModel.IndentationLevel = indentation;
        userModel.userId = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"id"]];
        userModel.name = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"name"]];
        userModel.voipAccount = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"voipAccount"]];
        userModel.strId = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"id"]];
        userModel.headPortraitUrl = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"headPortraitUrl"]];
        userModel.accId = [NSString stringWithFormat:@"%@",[userDic objectForKey:@"accId"]];
        [model.userList addObject:userModel];
        [self.dataSource addObject:userModel];
        
        [self.nameSource addObject:userModel.name];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
           NSString * headerImage =  [NSString stringWithFormat:@"%@%@",BaseURL,userModel.headPortraitUrl];
            [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:headerImage] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [[SDImageCache sharedImageCache]storeImage:image forKey:userModel.voipAccount];
            }];
        });
        

    }
    
    return model.userList;
}


-(void)getContactCompletionWithFriend:(void (^)(BOOL, NSMutableArray *))completion
{
    [self BaseData];
    
    NSString *ContactUrl = [_baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/bd/buddy/getBuddyJson?sys_username=%@%@%@&sys_auto_authenticate=true&voipAccount=%@",_userName,@"%2C",_organizationID,_voipAcount]];
    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    [manager GET:ContactUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSMutableArray *friendArray = [NSMutableArray array];
            friendArray = [self handleContactList:responseObject];
            

            completion(YES,friendArray);
        }else{
            completion(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}





-(void)getContactCompletionWithClasses:(void (^)(BOOL, NSMutableArray *))completion
{
    [self BaseData];
    
//    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@%@%@",_userName,@"%2C",_organizationID],@"voipAccount":_voipAcount};
//    NSString *requestURL = [NSString stringWithFormat:@"%@%@",_baseUrlString,@"/bd/organization/getClassTreeJsonForIOS"];
//    
//    [TYHHttpTool get:requestURL params:dic success:^(id json) {
//        if (json) {
//            NSMutableArray *mArray = [NSMutableArray array];
//            mArray = [self handleContactList:json];
//            completion(YES,mArray);
//        }else{
//            completion(NO,[NSMutableArray array]);
//        }
//        
//    } failure:^(NSError *error) {
//        
//    }];
    
//    
    NSString *ContactUrl = [_baseUrlString stringByAppendingString:[NSString stringWithFormat:@"/bd/organization/getClassTreeJsonForIOS?sys_username=%@%@%@&sys_auto_authenticate=true&voipAccount=%@&sys_password=%@",_userName,@"%2C",_organizationID,_voipAcount,_password]];
//    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    [manager GET:ContactUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSMutableArray *friendArray = [NSMutableArray array];
            friendArray = [self handleContactList:responseObject];
            
            completion(YES,friendArray);
        }else{
            completion(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

@end
