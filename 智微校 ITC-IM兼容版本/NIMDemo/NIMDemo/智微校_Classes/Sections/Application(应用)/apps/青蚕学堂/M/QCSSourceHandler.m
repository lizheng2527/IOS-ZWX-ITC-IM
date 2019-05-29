//
//  QCSSourceHandler.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/2.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "QCSSourceHandler.h"
#import "QCSMainModel.h"


#import <AVFoundation/AVFoundation.h>


//#import <Foundation/Foundation.h>
//#import <AssetsLibrary/AssetsLibrary.h>



@implementation QCSSourceHandler

+(NSMutableArray *)getMainItemSourceWithUserKind:(NSString *)userKind
{
    NSMutableArray *itemArray = [NSMutableArray array];
    
    if ([userKind isEqualToString:@"teacher"]) {
        
        QCSSourceModel *model1 =  [QCSSourceModel new];
        model1.itemTitle = @"云备课";
        model1.itemDescribition = @"云端备课 多端共享";
        model1.itemImageString = @"icon_1";
        [itemArray addObject:model1];
        
        QCSSourceModel *model2 =  [QCSSourceModel new];
        model2.itemTitle = @"课堂回顾";
        model2.itemDescribition = @"课堂详情 实时汇聚";
        model2.itemImageString = @"icon_2";
        [itemArray addObject:model2];
        
        QCSSourceModel *model3 =  [QCSSourceModel new];
        model3.itemTitle = @"课后作业";
        model3.itemDescribition = @"随堂作业 轻松发布";
        model3.itemImageString = @"icon_3";
        [itemArray addObject:model3];
        
        QCSSourceModel *model4 =  [QCSSourceModel new];
        model4.itemTitle = @"错题归档";
        model4.itemDescribition = @"智能归类 个性推送";
        model4.itemImageString = @"icon_4";
        [itemArray addObject:model4];
        
        QCSSourceModel *model5 =  [QCSSourceModel new];
        model5.itemTitle = @"学情分析";
        model5.itemDescribition = @"学情掌握 精准教学";
        model5.itemImageString = @"icon_5";
        [itemArray addObject:model5];
        
        QCSSourceModel *model6 =  [QCSSourceModel new];
        model6.itemTitle = @"微课资源";
        model6.itemDescribition = @"精品资源 共建共享";
        model6.itemImageString = @"icon_6";
        [itemArray addObject:model6];
    }
    else
    {
        QCSSourceModel *model1 =  [QCSSourceModel new];
        model1.itemTitle = @"课堂回顾";
        model1.itemDescribition = @"课堂详情 有效复习";
        model1.itemImageString = @"icon_2";
        [itemArray addObject:model1];
        
        
        QCSSourceModel *model3 =  [QCSSourceModel new];
        model3.itemTitle = @"课后作业";
        model3.itemDescribition = @"随堂作业 高效完成";
        model3.itemImageString = @"icon_3";
        [itemArray addObject:model3];
        
        QCSSourceModel *model4 =  [QCSSourceModel new];
        model4.itemTitle = @"错题归档";
        model4.itemDescribition = @"智能归类 强化训练";
        model4.itemImageString = @"icon_4";
        [itemArray addObject:model4];
        
        QCSSourceModel *model2 =  [QCSSourceModel new];
        model2.itemTitle = @"学情分析";
        model2.itemDescribition = @"学情同步  个性学习";
        model2.itemImageString = @"icon_5";
        [itemArray addObject:model2];
    }
    return itemArray;
    
}

+(NSMutableArray *)getCommonItemSource
{
    NSMutableArray *itemArray = [NSMutableArray array];
    
    QCSSourceModel *model1 =  [QCSSourceModel new];
    model1.itemTitle = @"每日推荐";
    model1.itemImageString = @"icon_9";
    [itemArray addObject:model1];
    
    QCSSourceModel *model2 =  [QCSSourceModel new];
    model2.itemTitle = @"家校小纸条";
    model2.itemImageString = @"icon_8";
    [itemArray addObject:model2];
    
    QCSSourceModel *model3 =  [QCSSourceModel new];
    model3.itemTitle = @"课外阅读";
    model3.itemImageString = @"icon_7";
    [itemArray addObject:model3];
    
    return itemArray;
}

+(NSString *)getImageBaseURL
{
    NSString *v3url = [[NSUserDefaults standardUserDefaults]valueForKey: USER_DEFAULT_QCXT_URL];
    NSArray *array =  [v3url componentsSeparatedByString:@"/dubbo-wisdomclass/"];
    NSString *trueURL = [NSString stringWithFormat:@"%@",array[0]];
    return trueURL;
}

