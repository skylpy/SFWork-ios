//
//  SFAddHeaderView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddHeaderView.h"

@interface SFAddHeaderView ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;

@property (weak, nonatomic) IBOutlet UITextField *unitTextField;



@end

@implementation SFAddHeaderView

+ (instancetype)shareSFAddHeaderView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFAddHeaderView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    RACChannelTo(self, self.item.name) = RACChannelTo(self.nameTextField, text);
    RACChannelTo(self, self.item.unit) = RACChannelTo(self.unitTextField, text);
    RACChannelTo(self, self.item.target) = RACChannelTo(self.numberTextField, text);
    
    @weakify(self)
    [[self.nameTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.item.name = x;
    }];
    [[self.unitTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.item.unit = x;
    }];
    [[self.numberTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.item.target = x;
    }];
}

- (void)setItem:(ItemsModel *)item{
    _item = item;
    
    self.nameTextField.text = item.name;
    self.unitTextField.text = item.unit;
    self.numberTextField.text = item.target;
}

@end
