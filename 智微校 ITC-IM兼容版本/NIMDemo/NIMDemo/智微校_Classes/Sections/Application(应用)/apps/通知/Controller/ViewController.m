//
//  ViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/8/7.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupDemoViews];
}


- (void)setupDemoViews
{
    UILabel *label1 = [UILabel new];
    self.label1 = label1;
    
    
    UILabel *label2 = [UILabel new];
    self.label2 = label2;
    
    UILabel *label3 = [UILabel new];
    self.label3 = label3;
    
    
    UIButton *button1 = [UIButton new];
    self.button1 = button1;
    
    UITextView *textView1 = [UITextView new];
    self.textView1 = textView1;
    
    UITextView *textView2 = [UITextView new];
    self.textView2 = textView2;
    
    
    UITextView *textView3 = [UITextView new];
    self.textView3 = textView3;
    
    
//        UICollectionView * collectionView = [UICollectionView new];
//        collectionView.backgroundColor = [UIColor whiteColor];
//        self.collectionView = collectionView;
    
    UIImageView * imageView1 = [UIImageView new];
    imageView1.image = [UIImage imageNamed:@"分割线"];
    self.imageView1 = imageView1;
    
    UIImageView * imageView2 = [UIImageView new];
    imageView2.image = [UIImage imageNamed:@"分割线"];
    self.imageView2 = imageView2;
    
    UIImageView * imageView3 = [UIImageView new];
    imageView3.image = [UIImage imageNamed:@"分割线"];
    self.imageView3 = imageView3;
    
    UILabel *label4 = [UILabel new];
    self.label4 = label4;
    
    UILabel *label5 = [UILabel new];
    self.label5 = label5;
    
    UIButton *button2 = [UIButton new];
    self.button2 = button2;
    
    UIButton *button3 = [UIButton new];
    self.button3 = button3;
    
    UIButton *button4 = [UIButton new];
    self.button4 = button4;
    
    UIButton *button5 = [UIButton new];
    self.button5 = button5;
    UIButton *button6 = [UIButton new];
    self.button6 = button6;
    UIButton *button7 = [UIButton new];
    self.button7 = button7;
    UIButton *button8 = [UIButton new];
    self.button8 = button8;
    UIButton *button9 = [UIButton new];
    self.button9 = button9;
    UIButton *button10 = [UIButton new];
    self.button10 = button10;
    UIButton *button11 = [UIButton new];
    self.button11 = button11;
    UIButton *button12 = [UIButton new];
    self.button12 = button12;
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
//    flowLayout.itemSize = CGSizeMake(130, 130);
//    flowLayout.minimumInteritemSpacing = 0;
//    flowLayout.minimumLineSpacing = 10;
//    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.sectionInset = UIEdgeInsetsMake(10, 0, 0, 0);
//    
//    UICollectionView * collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
//    collectionView.scrollEnabled = NO;
//    self.collectionView = collectionView;
    
    
    UIWebView * webView = [[UIWebView alloc] init];
    self.webView = webView;
    
    UIView * view1 = [UIView new];
    view1.backgroundColor = [UIColor redColor];
    self.view1 = view1;
    
    [self.view addSubview:view1];
    
    [self.view addSubview:label1];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [self.view addSubview:label4];
    [self.view addSubview:label5];
    
    [self.view addSubview:textView1];
    [self.view addSubview:textView2];
    [self.view addSubview:textView3];
//    [self.view addSubview:self.collectionView];
    [self.view addSubview:webView];
    [self.view addSubview:imageView1];
    [self.view addSubview:imageView2];
    [self.view addSubview:imageView3];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
    [self.view addSubview:button4];
    [self.view addSubview:button5];
    [self.view addSubview:button6];
    [self.view addSubview:button7];
    [self.view addSubview:button8];
    [self.view addSubview:button9];
    [self.view addSubview:button10];
    [self.view addSubview:button11];
    [self.view addSubview:button12];
    
    
}


@end
