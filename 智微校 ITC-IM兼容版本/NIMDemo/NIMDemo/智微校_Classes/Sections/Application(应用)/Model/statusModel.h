//
//  statusModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 3/25/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface statusModel : NSObject
/*
 "opTime": "2016-03-22 15:09 ",
 "status": "1",
 "name": "待审核",
 "note": "请耐心等待审核"
*/
@property (nonatomic, copy) NSString * opTime;
@property (nonatomic, copy) NSString * status;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * note;

@end
