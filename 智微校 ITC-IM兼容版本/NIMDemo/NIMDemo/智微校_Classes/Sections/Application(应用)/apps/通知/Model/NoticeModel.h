//
//  NoticeModel.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 15/10/20.
//  Copyright © 2015年 Lanxum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttachmentModel.h"
@interface NoticeModel : NSObject

/*
 [
    {
     "id": "20150914165011676452038689163573",
     "sendUser": "administrator",
     "kind": "通知",
     "kindFlag": "1",
     "attentionFlag": "0", 未关注
     "readFlag": "1",  未读
     "title": "hhhhhhhhhhhhh",
     "content": "hhhhhhhhhhhhh发送人：adm",
     "time": "09月14日",
     "attachmentFlag": [
                         {
 
                         "id" = "20141024141401471721780344945079";
                         "url": "/component/attachment!download.action?checkUser=false&period=&downloadToken=201509141650071752168212803932186210e537ab7425ada8f8cd2430ccb36f",
                         "name": "1.jpg"
                         }
                       ]
 
 content = "nnn\U53d1\U81ea\U592a\U9633\U82b1\U6821\U4fe1\U5ba2\U6237\U7aef\U53d1\U9001\U4eba\Uff1a\U5218\U8389";
 id = 20160225171817439921489809134580;
 kind = no;
 readFlag = 1;
 sendTime = "2016-02-25 17:18:17";
 sendUser = "\U5218\U8389";
 sourceId = 20160225171817343239843295231190;
 time = "\U6628\U5929  17:18";
 title = "\U4e0d\U4e0d\U4e0d";
    }
 ]
 */

@property (nonatomic, strong) AttachmentModel * attachModel;
@property (nonatomic, copy) NSString * ID;
@property (nonatomic, copy) NSString * sendUser;
@property (nonatomic, copy) NSString * kind;
@property (nonatomic, copy) NSString * kindCode;
@property (nonatomic, copy) NSString * kindFlag;
@property (nonatomic, assign) BOOL attentionFlag;
//@property (nonatomic, assign) BOOL readFlag;
@property (nonatomic, copy) NSString *readFlag;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * content;
@property (nonatomic, copy) NSString * time;
@property (nonatomic, strong) NSArray * attachmentFlag;
@property (nonatomic, assign) BOOL isChecked;
@property(nonatomic,copy)NSString *url;
@property (nonatomic, copy) NSString * sendTime;
@property (nonatomic, copy) NSString * sourceId;
@property (nonatomic, copy) NSString * mobileUrl;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * iconImageName;

@property (nonatomic, copy) NSString * operationName;

//获取的图标
@property (nonatomic, copy) NSString * customIcon;
//获取的图标
@property (nonatomic, copy) NSString * appIcon;
//自定义图标
@property (nonatomic, copy) NSString * icon;

@end
