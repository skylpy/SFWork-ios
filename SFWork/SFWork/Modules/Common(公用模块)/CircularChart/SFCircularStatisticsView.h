//
//  SFCircularStatisticsView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFChartTitleView.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFCircularStatisticsView : UIView


//中心颜色
@property (strong, nonatomic)UIColor *centerColor;
//圆环背景色
@property (strong, nonatomic)UIColor *arcBackColor;

//圆环色

@property (strong, nonatomic)UIColor *arcFinishColor;
@property (strong, nonatomic)UIColor *arcUnfinishColor;

@property (strong, nonatomic)UIColor *arcTitleColor;
//百分比数值（0-1）
@property (assign, nonatomic)float percent;
//字体
@property (assign, nonatomic)float fontSize;
//圆环宽度
@property (assign, nonatomic)float width;
@property (nonatomic, strong) SFChartTitleView *chartTitleView;

@end

NS_ASSUME_NONNULL_END