+(NSString *)getSubjectBackgroundImageWithCourseName:(NSString *)courseName
{
    if ([courseName isEqualToString:@"语文"]) {
        return @"bg1";
    }
    else if ([courseName isEqualToString:@"数学"]) {
        return @"bg2";
    }
    else if ([courseName isEqualToString:@"英语"]) {
        return @"bg3";
    }
    else if ([courseName isEqualToString:@"政治"]) {
        return @"bg4";
    }
    else if ([courseName isEqualToString:@"历史"]) {
        return @"bg5";
    }
    else if ([courseName isEqualToString:@"地理"]) {
        return @"bg6";
    }
    else if ([courseName isEqualToString:@"物理"]) {
        return @"bg7";
    }
    else if ([courseName isEqualToString:@"化学"]) {
        return @"bg8";
    }
    else
        return @"bg9"; //生物
    
}

+(NSString *)getDateToday
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    
    return [NSString stringWithFormat:@"%@",dateString];
}

+(NSString *)getDateOneYearBefore
{
    
    NSDate *currentdata = [NSDate date];
    
    ///< NSCalendar -- 日历类，它提供了大部分的日期计算接口，并且允许您在NSDate和NSDateComponents之间转换
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    /*
     ///<  NSDateComponents：时间容器，一个包含了详细的年月日时分秒的容器。
     ///< 下例：获取指定日期的年，月，日
     NSDateComponents *comps = nil;
     comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:currentdata];
     NSLog(@"年 year = %ld",comps.year);
     NSLog(@"月 month = %ld",comps.month);
     NSLog(@"日 day = %ld",comps.day);*/
    
    
    NSDateComponents *datecomps = [[NSDateComponents alloc] init];
    [datecomps setYear:-1];
    [datecomps setMonth:0];
    [datecomps setDay:0];
    
    ///< dateByAddingComponents: 在参数date基础上，增加一个NSDateComponents类型的时间增量
    NSDate *calculatedate = [calendar dateByAddingComponents:datecomps toDate:currentdata options:0];
    
    ///< 打印推算时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *calculateStr = [formatter stringFromDate:calculatedate];
    
    return [NSString stringWithFormat:@"%@",calculateStr];
    
}


+(NSMutableArray *)getTreeArrayAfterDeal:(NSMutableArray *)needDealArray
{
    
    NSMutableArray *handleArray = [NSMutableArray array];
    handleArray = [self handleContactList:needDealArray];
    
    return handleArray;    
}




+ (NSMutableArray *)handleContactList:(NSMutableArray *)array;
{
    NSMutableArray *totalArray = [[NSMutableArray alloc] initWithCapacity:0];
    static NSUInteger indentation = 0;
    
    for (QCSMainResultGradeModel *dic in array) {
        JXZTreeMainModel *contactModel = [[JXZTreeMainModel alloc] init];
        contactModel.IndentationLevel = indentation;
        contactModel.contactId = dic.id;
        contactModel.name = dic.name;
        contactModel.parentId = dic.parentId;
        NSMutableArray *childsArray = dic.childrenEclassModelArray;
        if (childsArray && childsArray.count > 0) {
            contactModel.childs = [self addSubContact:childsArray withContactModel:contactModel andIndentation:indentation];
        }
        
        [totalArray addObject:contactModel];
    }
    return totalArray;
}

+ (NSMutableArray *)addSubContact:(NSMutableArray *)childsArray withContactModel:(JXZTreeMainModel *)model andIndentation:(NSUInteger)indentation
{
    indentation ++;
    model.childs = [[NSMutableArray alloc] initWithCapacity:0];
    for (QCSMainChildrenEclassModel *dic in childsArray) {
        NSString *parentId = dic.parentId;
        if ([model.contactId isEqualToString:parentId]) {
            JXZTreeMainModel *contactModel = [[JXZTreeMainModel alloc] init];
            contactModel.IndentationLevel = indentation;
            contactModel.contactId = dic.id;
            contactModel.parentMobileID = dic.idMobile;
            contactModel.name = dic.name;;
            contactModel.parentId = dic.parentId;
            [model.childs addObject:contactModel];

            
            NSMutableArray *subArray = dic.childrenCourseModelArray;
            if (subArray && subArray.count > 0) {
                contactModel.childs = [self addSubUserList:subArray withContactModel:contactModel andIndentation:indentation];
            }
            
            
//            NSMutableArray *userListArray = [dic objectForKey:@"userList"];
//            if (userListArray && userListArray.count >0) {
//                contactModel.userList = [self addSubUserList:userListArray withContactModel:contactModel andIndentation:indentation];
//            }
            
        }
    }
    return model.childs;
}


