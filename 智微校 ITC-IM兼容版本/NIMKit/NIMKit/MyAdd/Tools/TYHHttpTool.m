//
//  TYHHttpTool.m
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/10/20.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import "TYHHttpTool.h"
#import <NIMSDK/NIMSDK.h>

//#import "JPUSHService.h"

@implementation TYHHttpTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
//    NSString *sysToken =[[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_TOKEN"];
    
    NSMutableDictionary *haveDataSourceNameDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [haveDataSourceNameDic setValue:[self isBlankString:dataSourceName]?@"":dataSourceName forKey:@"dataSourceName"];
//    [haveDataSourceNameDic setValue:[self isBlankString:sysToken]?@"":sysToken forKey:@"sys_Token"];
    
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
//    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];

    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];

    // 2.发送请求
    [mgr GET:url parameters:haveDataSourceNameDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *string = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        if ([string hasPrefix:@"noToken"]) {
            
            [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error)
             {
                 extern NSString *TokenCheckFalse;
                 [[NSNotificationCenter defaultCenter] postNotificationName:TokenCheckFalse object:nil];
//                 [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"noTokenRequest"];
//                 [[NSUserDefaults standardUserDefaults]synchronize];
                 
                 extern NSString *NTESNotificationLogout;
                 [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
             }];
        }
        if (failure) {
            failure(error);
        }
    }];
    
}


+ (void)gets:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    
    NSMutableDictionary *haveDataSourceNameDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [haveDataSourceNameDic setValue:dataSourceName.length?dataSourceName:@"" forKey:@"dataSourceName"];
    
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //临时添加
    mgr.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    // 2.发送请求
    [mgr GET:url parameters:haveDataSourceNameDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *string = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
        if ([string hasPrefix:@"noToken"]) {
            
            [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error)
             {
                 extern NSString *NTESNotificationLogout;
                 [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"TokenCheckFalse" object:nil];
             }];
        }
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    
    NSMutableDictionary *haveDataSourceNameDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [haveDataSourceNameDic setValue:dataSourceName.length?dataSourceName:@"" forKey:@"dataSourceName"];
    
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    
    // 2.发送请求
    [mgr POST:url parameters:haveDataSourceNameDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
+ (void)posts:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure {
    
    NSString *dataSourceName = [[NSUserDefaults standardUserDefaults]valueForKey:@"USER_DEFAULT_DataSourceName"];
    NSMutableDictionary *haveDataSourceNameDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [haveDataSourceNameDic setValue:dataSourceName.length?dataSourceName:@"" forKey:@"dataSourceName"];
    
    // 1.创建请求管理者
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    
    [mgr.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    [mgr.responseSerializer setAcceptableStatusCodes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(200, 200)]];
    
    mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    // 2.发送请求
    [mgr POST:url parameters:haveDataSourceNameDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

- (void)downloadInferface:(NSString*)requestURL
          downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
          downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                 progress:(void (^)(float progress))progress {
    
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:nil error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(operation,error);
        NSLog(@"下载失败");
    }];
    
    [operation start];
}

+ (BOOL) isBlankString:(NSString *)string {
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

@end
