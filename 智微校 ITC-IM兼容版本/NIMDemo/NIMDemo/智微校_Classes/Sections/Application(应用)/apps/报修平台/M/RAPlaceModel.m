//
//  RAPlaceModel.m
//  NIM
//
//  Created by 中电和讯 on 17/3/16.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RAPlaceModel.h"

@implementation RASchoolModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"schoolID":@"id"};
}

@end

@implementation RAPlaceModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"buildingID":@"id"};
}
@end


@implementation RAPlaceFloorModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"floorID":@"id"};
}
@end

@implementation RAPlaceRoomModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"roomID":@"id"};
}
@end

@implementation RAErrorModel

+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"errorID":@"id"};
}
@end

