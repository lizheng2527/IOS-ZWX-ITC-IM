//
//  RecordNetHelper.m
//  NIM
//
//  Created by 中电和讯 on 2017/11/30.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RecordNetHelper.h"
#import <MJExtension.h>
#import "TYHHttpTool.h"
#import "RecordModel.h"
#import "ACMediaModel.h"


//#define k_V3ServerURL @"http://192.168.1.20:8080/dc-base"


@implementation RecordNetHelper
{
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
    NSString *dataSourceName;
    NSDictionary *userInfoDic;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        [self getNeedData];
    }
    return self;
}

#pragma mark - 获取用户基础数据
-(void)getNeedData
{
    userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_DataSourceName];
    dataSourceName = dataSourceName.length?dataSourceName:@"";
    
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_USERID];
    userInfoDic = @{@"sys_auto_authenticate":@"true",@"sys_username":[NSString stringWithFormat:@"%@",userName],@"sys_password":password,@"dataSourceName":dataSourceName};
}


#pragma mark - 方法
#pragma mark - 获取我的工作日志列表
-(void)getMyRecordListWithDate:(NSString *)Date andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/logwork!getAllWorkLogByDate.action"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [dic setValue:userID forKey:@"userId"];
    [dic setValue:Date.length?Date:dateString forKey:@"date"];
    
    [TYHHttpTool get:requestURL params:dic success:^(id json) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:[RecordModel mj_objectArrayWithKeyValuesArray:json]];
        for (RecordModel *model in array) {
            model.attachmentListModelArray = [NSMutableArray arrayWithArray:[RecordattachmentModel mj_objectArrayWithKeyValuesArray:model.attachmentList]];
        }
        status(YES,array);
    } failure:^(NSError *error) {
        status(NO,[NSMutableArray array]);
    }];
}

//提交工作日志
-(void)saveWorkLogWithUserDic:(NSMutableDictionary *)dic UploadImageArray:(NSMutableArray *)imageArray andStatus:(void (^)(BOOL successful,NSMutableArray  *dataSource))status failure:(void (^)(NSError *error))failure
{
    
//    userId    20160702182427668420778801064131
//    remark    开始备注
//    sys_password    e10adc3949ba59abbe56e057f20f883e
//    date    2017-12-14
//    sys_Token    538ebb57048e09590d0666b3a520285d
//    plan    开始计划
//    sys_username    gaoyacun
//    summarize    开始总结
//    dataSourceName    SCHOOL_CONTEXT_DEFAULT
//    sys_auto_authenticate    true
    
    
    NSString *requestURL = [NSString stringWithFormat:@"%@%@",k_V3ServerURL,@"/bd/logwork!saveWorkLog.action"];
    NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:userInfoDic];
    [requestDic setValue:userID forKey:@"userId"];
    [requestDic addEntriesFromDictionary:dic];
    
    if (!imageArray.count) {
//        requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,@"/bd/logwork!saveWorkLog.action",userName,password,dataSourceName];
        
        [TYHHttpTool gets:requestURL params:requestDic success:^(id json) {
            
            NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            NSMutableArray *array = [NSMutableArray array];
            
            if ([string isEqualToString:@"true"] || [string isEqualToString:@"success"] || [string isEqualToString:@"ok"]) {
                [array addObject:@"提交成功"];
                status(YES,array);
            }
            else
            {
                [array addObject:@"提交失败"];
                status(NO,array);
            }
            
        } failure:^(NSError *error) {
            NSMutableArray *array = [NSMutableArray arrayWithObject:@"提交失败"];
            status(NO,array);
        }];
    }
    else
    {
        
        requestURL = [NSString stringWithFormat:@"%@%@?sys_username=%@&sys_password=%@&sys_auto_authenticate=true&dataSourceName=%@",k_V3ServerURL,@"/bd/logwork!saveWorkLog.action",userName,password,dataSourceName];
        
        NSMutableArray  *imageDataArr = [NSMutableArray array];
        [imageArray enumerateObjectsUsingBlock:^(ACMediaModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //            [dic setValue:obj.name forKey:@"uploadFileNames"];
            
            NSString * str2 = [NSString stringWithFormat:@"uploadFileNames[%d]",(int)idx];
            requestDic[str2] = [NSString stringWithFormat:@"%@",obj.name];
            
            
            UIImage *imageNew = obj.image;
            //设置image的尺寸
            CGSize imagesize = imageNew.size;
            imageNew = [self imageCompressForWidth:imageNew targetWidth:imagesize.width];
            NSData *imageData = UIImageJPEGRepresentation(imageNew,0.7);
            [imageDataArr addObject:imageData];
        }];
        
        
        AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
        ////    这个决定了下面responseObject返回的类型
        
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager POST:requestURL parameters:requestDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
            //           __block NSInteger imgCount = 0;
            
            [imageDataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSData *imageData = obj;
                NSString *fileName = [NSString stringWithFormat:@"%@",[(ACMediaModel *)imageArray[idx] name]];
                [formData appendPartWithFileData:imageData name:@"uploadFiles" fileName:fileName mimeType:@"image/png"];
            }];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSString * data = [[NSString  alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if ([data isEqualToString:@"ok"] || [data isEqualToString:@"success"] || [data isEqualToString:@"true"]) {
                status(YES,responseObject);
            }
            else status(NO,responseObject);
            NSLog(@"responseObject :%@",responseObject);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            status(NO,[NSMutableArray array]);
        }];
    }
}



#pragma mark - ImageHandler

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
