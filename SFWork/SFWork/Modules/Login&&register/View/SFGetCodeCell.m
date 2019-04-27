//
//  SFGetCodeCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/30.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFGetCodeCell.h"

@interface SFGetCodeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *valueTextField;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;

@end

@implementation SFGetCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.getCodeButton.layer.cornerRadius = 2;
    self.getCodeButton.clipsToBounds = YES;
    self.getCodeButton.layer.borderColor = defaultColor.CGColor;
    self.getCodeButton.layer.borderWidth = 1;
    self.valueTextField.keyboardType = UIKeyboardTypePhonePad;
    @weakify(self)
    [[self.getCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.getCodeClick?:self.getCodeClick(x);
    }];
}



- (void)setModel:(SFRegisterModel *)model{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.valueTextField.placeholder = model.placeholder;
    self.valueTextField.enabled = model.isClick;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
