//
//  SFJoBottomView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFJoBottomView.h"

@interface SFJoBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *refuseButtom;
@property (weak, nonatomic) IBOutlet UIButton *passButton;

@end

@implementation SFJoBottomView

+ (instancetype)shareBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFJoBottomView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.refuseButtom.layer.cornerRadius = 5;
    self.refuseButtom.clipsToBounds = YES;
    
    self.passButton.layer.cornerRadius = 5;
    self.passButton.clipsToBounds = YES;
    
    @weakify(self)
    [[self.refuseButtom rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectIndex?:self.selectIndex(0);
    }];
    
    [[self.passButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectIndex?:self.selectIndex(1);
    }];
}
@end
