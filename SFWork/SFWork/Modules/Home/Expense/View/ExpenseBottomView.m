//
//  ExpenseBottomView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "ExpenseBottomView.h"

@interface ExpenseBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *approvalButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *makeCopyButton;

@end

@implementation ExpenseBottomView

+ (instancetype)shareExpenseBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"ExpenseBottomView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.approvalButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    [self.sendButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    [self.makeCopyButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    @weakify(self)
    [[self.approvalButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectTag?:self.selectTag(1);
        [self selectBtn:x];
    }];
    
    [[self.sendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectTag?:self.selectTag(2);
        [self selectBtn:x];
    }];
    
    [[self.makeCopyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
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
