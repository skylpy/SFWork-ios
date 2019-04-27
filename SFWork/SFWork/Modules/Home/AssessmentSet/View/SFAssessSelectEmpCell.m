//
//  SFAssessSelectEmpCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessSelectEmpCell.h"

@interface SFAssessSelectEmpCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *empLabel;

@end

@implementation SFAssessSelectEmpCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFAssessmentSetModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.desLabel.text = model.destitle;
    self.empLabel.text = model.value;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
