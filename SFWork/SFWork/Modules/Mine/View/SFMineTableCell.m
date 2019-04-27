//
//  SFMineTableCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFMineTableCell.h"

@implementation SFMineTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFMineModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.iconImage.image = [UIImage imageNamed:model.icon];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
