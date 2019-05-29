//
//  AssetDiliverFooterView.h
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/5.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AssetFooterViewDelegate <NSObject>

@required
-(void)changeBtnImageChoose;
-(void)changeBtnImageUnChoose;

@end

@interface AssetDiliverFooterView : UIView
@property(nonatomic,assign)UIButton *leftBtn;
@property(nonatomic,retain)UILabel *leftLabel;

@property(nonatomic,assign)UIButton *rightBtn;
@property(nonatomic,retain)UILabel *rightLabel;

@property(nonatomic,assign)UIButton *addPicBtn;
@property(nonatomic,retain)UIView *mainView;

@property (nonatomic,assign) id<AssetFooterViewDelegate> delegate;
@end
