//
//  QCSClassDetailModel.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface QCSClassDetailModel : NSObject

@end

//手写笔记
@interface QCSClassDetailSXBJModel : NSObject

@property(nonatomic,copy)NSString *startTime;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *picUrl;

@end

//手写笔记Detail
@interface QCSClassDetailSXBJDetailModel : NSObject

@property(nonatomic,retain)NSMutableArray *answerUrl;
@property(nonatomic,retain)NSMutableArray *answerUrlModelArray;

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *downloadUrl;
@property(nonatomic,copy)NSString *picUrl;
@end


//板书记录
@interface QCSClassDetailBSJLModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *downloadUrl;
@property(nonatomic,copy)NSString *picUrl;

@end

//选择题
@interface QCSClassDetailXZTModel : NSObject

@property(nonatomic,copy)NSString *option;
@property(nonatomic,copy)NSString *urls;
@property(nonatomic,copy)NSString *percentStr;
@property(nonatomic,copy)NSString *rightAnswer;
@property(nonatomic,copy)NSString *chooseType;
@property(nonatomic,copy)NSString *countStr;

@property(nonatomic,retain)NSMutableArray *optionList;
@property(nonatomic,retain)NSMutableArray *optionListModelArray;
@end

//选择题Inside
@interface QCSClassDetailXZTInsideModel : NSObject

@property(nonatomic,copy)NSString *studentNames;
@property(nonatomic,copy)NSString *option;

@end



//教学课件
@interface QCSClassDetailJXKJModel : NSObject

@property(nonatomic,copy)NSString *downloadUrl;
@property(nonatomic,copy)NSString *id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *size;

@end



