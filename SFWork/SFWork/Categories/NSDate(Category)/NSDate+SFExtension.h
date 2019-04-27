//
//  NSDate+SFExtension.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (SFExtension)


/** 当前时间转字符串 */
+ (NSString *)dateWithFormat:(NSString *)format;
/**
 时间转字符串
 
 @param format 要转换的时间格式，不传则默认yyyy-MM-dd形式
 @return 字符串时间
 */
- (NSString *)dateWithFormat:(NSString *)format;
/**
 时间戳格式化时间字符串
 
 @param timestamp 时间戳
 @param format 要转换的时间格式，不传则默认yyyy-MM-dd形式
 @return 字符串时间
 */
+ (NSString *)dateFormTimestamp:(NSString *)timestamp withFormat:(NSString *)format;
/** 获取当前时间戳 */
NSString * getCurrentTime(NSInteger count);
/** 秒数转换字符串 */
NSString *translateTime(NSInteger time);
//获取最近7天时间 数组
+(NSMutableArray *)latelyEightTime:(NSString *)format;

//获取当前时间戳
+(NSString *)getNowTimeTimestamp3;

//日期对比
+ (int)compareOneDay:(NSDate *)currentDay withAnotherDay:(NSDate *)BaseDay;
+ (NSDate *)getCurrentTime;
+(NSDate*)dateFromString:(NSString*)string;
//NSDate转NSString

+(NSString*)stringFromDate:(NSDate*)date;
//NSDate转NSString

+(NSString*)stringFromDate:(NSDate*)date withFormatter:(NSString *)formatter;

//获取当天0点时间戳
+ (double)getZeroWithTime0Interverl:(NSDate *) date;
//获取当天24点时间戳
+ (double)getZeroWithTime24Interverl:(NSDate *) date;
+(NSString *)getNowTimeTimestamp;
+(NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;
//计算任意2个时间的之间的间隔
+ (NSTimeInterval)pleaseInsertStarTime:(NSString *)starTime andInsertEndTime:(NSString *)endTime withFormatter:(NSString *)formatter;
@end

NS_ASSUME_NONNULL_END
