//
//  SFItemCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFItemCell.h"

@interface SFItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation SFItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization cod
    self.sendButton.layer.cornerRadius = 13;
    self.sendButton.clipsToBounds = YES;
    self.sendButton.layer.borderWidth = 1;
    self.sendButton.layer.borderColor = defaultColor.CGColor;
}

- (void)setModel:(ItemsModel *)model{
    _model = model;
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@：%@%@",model.name,model.value,model.unit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
