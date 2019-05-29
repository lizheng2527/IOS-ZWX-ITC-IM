//
//  MRSAddDetailCell.h
//  NIM
//
//  Created by 中电和讯 on 2017/4/5.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MRSAddDetailCell;
@class MRSAddModel;

@protocol MRSAddDetailCellDelegate <NSObject>
@optional
-(void)closeBtnClick:(MRSAddDetailCell *)cell;

-(void)cellTextFieldValueChanged;
@end

@interface MRSAddDetailCell : UITableViewCell<UITextFieldDelegate>
@property(nonatomic,assign)id<MRSAddDetailCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;
@property (weak, nonatomic) IBOutlet UITextField *countTextField;
@property (weak, nonatomic) IBOutlet UITextField *sumTextField;

@property(nonatomic,retain)MRSAddModel *model;
@property(nonatomic,retain)MRSAddModel *innerModel;
@end

//添加的model列表
@interface MRSAddModel : NSObject
@property(nonatomic,copy)NSString *count;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *subtotal;

@property(nonatomic,assign)NSInteger index;
@end
