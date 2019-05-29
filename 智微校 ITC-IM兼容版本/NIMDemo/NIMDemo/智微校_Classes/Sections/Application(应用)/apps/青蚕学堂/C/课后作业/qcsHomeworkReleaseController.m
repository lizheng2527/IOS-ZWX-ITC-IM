//
//  qcsHomeworkReleaseController.m
//  NIM
//
//  Created by 中电和讯 on 2018/5/11.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "qcsHomeworkReleaseController.h"
#import "QCSchoolDefine.h"
#import "ETTextView.h"
#import <AVFoundation/AVFoundation.h>
#import "LGAudioKit.h"
#import <Photos/Photos.h>
#import "QCSNetHelper.h"
#import "NSString+NTES.h"

#import <TZImagePickerController.h>

#import "GYZCustomCalendarPickerView.h"

#import "qcsHomeworkChooseTypeController.h"
#import "ZXCollectionCell.h"
#import "qcsHomeworkObjectController.h"

#import "HVideoViewController.h"
#import "qcsHomeworkModel.h"
#import "lame.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import <TZImagePickerController/TZVideoPlayerController.h>
#import <TZImagePickerController/TZAssetModel.h>
#import <SDWebImageManager.h>
#import "ETTextView.h"


#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

@interface qcsHomeworkReleaseController ()<GYZCustomCalendarPickerViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ZXCollectionCellDelegate,TZImagePickerControllerDelegate>

@property(nonatomic,retain)NSMutableArray *itemArray;

@property (nonatomic, weak) NSTimer *timerOf60Second;
@end

@implementation qcsHomeworkReleaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"布置作业";
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    
    self.mainScrollview.backgroundColor = [UIColor QCSBackgroundColor];
    
    self.mainCollectionBGViewLayoutHeight.constant = 1;
    [self.chooseTimeButton setTitle:[QCSSourceHandler getDateToday] forState:UIControlStateNormal];
    
    _textView.placeholder = @"请输入作业内容";
    [self setUpCollectionView];
    
    [_saveRecordButton setImage:[UIImage imageNamed:@"second_sounding_d"] forState:UIControlStateNormal];
    [_saveRecordButton addTarget:self action:@selector(startRecordVoice) forControlEvents:UIControlEventTouchDown];
    [_saveRecordButton addTarget:self action:@selector(cancelRecordVoice) forControlEvents:UIControlEventTouchUpOutside];
    [_saveRecordButton addTarget:self action:@selector(confirmRecordVoice) forControlEvents:UIControlEventTouchUpInside];
    [_saveRecordButton addTarget:self action:@selector(updateCancelRecordVoice) forControlEvents:UIControlEventTouchDragExit];
    [_saveRecordButton addTarget:self action:@selector(updateContinueRecordVoice) forControlEvents:UIControlEventTouchDragEnter];
}



#pragma ButtonClickedActions
- (IBAction)chooseImageOrVideoAction:(id)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    

    [alertController addAction:[UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        HVideoViewController *ctrl = [[NSBundle mainBundle] loadNibNamed:@"HVideoViewController" owner:nil options:nil].lastObject;
        ctrl.HSeconds = 15;//设置可录制最长时间
        ctrl.takeBlock = ^(id item) {
            if ([item isKindOfClass:[NSURL class]]) {
                NSURL *videoURL = item;//视频url
                
                qcsHomeworkMediaModel *model = [[qcsHomeworkMediaModel alloc]init];
                model.URL = videoURL;
                model.type = @"Video";
                model.CoverImage = [QCSSourceHandler getCoverImageByVideoURL:videoURL];
                [self.itemArray addObject:model];
                
                [self ChangeCollectionViewHeight];
                
            } else {
                //图片
                if ([item isKindOfClass:[UIImage class]]) {
                    qcsHomeworkMediaModel *model = [[qcsHomeworkMediaModel alloc]init];
                    model.CoverImage = item;
                    model.type = @"Image";
                    [self.itemArray addObject:model];
                    [self ChangeCollectionViewHeight];
                }
            }
        };
        [self presentViewController:ctrl animated:YES completion:nil];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc]initWithMaxImagesCount:9 - _itemArray.count delegate:self];
        imagePicker.allowPickingGif = NO;
        imagePicker.isSelectOriginalPhoto = YES;
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            [photos enumerateObjectsUsingBlock:^(UIImage * obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                qcsHomeworkMediaModel *model = [[qcsHomeworkMediaModel alloc]init];
                model.CoverImage = obj;
                model.type = @"Image";
                [_itemArray addObject:model];
            }];
            [self ChangeCollectionViewHeight];
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        TZImagePickerController *imagePicker = [[TZImagePickerController alloc]initWithMaxImagesCount:9 - _itemArray.count delegate:self];
        imagePicker.isSelectOriginalPhoto = YES;
        imagePicker.allowPickingGif = NO;
        imagePicker.allowPickingVideo = YES;
        imagePicker.allowPickingMultipleVideo = YES;
        [imagePicker setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            [_itemArray addObjectsFromArray:photos];
            [self ChangeCollectionViewHeight];
            
        }];
        [self presentViewController:imagePicker animated:YES completion:nil];
        
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (IBAction)saveRecordAction:(id)sender {
    
//    [self startRecordVoice];
//    tempController *con = [tempController new];
//    [self.navigationController pushViewController:con animated:YES];
}


