//
//  SFSelectEmpCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/30.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectEmployCell.h"

@interface SFSelectEmployCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end
@implementation SFSelectEmployCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
