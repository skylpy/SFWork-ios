//
//  SFVerCodeCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/17.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVerCodeCell.h"

@interface SFVerCodeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;



@end

@implementation SFVerCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.getCodeButton.layer.cornerRadius = 2;
    self.getCodeButton.clipsToBounds = YES;
    self.getCodeButton.layer.borderColor =defaultColor.CGColor;
    self.getCodeButton.layer.borderWidth = 1;
    [self.getCodeButton setTitleColor:defaultColor forState:UIControlStateNormal];
    @weakify(self)
    [[self.getCodeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.getCodeClick?:self.getCodeClick(x);
    }];
    
    RACChannelTo(self, self.model.value) = RACChannelTo(self.textField, text);

    [[self.textField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.model.value = x;
    }];
}

- (void)setModel:(SFForGetModel *)model{
    _model = model;
    self.iconImage.image = [UIImage imageNamed:model.icon];
    self.textField.text = model.value;
    self.textField.enabled = model.isClick;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)sureButton:(UIButton *)sender {
}
@end
