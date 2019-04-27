//
//  SFEmployeeCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFEmployeeCell.h"

@interface SFEmployeeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *roleButton;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation SFEmployeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    @weakify(self)
    [[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        self.model.isSelect = x.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectEmployee:) ]) {
            
            [self.delegate selectEmployee:self.model];
        }
    }];
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

- (void)setModel:(SFEmployeesModel *)model{
    _model = model;
    [self.avatarImage setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:[UIImage imageNamed:@"icon_rectangle_personal_green"]];
    self.nameLabel.text = model.name;
    self.selectButton.selected = model.isSelect;
    if (![model.role isEqualToString:@"EMPLOYEE"]) {
        NSString * role = [model.role isEqualToString:@"SUPERADMIN"]?@"超级管理员":
        [model.role isEqualToString:@"DEPARTMENTADMIN"]?@"部门管理员":@"";
        self.roleButton.hidden = NO;
        [self.roleButton setTitle:role forState:UIControlStateNormal];
    }else{
        self.roleButton.hidden = YES;
    }
}

- (void)setType:(SelectEmpType)type{
    _type = type;
    self.selectButton.hidden = type == multipleType ? NO:YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