+ (NSMutableArray *)addSubUserList:(NSMutableArray *)userListArray withContactModel:(JXZTreeMainModel *)model andIndentation:(NSUInteger)indentation
{
    indentation ++;
    model.childs = [[NSMutableArray alloc] initWithCapacity:0];
    //    model.userList = [AssetListDetailsModel objectArrayWithKeyValuesArray:userListArray];
    for (QCSMainChildrenCourseModel *userDic in userListArray) {
        JXZTreeMainModel *userModel = [[JXZTreeMainModel alloc] init];
        userModel.parentMobileID = userDic.parentMobileID;
        userModel.IndentationLevel = indentation;
        userModel.contactId = userDic.id;
        userModel.name = userDic.name;
        [model.childs addObject:userModel];
    }
    return model.childs;
}




#pragma mark - 学情分析
+(NSMutableArray *)getStudyAnalyticsArrayClass
{
    NSMutableArray *itemArray = [NSMutableArray array];
    
    QCSSourceModel *modelAnalytic =  [QCSSourceModel new];
    modelAnalytic.itemTitle = @"课堂互动分析";
    modelAnalytic.isExpand = YES;
    modelAnalytic.level = @"0";
    modelAnalytic.typeNum = @"0";
    modelAnalytic.itemImageString = @"qcxt_icon_leftdrawer_lesson_kthdfx";
    [itemArray addObject:modelAnalytic];
    
    QCSSourceModel *modelAnalyticOf1 =  [QCSSourceModel new];
    modelAnalyticOf1.itemTitle = @"学生抢答";
    modelAnalyticOf1.isExpand = NO;
    modelAnalyticOf1.parentLevel = @"0";
    modelAnalyticOf1.level = @"1";
    modelAnalyticOf1.typeNum = @"1";
    [itemArray addObject:modelAnalyticOf1];
    
    QCSSourceModel *modelAnalyticOf2 =  [QCSSourceModel new];
    modelAnalyticOf2.itemTitle = @"学生自举";
    modelAnalyticOf2.isExpand = NO;
    modelAnalyticOf2.parentLevel = @"0";
    modelAnalyticOf2.typeNum = @"0";
    modelAnalyticOf2.level = @"1";
    [itemArray addObject:modelAnalyticOf2];
    
    QCSSourceModel *modelAnalyticOf3 =  [QCSSourceModel new];
    modelAnalyticOf3.itemTitle = @"课堂录屏";
    modelAnalyticOf3.isExpand = NO;
    modelAnalyticOf3.parentLevel = @"0";
    modelAnalyticOf3.typeNum = @"8";
    modelAnalyticOf3.level = @"1";
    [itemArray addObject:modelAnalyticOf3];
    
    QCSSourceModel *modelAnalyticOf4 =  [QCSSourceModel new];
    modelAnalyticOf4.itemTitle = @"随机选人";
    modelAnalyticOf4.isExpand = NO;
    modelAnalyticOf4.parentLevel = @"0";
    modelAnalyticOf4.typeNum = @"2";
    modelAnalyticOf4.level = @"1";
    [itemArray addObject:modelAnalyticOf4];
    
    QCSSourceModel *modelAnalyticOf5 =  [QCSSourceModel new];
    modelAnalyticOf5.itemTitle = @"选择统计";
    modelAnalyticOf5.isExpand = NO;
    modelAnalyticOf5.parentLevel = @"0";
    modelAnalyticOf5.typeNum = @"6";
    modelAnalyticOf5.level = @"1";
    [itemArray addObject:modelAnalyticOf5];
    
    QCSSourceModel *modelAnalyticOf6 =  [QCSSourceModel new];
    modelAnalyticOf6.itemTitle = @"学生手写";
    modelAnalyticOf6.isExpand = NO;
    modelAnalyticOf6.parentLevel = @"0";
    modelAnalyticOf6.typeNum = @"4";
    modelAnalyticOf6.level = @"1";
    [itemArray addObject:modelAnalyticOf6];
    
    
    QCSSourceModel *modelList =  [QCSSourceModel new];
    modelList.itemTitle = @"青蚕班级报表";
    modelList.isExpand = YES;
    modelList.level = @"0";
    modelList.typeNum = @"1";
    modelList.itemImageString = @"qcxt_icon_leftdrawer_lesson_qcbjbb";
    [itemArray addObject:modelList];
    
    QCSSourceModel *modelListOf1 =  [QCSSourceModel new];
    modelListOf1.itemTitle = @"抢答榜";
    modelListOf1.isExpand = NO;
    modelListOf1.parentLevel = @"1";
    modelListOf1.typeNum = @"1";
    modelListOf1.level = @"1";
    [itemArray addObject:modelListOf1];
    
    QCSSourceModel *modelListOf2 =  [QCSSourceModel new];
    modelListOf2.itemTitle = @"评价榜";
    modelListOf2.isExpand = NO;
    modelListOf2.parentLevel = @"1";
    modelListOf2.typeNum = @"3";
    modelListOf2.level = @"1";
    [itemArray addObject:modelListOf2];
    
    QCSSourceModel *modelListOf3 =  [QCSSourceModel new];
    modelListOf3.itemTitle = @"综合评价";
    modelListOf3.isExpand = NO;
    modelListOf3.parentLevel = @"1";
    modelListOf3.typeNum = @"100";
    modelListOf3.level = @"1";
    [itemArray addObject:modelListOf3];
    
    return itemArray;
}
+(NSMutableArray *)getStudyAnalyticsArrayStudent
{
    NSMutableArray *itemArray = [NSMutableArray array];
    
    QCSSourceModel *model1 =  [QCSSourceModel new];
    model1.itemTitle = @"抢答榜";
    model1.typeNum = @"1";
    model1.itemDescribition = @"qcxt_icon_leftdrawer_lesson_qd";
    [itemArray addObject:model1];
    
    QCSSourceModel *model2 =  [QCSSourceModel new];
    model2.itemTitle = @"选择题";
    model2.typeNum = @"6";
    model2.itemDescribition =@"qcxt_icon_leftdrawer_lesson_xz";
    [itemArray addObject:model2];
    
    QCSSourceModel *model3 =  [QCSSourceModel new];
    model3.itemTitle = @"评价榜";
    model3.typeNum = @"3";
    model3.itemDescribition =@"qcxt_icon_leftdrawer_lesson_pj";
    [itemArray addObject:model3];
    
    QCSSourceModel *model4 =  [QCSSourceModel new];
    model4.itemTitle = @"综合评价";
    model4.typeNum = @"100";
    model4.itemDescribition=@"qcxt_icon_leftdrawer_lesson_zhpj";
    [itemArray addObject:model4];
    
    return itemArray;
}

