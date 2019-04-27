//
//  NSDate+SFExtension.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "NSDate+SFExtension.h"

@implementation NSDate (SFExtension)

/** 当前时间转字符串 */
+ (NSString *)dateWithFormat:(NSString *)format{
    return [[NSDate date] dateWithFormat:format];
}

/**
 时间转字符串
 
 @param format 要转换的时间格式，不传则默认yyyy-MM-dd形式
 @return 字符串时间
 */
- (NSString *)dateWithFormat:(NSString *)format{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (format.length > 0) {
        [formatter setDateFormat:format];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    return [formatter stringFromDate:self];
}

/**
 时间戳格式化时间字符串
 
 @param timestamp 时间戳
 @param format 要转换的时间格式，不传则默认yyyy-MM-dd形式
 @return 字符串时间
 */
+ (NSString *)dateFormTimestamp:(NSString *)timestamp withFormat:(NSString *)format{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(timestamp.length == 10) ? [timestamp integerValue] : [timestamp integerValue] / 1000.0];
    return [date dateWithFormat:format];
}

//获取最近7天时间 数组
+(NSMutableArray *)latelyEightTime:(NSString *)format{
    NSMutableArray *eightArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 7; i ++) {
        //从现在开始的24小时
        NSTimeInterval secondsPerDay = -i * 24*60*60;
        NSDate *curDate = [NSDate dateWithTimeIntervalSinceNow:secondsPerDay];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:format];
        NSString *dateStr = [dateFormatter stringFromDate:curDate];//几月几号
        
        NSDateFormatter *weekFormatter = [[NSDateFormatter alloc] init];
        [weekFormatter setDateFormat:@"EEEE"];//星期几 @"HH:mm 'on' EEEE MMMM d"];
        NSString *weekStr = [weekFormatter stringFromDate:curDate];
        
        //转换英文为中文
        NSString *chinaStr = [self cTransformFromE:weekStr];
        
        //组合时间
        NSString *strTime = [NSString stringWithFormat:@"%@",dateStr];
        [eightArr addObject:strTime];
    }
    
    return eightArr;
}

//转换英文为中文
+(NSString *)cTransformFromE:(NSString *)theWeek{
    NSString *chinaStr;
    if(theWeek){
        if([theWeek isEqualToString:@"Monday"]){
            chinaStr = @"一";
        }else if([theWeek isEqualToString:@"Tuesday"]){
            chinaStr = @"二";
        }else if([theWeek isEqualToString:@"Wednesday"]){
            chinaStr = @"三";
        }else if([theWeek isEqualToString:@"Thursday"]){
            chinaStr = @"四";
        }else if([theWeek isEqualToString:@"Friday"]){
            chinaStr = @"五";
        }else if([theWeek isEqualToString:@"Saturday"]){
            chinaStr = @"六";
        }else if([theWeek isEqualToString:@"Sunday"]){
            chinaStr = @"七";
        }
    }
    return chinaStr;
}

/** 获取当前时间戳 */
NSString * getCurrentTime(NSInteger count){
//    if (count == 10) {
//        return [NSString stringWithFormat:@"%0.f",[[NSDate date] timeIntervalSince1970] - [SFInstance shareInstance].c];
//    }else{
//        return [NSString stringWithFormat:@"%0.f",(([[NSDate date] timeIntervalSince1970] - [XWInstance shareInstance].timeDiff) * 1000.0)];
//    }
    return nil;
}

/** 秒数转换字符串 */
NSString *translateTime(NSInteger time){
    if (time > 0 && time < 60) {
        return [NSString stringWithFormat:@"00:%02ld",time];
    }else if (time < 60 * 60){
        NSInteger mm = time / 60;
        NSInteger ss = time % 60;
        return [NSString stringWithFormat:@"%02ld:%02ld",mm,ss];
    }else{
        NSInteger hh = time / 60 / 60;
        NSInteger mm = time % 60 / 60;
        NSInteger ss = time % 60 % 60;
        return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",hh,mm,ss];
    }
    return @"00:00";
}

