//
//  SFJournalSetCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFJournalSetCell.h"

@interface SFJournalSetCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UITextField *destextField;
@property (weak, nonatomic) IBOutlet UILabel *startLabel;

@end

@implementation SFJournalSetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SFJournalModel *)model{
    
    _model = model;
    self.titleLabel.text = model.title;
    self.destextField.text = model.destitle;
    self.destextField.placeholder = model.placeholder;
    self.startLabel.text = model.stars;
    self.titleLabel.textColor = Color(model.descolor);
    self.destextField.enabled = model.isClick;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
