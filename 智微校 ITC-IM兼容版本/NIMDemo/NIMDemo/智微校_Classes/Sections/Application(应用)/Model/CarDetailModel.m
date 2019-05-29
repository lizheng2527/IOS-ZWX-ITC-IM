//
//  CarDetailModel.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 4/12/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import "CarDetailModel.h"
#import <MJExtension.h>

@implementation CarDetailModel

+ (NSDictionary *)objectClassInArray {

    return @{
             @"oaCarData":@"OaCarDataModel",
             @"attachments":@"AttachmentsModel"
             };
}

@end
