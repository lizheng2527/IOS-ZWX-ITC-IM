//
//  HWNetWorkHandler.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/28.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "HWNetWorkHandler.h"
#import "TYHHttpTool.h"
#import "HWListModel.h"
#import "HWCourseModel.h"
#import <MJExtension.h>
#import "HWDetailModel.h"

@implementation HWNetWorkHandler{
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
    NSString *uploadImageNames;
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
    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    
//    uploadImageNames = @"image0.png,image1.png,image2.png,image3.png,image4.png,image5.png,image6.png,image7.png,image8.png";
//    
//    userName = @"0114020301901035";
//    password = @"000000";
//    userID = @"20131122180522362663861377060772";
}



//获取作业列表
- (void)getHomeWorkListWithPage:(NSInteger )page CourseID:(NSString *)courseID andStatus :(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
//    http://192.168.1.66:9998/dc-nlszy/il/homeWork!getStudentHomeWork.action?pageNo=1&studentId=20131122180522362663861377060772&courseId=&sys_username=0114020301901035&sys_password=000000&sys_auto_authenticate=true
    
    
    NSString *tempNum = [NSString stringWithFormat:@"%ld",(long)page];
    NSMutableArray *blcokArray = [NSMutableArray array];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/il/homeWork!getStudentHomeWork.action"];
    NSLog(@"%@",urlString);
    
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"studentId":userID,@"pageNo":tempNum,@"courseId":courseID};
    [TYHHttpTool get:urlString params:dic success:^(id json) {
        NSArray *modelArray = [HWListModel mj_objectArrayWithKeyValuesArray:json];
        for (HWListModel *homeworkListModel in modelArray) {
            [blcokArray addObject:homeworkListModel];
        }
        status(YES,blcokArray);
    } failure:^(NSError *error) {
        status(NO,nil);
    }];
}
//获取课程列表
-(void)getCourseListWithStudentID:(NSString *)studentID Status:(void (^)(BOOL,NSMutableArray *))status failure:(void(^)(NSError *))failure
{
    
    
    NSMutableArray *blcokArray = [NSMutableArray array];
    HWCourseModel *model = [[HWCourseModel alloc]init];
    model.courseName = @"选择全部";
    model.courseId = @"";
    [blcokArray addObject:model];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/il/homeWork!getCourseList.action"];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"studentId":userID,@"courseId":@""};
    
    [TYHHttpTool get:urlString params:dic success:^(id json) {
        NSArray *modelArray = [HWCourseModel mj_objectArrayWithKeyValuesArray:json];
        for (HWCourseModel *courseModel in modelArray) {
            [blcokArray addObject:courseModel];
        }
        status(YES,blcokArray);
    } failure:^(NSError *error) {
        status(NO,nil);
    }];
}

//获取作业详情
-(void)getCourseDetailWithHomeworkID:(NSString *)homeWorkID Status:(void (^)(BOOL,NSMutableArray *))status failure:(void(^)(NSError *))failure
{
    NSMutableArray *blcokArray = [NSMutableArray array];
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/il/homeWork!getHomeWorkDetail.action"];
    NSDictionary *dic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"studentWorkId":homeWorkID};
    
    [TYHHttpTool get:urlString params:dic success:^(id json) {
        
        HWDetailModel *model = [HWDetailModel mj_objectWithKeyValues:json];
        [blcokArray addObject:model];
        
        status(YES,blcokArray);
    } failure:^(NSError *error) {
        status(NO,nil);
    }];
    
}


#pragma mark - 发表作业（根据有无上传图片自动调用相应接口）
-(void)uploadHomeworkandContentWith:(NSString *)content tadID:(NSString *)tagId uploadFiles:(NSMutableArray *)uploadFiles andStatus:(void (^)(BOOL ,NSMutableArray *))status failure:(void (^)(NSError *error))failure
{
    NSString *uploadURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/il/homeWork!saveHomeWorkAnswer.action"];
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    params[@"sys_username"] = [NSString stringWithFormat:@"%@" ,userName];
    params[@"sys_auto_authenticate"]= @"true";
    params[@"dataSourceName"] = dataSourceName;
    params[@"sys_password"]= [NSString stringWithFormat:@"%@",password];
    params[@"content"] = content;
    params[@"studnetWorkId"] = tagId;
    
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString * str = [NSString stringWithFormat:@"%@",[formatter stringFromDate:[NSDate date]]];
    
    [uploadFiles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * str2 = [NSString stringWithFormat:@"uploadFileNames[%d]",(int)idx];
        params[str2] = [NSString stringWithFormat:@"%@%d.png",str,(int)idx];
    }];
    
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    ////    这个决定了下面responseObject返回的类型

        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        //    UIImage * image2;
        for (UIImage * image in uploadFiles) {
            //设置image的尺寸
            UIImage *imageNew = image;
            //设置image的尺寸
            CGSize imagesize = imageNew.size;
            imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
            NSData *imageData = UIImageJPEGRepresentation(imageNew,0.1);
            [imageDataArr addObject:imageData];
        }
        
        [manager POST:uploadURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            //           __block NSInteger imgCount = 0;
            
            [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = obj;
                NSString *fileName = [NSString stringWithFormat:@"%@%d.png",str,(int)idx];

                [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
            }];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {

            status(YES,responseObject);
            NSLog(@"responseObject :%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
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




@end
