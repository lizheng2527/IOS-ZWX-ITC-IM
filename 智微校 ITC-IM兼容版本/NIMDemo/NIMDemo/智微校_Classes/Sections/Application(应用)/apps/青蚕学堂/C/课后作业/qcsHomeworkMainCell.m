//
//  qcsHomeworkMainCell.m
//  NIM
//
//  Created by 中电和讯 on 2018/5/22.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsHomeworkMainCell.h"
#import "UIView+SDAutoLayout.h"
#import "qcsHomeworkModel.h"
#import "QCSchoolDefine.h"
#import "NSString+NTES.h"
#import <UIButton+WebCache.h>

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "TYHHttpTool.h"
#import "qcsHomeworkMainController.h"



#define TimeLineCellHighlightedColor [UIColor colorWithRed:92/255.0 green:140/255.0 blue:193/255.0 alpha:1.0]

const CGFloat contentLabelFontSize = 15;
CGFloat maxContentLabelHeight = 0; // 根据具体font而定




@implementation qcsHomeworkMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setup];
}

//- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self setup];
//
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//
//    }
//    return self;
//}



- (void)setup
{
    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:_subjectLabel.bounds byRoundingCorners:UIRectCornerTopRight|UIRectCornerBottomRight cornerRadii:CGSizeMake(6, 6)];
    CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
    maskLayer.frame=_subjectLabel.bounds;
    maskLayer.path=maskPath.CGPath;
    _subjectLabel.layer.mask=maskLayer;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.contentView.backgroundColor = [UIColor QCSBackgroundColor];
    self.backgroundColor = [UIColor QCSBackgroundColor];
}


-(void)setModel:(qcsHomeworkModel *)model
{
    _model = model;
    
    self.subjectLabel.text = model.dboCourseName;
    self.subjectLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[QCSSourceHandler getSubjectBackgroundImageWithCourseName:model.dboCourseName]]];
    
    self.titleTimeLabel.text = model.dateStart;
    
    NSMutableString *pushClassString  = [NSMutableString string];
    [model.homeworkEclassesModelArray enumerateObjectsUsingBlock:^(qcsHomeworkItemModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [pushClassString appendFormat:@"%@,",obj.dboEclassName];
    }];
    self.pushLabel.text = [NSString removeLastOneChar:pushClassString];
    
    self.finishTimeLabel.text = model.dateEnd;
    
    self.detailTexttLabel.text = model.content;
    
//    __block CGFloat width =
    
    __block CGFloat buttonWidth = (SCREEN_WIDTH - 25) / 6;
    
    if (model.attachmentVosModelArray.count == 0) {
        _sourceViewHeight.constant = 0;
    }else if (model.attachmentVosModelArray.count <= 5 ) {
        _sourceViewHeight.constant = buttonWidth + 8;
    }
    else
    {
        _sourceViewHeight.constant = buttonWidth * 2 + 16 + 8;
    }
    
    
    if ([model.content isEqualToString:@"没有附件的视频作业"]) {
        NSLog(@"yes");
    }
    
    if (model.attachmentVosModelArray.count) {
        [model.attachmentVosModelArray enumerateObjectsUsingBlock:^(qcsHomeworkItemModel  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [UIButton new];
            button.tag = 20001 + idx;
            if (idx <= 4) {
                button.frame = CGRectMake( idx * buttonWidth + 10 * idx  , 8, buttonWidth, buttonWidth);
            }
            else
            {
                button.frame = CGRectMake((idx % 5) * buttonWidth + 10 * (idx % 5)  , buttonWidth + 16, buttonWidth, buttonWidth);
            }

            
            if (!button.superview) {
                [_sourceContainerView addSubview:button];
            }
            button.backgroundColor = [UIColor orangeColor];
            
            NSArray *fileTypeArray = [obj.name componentsSeparatedByString:@"."];
            if (fileTypeArray.count) {
                NSString *typeString = fileTypeArray[1];
                if ([typeString isEqualToString:@"jpg"] || [typeString isEqualToString:@"png"] || [typeString isEqualToString:@"JPG"] || [typeString isEqualToString:@"PNG"]|| [typeString isEqualToString:@"gif"]  ) {
                    
                    
                    [button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],obj.picUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
                    
                }
                else if([typeString isEqualToString:@"MP4"]  || [typeString isEqualToString:@"mp4"] ||[typeString isEqualToString:@"flv"] ||  [typeString isEqualToString:@"FLV"] )
                {
                    [button sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_QCXT_URL],obj.picUrl]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"暂无图片Test"]];
                }
                
                else if([typeString isEqualToString:@"mp3"]  || [typeString isEqualToString:@"MP3"] )
                {
                    [button setImage:[UIImage imageNamed:@"音频"] forState:UIControlStateNormal];
                }
                [button addTarget:self action:@selector(SourceTapAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            
        }];
    }
    
    if (!model.attachmentVosModelArray.count) {
        _sourceContainerView.hidden = YES;
    }else _sourceContainerView.hidden = NO;
    
    
}



