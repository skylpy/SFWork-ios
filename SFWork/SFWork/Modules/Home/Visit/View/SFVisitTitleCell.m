//
//  SFVisitTitleCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFVisitTitleCell.h"

@interface SFVisitTitleCell ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contLabel;

@end

@implementation SFVisitTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(StatisticsList *)model{
    _model = model;
    
    self.titleLabel.text = model.name;
    self.contLabel.text = [NSString stringWithFormat:@"%@个",model.count];
}

- (void)setSmodel:(StatisticsList *)smodel{
    _smodel = smodel;
    self.titleLabel.text = smodel.name;
    self.contLabel.text = [NSString stringWithFormat:@"%@个",smodel.sum];
    self.colorView.backgroundColor = Color(smodel.color);
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    if (index == 0) {
        self.colorView.backgroundColor = Color(@"#01B38B");
    }
    if (index == 1) {
        self.colorView.backgroundColor = Color(@"#FE7F0E");
    }
    if (index == 2) {
        self.colorView.backgroundColor = Color(@"#A86ADE");
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