- (IBAction)chooseObjectAction:(id)sender {
    
    qcsHomeworkObjectController *oView = [qcsHomeworkObjectController new];
    oView.studentCourseArray = [NSMutableArray arrayWithArray:self.studentCourseArray];
    [self.navigationController pushViewController:oView animated:YES];
    
}

- (IBAction)chooseTypeAction:(id)sender {
    
    qcsHomeworkChooseTypeController *typeView = [qcsHomeworkChooseTypeController new];
    [self.navigationController pushViewController:typeView animated:YES];
    
}

- (IBAction)chooseTimeAction:(id)sender {
    GYZCustomCalendarPickerView *pickerView = [[GYZCustomCalendarPickerView alloc]initWithTitle:@"请选择日期"];
    pickerView.delegate = self;
    pickerView.calendarType = GregorianCalendar;//日期类型
    [pickerView show];
}

- (IBAction)uploadHomeworkAction:(id)sender {
    
    
    [SVProgressHUD showWithStatus:@"上传作业数据中"];
    
    QCSNetHelper *helper = [QCSNetHelper new];
    
    [helper uploadHomeworkWithPostdic:[self getPostDic] andItemSource:_itemArray andStatus:^(BOOL successful) {
        if (successful) {
            [SVProgressHUD dismiss];
            [self.view makeToast:@"发布作业完成" duration:1.5 position:CSToastPositionCenter];
        }else
        {
            [SVProgressHUD dismiss];
            [self.view makeToast:@"发布作业失败" duration:1.5 position:CSToastPositionCenter];
        }
        
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [self.view makeToast:@"发布作业失败" duration:1.5 position:CSToastPositionCenter];
    }];
    
}


-(NSMutableDictionary *)getPostDic
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSMutableDictionary *postDic = [NSMutableDictionary dictionary];
    
    
    [postDic setValue:_chooseClassID forKey:@"eclassIds"];
    [postDic setValue:_chooseTypeID forKey:@"kind"];
    [postDic setValue:_chooseCourseID forKey:@"dboCourse"];
    [postDic setValue:_chooseFinishTime forKey:@"dateEnd"];
    [postDic setValue:_textView.text.length?_textView.text:@"" forKey:@"content"];
    [postDic setValue:currentTimeString forKey:@"dateStart"];
    [postDic setValue:_chooseGradeID forKey:@"dboGrade"];
    

    return postDic;
}


#pragma QTCustomCalendarPickerViewDelegate
//接收日期选择器选项变化的通知
- (void)notifyNewCalendar:(IDJCalendar *)cal {
    NSString *result = @"";
    if ([cal isMemberOfClass:[IDJCalendar class]]) {//阳历
        
        NSString *year =[NSString stringWithFormat:@"%@",cal.year];
        NSString *month = [cal.month intValue] > 9 ? cal.month:[NSString stringWithFormat:@"0%@",cal.month];
        NSString *day = [cal.day intValue] > 9 ? cal.day:[NSString stringWithFormat:@"0%@",cal.day];
        result = [NSString stringWithFormat:@"%@-%@-%@",year,month, day];
        
    } else if ([cal isMemberOfClass:[IDJChineseCalendar class]]) {//阴历
        
        IDJChineseCalendar *_cal=(IDJChineseCalendar *)cal;
        
        NSArray *array=[_cal.month componentsSeparatedByString:@"-"];
        NSString *dateStr = @"";
        if ([[array objectAtIndex:0]isEqualToString:@"a"]) {
            dateStr = [NSString stringWithFormat:@"%@%@",dateStr,[_cal.chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1]];
        } else {
            dateStr = [NSString stringWithFormat:@"%@闰%@",dateStr,[_cal.chineseMonths objectAtIndex:[[array objectAtIndex:1]intValue]-1]];
        }
        result = [NSString stringWithFormat:@"%@%@",dateStr, [NSString stringWithFormat:@"%@", [_cal.chineseDays objectAtIndex:[_cal.day intValue]-1]]];
    }
    [self.chooseTimeButton setTitle:result forState:UIControlStateNormal];
    self.chooseFinishTime = result;
    
}


