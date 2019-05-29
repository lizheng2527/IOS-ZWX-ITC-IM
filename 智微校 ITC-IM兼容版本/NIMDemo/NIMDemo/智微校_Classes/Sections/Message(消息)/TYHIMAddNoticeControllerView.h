//
//  TYHIMAddNoticeControllerView.h
//  NIM
//
//  Created by 中电和讯 on 2019/2/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TYHIMAddNoticeControllerView : UIViewController

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;
@property(nonatomic,copy)NSString *token;
@property (nonatomic, assign) BOOL attentionFlag;


@end

NS_ASSUME_NONNULL_END
