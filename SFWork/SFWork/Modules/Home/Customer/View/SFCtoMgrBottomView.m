//
//  SFCtoMgrBottomView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFCtoMgrBottomView.h"

@interface SFCtoMgrBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *customerButton;
@property (weak, nonatomic) IBOutlet UIButton *businessButton;
@property (weak, nonatomic) IBOutlet UIButton *privateButton;
@property (weak, nonatomic) IBOutlet UIButton *customerButton1;
@property (weak, nonatomic) IBOutlet UIButton *businessButton1;

@end

@implementation SFCtoMgrBottomView

+ (instancetype)shareBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFCtoMgrBottomView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    [self.customerButton1 layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];

    [self.businessButton1 layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];

    [self.customerButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    [self.businessButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    [self.privateButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    @weakify(self)
    [[self.customerButton1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self selectButton:x];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectClick:)]) {
            [self.delegate selectClick:comType];
        }
    }];
    [[self.businessButton1 rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self selectButton:x];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectClick:)]) {
            [self.delegate selectClick:busType];
        }
    }];
    [[self.customerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self selectButton:x];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectClick:)]) {
            [self.delegate selectClick:comType];
        }
    }];
    [[self.businessButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self selectButton:x];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectClick:)]) {
            [self.delegate selectClick:busType];
        }
    }];
    [[self.privateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self selectButton:x];
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectClick:)]) {
            [self.delegate selectClick:priType];
        }
    }];
}

- (void)selectButton:(UIButton *)sender {
    
    for (int i = 1000; i < 1003; i ++) {
        UIButton * button = [self viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}

@end
