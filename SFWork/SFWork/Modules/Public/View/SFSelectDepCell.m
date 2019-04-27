//
//  SFSelectDepCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectDepCell.h"

@interface SFSelectDepCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLayoutLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectLayoutW;

@end

@implementation SFSelectDepCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    @weakify(self)
    [[self.nextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.nextClick?:self.nextClick(self.model);
    }];
    
    [[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        self.model.isSelect = x.selected;
        !self.selectClick?:self.selectClick(self.model);
    }];
}

- (void)setModel:(SFOrgListModel *)model{
    
    _model = model;
    
    self.titleLabel.text = model.name;
    self.selectButton.selected = model.isSelect;
}

- (void)setType:(SelectDepType)type{
    _type = type;
    self.selectButton.hidden = type == singleDepType ? YES:NO;
    self.selectLayoutLeft.constant = type == singleDepType ? 5:15;
    self.selectLayoutW.constant =  type == singleDepType ? 0:20;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
