//
//  UILabel+SFExtension.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (SFExtension)

@property (nonatomic, assign, readonly) CGFloat textWidth;
@property (nonatomic, assign, readonly) CGFloat textHeight;

+ (instancetype)creatLabelWithFrameX:(CGFloat)x Y:(CGFloat)y W:(CGFloat)w H:(CGFloat)h Text:(NSString *)text fontSize:(CGFloat)size TextColor:(UIColor *)textColor BGColor:(UIColor *)bgColors;

+ (instancetype)creatLabelWithFontName:(NSString *)name TextColor:(UIColor *)textColor FontSize:(CGFloat)size Text:(NSString *)text;

+ (instancetype)labelWithTextColor:(UIColor *)textColor size:(CGFloat)size;

+ (UILabel *)createALabelText:(NSString *)text withFont:(UIFont *)font withColor:(UIColor *)color;



@end

NS_ASSUME_NONNULL_END
