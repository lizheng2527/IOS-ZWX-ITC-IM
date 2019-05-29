//
//  AppModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/1/13.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppModel : NSObject
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * imageStr;
@property (nonatomic, copy) NSString * baseUrl;
@property (nonatomic, copy) NSString *type;
@end


@interface AppMainModel : NSObject

@property(nonatomic,copy)NSString *sectionName;
@property(nonatomic,retain)NSMutableArray *sectionModelArray; //放置AppModel
@end