+(NSString *)getNowTimeTimestamp3{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
}

+ (NSDate *)getCurrentTime{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm "];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
    NSDate *date = [formatter dateFromString:dateTime];
    return date;
}

+(NSDate*)dateFromString:(NSString*)string {
    //设置转换格式
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"HH:mm"];
    
    //NSString转NSDate
    
    NSDate *date=[formatter dateFromString:string];
    
    return date;
    
}

//NSDate转NSString

+(NSString*)stringFromDate:(NSDate*)date {
    
    //用于格式化NSDate对象
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    
    //设置格式：zzz表示时区
    
    [dateFormatter setDateFormat:@"HH:mm"];
    
    //NSDate转NSString
    
    NSString *currentDateString=[dateFormatter stringFromDate:date];
    
    
    //如果需要的格式为xxxx-xx-xx,只需要截取字符串就好了(下面两行代码)
    
    //NSArray *dateArray = [dateString componentsSeparatedByString:@" "];
    
    // NSString *currentDateString = [dateArrayfirstObject];
    
    
    return currentDateString;
    
}

//NSDate转NSString

+(NSString*)stringFromDate:(NSDate*)date withFormatter:(NSString *)formatter{
    
    //用于格式化NSDate对象
    
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    
    //设置格式：zzz表示时区
    
    [dateFormatter setDateFormat:formatter];
    
    //NSDate转NSString
    
    NSString *currentDateString=[dateFormatter stringFromDate:date];
    
    
    //如果需要的格式为xxxx-xx-xx,只需要截取字符串就好了(下面两行代码)
    
    //NSArray *dateArray = [dateString componentsSeparatedByString:@" "];
    
    // NSString *currentDateString = [dateArrayfirstObject];
    
    
    return currentDateString;
    
}


//日期对比
+ (int)compareOneDay:(NSDate *)currentDay withAnotherDay:(NSDate *)BaseDay {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentDayStr = [dateFormatter stringFromDate:currentDay];
    NSString *BaseDayStr = [dateFormatter stringFromDate:BaseDay];
    NSDate *dateA = [dateFormatter dateFromString:currentDayStr];
    NSDate *dateB = [dateFormatter dateFromString:BaseDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", currentDay, BaseDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

//获取当天0点时间戳
+ (double)getZeroWithTime0Interverl:(NSDate *) date {
    
    return ([date timeIntervalSince1970] - 12*60*60) * 1000;
}

//获取当天24点时间戳
+ (double)getZeroWithTime24Interverl:(NSDate *) date {
    
    return ([date timeIntervalSince1970]+12*60*60) * 1000;
}

+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
//    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    
    return timeSp;
    
}

+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue]*1000;
    
    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld",(long)timeSp); //时间戳的值
    
    return timeSp;
    
}

+(double)sdhfhj {
    
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [greCalendar setTimeZone: timeZone];
    
    NSDateComponents *dateComponents = [greCalendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:[NSDate date]];
    
    //  定义一个NSDateComponents对象，设置一个时间点
    NSDateComponents *dateComponentsForDate = [[NSDateComponents alloc] init];
    [dateComponentsForDate setDay:dateComponents.day];
    [dateComponentsForDate setMonth:dateComponents.month];
    [dateComponentsForDate setYear:dateComponents.year];
    [dateComponentsForDate setHour:23];
    [dateComponentsForDate setMinute:59];
    
    NSDate *dateFromDateComponentsForDate = [greCalendar dateFromComponents:dateComponentsForDate];
    return [dateFromDateComponentsForDate timeIntervalSince1970];
}

//计算任意2个时间的之间的间隔
+ (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime withFormatter:(NSString *)formatter {
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:formatter];//根据自己的需求定义格式
    NSDate* startDate = [formater dateFromString:starTime];
    NSDate* endDate = [formater dateFromString:endTime];
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    return time;
}

@end
