//
//  SFDataReportCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFDataReportCell.h"

@interface SFDataReportCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *desTextField;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end

@implementation SFDataReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    RACChannelTo(self, self.model.value) = RACChannelTo(self.desTextField, text);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @weakify(self)
    [[self.desTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.model.value = x;
    }];
}

- (void)setModel:(ItemsModel *)model{
    _model = model;
    self.titleLabel.text = model.name;
    self.desTextField.text = model.value;
    self.unitLabel.text = model.unit;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