#pragma mark - CollectionView
- (void)setUpCollectionView {
    
    _itemArray = [NSMutableArray array];
    
    
    if (_preDetailModel) {
        
        
        NSMutableString *classString = [NSMutableString string];
        [_preDetailModel.homeworkEclassesModelArray enumerateObjectsUsingBlock:^(qcsHomeworkItemModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [classString appendFormat:@"%@,",obj.dboEclassName];
        }];
        
        self.textView.text = _preDetailModel.content;
        [self.chooseObjectButton setTitle:[NSString removeLastOneChar:[NSString stringWithFormat:@"%@",classString]] forState:UIControlStateNormal];
        [self.chooseTypeButton setTitle:_preDetailModel.kind forState:UIControlStateNormal];
        [self.chooseTimeButton setTitle:_preDetailModel.dateEnd forState:UIControlStateNormal];
        
        [_preDetailModel.attachmentVosModelArray enumerateObjectsUsingBlock:^(qcsHomeworkItemModel   *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            qcsHomeworkMediaModel *mediaModel = [qcsHomeworkMediaModel new];
            mediaModel.CoverImage =  [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[NSString stringWithFormat:@"%@%@",[QCSSourceHandler getImageBaseURL],obj.picUrl]];
            mediaModel.type = @"Image";
//            mediaModel.type = @"Video";
//            mediaModel.type = @"Audio";
            
            
            
            
            [_itemArray addObject:mediaModel];
        }];
    }
    
    self.view.backgroundColor = [UIColor QCSBackgroundColor];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    flowLayout.itemSize = CGSizeMake((SCREEN_WIDTH - 10) / 6, (SCREEN_WIDTH - 10) / 6);
    flowLayout.minimumInteritemSpacing=5; //cell之间左右的
    flowLayout.minimumLineSpacing=5;      //cell上下间隔
    flowLayout.sectionInset = UIEdgeInsetsMake(6, 0, 0, 0);
    
    _mainCollectionBGView.collectionViewLayout = flowLayout;
    _mainCollectionBGView.backgroundColor = [UIColor QCSBackgroundColor];
    _mainCollectionBGView.dataSource = self;
    _mainCollectionBGView.delegate = self;
    _mainCollectionBGView.bounces = NO;
    
    [_mainCollectionBGView registerClass:[ZXCollectionCell class] forCellWithReuseIdentifier:@"ZXCollectionCell"];
    
    [self ChangeCollectionViewHeight];
}


#pragma mark - Collection View Data Source
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _itemArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"ZXCollectionCell";
    ZXCollectionCell *cell = (ZXCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identify forIndexPath:indexPath];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    cell.delegate = self;
    cell.model = _itemArray[indexPath.row];
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    qcsHomeworkMediaModel *model = _itemArray[indexPath.row];
    
    if ([model.type isEqualToString:@"Image"]) {
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        NSMutableArray *photos = [NSMutableArray array];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = model.CoverImage;
        [photos addObject:photo];
        browser.photos = photos;
        browser.currentPhotoIndex = 0;
        [browser show];
    }
    else if([model.type isEqualToString:@"Video"]) {
        
//        PHAsset *asset = [[PHAsset alloc]init];
//        asset.sourceType = PHAssetMediaTypeVideo;
//
//
//
//        TZVideoPlayerController *vc = [[TZVideoPlayerController alloc] init];
//        TZAssetModel *model = [TZAssetModel modelWithAsset:asset type:TZAssetModelMediaTypeVideo timeLength:@""];
//        vc.model = model;
//        [self presentViewController:vc animated:YES completion:nil];
        
    }else if([model.type isEqualToString:@"Audio"]) {
        [self.view makeToast:@"开发中"];
    }
    
    
    
    
    
}


-(void)moveImageBtnClick:(ZXCollectionCell *)aCell
{
    [_itemArray removeLastObject];
    [_mainCollectionBGView reloadData];
    [self ChangeCollectionViewHeight];
}
-(void)showAlertController:(ZXCollectionCell *)aCell
{
    
}


#pragma mark - ChangeCollectionViewHeight
-(void)ChangeCollectionViewHeight
{
    if (_itemArray.count == 0) {
        self.mainCollectionBGViewLayoutHeight.constant = 1;
    }
    else if (_itemArray.count >= 1&& _itemArray.count <= 5) {
        self.mainCollectionBGViewLayoutHeight.constant = SCREEN_WIDTH / 6 + 5;
    }else if(_itemArray.count >= 6&& _itemArray.count <= 10)
    {
        self.mainCollectionBGViewLayoutHeight.constant = SCREEN_WIDTH / 6 * 2 + 10;
    }
    
    [_mainCollectionBGView reloadData];
}

