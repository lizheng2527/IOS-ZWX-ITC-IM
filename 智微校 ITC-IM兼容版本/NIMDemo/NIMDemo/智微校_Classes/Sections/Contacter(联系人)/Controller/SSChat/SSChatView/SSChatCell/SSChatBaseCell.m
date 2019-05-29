//
//  SSChatBaseCell.m
//  SSChatView
//
//  Created by soldoros on 2018/10/9.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "SSChatBaseCell.h"
#import <UIButton+WebCache.h>

@implementation SSChatBaseCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // Remove touch delay for iOS 7
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)view).delaysContentTouches = NO;
                break;
            }
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = SSChatCellColor;
        self.contentView.backgroundColor = SSChatCellColor;
        [self initSSChatCellUserInterface];
    }
    return self;
}


-(void)initSSChatCellUserInterface{
    
    
    // 2、创建头像
    _mHeaderImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _mHeaderImgBtn.backgroundColor =  [UIColor brownColor];
    _mHeaderImgBtn.tag = 10;
    _mHeaderImgBtn.userInteractionEnabled = YES;
    [self.contentView addSubview:_mHeaderImgBtn];
    _mHeaderImgBtn.clipsToBounds = YES;
    [_mHeaderImgBtn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //创建时间
    _mMessageTimeLab = [UILabel new];
    _mMessageTimeLab.bounds = CGRectMake(0, 0, SSChatTimeWidth, SSChatTimeHeight);
    _mMessageTimeLab.top = SSChatTimeTop;
    _mMessageTimeLab.centerX = SCREEN_Width*0.5;
    [self.contentView addSubview:_mMessageTimeLab];
    _mMessageTimeLab.textAlignment = NSTextAlignmentCenter;
    _mMessageTimeLab.font = [UIFont systemFontOfSize:SSChatTimeFont];
    _mMessageTimeLab.textColor = [UIColor whiteColor];
    _mMessageTimeLab.backgroundColor = makeColorRgb(220, 220, 220);
    _mMessageTimeLab.clipsToBounds = YES;
    _mMessageTimeLab.layer.cornerRadius = 3;
    
    
    //背景按钮
    _mBackImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _mBackImgButton.backgroundColor =  [SSChatCellColor colorWithAlphaComponent:0.4];
    _mBackImgButton.tag = 50;
    [self.contentView addSubview:_mBackImgButton];
    [_mBackImgButton addTarget:self action:@selector(backPressed:) forControlEvents:UIControlEventTouchUpInside];
    

}


-(BOOL)canBecomeFirstResponder{
    return YES;
}


-(void)setLayout:(SSChatMessagelLayout *)layout{
    _layout = layout;
    
    _mMessageTimeLab.hidden = !layout.message.showTime;
    _mMessageTimeLab.text = layout.message.messageTime;
    [_mMessageTimeLab sizeToFit];
    _mMessageTimeLab.height = SSChatTimeHeight;
    _mMessageTimeLab.width += 20;
    _mMessageTimeLab.centerX = SCREEN_Width*0.5;
    _mMessageTimeLab.top = SSChatTimeTop;
    
    
    self.mHeaderImgBtn.frame = layout.headerImgRect;
    
    //头像
     if(_layout.message.messageFrom == SSChatMessageFromMe){
//    [self.mHeaderImgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",layout.message.headerImgurl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Identifier"]];
         
         UIImage *image = [UIImage imageWithData:[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_HEADIMAGE_DATA]];
         if (!image) {
             image = [UIImage imageNamed:@"mk-photo"];
         }
         
         [self.mHeaderImgBtn setBackgroundImage:image forState:UIControlStateNormal];
     }
    
    
    self.mHeaderImgBtn.layer.cornerRadius = self.mHeaderImgBtn.height*0.5;
    if(_layout.message.messageFrom == SSChatMessageFromOther){
//        头像
        [self.mHeaderImgBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",layout.message.headerImgurl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mk-photo"]];
    }

}

-(void)prepareForReuse
{
    [super prepareForReuse];
        [self.mHeaderImgBtn sd_cancelImageLoadForState:UIControlStateNormal];
        [self.mHeaderImgBtn setBackgroundImage:nil forState:UIControlStateNormal];
}

//消息按钮
-(void)buttonPressed:(UIButton *)sender{
    
    if (self.delegate && [_delegate respondsToSelector:@selector(SSChatHeaderImgCellClick:indexPath:)]) {
        [_delegate SSChatHeaderImgCellClick:0 indexPath:_indexPath];
    }
}

-(void)backPressed:(UIButton *)sender
{
    [self becomeFirstResponder];
    self.mBackImgButton.highlighted = YES;
    
    UIMenuItem* copy =
    [[UIMenuItem alloc] initWithTitle:@"复制"
                               action:@selector(menuCopy:)];
    UIMenuItem* remove =
    [[UIMenuItem alloc] initWithTitle:@"删除"
                               action:@selector(menuRemove:)];
    
    UIMenuController* menu = [UIMenuController sharedMenuController];
    [menu setMenuItems:@[ copy, remove ]];
    [menu setTargetRect:self.mBackImgButton.frame inView:self];
    [menu setMenuVisible:YES animated:YES];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(UIMenuControllerWillHideMenu)
     name:UIMenuControllerWillHideMenuNotification
     object:nil];
    
}

- (void)UIMenuControllerWillHideMenu
{
    self.mBackImgButton.highlighted = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return (action == @selector(menuCopy:) || action == @selector(menuRemove:));
}

- (void)menuCopy:(id)sender
{
    [UIPasteboard generalPasteboard].string = self.mTextView.text;
}

- (void)menuRemove:(id)sender
{
}


@end
