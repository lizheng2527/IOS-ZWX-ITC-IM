//
//  SchoolMatesModel.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/1/5.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
//朋友圈整体cell
@interface SchoolMatesModel : NSObject
@property(nonatomic,copy)NSString *commentCount;
@property(nonatomic,retain)NSMutableArray *commentsArray; //消息回复
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *headPortraitUrl;
@property(nonatomic,copy)NSString *tempID;
@property(nonatomic,copy)NSString *isThumbsup;
@property(nonatomic,retain)NSMutableArray *picUrlsArray;//预览图和点开大图
@property(nonatomic,copy)NSString *publishTime;
@property(nonatomic,copy)NSString *thumbsupCount;
@property(nonatomic,retain)NSMutableArray *thumbsupsArray; //点赞🐶
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,retain)NSMutableArray *momentsArray; //个人详情


@property(nonatomic,retain)NSString *departmentName;
@property(nonatomic,retain)NSString *departmentId;

@end

//朋友圈消息回复
@interface commentsModel : NSObject
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *contentID;
@property(nonatomic,retain)NSMutableArray *replysArray;
@property(nonatomic,copy)NSString *time;
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@end

//朋友圈照片的大图和预览小图
@interface picUrlsModel : NSObject
@property(nonatomic,copy)NSString *bigPicUrl;
@property(nonatomic,copy)NSString *smallPicUrl;
@end

//点赞
@interface thumbsupsModel : NSObject
@property(nonatomic,copy)NSString *userId;
@property(nonatomic,copy)NSString *userName;
@end


@interface replyModel : NSObject
@property(nonatomic,copy)NSString *replyUserId;
@property(nonatomic,copy)NSString *replyUserName;
@property(nonatomic,copy)NSString *targetUserId;
@property(nonatomic,copy)NSString *targetUserName;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *contentID;

@end

@interface momentsModel : NSObject
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *contentID;
@property(nonatomic,retain)NSMutableArray *picUrls;
@property(nonatomic,copy)NSString *publishTime;

@property(nonatomic,copy)NSString *voipAccount;

@end

@interface classModel : NSObject
@property(nonatomic,copy)NSString *classID;
@property(nonatomic,copy)NSString *className;
@property(nonatomic,copy)NSString *operateFlag;
@end



