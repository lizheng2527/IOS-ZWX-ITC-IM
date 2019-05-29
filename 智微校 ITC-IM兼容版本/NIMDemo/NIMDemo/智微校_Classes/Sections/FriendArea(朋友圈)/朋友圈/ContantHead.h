//
//  ContantHead.h
//  WFCoretext
//
//  Created by 阿虎 on 14/10/29.
//  Copyright (c) 2014年 tigerwf. All rights reserved.
//

#ifndef WFCoretext_ContantHead_h
#define WFCoretext_ContantHead_h

typedef NS_ENUM(NSInteger, GestureType) {

    TapGesType = 1,
    LongGesType,

};

#define TableHeader 40
#define ShowImage_H 80
#define PlaceHolder @" "
#define offSet_X 20
#define EmotionItemPattern    @"\\[em:(\\d+):\\]"

#define kDistance 20 //说说和图片的间隔
#define kReplyBtnDistance 30 //回复按钮距离
#define kReply_FavourDistance 8 //回复按钮到点赞的距离
#define AttributedImageNameKey      @"ImageName"

#define screenWidth  [UIScreen mainScreen].bounds.size.width
#define screenHeight  [UIScreen mainScreen].bounds.size.height

#define limitline 4
#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4] //点击背景  颜色
#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]//点击姓名颜色

#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))

#define WS(weakSelf)  __weak __typeof(self)weakSelf = self;

#define kContentText1 @"来一发优秀的通宵"

#define kContentText2 @"可以可以"

#define kContentText3 @"Most people are so ungrateful to be alive. But not you. Not anymore. "

#define kContentText4 @"不通宵，毋宁死"

#define kContentText5 @"14124124"

#define kContentText6 @"123213"

#define kShuoshuoText1 @"555"

#define kShuoshuoText2 @"333"

#define kShuoshuoText3 @"3333"

#define kShuoshuoText4 @"人有的时候很脆弱，会遇到很多不如意18618881888的事，日积月累就会形成心结，就算想告诉亲戚朋友，他们也未必懂得怎样[em:03:]开解"

#define kShuoshuoText5 @"222222222"

#define kShuoshuoText6 @"111111111"

#endif
