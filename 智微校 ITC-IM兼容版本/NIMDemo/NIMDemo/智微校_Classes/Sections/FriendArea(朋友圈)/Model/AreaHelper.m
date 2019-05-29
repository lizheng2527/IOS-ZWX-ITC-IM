//
//  AreaHelper.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/1/5.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AreaHelper.h"
#import <MJExtension.h>

#import "FriendAreaDefine.h"
#import "TYHHttpTool.h"
#import "SchoolMatesModel.h"
#import <AFNetworking.h>
#import "NewStateModel.h"
#import "CommentRecordListModel.h"
#import "TYHHttpTool.h"

@implementation AreaHelper{
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
    NSString *uploadImageNames;
    
    NSString *personRecordTime;
    NSString *personTime;
    NSString *classTime;
    NSString *classRecordTime;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self getNeedData];
    }
    return self;
}
#pragma mark - 获取初始化信息
-(void)getNeedData
{
    userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    
    if (![self isBlankString:[[NSUserDefaults standardUserDefaults]valueForKey:Area_personRecordTime]]) {
        personRecordTime = [[NSUserDefaults standardUserDefaults]valueForKey:Area_personRecordTime];
    }
    else
    {
        personRecordTime = @"2020-07-13 18:38:07";
    }
    if (![self isBlankString:[[NSUserDefaults standardUserDefaults]valueForKey:Area_personTime]]) {
        personTime = [[NSUserDefaults standardUserDefaults]valueForKey:Area_personTime];
    }
    else
    {
        personTime = @"2020-07-13 18:38:07";
    }
    if (![self isBlankString:[[NSUserDefaults standardUserDefaults]valueForKey:Area_classRecordTime]]) {
        classRecordTime = [[NSUserDefaults standardUserDefaults]valueForKey:Area_classRecordTime];
    }
    else
    {
        classRecordTime = @"2020-07-13 18:38:07";
    }
    if (![self isBlankString:[[NSUserDefaults standardUserDefaults]valueForKey:Area_classTime]]) {
        classTime = [[NSUserDefaults standardUserDefaults]valueForKey:Area_classTime];
    }
    else
    {
        classTime = @"2020-07-13 18:38:07";
    }
    uploadImageNames = @"image0.png,image1.png,image2.png,image3.png,image4.png,image5.png,image6.png,image7.png,image8.png";
}

#pragma mark - 新动态
- (void)getNewStateWithStatus :(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    
    NSDictionary *dic = @{@"userId":userID,@"personRecordTime":personRecordTime,@"personTime":personTime,@"classRecordTime":classRecordTime,@"classTime":classTime};
    NSString *requestUrl = [NSString stringWithFormat:@"%@%@",BaseURL,getNewMomentRecordCount];
    requestUrl = [NSString stringWithFormat:@"%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true",requestUrl,[NSString stringWithFormat:@"%@",userName],password];
    
//    requestUrl = [requestUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [TYHHttpTool get:requestUrl params:dic success:^(id json) {
        NSMutableArray *modelArray = [NewStateModel mj_objectArrayWithKeyValuesArray:json];
        status(YES,modelArray);
    } failure:^(NSError *error) {
        status(NO,nil);
    }];
}

-(void)getNewMomentRecordListWithSchoolKind:(NSString *)kind requsetTime:(NSString *)time Status:(void (^)(BOOL, NSMutableArray *))status failure:(void (^)(NSError *))failure
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,getNewMomentRecordList];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"userId":userID,@"time":time,@"kind":kind};
    [TYHHttpTool get:urlString params:dic success:^(id json) {
        NSArray *blockarray = [CommentRecordListModel mj_objectArrayWithKeyValuesArray:json];
        status(YES,[NSMutableArray arrayWithArray:blockarray]);
    } failure:^(NSError *error) {
        status(NO,nil);
    }];
}


- (BOOL) isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

