//
//  SFAssessmentCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessmentCell.h"

@interface SFAssessmentCell ()
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UITextField *numberTextField;
@property (weak, nonatomic) IBOutlet UILabel *opertionLabel;
@property (weak, nonatomic) IBOutlet UITextField *soreTextField;

@end

@implementation SFAssessmentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    RACChannelTo(self, self.model.score) = RACChannelTo(self.soreTextField, text);
    RACChannelTo(self, self.model.value) = RACChannelTo(self.numberTextField, text);
    
    @weakify(self)
    [[self.numberTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)

        self.model.value = x;
        if (self.value <= [x integerValue]) {
            
            self.opertionLabel.text = @"加分";
            self.model.operator = @"PLUS";
        }else{
            self.opertionLabel.text = @"减分";
             self.model.operator = @"SUBTRACT";
        }
    }];
    
    [[self.soreTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.model.score = x;
    }];
}

- (void)cellWithValue:(NSInteger)value withModel:(RatingSettingModel *)model{
    _model = model;
    _value = value;
    self.soreTextField.text = model.score;
    self.numberTextField.text = model.value;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
