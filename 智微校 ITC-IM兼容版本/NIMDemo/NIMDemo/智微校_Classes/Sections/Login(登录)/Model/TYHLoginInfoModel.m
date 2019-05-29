//
//  TYHLoginInfoModel.m
//  NIM
//
//  Created by 中电和讯 on 16/12/5.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "TYHLoginInfoModel.h"
#import <MJExtension.h>

@implementation TYHLoginInfoModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"userID":@"id"};
}
@end

//组织机构Model
@implementation TYHOranizationModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"organizationName":@"name",@"organizationID":@"id"};
}
@end
