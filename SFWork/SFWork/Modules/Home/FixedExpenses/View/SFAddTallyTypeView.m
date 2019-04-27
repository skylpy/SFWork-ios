//
//  SFAddTallyTypeView.m
//  SFWork
//
//  Created by fox on 2019/4/21.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFAddTallyTypeView.h"

@interface SFAddTallyTypeView ()
@property (weak, nonatomic) IBOutlet UIView *mainView;


@end

@implementation SFAddTallyTypeView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    _textField.layer.borderColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor;
    _textField.layer.borderWidth = 1;
    _textField.layer.cornerRadius = 3;
    _mainView.layer.cornerRadius = 8;
    [_textField becomeFirstResponder];
}

- (IBAction)sureBtnAction:(UIButton *)sender {
    NSString * nameStr = _textField.text;
    [nameStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.sureBlock) {
        self.sureBlock(nameStr);
    }
    
    
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}
@end
