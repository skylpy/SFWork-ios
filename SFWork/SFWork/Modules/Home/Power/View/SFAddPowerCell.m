//
//  SFAddPowerCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddPowerCell.h"

@interface SFAddPowerCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;

@end

@implementation SFAddPowerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFPowerModel *)model{
    
    _model = model;
    self.nameLabel.text = model.title;
    self.desLabel.text = model.placeholder;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
