//  ComfirmView.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModelComfirm : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *titleColor;
@property (nonatomic, assign) CGFloat fontSize;

+ (instancetype)comfirmModelWith:(NSString *)title titleColor:(UIColor *)color fontSize:(CGFloat)size;

@end

@interface ComfirmView : UIView

+ (instancetype)showInView:(UIView *)superView
            cancelItemWith:(ModelComfirm *)cancelModel
                dataSource:(NSArray *)dataSource
               actionBlock:(void (^)(ComfirmView *view, NSInteger index))actionBlock;

- (void)dissmissAcion;

@end

@interface ComfirmCell : UITableViewCell

@property (nonatomic, strong) ModelComfirm *model;

@end
