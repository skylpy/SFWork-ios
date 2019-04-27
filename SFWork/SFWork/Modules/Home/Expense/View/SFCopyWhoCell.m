//
//  SFCopyWhoCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFCopyWhoCell.h"

@interface SFCopyWhoCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SFCopyWhoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.iconImage.layer.cornerRadius = 24;
    self.iconImage.clipsToBounds = YES;
    // Initialization code
}

- (void)setWhoModel:(ExpenseToWhoModel *)whoModel{
    _whoModel = whoModel;
    [self.iconImage setImageWithURL:[NSURL URLWithString:whoModel.employeeAvatar] placeholder:DefaultImage];
    self.titleLabel.text = whoModel.employeeName;
}

@end
