//
//  SFDatePickView.m
//  SFWork
//
//  Created by fox on 2019/4/19.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFDatePickView.h"

@interface SFDatePickView()<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    NSCalendar *calendar;
    
}
@property (strong, nonatomic) UIPickerView * pickerView;
@property (nonatomic,strong) NSString *string;
@property (nonatomic,strong) NSArray *columnArray;//存放每种情况需要分割的列
@end

@implementation SFDatePickView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 存放每种情况需要分割的列
        self.columnArray = @[@(1),@(2),@(3),@(4),@(5),@(6),@(2),@(3),@(2)];
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.dataSource=self;
        _pickerView.delegate=self;
        [self addSubview:_pickerView];
        
        // 2.获取当前时间
        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year = [comps year];
        
        startYear = year-15;
        yearRange = 50;
    }
    return self;
}

#pragma mark - UIPickerViewDataSource
// 多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return [self.columnArray[self.pickerViewMode] integerValue];
}
//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (self.pickerViewMode) {
        case LJDatePickerModeYear: //年
        {
            switch (component) {
                case 0:
                {
                    return yearRange;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case LJDatePickerModeYearAndMonth://年月
        {
            switch (component) {
                case 0:
                {
                    return yearRange;
                }
                    break;
                case 1:
                {
                    return 12;
                }
                    
                default:
                    break;
            }
        }
            break;
        case LJDatePickerModeDate://年月日
        {
            switch (component) {
                case 0:
                {
                    return yearRange;
                }
                    break;
                case 1:
                {
                    return 12;
                }
                case 2:
                {
                    return dayRange;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case LJDatePickerModeDateHour://年月日时
        {
            switch (component) {
                case 0:
                {
                    return yearRange;
                }
                    break;
                case 1:
                {
                    return 12;
                }
                case 2:
                {
                    return dayRange;
                }
                    break;
                case 3:
                {
                    return 24;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case LJDatePickerModeDateHourMinute://年月日时分
        {
            switch (component) {
                case 0:
                {
                    return yearRange;
                }
                    break;
                case 1:
                {
                    return 12;
                }
                case 2:
                {
                    return dayRange;
                }
                    break;
                case 3:
                {
                    return 24;
                }
                    break;
                case 4:
                {
                    return 60;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case LJDatePickerModeDateHourMinuteSecond://年月日时分秒
        {
            switch (component) {
                case 0:
                {
                    return yearRange;
                }
                    break;
                case 1:
                {
                    return 12;
                }
                case 2:
                {
                    return dayRange;
                }
                    break;
                case 3:
                {
                    return 24;
                }
                    break;
                case 4:
                {
                    return 60;
                }
                    break;
                case 5:
                {
                    return 60;
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case LJDatePickerModeTime://时分
        {
            switch (component) {
                    
                case 0:
                {
                    return 24;
                }
                    break;
                case 1:
                {
                    return 60;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case LJDatePickerModeTimeAndSecond://时分秒
        {
            switch (component) {
                    
                case 0:
                {
                    return 24;
                }
                    break;
                case 1:
                {
                    return 60;
                }
                    break;
                case 2:
                {
                    return 60;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case LJDatePickerModeMinuteAndSecond://分秒
        {
            switch (component) {
                    
                case 0:
                {
                    return 60;
                }
                    break;
                case 1:
                {
                    return 60;
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return 0;
}

#pragma mark  UIPickerViewDelegate
// 默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate
{
    // 获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar0 components:unitFlags fromDate:currentDate];
    NSInteger year   = [comps year];
    NSInteger month  = [comps month];
    NSInteger day    = [comps day];
    NSInteger hour   = [comps hour];
    NSInteger minute = [comps minute];
    NSInteger second = [comps second];
    
    selectedYear     = year;
    selectedMonth    = month;
    selectedDay      = day;
    selectedHour     = hour;
    selectedMinute   = minute;
    selectedSecond   = second;
    
    
    dayRange = [self isAllDay:year andMonth:month];
    
    switch (self.pickerViewMode) {
        case 0:
        {
            [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
            [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
            
        }
            break;
        case 1:
        {
            [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
            [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
            
            [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
            [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
        }
            break;
        case 2:
        {
            [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
            [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
            [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
            
            [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
            [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
            [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
        }
            break;
        case 3:
        {
            [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
            [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
            [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
            [self.pickerView selectRow:hour inComponent:3 animated:NO];
            
            [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
            [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
            [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
            [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
        }
            break;
        case 4:
        {
            [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
            [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
            [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
            [self.pickerView selectRow:hour inComponent:3 animated:NO];
            [self.pickerView selectRow:minute inComponent:4 animated:NO];
            
            [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
            [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
            [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
            [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
            [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
        }
            break;
        case 5:
        {
            [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
            [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
            [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
            [self.pickerView selectRow:hour inComponent:3 animated:NO];
            [self.pickerView selectRow:minute inComponent:4 animated:NO];
            [self.pickerView selectRow:second inComponent:5 animated:NO];
            
            
            [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
            [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
            [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
            [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
            [self pickerView:self.pickerView didSelectRow:minute inComponent:4];
            [self pickerView:self.pickerView didSelectRow:second inComponent:5];
            
        }
            break;
        case 6:
        {
            [self.pickerView selectRow:hour inComponent:0 animated:NO];
            [self.pickerView selectRow:minute inComponent:1 animated:NO];
            
            [self pickerView:self.pickerView didSelectRow:hour inComponent:0];
            [self pickerView:self.pickerView didSelectRow:minute inComponent:1];
        }
            break;
        case 7:
        {
            [self.pickerView selectRow:hour inComponent:0 animated:NO];
            [self.pickerView selectRow:minute inComponent:1 animated:NO];
            [self.pickerView selectRow:second inComponent:2 animated:NO];
            
            [self pickerView:self.pickerView didSelectRow:hour inComponent:0];
            [self pickerView:self.pickerView didSelectRow:minute inComponent:1];
            [self pickerView:self.pickerView didSelectRow:second inComponent:2];
        }
            break;
        case 8:
        {
            [self.pickerView selectRow:minute inComponent:0 animated:NO];
            [self.pickerView selectRow:second inComponent:1 animated:NO];
            
            [self pickerView:self.pickerView didSelectRow:minute inComponent:0];
            [self pickerView:self.pickerView didSelectRow:second inComponent:1];
        }
            break;
            
        default:
            break;
    }
    
    [self.pickerView reloadAllComponents];
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label = [[UILabel alloc]initWithFrame:CGRectMake(kWidth*component/6.0, 0,kWidth/6.0, 30)];
    label.font = [UIFont systemFontOfSize:15.0];
    label.tag = component*100+row;
    label.textAlignment = NSTextAlignmentCenter;
    
    
    switch (self.pickerViewMode) {
        case 0:
        {
            switch (component) {
                case 0:
                {
                    label.text = [NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
                }
                    break;
                    
                default:
                    break;
            }
            
        }
            break;
        case 1:
        {
            switch (component) {
                case 0:
                {
                    label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
                }
                    break;
                case 1:
                {
                    label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (component) {
                case 0:
                {
                    label.text=[NSString stringWithFormat:@"%ld",(long)(startYear + row)];
                }
                    break;
                case 1:
                {
                    label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
                }
                    break;
                case 2:
                {
                    
                    label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 3:
        {
            switch (component) {
                case 0:
                {
                    label.text=[NSString stringWithFormat:@"%ld",(long)(startYear + row)];
                }
                    break;
                case 1:
                {
                    label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
                }
                    break;
                case 2:
                {
                    
                    label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
                }
                    break;
                case 3:
                {
                    label.text=[NSString stringWithFormat:@"%ld",(long)row];
                }
                    break;
                    
                default:
                    break;
            }
            label.textAlignment=NSTextAlignmentCenter;
            
        }
            break;
        case 4:
        {
            switch (component) {
                case 0:
                {
                    label.text=[NSString stringWithFormat:@"%ld",(long)(startYear + row)];
                }
                    break;
                case 1:
                {
                    label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
                }
                    break;
                case 2:
                {
                    
                    label.text=[NSString stringWithFormat:@"%ld",(long)row+1];
                }
                    break;
                case 3:
                {
                    label.text=[NSString stringWithFormat:@"%ld",(long)row];
                }
                    break;
                case 4:
                {
                    label.text=[NSString stringWithFormat:@"%ld",(long)row];
                }
                    break;
                    
                default:
                    break;
            }
            label.textAlignment=NSTextAlignmentCenter;
            
        }
            break;
        case 5:
        {
            switch (component) {
                case 0:
                {
                    label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
                }
                    break;
                case 1:
                {
                    label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
                }
                    break;
                case 2:
                {
                    
                    label.text=[NSString stringWithFormat:@"%ld日",(long)row+1];
                }
                    break;
                case 3:
                {
                    label.text=[NSString stringWithFormat:@"%ld时",(long)row];
                }
                    break;
                case 4:
                {
                    label.text=[NSString stringWithFormat:@"%ld分",(long)row];
                }
                    break;
                case 5:
                {
                    label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
                }
                    break;
                    
                default:
                    break;
            }
            label.textAlignment=NSTextAlignmentCenter;
            
        }
            break;
        case 6:
        {
            switch (component) {
                case 0:
                {
                    label.textAlignment=NSTextAlignmentLeft;
                    label.text=[NSString stringWithFormat:@"%ld时",(long)row];
                }
                    break;
                case 1:
                {
                    label.textAlignment=NSTextAlignmentRight;
                    label.text=[NSString stringWithFormat:@"%ld分",(long)row];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 7:
        {
            switch (component) {
                case 0:
                {
                    label.textAlignment=NSTextAlignmentLeft;
                    label.text=[NSString stringWithFormat:@"%ld时",(long)row];
                }
                    break;
                case 1:
                {
                    label.textAlignment=NSTextAlignmentCenter;
                    label.text=[NSString stringWithFormat:@"%ld分",(long)row];
                }
                    break;
                case 2:
                {
                    label.textAlignment=NSTextAlignmentRight;
                    label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 8:
        {
            switch (component) {
                case 0:
                {
                    label.textAlignment=NSTextAlignmentLeft;
                    label.text=[NSString stringWithFormat:@"%ld分",(long)row];
                }
                    break;
                case 1:
                {
                    label.textAlignment=NSTextAlignmentRight;
                    label.text=[NSString stringWithFormat:@"%ld秒",(long)row];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return ([UIScreen mainScreen].bounds.size.width-40)/[self.columnArray[self.pickerViewMode] integerValue];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 30;
}

// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
    switch (self.pickerViewMode) {
        case 0:
        {
            switch (component) {
                case 0:
                {
                    selectedYear = startYear + row;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                    
                default:
                    break;
            }
            
            _string =[NSString stringWithFormat:@"%ld",
                      selectedYear];
            if ([self.delegate respondsToSelector:@selector(endingSelectDate:DatePick:)]) {
                [self.delegate endingSelectDate:_string DatePick:self];
            }
        }
            break;
        case 1:
        {
            switch (component) {
                case 0:
                {
                    selectedYear=startYear + row;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                case 1:
                {
                    selectedMonth=row+1;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                    
                default:
                    break;
            }
            
            _string =[NSString stringWithFormat:@"%ld-%.2ld",
                      selectedYear,
                      selectedMonth];
            if ([self.delegate respondsToSelector:@selector(endingSelectDate:DatePick:)]) {
                [self.delegate endingSelectDate:_string DatePick:self];
            }
        }
            break;
        case 2:
        {
            switch (component) {
                case 0:
                {
                    selectedYear=startYear + row;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                case 1:
                {
                    selectedMonth=row+1;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                case 2:
                {
                    selectedDay=row+1;
                }
                    break;
                    
                default:
                    break;
            }
            
            _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld",
                      selectedYear,
                      selectedMonth,
                      selectedDay];
            if ([self.delegate respondsToSelector:@selector(endingSelectDate:DatePick:)]) {
                [self.delegate endingSelectDate:_string DatePick:self];
            }
        }
            break;
        case 3:
        {
            switch (component) {
                case 0:
                {
                    selectedYear=startYear + row;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                case 1:
                {
                    selectedMonth=row+1;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                case 2:
                {
                    selectedDay=row+1;
                }
                    break;
                case 3:
                {
                    selectedHour=row;
                }
                    break;
                    
                default:
                    break;
            }
            
            _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld",
                      selectedYear,
                      selectedMonth,
                      selectedDay,
                      selectedHour];
            if ([self.delegate respondsToSelector:@selector(endingSelectDate:DatePick:)]) {
                [self.delegate endingSelectDate:_string DatePick:self];
            }
        }
            break;
        case 4:
        {
            switch (component) {
                case 0:
                {
                    selectedYear=startYear + row;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                case 1:
                {
                    selectedMonth=row+1;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                case 2:
                {
                    selectedDay=row+1;
                }
                    break;
                case 3:
                {
                    selectedHour=row;
                }
                    break;
                case 4:
                {
                    selectedMinute=row;
                }
                    break;
                    
                default:
                    break;
            }
            
            _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",
                      selectedYear,
                      selectedMonth,
                      selectedDay,
                      selectedHour,
                      selectedMinute];
            if ([self.delegate respondsToSelector:@selector(endingSelectDate:DatePick:)]) {
                [self.delegate endingSelectDate:_string DatePick:self];
            }
        }
            break;
        case 5:
        {
            switch (component) {
                case 0:
                {
                    selectedYear=startYear + row;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                case 1:
                {
                    selectedMonth=row+1;
                    dayRange=[self isAllDay:selectedYear andMonth:selectedMonth];
                }
                    break;
                case 2:
                {
                    selectedDay=row+1;
                }
                    break;
                case 3:
                {
                    selectedHour=row;
                }
                    break;
                case 4:
                {
                    selectedMinute=row;
                }
                    break;
                case 5:
                {
                    selectedSecond=row;
                }
                    break;
                    
                default:
                    break;
            }
            
            _string =[NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld %.2ld",
                      selectedYear,
                      selectedMonth,
                      selectedDay,
                      selectedHour,
                      selectedMinute,
                      selectedSecond];
            if ([self.delegate respondsToSelector:@selector(endingSelectDate:DatePick:)]) {
                [self.delegate endingSelectDate:_string DatePick:self];
            }
        }
            break;
        case 6:
        {
            switch (component) {
                case 0:
                {
                    selectedHour=row;
                }
                    break;
                case 1:
                {
                    selectedMinute=row;
                }
                    break;
                    
                default:
                    break;
            }
            
            _string = [NSString stringWithFormat:@"%.2ld:%.2ld",selectedHour,selectedMinute];
            if ([self.delegate respondsToSelector:@selector(endingSelectDate:DatePick:)]) {
                [self.delegate endingSelectDate:_string DatePick:self];
            }
        }
            break;
        case 7:
        {
            switch (component) {
                case 0:
                {
                    selectedHour=row;
                }
                    break;
                case 1:
                {
                    selectedMinute=row;
                }
                    break;
                case 2:
                {
                    selectedSecond=row;
                }
                    break;
                    
                default:
                    break;
            }
            
            _string = [NSString stringWithFormat:@"%.2ld:%.2ld %.2ld",
                       selectedHour,
                       selectedMinute,
                       selectedSecond];
            if ([self.delegate respondsToSelector:@selector(endingSelectDate:DatePick:)]) {
                [self.delegate endingSelectDate:_string DatePick:self];
            }
        }
            break;
        case 8:
        {
            switch (component) {
                case 0:
                {
                    selectedMinute=row;
                }
                    break;
                case 1:
                {
                    selectedSecond=row;
                }
                    break;
                    
                default:
                    break;
            }
            
            _string = [NSString stringWithFormat:@"%.2ld %.2ld",
                       selectedMinute,
                       selectedSecond];
            if ([self.delegate respondsToSelector:@selector(endingSelectDate:DatePick:)]) {
                [self.delegate endingSelectDate:_string DatePick:self];
            }
        }
            break;
            
        default:
            break;
    }
}

-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day=0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day=31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day=30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day=29;
                break;
            }
            else
            {
                day=28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

- (NSString *)getCurrenSelectDate{
    return _string;
}

@end