#pragma mark - －－－－－－朋友圈－－－－－－
#pragma mark - 获取圈子信息
- (void)getPersonalMomentsWithPageNum:(NSInteger )pageNum andStatus :(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSString *tempNum = [NSString stringWithFormat:@"%ld",(long)pageNum];
    NSMutableArray *blcokArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,getPersonalMoments];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"userId":userID,@"pageNum":tempNum};
    
    [TYHHttpTool get:urlString params:dic success:^(id json) {
        NSArray *modelArray = [SchoolMatesModel mj_objectArrayWithKeyValuesArray:json];
        for (SchoolMatesModel *schoolModel in modelArray) {
            [blcokArray addObject:schoolModel];
        }
        status(YES,blcokArray);
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 发表动态（根据有无上传图片自动调用相应接口）
-(void)uploadCommentWith:(NSString *)content tadID:(NSString *)tagId publicFlag:(NSString *)publicFlag location:(NSString *)location url:(NSString *)url uploadFiles:(NSMutableArray *)uploadFiles andStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSString *uploadURLWithoutFiles = [NSString stringWithFormat:@"%@%@",BaseURL,savePersonalMomentWithoutFile];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"sys_username"] = [NSString stringWithFormat:@"%@" ,userName];
    params[@"sys_auto_authenticate"]= @"true";
    params[@"sys_password"]= [NSString stringWithFormat:@"%@",password];
    params[@"content"] = content;
    params[@"publicFlag"] = @"1";
    params[@"location"] = location;
    NSString *tmpString = @"";
    if (uploadFiles != nil && uploadFiles.count > 0) {
        for (int i = 1; i <= uploadFiles.count; i++) {
            tmpString = [uploadImageNames substringWithRange:NSMakeRange(0, i*10 + (i-1)*1)];
        }
        params[@"uploadFileNames"] = tmpString;
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    
    ////    这个决定了下面responseObject返回的类型
    
    if (uploadFiles.count == 0 || uploadFiles == nil) {
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:uploadURLWithoutFiles parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            status(YES,responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            status(NO,[NSMutableArray arrayWithObject:error]);
            NSLog(@"上传失败,%@",error);
        }];
    }
    else
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        NSString *uploadURLWithoutFiles = [NSString stringWithFormat:@"%@%@",BaseURL,savePersonalMoment];
        
        uploadURLWithoutFiles = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true",BaseURL,savePersonalMoment,[NSString stringWithFormat:@"%@" ,userName],password];
        [params removeObjectForKey:@"sys_auto_authenticate"];
        [params removeObjectForKey:@"sys_password"];
        [params removeObjectForKey:@"sys_username"];
        
        
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        
//        NSData * data;
        //    UIImage * image2;
        for (UIImage * image in uploadFiles) {
            
            //        CGSize imagesize = image.size;
            //        imagesize.height =80;
            //        imagesize.width =80;
            //
            //        image2 = [self imageWithImage:image scaledToSize:imagesize];
            //判断图片是不是png格式的文件
            
            //设置image的尺寸
            UIImage *imageNew = image;
            //设置image的尺寸
            CGSize imagesize = imageNew.size;
//            imagesize.height =imagesize.height * 0.9;
//            imagesize.width =imagesize.width * 0.9;
            //对图片大小进行压缩--
//            imageNew = [self imageWithImage:imageNew scaledToSize:imagesize];
//            imageNew = [self imageCompressForSize:imageNew targetSize:imagesize];
            imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
//            imageCompressForWidth
            
            NSData *imageData = UIImageJPEGRepresentation(imageNew,0.1);
            
//            if (UIImagePNGRepresentation(image)) {
//                //返回为png图像。
//                data = UIImagePNGRepresentation(image);
//            }else {
//                //返回为JPEG图像。
//                data = UIImageJPEGRepresentation(image, 0.00001);
//            }
            [imageDataArr addObject:imageData];
            
        }
        
        [manager POST:uploadURLWithoutFiles parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//           __block NSInteger imgCount = 0;
       
//            dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            
            [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSData *imageData = obj;
                    NSString *fileName = [NSString stringWithFormat:@"image%d.png",(int)idx];
                    [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
            }];
            
//            for (NSData *imageData in imageDataArr) {
//               
//            }
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"=-= =-= %@",params);
            status(YES,responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            status(NO,[NSMutableArray arrayWithObject:error]);
            NSLog(@"上传失败,%@",error);
            NSLog(@"=-= =-= %@",params);
        }];
        
    }
}


//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
//    UIGraphicsBeginImageContext(newSize);
//    
//    // Tell the old image to draw in this new context, with the desired
//    // n/
    
    
    CGSize imageSize = image.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    if (width <= newSize.width && height <= newSize.height){
        return image;
    }
    if (width == 0 || height == 0){
        return image;
    }
    
    CGFloat widthFactor = newSize.width / width;

    CGFloat scaleFactor = widthFactor;
    CGFloat scaledWidth = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth,scaledHeight);
    UIGraphicsBeginImageContext(targetSize);
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
                             
}


-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }

    UIGraphicsEndImageContext();
    return newImage;

}