+(NSMutableArray *)getHomeworkChooseTypeArray
{
    NSMutableArray *itemArray = [NSMutableArray array];
    
    QCSSourceModel *model1 =  [QCSSourceModel new];
    model1.itemTitle = @"图片作业";
    model1.typeNum = @"0";
    model1.isExpand = NO;
    [itemArray addObject:model1];
    
    QCSSourceModel *model2 =  [QCSSourceModel new];
    model2.itemTitle = @"视频作业";
    model2.typeNum = @"1";
    model2.isExpand = NO;
    [itemArray addObject:model2];
    
    QCSSourceModel *model3 =  [QCSSourceModel new];
    model3.itemTitle = @"音频作业";
    model3.typeNum = @"2";
    model3.isExpand = NO;
    [itemArray addObject:model3];
    
    QCSSourceModel *model4 =  [QCSSourceModel new];
    model4.itemTitle = @"通知作业";
    model4.typeNum = @"3";
    model4.isExpand = NO;
    [itemArray addObject:model4];
    
    QCSSourceModel *model5 =  [QCSSourceModel new];
    model5.itemTitle = @"口述作业";
    model5.typeNum = @"4";
    model5.isExpand = NO;
    [itemArray addObject:model5];
    
    QCSSourceModel *model6 =  [QCSSourceModel new];
    model6.itemTitle = @"文本作业";
    model6.typeNum = @"5";
    model6.isExpand = NO;
    [itemArray addObject:model6];
    
    QCSSourceModel *model7 =  [QCSSourceModel new];
    model7.itemTitle = @"其他";
    model7.typeNum = @"6";
    model7.isExpand = NO;
    [itemArray addObject:model7];
    
    return itemArray;
}


+(UIImage *)getCoverImageByVideoURL:(NSURL *)url
{
    AVURLAsset *urlSet = [AVURLAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlSet];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    NSError *error = nil;
    CMTime time = CMTimeMake(0,30);//缩略图创建时间 CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要获取某一秒的第几帧可以使用CMTimeMake方法)
    CMTime actucalTime; //缩略图实际生成的时间
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:&actucalTime error:&error];
    if (error) {
        NSLog(@"截取视频图片失败:%@",error.localizedDescription);
    }
    CMTimeShow(actucalTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    if (image) {
        NSLog(@"视频截取成功");
    } else {
        NSLog(@"视频截取失败");
    }
    return image;
}

@end

@implementation QCSSourceModel

@end
