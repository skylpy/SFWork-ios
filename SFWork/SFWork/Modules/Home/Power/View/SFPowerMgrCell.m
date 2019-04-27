//
//  SFPowerMgrCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPowerMgrCell.h"

@interface SFPowerMgrCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation SFPowerMgrCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFPowerModel *)model{
    _model = model;
    
    self.titleLabel.text = model.title;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
