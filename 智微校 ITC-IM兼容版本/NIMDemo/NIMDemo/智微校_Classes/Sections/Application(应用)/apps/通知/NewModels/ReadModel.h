//
//  ReadModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 16/2/15.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadModel : NSObject
//result = {"readList":[{"name":"于涵","readingTime":"2016-02-15 12:01:26"}],"unReadList":[{"name":"林雨佳"},{"name":"刘莉"}]}
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * readingTime;
//@property (nonatomic, copy) NSString * 
@end
