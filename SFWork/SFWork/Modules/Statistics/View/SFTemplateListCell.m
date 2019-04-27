//
//  SFTemplateListCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTemplateListCell.h"

@interface SFTemplateListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SFTemplateListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    
    self.iconImage.image = [UIImage imageNamed:dict[@"icon"]];
    self.titleLabel.text = dict[@"name"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
