//
//  SFHomeCollectionCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFHomeCollectionCell.h"

@implementation SFHomeCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(SFHomeModel *)model{
    _model = model;
    self.iconImage.image = [UIImage imageNamed:model.icon];
    self.titleLabel.text = model.title;
}

@end
