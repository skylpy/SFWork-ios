//
//  SFContactCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/15.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFContactCell.h"

@interface SFContactCell ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *deleteLayoutX;

@end

@implementation SFContactCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self)
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.deleteClick?:self.deleteClick(self.model);
    }];
}

- (void)setModel:(ClientLinkModel *)model{
    
    _model = model;
    self.titleLabel.text = model.name;
    self.phoneLabel.text = model.tel;
}

- (void)setIsHiden:(BOOL)isHiden{
    _isHiden = isHiden;
    self.deleteButton.hidden = isHiden;
    self.deleteLayoutX.constant = isHiden ? 0:15;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