#pragma mark - 获取个人主页信息
-(void)getUserMomentsWithPagenum:(NSInteger)pageNum userID:(NSString *)usersID andStatus:(void (^)(BOOL, NSMutableArray *,NSString*))status failure:(void (^)(NSError *))failure
{
    NSString *tempNum = [NSString stringWithFormat:@"%ld",(long)pageNum];
    NSMutableArray *tempArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,getUserMoments];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"userId":usersID,@"pageNum":tempNum};
    [TYHHttpTool get:urlString params:dic success:^(id json) {
        for (momentsModel *moModel in [momentsModel mj_objectArrayWithKeyValuesArray:[json objectForKey:@"moments"]]) {
            moModel.picUrls = [picUrlsModel mj_objectArrayWithKeyValuesArray:moModel.picUrls];
            moModel.voipAccount = [json objectForKey:@"voipAccount"];
            [tempArray addObject:moModel];
        }
        status(YES,tempArray,[json objectForKey:@"voipAccount"]);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray arrayWithObject:error],nil);
    }];
    
}

#pragma mark - 获取个人空间详情
-(void)getUserMomentsDetailWithMomentID:(NSString *)commentID andStatus:(void (^)(BOOL, NSMutableArray *))status failure:(void (^)(NSError *))failure
{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"momentId":commentID};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,getMomentDetail];
    
    [TYHHttpTool get:url params:dic success:^(id json) {
        
        SchoolMatesModel *modelArray = [SchoolMatesModel mj_objectWithKeyValues:json];
//        for (SchoolMatesModel *schoolModel in modelArray) {
//            [tempArray addObject:schoolModel];
//        }
        status(YES,[NSMutableArray arrayWithObjects:modelArray,nil]);
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 点赞
+(void)addLikeWithCommentID:(NSString *)commentID
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"momentId":commentID};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,thumbsup];
    [TYHHttpTool get:url params:dic success:^(id json) {
        
    } failure:^(NSError *error) {
    }];

}
#pragma mark - 删除赞
+(void)DelLikeWithCommentID:(NSString *)commentID
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"momentId":commentID};
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,cancelThumbsup];
    [TYHHttpTool get:url params:dic success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 删除个人已发布状态
+(void)DelCommentWithCommentID:(NSString *)commentID
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"momentId":commentID};
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,deleteMoment];
    [TYHHttpTool get:url params:dic success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - 评论发布状态
+(void)AddCommentWithCommentID:(NSString *)commentID andContent:(NSString *)content
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
     NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"momentId":commentID,@"content":content};
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,saveMomentComment];
    [TYHHttpTool post:url params:dic success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
}

#pragma mark - 删除评论的回复
+(void)DelCommentWithReplyID:(NSString *)replyID kind:(NSString *)kind
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"replyId":replyID,@"kind":kind};

    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,deleteCommentReply];
    [TYHHttpTool get:url params:dic success:^(id json) {
        
    } failure:^(NSError *error) {
        
        
    }];
}

#pragma mark - 删除状态的评论
+(void)deleteMomentCommentWithCommentID:(NSString *)CommentID kind:(NSString *)kind
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"commentId":CommentID,@"kind":kind};
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,deleteMomentComment];
    [TYHHttpTool get:url params:dic success:^(id json) {
        
    } failure:^(NSError *error) {
        
        
    }];
}


#pragma mark - 回复评论
+(void)saveCommentReplyWithCommentID:(NSString *)CommentID kind:(NSString *)kind content:(NSString *)content andTargetUserId:(NSString *)targetUserId
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_PASSWORD];
    NSString *organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
//    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@%@%@",userName,@"%2C",organizationID],@"sys_password":password,@"commentId":CommentID,@"kind":kind,@"content":content,@"targetUserId":targetUserId};
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"commentId":CommentID,@"kind":kind,@"content":content,@"targetUserId":targetUserId};
    
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,saveCommentReply];
    
    [TYHHttpTool post:url params:dic success:^(id json) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - －－－－－－班级墙报－－－－－－－
#pragma mark - 获取班级墙报Json
- (void)getClassPaperWithPageNum:(NSInteger )pageNum andStatus :(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSString *tempNum = [NSString stringWithFormat:@"%ld",(long)pageNum];
    NSMutableArray *blcokArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,getAllClassMoments];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"pageNum":tempNum,@"userId":userID};
    
    [TYHHttpTool get:urlString params:dic success:^(id json) {
        NSMutableArray *tempCommentArray = [NSMutableArray array];
        [tempCommentArray removeAllObjects];
        NSArray *modelArray = [SchoolMatesModel mj_objectArrayWithKeyValuesArray:json];
        for (SchoolMatesModel *schoolModel in modelArray) {
            [blcokArray addObject:schoolModel];
        }
        status(YES,blcokArray);
    } failure:^(NSError *error) {
        
    }];
}



