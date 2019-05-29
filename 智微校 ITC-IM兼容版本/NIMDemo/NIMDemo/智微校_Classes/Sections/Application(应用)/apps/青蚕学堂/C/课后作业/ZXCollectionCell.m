//
//  ZXCollectionCell.m
//  ImageViewTest
//

#import "ZXCollectionCell.h"
#import "qcsHomeworkModel.h"


@implementation ZXCollectionCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        self.imgView.layer.masksToBounds = YES;
        self.imgView.layer.cornerRadius = 4.0f;
        [self addSubview:self.imgView];
        
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        self.imgView.userInteractionEnabled = YES;
        [self.imgView addGestureRecognizer:ges];
        
        _close  = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * image = [UIImage imageNamed:@"qcxt_delete"];
        [_close setImage:image forState:UIControlStateNormal];
        [_close setFrame:CGRectMake(self.frame.size.width-image.size.width, -3, image.size.width, image.size.height)];
        [_close sizeToFit];
        [_close addTarget:self action:@selector(closeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_close];
    }
    return self;
}




-(void)setModel:(qcsHomeworkMediaModel *)model
{
    
    if ([model.type isEqualToString:@"Image"]) {
        self.imgView.image = model.CoverImage;
    }
    else if([model.type isEqualToString:@"Video"])
    {
        self.imgView.image = model.CoverImage;
    }else if([model.type isEqualToString:@"Audio"])
    {
        self.imgView.image = [UIImage imageNamed:@"音频"];
    }
    
}

-(void)closeBtn:(UIButton *)sender{
    if (_delegate && [_delegate respondsToSelector:@selector(moveImageBtnClick:)]) {
        [_delegate moveImageBtnClick:self];
    }
}

-(void)tapAction:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(showAlertController:)]) {
        [_delegate showAlertController:self];
    }
}

@end
