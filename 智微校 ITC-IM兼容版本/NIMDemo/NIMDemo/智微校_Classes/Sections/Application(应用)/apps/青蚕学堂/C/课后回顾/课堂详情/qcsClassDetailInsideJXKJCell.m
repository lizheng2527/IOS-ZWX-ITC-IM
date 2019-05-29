//
//  qcsClassDetailInsideJXKJCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/4/9.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsClassDetailInsideJXKJCell.h"
#import "QCSchoolDefine.h"
#import "QCSClassDetailModel.h"


@implementation qcsClassDetailInsideJXKJCell

-(void)setModel:(QCSClassDetailJXKJModel *)model
{
    if (model.name.length) {
        NSArray *fileTypeArray = [model.name componentsSeparatedByString:@"."];
        self.imageView.image = [UIImage imageNamed:[self returnImageName:fileTypeArray[1]]];
    }
    
    self.titleLabel.text = model.name;
    self.sizeLabel.text = [NSString stringWithFormat:@"(%@)", [self transformedValue:model.size]];
    
}

- (id)transformedValue:(id)value
{
    
    double convertedValue = [value doubleValue];
    int multiplyFactor = 0;
    
    NSArray *tokens = @[@"bytes",@"KB",@"MB",@"GB",@"TB"];
    
    while (convertedValue > 1024) {
        convertedValue /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%4.2f %@",convertedValue, tokens[multiplyFactor]];
}

-(NSString *)returnImageName:(NSString *)fileType
{
    if ([fileType isEqualToString:@"doc"] || [fileType isEqualToString:@"docx"]) {
        return @"qc_word";
    }
    else if ([fileType isEqualToString:@"ppt"] || [fileType isEqualToString:@"pptx"]) {
        return @"qc_ppt";
    }
    else if ([fileType isEqualToString:@"mp4"] || [fileType isEqualToString:@"mov"]|| [fileType isEqualToString:@"flv"] || [fileType isEqualToString:@"avi"] || [fileType isEqualToString:@"swf"] || [fileType isEqualToString:@"mpg"]) {
        return @"视频";
    }
    else if ([fileType isEqualToString:@"jpg"] || [fileType isEqualToString:@"jpeg"]|| [fileType isEqualToString:@"gif"]|| [fileType isEqualToString:@"png"]) {
        return @"图片";
    }
    else if ([fileType isEqualToString:@"mp3"] || [fileType isEqualToString:@"wma"]) {
        return @"音频";
    }
    else return @"暂无图片Test";
}




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor QCSBackgroundColor];
}

@end
