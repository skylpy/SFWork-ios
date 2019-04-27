//
//  SFDataProjectsCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFDataProjectsCell.h"

@interface SFDataProjectsCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

@implementation SFDataProjectsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(ItemsModel *)model{
    _model = model;
    self.titleLabel.text = model.name;
    self.contentLabel.text = [NSString stringWithFormat:@"%@ %@",model.target,model.unit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
