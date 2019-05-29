//
//  qcsClassDetailInsideXZTCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/9.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QCSClassDetailXZTModel;
@class qcsClassDetailInsideXZTCell;


@protocol qcsClassDetailInsideXZTCellDelegate <NSObject>

@optional

- (void)ImageViewClicked:(qcsClassDetailInsideXZTCell *)cell;

- (void)DetailBtnClicked:(qcsClassDetailInsideXZTCell *)cell;

@end


@interface qcsClassDetailInsideXZTCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *rightAnswerLabel;

@property (weak, nonatomic) IBOutlet UILabel *answerOneChooseLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerOneStudentLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerTwoChooseLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerTwoStudentLabel;

@property (weak, nonatomic) IBOutlet UIButton *detailButton;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property(nonatomic,retain)QCSClassDetailXZTModel *model;


@property(nonatomic,assign)id<qcsClassDetailInsideXZTCellDelegate>delegate;
@end
