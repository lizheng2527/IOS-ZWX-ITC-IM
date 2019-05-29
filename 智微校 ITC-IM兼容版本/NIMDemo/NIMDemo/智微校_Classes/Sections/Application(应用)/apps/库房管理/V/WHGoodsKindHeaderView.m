//
//  WHGoodsKindHeaderView.m
//  NIM
//
//  Created by 中电和讯 on 2017/4/8.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "WHGoodsKindHeaderView.h"

#import "WHGoodsModel.h"

@interface WHGoodsKindHeaderView ()

@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end


@implementation WHGoodsKindHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        CGFloat w = [UIScreen mainScreen].bounds.size.width;
        
        self.arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"未展开"]];
        self.arrowImageView.frame = CGRectMake(16, 17, 6, 8);
        [self.contentView addSubview:self.arrowImageView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(onExpand:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        button.frame = CGRectMake(0, 0, w, 44);
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, w - 30, 44)];
        self.titleLabel.textColor = [UIColor blackColor];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLabel];
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(16, 44 - 0.5, w, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:line];
    }
    
    return self;
}

- (void)setModel:(WHGoodsKindModel *)model {
    if (_model != model) {
        _model = model;
    }
    
    if (!model.isExpanded) {
        self.arrowImageView.transform = CGAffineTransformIdentity;
    } else {
        self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    
    self.titleLabel.text = model.name;
    
    if (!model.nodesModelArray.count) {
        self.arrowImageView.hidden = YES;
        self.titleLabel.frame = CGRectMake(16, 0, 200, 44);
    }
}

- (void)onExpand:(UIButton *)sender {
    self.model.isExpanded = !self.model.isExpanded;
    
    [UIView animateWithDuration:0.25 animations:^{
        if (self.model.isExpanded) {
            self.arrowImageView.transform = CGAffineTransformIdentity;
        } else {
            self.arrowImageView.transform = CGAffineTransformMakeRotation(M_PI / 4);
        }
    }];
    
    if (self.expandCallback) {
        self.expandCallback(self.model.isExpanded);
    }
    
    if (!self.model.nodesModelArray.count) {
        [self.delegate likeRowCellClicker:self];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
