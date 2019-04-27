//
//  SFServiceAgreeCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFServiceAgreeCell.h"
#import "GHAttributesLabel.h"

@interface SFServiceAgreeCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet GHAttributesLabel *attributesLabel;

@end

@implementation SFServiceAgreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    @weakify(self)
    [[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        !self.selectClick?:self.selectClick(x);
    }];
    GHAttributesLabel *attributesLabel1 = [[GHAttributesLabel alloc]initWithFrame:CGRectMake(40, 10, [UIScreen mainScreen].bounds.size.width - 20, 44)];

    NSString * message = @"本人已阅读并同意《三帆外勤服务协议》";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:message];
    [attrStr addAttribute:NSLinkAttributeName
                    value:@"《三帆外勤服务协议》"
                    range:NSMakeRange(8, 10)];
   
    
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont fontWithName:kRegFont size:14]
                    range:NSMakeRange(0, attrStr.length)];
    
    attributesLabel1.actionBlock = ^{
        
        !self.serviceClick?:self.serviceClick();
    };
    
    [attributesLabel1 setAttributesText:attrStr actionText:@"《三帆外勤服务协议》"];
    [attrStr addAttribute:NSForegroundColorAttributeName value:defaultColor range:[message rangeOfString:@"《三帆外勤服务协议》"]];
     [self addSubview:attributesLabel1];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
