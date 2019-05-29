//
//  RAErrorCollectionView.m
//  NIM
//
//  Created by 中电和讯 on 17/3/15.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RAErrorCollectionView.h"
#import "RAPlaceModel.h"
#import "TYHRepairDefine.h"

#define cellBtnTag 40000
#define cellID @"cellID"
@interface RAErrorCollectionView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) CGSize ItemSize;
@property (nonatomic, strong) NSMutableArray *buttonSourceArray;
@end

@implementation RAErrorCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewItemSize:(CGSize)itemSize withBtnArray:(NSArray *)buttonArray
{
    _ItemSize = itemSize;
    if (self = [super initWithFrame:frame collectionViewLayout:self.layout]) {
        //        [self setLayout:self.layout];
        _buttonSourceArray = [NSMutableArray arrayWithArray:buttonArray];
        self.bounces = NO;
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.delegate = self;
        self.dataSource = self;
        self.backgroundColor = [UIColor whiteColor];
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellID];
    }
    return self;
}

- (UICollectionViewFlowLayout *)layout {
    if (!_layout) {
        _layout = [[UICollectionViewFlowLayout alloc] init];
        _layout.itemSize = self.ItemSize;
        _layout.minimumLineSpacing = 3.0;
        _layout.minimumInteritemSpacing = 3.0;
//        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.sectionInset = UIEdgeInsetsMake(10, 5, 5, 5);
    }
    return _layout;
}


#pragma mark - UICollectionViewDelegate --- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.buttonSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; //
    
    RAErrorModel *model = _buttonSourceArray[indexPath.item];
//    if (indexPath.item == 0) {
//        model.name = @"这是一个很长的错误呢";
//    }
//    else if(indexPath.item == 1)
//    {
//        model.name = @"我是错误";
//    }
//    else if(indexPath.item == 2)
//    {
//        model.name = @"我真的不是错误";
//    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    if (!model.isClick) {
        button.backgroundColor = [UIColor RepairBGColor];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    else
    {
        button.backgroundColor = [UIColor TabBarColorRepair];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    button.titleLabel.font = [UIFont systemFontOfSize:13];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 10.0f;
    button.tag = cellBtnTag + indexPath.item;
    
    [button addTarget:self action:@selector(errorBtnAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
    CGRect buttonFrame = button.frame;
    
    NSString *content = model.name;
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = CGSizeMake(MAXFLOAT, 20.0f);
    CGSize buttonSize = [content boundingRectWithSize:size
                                              options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{ NSFontAttributeName:font}
                                              context:nil].size;
    
    CGSize itemSize = CGSizeMake(buttonSize.width + 10, 20);
    buttonFrame.size = itemSize;
    button.frame = buttonFrame;
    
//    button.frame = CGRectMake(locationBtnFrame.origin.x,
//                                           locationBtnFrame.origin.y,
//                                           theStringSize.width, locationBtnFrame.size.height);
    
    
    
    [button setTitle:model.name forState:UIControlStateNormal];
    [cell.contentView addSubview:button];
    
//    UIImageView *imageV = [[UIImageView alloc] initWithImage:_buttonSourceArray[indexPath.row]];
//    CGRect imageFrame = imageV.frame;
//    imageFrame.size = _ItemSize;
//    imageV.frame = imageFrame;
//    [cell.contentView addSubview:imageV];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"第%ld分区--第%ld个Item", indexPath.section, indexPath.row);
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RAErrorModel *model = _buttonSourceArray[indexPath.item];
//    if (indexPath.item == 0) {
//        model.name = @"这是一个很长的错误呢";
//    }
//    else if(indexPath.item == 1)
//    {
//        model.name = @"我是错误";
//    }
//    else if(indexPath.item == 2)
//    {
//        model.name = @"我真的不是错误";
//    }
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = CGSizeMake(MAXFLOAT, 20.0f);
    CGSize buttonSize = [model.name boundingRectWithSize:size
                                              options:NSStringDrawingTruncatesLastVisibleLine  | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:@{ NSFontAttributeName:font}
                                              context:nil].size;
    
    CGSize itemSize = CGSizeMake(buttonSize.width + 10, 20);

    return itemSize;
}


//-(void)errorBtnAction:(id)sender
//{
//    if (self.errorBtnDelegate && [self.errorBtnDelegate respondsToSelector:@selector(cellBtnDidClick:)]) {
//        [self.errorBtnDelegate cellBtnDidClick:_buttonSourceArray];
//    }
//}

- (void)errorBtnAction:(id)sender event:(id)event
{
//    UIButton *button = (UIButton *)sender;
    
    NSSet *touches =[event allTouches];
    UITouch *touch =[touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self];
    NSIndexPath *indexPath= [self indexPathForItemAtPoint:currentTouchPosition];
    if (indexPath!= nil)
    {
        RAErrorModel *model = _buttonSourceArray[indexPath.item];
        model.isClick = !model.isClick;
        // do something
        [self reloadData];
    }
}




-(CGSize) boundingRectWithSize:(NSString*) txt Font:(UIFont*) font Size:(CGSize) size{
    
    CGSize _size;
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    
    NSDictionary *attribute = @{NSFontAttributeName: font};
    
    NSStringDrawingOptions options = NSStringDrawingTruncatesLastVisibleLine |
    
    NSStringDrawingUsesLineFragmentOrigin |
    
    NSStringDrawingUsesFontLeading;
    _size = [txt boundingRectWithSize:size options: options attributes:attribute context:nil].size;
#else
    _size = [txt sizeWithFont:font constrainedToSize:size];
#endif
    return _size;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
