//
//  SFAnnounceHeaderView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAnnounceHeaderView.h"

@interface SFAnnounceHeaderView ()

@property (weak, nonatomic) IBOutlet UIButton *publishedButton;
@property (weak, nonatomic) IBOutlet UIButton *unpulishButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutX;

@end

@implementation SFAnnounceHeaderView

+ (instancetype)shareSFAnnounceHeaderView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFAnnounceHeaderView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    @weakify(self)
    [[self.publishedButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewLayoutX.constant = 0;
        !self.selectItemClcik?:self.selectItemClcik(0);
        [self selectStatueBtn:x];
    }];
    [[self.unpulishButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.viewLayoutX.constant = kWidth/2;
        !self.selectItemClcik?:self.selectItemClcik(1);
        [self selectStatueBtn:x];
    }];
}

- (void)selectStatueBtn:(UIButton *)sender{
    
    for (int i = 1000; i < 1002; i ++) {
        UIButton * button = [self viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}

@end
