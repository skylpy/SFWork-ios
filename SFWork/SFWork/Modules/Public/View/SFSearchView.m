
//
//  SFSearchView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSearchView.h"

@interface SFSearchView ()
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, copy) NSString *string;

@end

@implementation SFSearchView

+ (instancetype)shareSFSearchViewView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFSearchView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.searchView.layer.cornerRadius = 3;
    self.searchView.clipsToBounds = YES;
    
    RACChannelTo(self, self.string) = self.searchTextField.rac_newTextChannel;
    @weakify(self);
    // 当 self.textField.text改变的时候，会回调这个block，然后再给string赋值，实现双向绑定
    [self.searchTextField.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.string = x;
    }];
}


@end
