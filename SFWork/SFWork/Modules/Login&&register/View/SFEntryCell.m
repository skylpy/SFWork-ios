//
//  SFEntryCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/17.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFEntryCell.h"

@interface SFEntryCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImage;

@end

@implementation SFEntryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    RACChannelTo(self, self.model.value) = RACChannelTo(self.textField, text);
    
    @weakify(self)
    [[self.textField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.model.value = x;
        if (self.model.type == 1) {
            if (x.length == 0) return ;
            if ([NSString valiMobile:x]) {
                self.desLabel.text = @"";
            }else{
                self.desLabel.text = @"请输入正确的手机号";
            }
        }
    }];
}

- (void)setModel:(SFForGetModel *)model{
    _model = model;
    
    self.iconImage.image = [UIImage imageNamed:model.icon];
    self.textField.text = model.value;
    self.textField.placeholder = model.placeholder;
    self.textField.enabled = model.isClick;
    
    if (model.type == 4) {
        self.arrowImage.hidden = NO;
    }else{
        self.arrowImage.hidden = YES;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
