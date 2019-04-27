//
//  SFExpCollectCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFExpCollectCell.h"

@interface SFExpCollectCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *nametextField;

@end
@implementation SFExpCollectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    RACChannelTo(self, self.model.detitle) = RACChannelTo(self.nametextField, text);
}

- (void)setModel:(SFApprpvalModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.nametextField.placeholder = model.placeholder;
    self.nametextField.text = model.detitle;
    self.nametextField.enabled = model.isClick ;
}

@end
