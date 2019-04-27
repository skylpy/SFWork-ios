//
//  SFUserStatueCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFUserStatueCell.h"

@interface SFUserStatueCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;

@end

@implementation SFUserStatueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (IBAction)changeValue:(UISwitch *)sender {
    
    self.model.isClick = sender.on;
    !self.selectAllClick?:self.selectAllClick(sender.on);
}

- (void)setModel:(SFProfileModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.switchButton.on = model.isClick;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
