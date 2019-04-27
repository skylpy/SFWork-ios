//
//  SFRegisterCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFRegisterCell.h"

@implementation SFRegisterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.valueTextField.enabled = self.model.isClick;
    //双向绑定
    RACChannelTo(self, self.model.value) = RACChannelTo(self.valueTextField, text);
    
    @weakify(self)
    [[self.valueTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        self.model.value = x;
        //手机号
        if (self.model.type == 4) {
            
            if ([NSString valiMobile:x]) {
                self.desLabel.text = @"";
            }else{
                self.desLabel.text = @"请输入正确的手机号";
            }
        }
        if (self.model.type == 6) {
            if (x.length >= 6&&x.length <16) {
                self.desLabel.text = @"";
            }else{
                self.desLabel.text = @"请输入6位以上,15位以下数字或字母组合";
            }
        }
    }];
}

- (void)setModel:(SFRegisterModel *)model{
    _model = model;
    
    self.titleLabel.text = model.title;
    self.valueTextField.placeholder = model.placeholder;
    self.valueTextField.enabled = model.isClick;
    
    if (model.type == 4 || model.type == 5) {
        
        self.valueTextField.keyboardType = UIKeyboardTypePhonePad;
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条样式
    CGContextSetLineCap(context, kCGLineCapSquare);
    //设置颜色
    CGContextSetRGBStrokeColor(context, 238 / 255.0, 238 / 255.0, 238 / 255.0, 1.0);
    //设置线条粗细宽度
    CGContextSetLineWidth(context, 1);
    //开始一个起始路径
    CGContextBeginPath(context);
    //起始点设置为(0,0):注意这是上下文对应区域中的相对坐标，
    CGContextMoveToPoint(context, 0, 1);
    //设置下一个坐标点
    CGContextAddLineToPoint(context, kWidth ,0);
    //连接上面定义的坐标点
    CGContextStrokePath(context);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
