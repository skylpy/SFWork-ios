//
//  SFSwitchCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSwitchCell.h"

@interface SFSwitchCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *deslabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end

@implementation SFSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.titleLabel.textColor = Color(@"#333333");
    [self.switchBtn addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventValueChanged];
}

- (void)changeValue:(UISwitch *)swh{

    self.model.isClick = swh.on;
    self.model.destitle = swh.isOn ? @"是":@"否";
    self.deslabel.text = swh.isOn ? @"是":@"否";
    !self.selectClick?:self.selectClick(swh.isOn);
}

- (void)setModel:(SFCustomerModel *)model{
    
    _model = model;
    self.titleLabel.text = model.title;

}

- (void)setJmodel:(SFJournalModel *)jmodel{
    _jmodel = jmodel;
    self.titleLabel.text = jmodel.title;
    self.titleLabel.textColor = Color(jmodel.descolor);
//    self.switchBtn.on = jmodel.isClick;
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
