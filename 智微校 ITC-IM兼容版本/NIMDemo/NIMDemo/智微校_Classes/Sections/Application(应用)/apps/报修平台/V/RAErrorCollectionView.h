//
//  RAErrorCollectionView.h
//  NIM
//
//  Created by 中电和讯 on 17/3/15.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol RAErrorCollectionViewDelegate <NSObject>
//@optional
//
//- (void)cellBtnDidClick:(NSMutableArray *)clickBtnIDArray;
//
//@end



@interface RAErrorCollectionView : UICollectionView
//@property(nonatomic,assign)id<RAErrorCollectionViewDelegate>errorBtnDelegate;

- (instancetype)initWithFrame:(CGRect)frame collectionViewItemSize:(CGSize)itemSize withBtnArray:(NSArray *)buttonArray;
@end
