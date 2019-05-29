//
//  MRSAddDetailCell.m
//  NIM
//
//  Created by 中电和讯 on 2017/4/5.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import "MRSAddDetailCell.h"
#import "NSString+NTES.h"
@class MRSAddModel;



@implementation MRSAddDetailCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    [self contentViewConfig];
}

-(void)contentViewConfig
{
    self.selectionStyle = NO;
    
    self.sumTextField.delegate = self;
    self.priceTextField.delegate = self;
    self.countTextField.delegate = self;
    self.nameTextField.delegate = self;
}


-(void)setModel:(MRSAddModel *)model
{
    self.priceTextField.text = model.price;
    self.countTextField.text = model.count;
    self.sumTextField.text = model.subtotal;
    self.nameTextField.text = model.name;
    
    self.innerModel = model;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if ([textField isEqual:self.nameTextField]) {
        self.innerModel.name = toBeString;
    }
    else if([textField isEqual:self.priceTextField])
    {
        self.innerModel.price = toBeString;
    }
    else if([textField isEqual:self.countTextField])
    {
        self.innerModel.count = toBeString;
    }
    
    if ([textField isEqual:self.priceTextField]) {
        if (![NSString isBlankString:self.countTextField.text]) {
            self.sumTextField.text = [NSString stringWithFormat:@"%.2f",[toBeString floatValue] * [self.countTextField.text floatValue]];
            self.innerModel.subtotal = self.sumTextField.text;
        }
    }
    else if([textField isEqual:self.countTextField])
    {
        if (![NSString isBlankString:self.priceTextField.text]) {
            self.sumTextField.text = [NSString stringWithFormat:@"%.2f",[toBeString floatValue] * [self.priceTextField.text floatValue]];
            self.innerModel.subtotal = self.sumTextField.text;
        }
    }
    else if([NSString isBlankString:self.priceTextField.text] || [NSString isBlankString:self.countTextField.text])
    {
        self.sumTextField.text = @"";
        self.innerModel.subtotal = @"";
    }
    //让tableview的footerview的值改变
    [self.delegate cellTextFieldValueChanged];
    return YES;
}


- (IBAction)closeAction:(id)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(closeBtnClick:)]) {
        [_delegate closeBtnClick:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation MRSAddModel

@end