-(void)SourceTapAction:(id)sender
{
    UIButton *button =(UIButton *)sender;
    NSInteger idx = button.tag - 20001;
    qcsHomeworkItemModel *model = _model.attachmentVosModelArray[idx];
    
    NSArray *fileTypeArray = [model.name componentsSeparatedByString:@"."];
    if (fileTypeArray.count) {
        NSString *typeString = fileTypeArray[1];
        if ([typeString isEqualToString:@"jpg"] || [typeString isEqualToString:@"png"] || [typeString isEqualToString:@"JPG"] || [typeString isEqualToString:@"PNG"]|| [typeString isEqualToString:@"gif"] ) {
            
            MJPhotoBrowser *brower = [[MJPhotoBrowser alloc] init];
            NSMutableArray *photos = [NSMutableArray array];
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],model.downloadUrl]] ;
            [photos addObject:photo];
            brower.photos = photos;
            brower.currentPhotoIndex = 0;
            [brower show];
            
        }
//        else if([typeString isEqualToString:@"MP4"]  || [typeString isEqualToString:@"mp4"] ||[typeString isEqualToString:@"flv"] ||  [typeString isEqualToString:@"FLV"])
//        {
//            NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],model.downloadUrl]];
//
//            [self playVideoWithURL:videoURL];
//
//        }
        else
        {
            
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString * paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",model.id,model.name]];
            
            if (![fileManager fileExistsAtPath:paths])
            {
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定下载此项目吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    TYHHttpTool *tool = [[TYHHttpTool alloc]init];
                    [tool downloadInferface:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],model.downloadUrl] downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        NSData *data = (NSData *)responseObject;
                        [data writeToFile:paths atomically:YES];
                        
                    } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        [[self getViewController].view makeToast:@"下载失败" duration:1.5 position:CSToastPositionCenter];
                        
                    } progress:^(float progress) {
                        [SVProgressHUD showProgress:progress status:[NSString stringWithFormat:@"下载中:%f%%",progress]];
                        if (progress == 1) {
                            [SVProgressHUD dismiss];
                        }
                    }];
                    
                }]];
                 [[self getViewController] presentViewController:alertController animated:YES completion:nil];
                
            }else
            {
                
                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                NSURL *url = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
                
                NSURL *path = [url URLByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",model.id,model.name]];
                
                UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: path];
                
                    
                    interactionController.delegate = self;
                    [interactionController presentPreviewAnimated:YES];
                    CGRect navRect = [self getViewController].navigationController.navigationBar.frame;
                    navRect.size =CGSizeMake(1500.0f,40.0f);
                    //显示包含预览的菜单项
                    [interactionController presentOptionsMenuFromRect:navRect inView:[self getViewController].view animated:YES];
            }
        }
//        else if([typeString isEqualToString:@"mp3"]  || [typeString isEqualToString:@"MP3"] )
//        {
//
//        }
    }
    
}



- (IBAction)editAction:(id)sender {
    
    if (self.delegate &&  [self.delegate respondsToSelector:@selector(didClickEditButtonInCell:)]) {
        [self.delegate didClickEditButtonInCell:self];
    }
}
- (IBAction)delAction:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickDelButtonInCell:)]) {
        [self.delegate didClickDelButtonInCell:self];
    }
    
}


#pragma mark - Private
- (void)moreButtonClicked
{
    if (self.moreButtonClickedBlock) {
        self.moreButtonClickedBlock(self.indexPath);
    }
}

- (qcsHomeworkMainController*)getViewController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            //            return (issueViewController*)nextResponder;
            return (qcsHomeworkMainController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}


- (void)playVideoWithURL:(NSURL *)url
{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController showInWindow];
    }
    self.videoController.contentURL = url;
}


#pragma mark Document Interaction Controller Delegate Methods
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return [self getViewController];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
