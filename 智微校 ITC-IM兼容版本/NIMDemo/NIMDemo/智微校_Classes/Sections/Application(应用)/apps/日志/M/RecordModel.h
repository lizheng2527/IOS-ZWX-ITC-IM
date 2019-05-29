//
//  RecordModel.h
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordModel : NSObject
@property(nonatomic,copy)NSString *effectiveTime;
@property(nonatomic,copy)NSString *plan;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *summarize;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *workEndTime;
@property(nonatomic,copy)NSString *workStartTime;
@property(nonatomic,retain)NSMutableArray *attachmentList;
@property(nonatomic,retain)NSMutableArray *attachmentListModelArray;

@end

@interface RecordattachmentModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *url;

@end

