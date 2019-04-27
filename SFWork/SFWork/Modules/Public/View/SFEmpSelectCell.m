//
//  SFEmpSelectCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFEmpSelectCell.h"

@interface SFEmpSelectCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@end

@implementation SFEmpSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self)
    [[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        self.model.isSelect = x.selected;
        !self.selectClick?:self.selectClick(self.model);
    }];
}

- (void)setModel:(SFEmployeesModel *)model{
    _model = model;
    [self.avatarImage setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"icon_rectangle_personal_green"]];
    self.nameLabel.text = model.name;
    self.selectButton.selected = model.isSelect;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
