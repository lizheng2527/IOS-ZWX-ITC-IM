//
//  AreaHelper.h
//  TYHxiaoxin
//
//  Created by 大存神 on 16/1/5.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaHelper : NSObject

//------------------------------------------------------------------------------
//获取动态
- (void)getNewStateWithStatus :(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;

-(void)getNewMomentRecordListWithSchoolKind:(NSString *)kind requsetTime:(NSString *)time Status:(void (^)(BOOL, NSMutableArray *))status failure:(void (^)(NSError *))failure;


//------------------------------------------------------------------------------
//朋友圈

//获取圈子Json
- (void)getPersonalMomentsWithPageNum:(NSInteger )pageNum andStatus :(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;

//发表动态（有图片）
//content 内容，tagId 标签id，publicFlag 是否公开，location 位置，url 外部链接，uploadFiles文件
-(void)uploadCommentWith:(NSString *)content tadID:(NSString *)tagId publicFlag:(NSString *)publicFlag location:(NSString *)location url:(NSString *)url uploadFiles:(NSMutableArray *)uploadFiles andStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;

////发表动态（没有图片）
//-(void)uploadCommentWithoutUploadfiles:(NSString *)content tadID:(NSString *)tagId publicFlag:(BOOL)publicFlag location:(NSString *)location url:(NSString *)url;


//获取个人空间
-(void)getUserMomentsWithPagenum:(NSInteger)pageNum userID:(NSString *)usersID andStatus:(void (^)(BOOL, NSMutableArray *,NSString*))status failure:(void (^)(NSError *))failure;

//获取个人空间详情
-(void)getUserMomentsDetailWithMomentID:(NSString *)commentID andStatus:(void (^)(BOOL, NSMutableArray *))status failure:(void (^)(NSError *))failure;

//点赞
+(void)addLikeWithCommentID:(NSString *)commentID;



//取消赞
+(void)DelLikeWithCommentID:(NSString *)commentID;

//删除状态
+(void)DelCommentWithCommentID:(NSString *)commentID;

//评论发布状态
+(void)AddCommentWithCommentID:(NSString *)commentID andContent:(NSString *)content;

//删除评论
+(void)deleteMomentCommentWithCommentID:(NSString *)CommentID kind:(NSString *)kind;

//删除评论的回复
+(void)DelCommentWithReplyID:(NSString *)replyID kind:(NSString *)kind;

//评论回复
+(void)saveCommentReplyWithCommentID:(NSString *)CommentID kind:(NSString *)kind content:(NSString *)content andTargetUserId:(NSString *)targetUserId;

//------------------------------------------------------------------------------
//班级墙报

//获取班级墙报Json
- (void)getClassPaperWithPageNum:(NSInteger )pageNum andStatus :(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;

//获取所在班级
-(void)getOwnerClassandStatus:(void (^)(BOOL, NSMutableArray *))status failure:(void (^)(NSError *))failure;

//发表班级墙报动态（根据有无上传图片自动调用相应接口）
-(void)uploadClassPaperCommentWith:(NSString *)content tadID:(NSString *)tagId publicFlag:(NSString *)publicFlag departmentId:(NSString *)departmentId location:(NSString *)location url:(NSString *)url uploadFiles:(NSMutableArray *)uploadFiles andStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure;

// 获取班级主页信息
-(void)getClassMomentsWithPagenum:(NSInteger)pageNum departmentID:(NSString *)departmentId andStatus:(void (^)(BOOL, NSMutableArray *))status failure:(void (^)(NSError *))failure;



@end
