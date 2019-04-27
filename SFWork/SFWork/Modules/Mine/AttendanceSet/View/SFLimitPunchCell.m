//
//  SFLimitPunchCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFLimitPunchCell.h"

@interface SFLimitPunchCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation SFLimitPunchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(SFAttendanceSetModel *)model{
    _model = model;
    self.titleLabel.text = model.title;
    self.selectButton.selected = model.isClick;
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
