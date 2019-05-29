//
//  RAPlaceModel.h
//  NIM
//
//  Created by 中电和讯 on 17/3/16.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RASchoolModel : NSObject

@property(nonatomic,retain)NSMutableArray *buildingList;
@property(nonatomic,retain)NSMutableArray *buildingListModelArray;
@property(nonatomic,copy)NSString *schoolID;
@property(nonatomic,copy)NSString *name;

@end


@interface RAPlaceModel : NSObject

@property(nonatomic,retain)NSMutableArray *floorList;
@property(nonatomic,retain)NSMutableArray *floorListModelArray;
@property(nonatomic,copy)NSString *buildingID;
@property(nonatomic,copy)NSString *name;

@end

@interface RAPlaceFloorModel : NSObject

@property(nonatomic,retain)NSMutableArray *roomList;
@property(nonatomic,retain)NSMutableArray *roomListModelArray;
@property(nonatomic,copy)NSString *floorID;
@property(nonatomic,copy)NSString *name;

@end

@interface RAPlaceRoomModel : NSObject
@property(nonatomic,copy)NSString *roomID;
@property(nonatomic,copy)NSString *name;

@end

@interface RAErrorModel : NSObject

@property(nonatomic,copy)NSString *errorID;
@property(nonatomic,copy)NSString *name;

@property(nonatomic,assign)BOOL isClick; //默认没有值,如果被点击,则YES
@end