#pragma mark - 发表班级墙报动态（根据有无上传图片自动调用相应接口）
//departmentId 部门id,content 内容，tagId 标签id，publicFlag 是否公开，location 位置，url 外部链接
-(void)uploadClassPaperCommentWith:(NSString *)content tadID:(NSString *)tagId publicFlag:(NSString *)publicFlag departmentId:(NSString *)departmentId location:(NSString *)location url:(NSString *)url uploadFiles:(NSMutableArray *)uploadFiles andStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSString *uploadURLWithoutFiles = [NSString stringWithFormat:@"%@%@",BaseURL,saveClassMomentWithoutFile];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    params[@"sys_username"] = [NSString stringWithFormat:@"%@" ,userName];
    params[@"sys_auto_authenticate"]= @"true";
    params[@"sys_password"]= [NSString stringWithFormat:@"%@",password];
    params[@"content"] = content;
    params[@"publicFlag"] = @"1";
    params[@"departmentId"]= departmentId;
    NSString *tmpString = @"";
    if (uploadFiles != nil && uploadFiles.count > 0) {
        for (int i = 1; i <= uploadFiles.count; i++) {
            tmpString = [uploadImageNames substringWithRange:NSMakeRange(0, i*10 + (i-1)*1)];
        }
        params[@"uploadFileNames"] = tmpString;
    }
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    ////    这个决定了下面responseObject返回的类型
    
    if (uploadFiles.count == 0 || uploadFiles == nil) {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        [manager POST:uploadURLWithoutFiles parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            status(YES,responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            status(NO,[NSMutableArray arrayWithObject:error]);
            NSLog(@"上传失败,%@",error);
        }];
    }
    else
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *uploadURLWithoutFiles = [NSString stringWithFormat:@"%@%@",BaseURL,saveClassMoment];
        
        
        uploadURLWithoutFiles = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true",BaseURL,saveClassMoment,[NSString stringWithFormat:@"%@" ,userName],password];
        [params removeObjectForKey:@"sys_auto_authenticate"];
        [params removeObjectForKey:@"sys_password"];
        [params removeObjectForKey:@"sys_username"];
        
        
        
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        //    UIImage * image2;
        for (UIImage * image in uploadFiles) {
            //设置image的尺寸
            UIImage *imageNew = image;
            //设置image的尺寸
            CGSize imagesize = imageNew.size;
            imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
            NSData *imageData = UIImageJPEGRepresentation(imageNew,0.00001);
            [imageDataArr addObject:imageData];
        }
        
        [manager POST:uploadURLWithoutFiles parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            //           __block NSInteger imgCount = 0;
            
            [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = obj;
                NSString *fileName = [NSString stringWithFormat:@"image%d.png",(int)idx];
                [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
            }];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"=-= =-= %@",params);
            status(YES,responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            status(NO,[NSMutableArray arrayWithObject:error]);
            NSLog(@"上传失败,%@",error);
            NSLog(@"=-= =-= %@",params);
        }];
        
    }
}


#pragma mark - 获取可选班级

-(void)getOwnerClassandStatus:(void (^)(BOOL, NSMutableArray *))status failure:(void (^)(NSError *))failure
{
    NSMutableArray *blcokArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,getUserClasses];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"userId":userID,@"userKind":@"0"};
    
    [TYHHttpTool get:urlString params:dic success:^(id json) {
        for (classModel *model in [classModel objectArrayWithKeyValuesArray:json])
        {
            [blcokArray addObject:model];
        }
        status(YES,blcokArray);
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - 获取班级主页信息
-(void)getClassMomentsWithPagenum:(NSInteger)pageNum departmentID:(NSString *)departmentId andStatus:(void (^)(BOOL, NSMutableArray *))status failure:(void (^)(NSError *))failure
{
    NSString *tempNum = [NSString stringWithFormat:@"%ld",(long)pageNum];
    NSMutableArray *tempArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BaseURL,getClassMoments];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"departmentId":departmentId,@"pageNum":tempNum};
    [TYHHttpTool get:urlString params:dic success:^(id json) {
        for (momentsModel *moModel in [momentsModel objectArrayWithKeyValuesArray:[json objectForKey:@"moments"]]) {
            moModel.picUrls = [picUrlsModel objectArrayWithKeyValuesArray:moModel.picUrls];
            [tempArray addObject:moModel];
        }
        status(YES,tempArray);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray arrayWithObject:error]);
    }];
    
}

@end
