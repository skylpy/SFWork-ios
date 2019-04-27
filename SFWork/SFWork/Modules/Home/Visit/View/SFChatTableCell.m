//
//  SFChatTableCell.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFChatTableCell.h"
#import "LRSChartView.h"

@interface SFChatTableCell ()

@property (nonatomic,strong) LRSChartView * incomeChartLineView;
@property (nonatomic, strong) NSMutableArray *datasArray;
@property (nonatomic, strong) NSMutableArray *daysArray;
@end

@implementation SFChatTableCell

- (NSMutableArray *)datasArray{
    
    if (!_datasArray) {
        _datasArray = [NSMutableArray array];
    }
    return _datasArray;
}

- (NSMutableArray *)daysArray{
    
    if (!_daysArray) {
        _daysArray = [NSMutableArray array];
    }
    return _daysArray;
}

- (LRSChartView *)incomeChartLineView {
    
    if (!_incomeChartLineView) {
        NSArray *tempDataArrOfY = @[@[@"12",@"10",@"15",@"8",@"5",@"9"]];
        
        [self.datasArray addObjectsFromArray:tempDataArrOfY];
        
        _incomeChartLineView = [[LRSChartView alloc]initWithFrame:CGRectMake(20, 0, kWidth-40, 224)];
        //是否默认显示第一个点
        _incomeChartLineView.isShowFirstPaoPao = YES;
        //是否可以浮动
        _incomeChartLineView.isFloating = YES;
        //设置X轴坐标字体大小
        _incomeChartLineView.x_Font = [UIFont systemFontOfSize:10];
        //设置X轴坐标字体颜色
        _incomeChartLineView.x_Color = [self colorWithHexString:@"0x999999"];
        //设置Y轴坐标字体大小
        _incomeChartLineView.y_Font = [UIFont systemFontOfSize:10];
        //设置Y轴坐标字体颜色
        _incomeChartLineView.y_Color = [self colorWithHexString:@"0x999999"];
        //设置X轴数据间隔
        _incomeChartLineView.Xmargin = 50;
        
        //设置背景颜色
        _incomeChartLineView.backgroundColor = [UIColor clearColor];
        //是否根据折线数据浮动泡泡
        _incomeChartLineView.isFloating = YES;
        //折线图数据
        _incomeChartLineView.leftDataArr = self.datasArray;
//        _incomeChartLineView.paopaoTitleArray = self.datasArray;
        //折线图所有颜色
        _incomeChartLineView.leftColorStrArr = @[@"#01B38B"];
        //设置折线样式
        _incomeChartLineView.chartViewStyle = LRSChartViewMoreClickLine;
        //设置图层效果
        _incomeChartLineView.chartLayerStyle = LRSChartGradient;
        //设置折现效果
        _incomeChartLineView.lineLayerStyle = LRSLineLayerNone;
        //泡泡背景颜色
        _incomeChartLineView.paopaoBackGroundColor = Color(@"#000000");
        //渐变效果的颜色组
        _incomeChartLineView.colors = @[@[[self colorWithHexString:@"#febf83"],[UIColor greenColor]],@[[self colorWithHexString:@"#53d2f8"],[UIColor blueColor]],@[[self colorWithHexString:@"#7211df"],[UIColor redColor]]];
        //渐变开始比例
        _incomeChartLineView.proportion = 0.3;
        //底部日期
        _incomeChartLineView.dataArrOfX = @[@"01-13",@"01-14",@"01-15",@"01-16",@"01-17",@"01-18"];
        //开始画图
        [_incomeChartLineView show];
    }
    return _incomeChartLineView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setDrawUI];
}

- (void)cellWithDatas:(NSArray *)datas withDays:(NSArray *)days{
    
    [self.daysArray removeAllObjects];
    [self.datasArray removeAllObjects];
    [self.daysArray addObjectsFromArray:days];
    [self.datasArray addObjectsFromArray:datas];
    self.incomeChartLineView.leftDataArr = self.datasArray;
    self.incomeChartLineView.dataArrOfX = self.daysArray;
    self.incomeChartLineView.paopaoTitleArray = self.datasArray[0];
    NSLog(@"self.datasArray = %@",self.datasArray);
    [self.incomeChartLineView show];
}

- (void)setDrawUI {
    
    [self addSubview:self.incomeChartLineView];
    
//    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    rightButton.frame = CGRectMake(0, 0, 60, 30);
//    rightButton.titleLabel.font = [UIFont fontWithName:kRegFont size:15];
//    [rightButton setTitleColor:defaultColor forState:UIControlStateNormal];
//    [rightButton setTitle:@"详细搜索" forState:UIControlStateNormal];
//    @weakify(self)
//    [[rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
//        @strongify(self)
//        [self.dataArray removeAllObjects];
//        NSArray *tempDataArrOfY = @[@[@"2",@"0",@"0",@"1",@"3",@"9"]];
//        [self.dataArray addObjectsFromArray:tempDataArrOfY];
//        //折线图数据
//        _incomeChartLineView.leftDataArr = self.dataArray;
//        //开始画图
//        [_incomeChartLineView show];
//    }];
//    [self addSubview:rightButton];
}

-(UIColor*)colorWithHexString:(NSString*)stringToConvert{
    if([stringToConvert hasPrefix:@"#"])
    {
        stringToConvert = [stringToConvert substringFromIndex:1];
    }
    NSScanner*scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if(![scanner scanHexInt:&hexNum])
    {
        return nil;
    }
    return [self colorWithRGBHex:hexNum];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
