//
//  SFSetTypeCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSetTypeCell.h"

@interface SFSetTypeCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *edirtButton;

@end
@implementation SFSetTypeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.deleteButton.layer.cornerRadius = 2;
    self.deleteButton.clipsToBounds = YES;
    
    self.edirtButton.layer.cornerRadius = 2;
    self.edirtButton.clipsToBounds = YES;
    
    @weakify(self)
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.deleteClick?:self.deleteClick(self.model);
    }];
    [[self.edirtButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.updateClick?:self.updateClick(self.model);
    }];
}

- (void)setModel:(SFSetTypeModel *)model{
    _model = model;
    self.titleLabel.text = model.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
