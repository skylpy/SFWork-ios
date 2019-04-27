//
//  SFDateTimePickerView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/20.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateTimePickerView.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SFDateTimePickerViewDelegate <NSObject>
@optional
/**
 * 确定按钮
 */
-(void)didClickFinishDateTimePickerView:(NSString*)date;
-(void)didClickFinishDateTimePickerViewStart:(NSString*)startDate withEnd:(NSString *)endDate;
/**
 * 取消按钮
 */
-(void)didClickCancelDateTimePickerView;

@end
@interface SFDateTimePickerView : UIView

/**
 * 设置当前时间
 */
@property(nonatomic, strong)NSDate*currentDate;
/**
 * 设置中心标题文字
 */
@property(nonatomic, strong)UILabel *titleL;

@property(nonatomic, strong)id<SFDateTimePickerViewDelegate>delegate;
/**
 * 模式
 */
@property (nonatomic, assign) DatePickerViewMode pickerViewMode;


/**
 * 掩藏
 */
- (void)hideDateTimePickerView;
/**
 * 显示
 */
- (void)showDateTimePickerView;


@end

NS_ASSUME_NONNULL_END
