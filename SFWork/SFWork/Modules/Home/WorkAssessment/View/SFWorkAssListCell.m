//
//  SFWorkAssListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFWorkAssListCell.h"

@interface SFWorkAssListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *depLabel;

@end

@implementation SFWorkAssListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFEmployeesModel *)model{
    _model = model;
    [self.iconImage setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:DefaultImage];
    self.nameLabel.text = model.name;
    self.depLabel.text = model.departmentName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
