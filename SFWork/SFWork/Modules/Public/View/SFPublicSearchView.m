//
//  SFPublicSearchView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/4.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPublicSearchView.h"

@interface SFPublicSearchView ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgSearchView;


@end

@implementation SFPublicSearchView

+ (instancetype)shareSFPublicSearchView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"SFPublicSearchView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.bgSearchView.backgroundColor = Color(@"#F6F6F6");
    self.bgSearchView.layer.cornerRadius = 15;
    self.bgSearchView.clipsToBounds = YES;
    self.seachTextField.delegate = self;
    
    @weakify(self)
    [[self.seachTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        !self.textSignalClick?:self.textSignalClick(x);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    !self.searchKeywordAction?:self.searchKeywordAction(textField.text);
}

@end
