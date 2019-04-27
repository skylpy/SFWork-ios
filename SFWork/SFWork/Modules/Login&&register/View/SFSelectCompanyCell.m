//
//  SFSelectCompanyCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectCompanyCell.h"

@interface SFSelectCompanyCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@end

@implementation SFSelectCompanyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(BaseErrorModel *)model{
    _model = model;
    self.nameLabel.text = model.companyName;
    self.desLabel.text = model.msg;
    if (model.status) {
        self.nameLabel.textColor = Color(@"#333333");
        self.desLabel.textColor = Color(@"#666666");
    }else{
        self.nameLabel.textColor = Color(@"#999999");
        self.desLabel.textColor = Color(@"#999999");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
