//
//  AssetDrawController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 16/9/20.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "AssetDrawController.h"
#import "PPSSignatureView.h"
#import "ImageHandller.h"
//#import <UIView+Toast.h>
@interface AssetDrawController ()

@end

@implementation AssetDrawController
{
    UIImage *drawImageNeedDeal;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initView];
}

-(void)initView
{
    _titleLabel.transform = CGAffineTransformMakeRotation( M_PI/2 );
    _backBtn.transform = CGAffineTransformMakeRotation( M_PI/2 );
    _clearBtn.transform = CGAffineTransformMakeRotation( M_PI/2 );
    _saveBtn.transform = CGAffineTransformMakeRotation( M_PI/2 );
//    
//    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    bgImgView.userInteractionEnabled = NO;
//    bgImgView.image = [UIImage imageNamed:@"paper"];
//    [_drawView addSubview:bgImgView];
//    [_drawView sendSubviewToBack:bgImgView];
//
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"paper"ofType:@"png"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    _drawView.layer.contents = (id)image.CGImage;
//    
}


#pragma mark -Actions

- (IBAction)clearDrawAction:(id)sender {
    [_drawView erase];
}

- (IBAction)saveDrawAction:(id)sender {
    [self dealImage];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(void)dealImage
{
    drawImageNeedDeal = [ImageHandller imageNeedDeal:_drawView.signatureImage rotation:UIImageOrientationLeft];
    if (self.type != 1) {
        drawImageNeedDeal = [ImageHandller imageNeedAddTextYiHaoPin:drawImageNeedDeal Test:@"#低值易耗品"];
    }
     else  drawImageNeedDeal = [ImageHandller imageNeedAddTextYiHaoPin:drawImageNeedDeal Test:@"#低值易耗品"];
    
    //临时注释,陈经纶不注释
//    drawImageNeedDeal = [ImageHandller addImage:drawImageNeedDeal addMsakImage:[UIImage imageNamed:@"logo_cjl"]];
    
    NSData *tmpImageData = UIImagePNGRepresentation(drawImageNeedDeal);
    [[NSUserDefaults standardUserDefaults]setObject:tmpImageData forKey:@"tmpImageDataa"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: YES];
    [[UIApplication sharedApplication] setStatusBarHidden:false];
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
