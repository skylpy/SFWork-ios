//
//  SFDatePickView.h
//  SFWork
//
//  Created by fox on 2019/4/19.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, LJDatePickerViewMode) {
    LJDatePickerModeYear = 0,              //年
    LJDatePickerModeYearAndMonth,          //年月
    LJDatePickerModeDate,                  //年月日
    LJDatePickerModeDateHour,              //年月日时
    LJDatePickerModeDateHourMinute,        //年月日时分
    LJDatePickerModeDateHourMinuteSecond,  //年月日时分秒
    LJDatePickerModeTime,                  //时分
    LJDatePickerModeTimeAndSecond,         //时分秒
    LJDatePickerModeMinuteAndSecond,       //分秒
    //SPDatePickerModeDateAndTime,           //月日周 时分
};
NS_ASSUME_NONNULL_BEGIN


@protocol DatePickDelegate <NSObject>

- (void)endingSelectDate:(NSString *)date DatePick:(id)datePick;

@end

@interface SFDatePickView : UIView
/**
 * 时间模式
 */
@property (nonatomic, assign)LJDatePickerViewMode pickerViewMode;

@property (weak, nonatomic) id<DatePickDelegate> delegate;

// 默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate;

- (NSString *)getCurrenSelectDate;
@end

NS_ASSUME_NONNULL_END

