//
//  qcsClassDetailInsideXZTStudentCell.h
//  NIM
//
//  Created by 中电和讯 on 2018/4/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QCSMainStudentXZTJModel;


@interface qcsClassDetailInsideXZTStudentCell : UICollectionViewCell


@property (weak, nonatomic) IBOutlet UILabel *rightAnswerLabel;

@property (weak, nonatomic) IBOutlet UILabel *answerTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerStudentLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerRightPercentLabel;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property(nonatomic,retain)QCSMainStudentXZTJModel *model;
@end
