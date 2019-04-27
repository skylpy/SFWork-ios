//
//  SFJournalBottomView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFJournalBottomView.h"

@interface SFJournalBottomView ()

@end

@implementation SFJournalBottomView

+ (instancetype)shareBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFJournalBottomView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    [self.brancdButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    [self.myButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    @weakify(self)
    [[self.brancdButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self selectBtn:x];
        !self.selectTag?:self.selectTag(0);
    }];
    
    [[self.myButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self selectBtn:x];
        !self.selectTag?:self.selectTag(1);
    }];
}

- (void)selectBtn:(UIButton *)sender{
    
    for (int i = 1000; i < 1002; i ++) {
        UIButton * button = [self viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}

@end
