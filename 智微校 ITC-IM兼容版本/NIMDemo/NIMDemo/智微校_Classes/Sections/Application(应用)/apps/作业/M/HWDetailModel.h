//
//  HWDetailModel.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/28.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HWDetailModel : NSObject
@property(nonatomic,copy)NSString *attachmentName;
@property(nonatomic,copy)NSString *attachmentUrl;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *courseName;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *fileSize;
@property(nonatomic,retain)id result;
@property(nonatomic,copy)NSString *workEclass;
@property(nonatomic,copy)NSString *studentWorkId;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *status;
@property(nonatomic,copy)NSString *statusName;
@end

@interface resultModel : NSObject
@property(nonatomic,copy)NSString *content;
@property(nonatomic,retain)NSMutableArray *imageList;

@end
