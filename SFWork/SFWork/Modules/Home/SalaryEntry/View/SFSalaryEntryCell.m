//
//  SFSalaryEntryCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSalaryEntryCell.h"

@interface SFSalaryEntryCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;


@end

@implementation SFSalaryEntryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self)
    [[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)

        !self.selectClick?:self.selectClick(self.model);
    }];
}

- (void)setModel:(SFSalaryEntryModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.desLabel.text = model.destitle;
    self.sumLabel.text = model.calculate;
    self.selectButton.selected = model.isClick;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
