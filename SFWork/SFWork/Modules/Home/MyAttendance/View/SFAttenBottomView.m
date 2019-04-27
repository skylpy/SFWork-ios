//
//  SFAttenBottomView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAttenBottomView.h"

@interface SFAttenBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *pickUpButton;
@property (weak, nonatomic) IBOutlet UIButton *statisticesButton;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@end

@implementation SFAttenBottomView

+ (instancetype)shareSFAttenBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFAttenBottomView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.pickUpButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    [self.statisticesButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    [self.applyButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    @weakify(self)
    [[self.pickUpButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectTag?:self.selectTag(1);
        [self selectBtn:x];
    }];
    
    [[self.statisticesButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectTag?:self.selectTag(2);
        [self selectBtn:x];
    }];
    
    [[self.applyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectTag?:self.selectTag(3);
        [self selectBtn:x];
    }];
}

- (void)selectBtn:(UIButton *)sender{
    
    for (int i = 1000; i < 1003; i ++) {
        UIButton * button = [self viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}

@end
