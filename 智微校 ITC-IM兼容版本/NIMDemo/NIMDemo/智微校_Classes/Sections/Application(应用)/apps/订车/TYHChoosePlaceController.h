//
//  TYHChoosePlaceController.h
//  TYHxiaoxin
//
//  Created by hzth-mac3 on 5/27/16.
//  Copyright © 2016 Lanxum. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PlaceBlock)(NSString * palce);
@interface TYHChoosePlaceController : UITableViewController

@property (nonatomic, copy) PlaceBlock placeBlock;
@end
