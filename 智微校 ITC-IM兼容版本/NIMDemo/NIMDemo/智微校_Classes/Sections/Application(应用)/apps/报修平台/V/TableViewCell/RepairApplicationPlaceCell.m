//
//  RepairApplicationPlaceCell.m
//  NIM
//
//  Created by 中电和讯 on 17/3/15.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "RepairApplicationPlaceCell.h"
#import "RAPlaceModel.h"
#import "TYHRepairDefine.h"

@implementation RepairApplicationPlaceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self BtnConfig];
}



-(void)setPlaceArray:(NSMutableArray *)placeArray
{
    if (placeArray.count) {
            [self.chooseSchoolBtn setTitle:[placeArray[0] name]forState:UIControlStateNormal];
            //设置building
            if ([placeArray[0] buildingListModelArray].count) {
                [self.chooseBuildingBtn setTitle:[[placeArray[0] buildingListModelArray][0] name] forState:UIControlStateNormal];
                
                //设置floor
                if ([[placeArray[0] buildingListModelArray][0] floorListModelArray].count) {
                    [self.chooseFloorBtn setTitle:[[[placeArray[0] buildingListModelArray][0] floorListModelArray][0] name] forState:UIControlStateNormal];
                    //设置room
                    if ([[[placeArray[0] buildingListModelArray][0] floorListModelArray][0] roomListModelArray].count) {
                        [self.chooseRoomBtn setTitle:[[[[placeArray[0] buildingListModelArray][0] floorListModelArray][0] roomListModelArray][0] name] forState:UIControlStateNormal];
                    }
                    else
                    {
                        self.chooseRoomBtn.userInteractionEnabled = NO;
                    }
                }else
                {
                    self.chooseFloorBtn.userInteractionEnabled = NO;
                    self.chooseRoomBtn.userInteractionEnabled = NO;
                }
            }
            else {
                self.chooseBuildingBtn.userInteractionEnabled = NO;
                self.chooseFloorBtn.userInteractionEnabled = NO;
                self.chooseRoomBtn.userInteractionEnabled = NO;
            }
    }
}


#pragma mark - BtnClick

- (IBAction)chooseSchoolBtnClick:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(chooseSchool:)]) {
        [_delegate chooseSchool:self];
    }
}

- (IBAction)chooseBuildingBtnClick:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(chooseBuilding:)]) {
        [_delegate chooseBuilding:self];
    }
}
- (IBAction)chooseFloorBtnClick:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(chooseFloor:)]) {
        [_delegate chooseFloor:self];
    }
}

- (IBAction)chooseRoomBtnClick:(id)sender {
    if (self.delegate && [_delegate respondsToSelector:@selector(chooseClass:)]) {
        [_delegate chooseClass:self];
    }
}

#pragma mrak - BtnConfig
-(void)BtnConfig
{
    _chooseSchoolBtn.layer.masksToBounds = YES;
    _chooseSchoolBtn.layer.cornerRadius = 3.0f;
    _chooseSchoolBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _chooseSchoolBtn.layer.borderWidth = 0.5f;
    [_chooseSchoolBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
    _chooseBuildingBtn.layer.masksToBounds = YES;
    _chooseBuildingBtn.layer.cornerRadius = 3.0f;
    _chooseBuildingBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _chooseBuildingBtn.layer.borderWidth = 0.5f;
    [_chooseBuildingBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
    _chooseFloorBtn.layer.masksToBounds = YES;
    _chooseFloorBtn.layer.cornerRadius = 3.0f;
    _chooseFloorBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _chooseFloorBtn.layer.borderWidth = 0.5f;
    [_chooseFloorBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
    _chooseRoomBtn.layer.masksToBounds = YES;
    _chooseRoomBtn.layer.cornerRadius = 3.0f;
    _chooseRoomBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _chooseRoomBtn.layer.borderWidth = 0.5f;
    [_chooseRoomBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
