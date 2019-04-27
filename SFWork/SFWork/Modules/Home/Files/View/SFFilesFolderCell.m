//
//  SFFilesFolderCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFFilesFolderCell.h"

@interface SFFilesFolderCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@end

@implementation SFFilesFolderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    @weakify(self)
    [[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        self.model.isSelect = x.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectFolder:)]) {
            [self.delegate selectFolder:self.model];
        }
    }];
    
//    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"SELECTFOLDER" object:nil] throttle:1] subscribeNext:^(NSNotification * _Nullable x) {
//        NSArray * array = x.object;
//
//    }];
}

- (void)setModel:(SFFilesModel *)model{
    _model = model;
    
    self.selectButton.selected = model.isSelect;
    self.nameLabel.text = model.name;
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
    CGContextMoveToPoint(context, 20, 1);
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
