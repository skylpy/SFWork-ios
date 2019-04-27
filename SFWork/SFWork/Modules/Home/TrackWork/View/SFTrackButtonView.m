
//
//  SFTrackButtonView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTrackButtonView.h"

@interface SFTrackButtonView ()

@property (weak, nonatomic) IBOutlet UIButton *refreshButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;

@end

@implementation SFTrackButtonView

+ (instancetype)shareSFTrackButtonView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFTrackButtonView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.layer.cornerRadius = 3;
    self.clipsToBounds = YES;
    
    @weakify(self)
    [[self.refreshButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectTag?:self.selectTag(0);
    }];
    
    [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectTag?:self.selectTag(1);
    }];
    
    [[self.reduceButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        !self.selectTag?:self.selectTag(2);
    }];
}

@end
