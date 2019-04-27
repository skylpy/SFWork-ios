//
//  SFPowerAssignCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/25.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPowerAssignCell.h"

@interface SFPowerAssignCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@end

@implementation SFPowerAssignCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


- (IBAction)chaneValue:(UISwitch *)sender {
    
    
}

- (void)setModel:(SFPowerModel *)model{
    
    _model = model;
    
    self.titleLabel.text = model.title;
    self.iconImage.image = [UIImage imageNamed:model.icon];
    self.switchButton.on = model.hasPermission;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
