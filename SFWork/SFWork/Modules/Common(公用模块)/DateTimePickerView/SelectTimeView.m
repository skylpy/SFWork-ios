//
//  SelectTimeView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/20.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SelectTimeView.h"

@interface SelectTimeView()


@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewLayoutX;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endButtonLayoutX;

@end

@implementation SelectTimeView

+ (instancetype)shareSelectTimeView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"SelectTimeView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    @weakify(self)
    [[self.startButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.lineViewLayoutX.constant = 0;
        
        [self selectItem:x];
    }];
    [[self.endButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        self.lineViewLayoutX.constant = kWidth/2+10;
        
        [self selectItem:x];
    }];
}

-(void)selectItem:(UIButton *)sender{
    
    for (int i = 1000; i < 1002; i ++) {
        UIButton * button = [self viewWithTag:i];
        button.selected = NO;
    }
    sender.selected = YES;
}

@end
