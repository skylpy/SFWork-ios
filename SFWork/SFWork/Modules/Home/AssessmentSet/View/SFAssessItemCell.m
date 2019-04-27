//
//  SFAssessItemCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/19.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAssessItemCell.h"

@interface SFAssessItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentTextField;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (nonatomic, assign) NSInteger score;

@end

@implementation SFAssessItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectView.layer.cornerRadius = 3;
    self.selectView.clipsToBounds = YES;
    self.selectView.layer.borderWidth = 1;
    self.selectView.layer.borderColor = Color(@"#D8D8D8").CGColor;
    self.leftView.backgroundColor = Color(@"#D8D8D8");
    self.rightView.backgroundColor = Color(@"#D8D8D8");
    
    RACChannelTo(self, self.model.score) = RACChannelTo(self.contentTextField, text);
    @weakify(self)
    [[self.contentTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.model.score = x;
    }];
    
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        if (self.score < 10000) {
            self.score ++;
            self.contentTextField.text = [NSString stringWithFormat:@"%ld",self.score];
        }
        
    }];
    [[self.reduceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.score > 0) {
            self.score --;
            self.contentTextField.text = [NSString stringWithFormat:@"%ld",self.score];
        }
    }];
}

- (void)setModel:(ItemSubListModel *)model{
    _model = model;
    
    self.score = [model.score integerValue];
    self.titleLabel.text = model.name;
    self.contentTextField.text = model.score;
    
    if ([model.name isEqualToString:@"根据模板的设置来自定义加减分"]) {
        self.selectView.hidden = YES;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
