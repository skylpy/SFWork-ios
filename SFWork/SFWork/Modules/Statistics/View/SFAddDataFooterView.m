
//
//  SFAddDataFooterView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/29.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAddDataFooterView.h"

@interface SFAddDataFooterView ()



@end

@implementation SFAddDataFooterView

+ (instancetype)shareSFAddDataFooterView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFAddDataFooterView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    @weakify(self)
    
    self.cancelButton.layer.cornerRadius = 2;
    self.cancelButton.clipsToBounds = YES;
    
    self.sureButton.layer.cornerRadius = 2;
    self.sureButton.clipsToBounds = YES;
    
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.sureClick?:self.sureClick(0);
    }];
    
    [[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.sureClick?:self.sureClick(1);
    }];
}

@end
