//
//  YJYLinesPaoPaoView.h
//  YJYLinesView
//
//  Created by yuhuan on 2018/3/22.
//  Copyright © 2018年 YJY. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,Direction){
    directionTop, //顶部
    directionBottom,  //底部
};
@interface LRSLinesPaoPaoView : UIView

@property (nonatomic,strong) UIImage *backgroudImage;

@property (nonatomic,assign) CGFloat margin;

@property (nonatomic,assign) CGFloat pointX;

@property (nonatomic,assign) CGFloat chartContentWidth;
//左侧是否靠边 默认为NO不靠边
@property (nonatomic,assign) BOOL beyondLeft;
//右侧是否靠边 默认为NO不靠边
@property (nonatomic,assign) BOOL beyondRight;

- (void)show:(NSArray *)dataArr and:(NSString *)title andTitleColor:(UIColor *)titleColor colorArr:(NSArray *)color;

+(CGSize)getWidthAndHeight:(NSArray *)dataArray;
//画边框并填充颜色
-(void)drawBoxWithDirection:(Direction)direction;

+ (float)measureSinglelineStringWidth:(NSString*)str andFont:(UIFont*)wordFont;
@end