//#pragma mark - CollectionView Layout
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize itemSize = CGSizeMake(75, 25);
//    return itemSize;
//
//}

#pragma mark - Private
-(void)viewWillAppear:(BOOL)animated
{
    

    
}


#pragma mark - Private Methods

/**
 *  开始录音
 */
- (void)startRecordVoice{
    

    __block BOOL isAllow = 0;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
        [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
            if (granted) {
                isAllow = 1;
            } else {
                isAllow = 0;
            }
        }];
    }
    if (isAllow) {
        //        //停止播放
        [[LGAudioPlayer sharePlayer] stopAudioPlayer];
        //        //开始录音
        [[LGSoundRecorder shareInstance] startSoundRecord:self.mainScrollview recordPath:[self recordPath]];
        //开启定时器
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        _timerOf60Second = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(sixtyTimeStopSendVodio) userInfo:nil repeats:YES];
    } else {
        
    }
}

/**
 *  录音结束
 */
- (void)confirmRecordVoice {
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 1.0f) {
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
        [self showShotTimeSign];
        return;
    }
    
    if ([[LGSoundRecorder shareInstance] soundRecordTime] < 61) {
        [self sendSound];
        [[LGSoundRecorder shareInstance] stopSoundRecord:self.mainScrollview];
    }
    if (_timerOf60Second) {
        [_timerOf60Second invalidate];
        _timerOf60Second = nil;
    }
}

/**
 *  更新录音显示状态,手指向上滑动后 提示松开取消录音
 */
- (void)updateCancelRecordVoice {
    [[LGSoundRecorder shareInstance] readyCancelSound];
}

/**
 *  更新录音状态,手指重新滑动到范围内,提示向上取消录音
 */
- (void)updateContinueRecordVoice {
    [[LGSoundRecorder shareInstance] resetNormalRecord];
}

/**
 *  取消录音
 */
- (void)cancelRecordVoice {
    [[LGSoundRecorder shareInstance] soundRecordFailed:self.mainScrollview];
}

/**
 *  录音时间短
 */
- (void)showShotTimeSign {
    [[LGSoundRecorder shareInstance] showShotTimeSign:self.mainScrollview];
}

- (void)sixtyTimeStopSendVodio {
    
    int countDown = 60 - [[LGSoundRecorder shareInstance] soundRecordTime];
    NSLog(@"countDown is %d soundRecordTime is %f",countDown,[[LGSoundRecorder shareInstance] soundRecordTime]);
    if (countDown <= 10) {
        [[LGSoundRecorder shareInstance] showCountdown:countDown - 1];
    }
    if ([[LGSoundRecorder shareInstance] soundRecordTime] >= 59 && [[LGSoundRecorder shareInstance] soundRecordTime] <= 60) {
        
        [_saveRecordButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        if (_timerOf60Second) {
            [_timerOf60Second invalidate];
            _timerOf60Second = nil;
        }
    }
}

/**
 *  语音文件存储路径
 *
 *  @return 路径
 */
- (NSString *)recordPath {
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"SoundFile"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    return filePath;
}

#pragma mark  显示录音
- (void)sendSound {
    
    qcsHomeworkMediaModel *messageModel = [[qcsHomeworkMediaModel alloc] init];
    messageModel.soundFilePath = [[LGSoundRecorder shareInstance] soundFilePath]; //caf文件路径
    messageModel.seconds = [[LGSoundRecorder shareInstance] soundRecordTime];
    messageModel.type = @"Audio";
    NSLog(@"recorder sound file path %@",messageModel.soundFilePath);

    //    self.messageModel.mp3FilePath = [self formatConversionToMp3];
    messageModel.mp3FilePath = [self audio_PCMtoMP3:messageModel.soundFilePath];
    [self.itemArray addObject:messageModel];
    
}


- (NSString*)audio_PCMtoMP3:(NSString *)path
{
    
    NSString *cafFilePath = path;    //caf文件路径
    
    NSString* fileName = [NSString stringWithFormat:@"/voice-%5.2f.mp3", [[NSDate date] timeIntervalSince1970] ];//存储mp3文件的路径
    
    NSString *mp3FileName = [[DocumentPath stringByAppendingPathComponent:@"SoundFile"] stringByAppendingPathComponent:fileName];
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FileName cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
    }

    return mp3FileName;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(UIImage*)imageFromSdcacheWithURL:(NSString *)url
{
    __block UIImage *thumbnailImage = [UIImage new];
    [[SDWebImageManager sharedManager]diskImageExistsForURL:[NSURL URLWithString:url] completion:^(BOOL isInCache) {
        if (isInCache) {
            thumbnailImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
        }
    }];
    return thumbnailImage;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
