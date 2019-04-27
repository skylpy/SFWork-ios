//
//  SFVisitBottomView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/21.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitBottomView.h"

@interface SFVisitBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *statistButton;
@property (weak, nonatomic) IBOutlet UIButton *listButton;


@end

@implementation SFVisitBottomView

+ (instancetype)shareVisitBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFVisitBottomView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    [self.statistButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    [self.listButton layoutButtonWithImageStyle:ZJButtonImageStyleTop imageTitleToSpace:5];
    
    @weakify(self)
    [[self.statistButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self selectBtn:x];
        !self.selectTag?:self.selectTag(0);
    }];
    
    [[self.listButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
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
