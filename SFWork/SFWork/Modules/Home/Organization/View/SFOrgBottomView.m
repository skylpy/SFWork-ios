//
//  SFOrgBottomView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFOrgBottomView.h"

@interface SFOrgBottomView ()

@property (weak, nonatomic) IBOutlet UIButton *addStaffButton;
@property (weak, nonatomic) IBOutlet UIButton *depButton;
@property (weak, nonatomic) IBOutlet UIButton *depSetButton;

@end

@implementation SFOrgBottomView

+ (instancetype)shareSFOrgBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFOrgBottomView" owner:self options:nil].firstObject;
}

+ (instancetype)shareOrgBottomView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFOrgBottomView" owner:self options:nil].lastObject;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    @weakify(self)
    [[self.addStaffButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(orgBottomVuewClick:)]) {
            
            [self.delegate orgBottomVuewClick:x];
        }
    }];
    
    [[self.depButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(orgBottomVuewClick:)]) {
            
            [self.delegate orgBottomVuewClick:x];
        }
    }];
    
    [[self.depSetButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if (self.delegate && [self.delegate respondsToSelector:@selector(orgBottomVuewClick:)]) {
            
            [self.delegate orgBottomVuewClick:x];
        }
    }];
}

@end
