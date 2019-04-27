//
//  NSString+SFSFExtension.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (SFExtension)

/**
 将文字按行分割成字符串
 
 @param font 字体
 @param width 字符串宽度
 @return 字符串数组
 */
- (NSArray<NSString *> *)componentsSeparatedByFont:(UIFont *)font width:(CGFloat)width;
/**
 按行数截取字符串
 
 @param lines 要截取的行数
 @param width 字符串宽度
 @return 截取后的字符串
 */
- (NSString *)subStringWithLines:(int)lines width:(CGFloat)width font:(UIFont *)font;

/**
 过滤html标签
 
 @param html htmt字符串
 @return 过滤后的文字
 */
+ (NSString *)filterHTML:(NSString *)html;
/** 根据<p>标签分隔html字符串 */
- (NSArray<NSString *> *)componentsSeparatedByTapP;
/**
 *  计算指定宽度的字符串高度
 
 */
- (float) calculateHeightWithFont: (UIFont *)font Width: (float) widt;

/**
 *  动态计算文字的宽高（单行）
 *  @param font 文字的字体
 *  @return 计算的宽高
 */
- (CGSize)mh_sizeWithFont:(UIFont *)font ;
/**
 *  中文编码
 */
- (instancetype)Encoding;

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input;



/**
 *  判断是否为空(包含空格或回车)
 */
- (BOOL)isBlankString;
/**
 根据文字多少计算高度
 */
+ (float)stringHeightWithString:(NSString *)string size:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth ;

/** 字典或数组转换成字符串 */
+ (NSString *)stringWithJsonData:(id)data;
/** 计算单行文字宽度 */
- (CGFloat)widthWithSize:(int)size;
/** 计算指定宽度文字高度 */
- (CGFloat)heightWithWidth:(CGFloat)width size:(int)size;
/** 对字符串进行URL编码 */
- (NSString *)URLEncodedString;
/** 对字符串进行URL解码 */
- (NSString *)URLDecodedString;
/** 根据size计算文件大小 */
+ (NSString *)stringWithSize:(NSInteger)size;
/** 根据时间戳获取字符串 */
+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval useDateFormatter:(NSDateFormatter *)dateFormatter;
/** 时间戳转换时间 */
- (NSString *)stringWithDataFormatter:(NSString *)dateFormatter;
/** 时间戳转换成时间(刚刚、几分钟前、几小时前形式) */
- (NSString *)translateDateFormatter:(NSString *)dateFormatter;
/** 标准时间格式转化成任意格式*/
- (NSString *)transTimeWithDateFormatter:(NSString *)dateFormatter;

//获取阿里oss fileKey
+ (NSString *)getAliOSSConstrainURL:(NSString *)fileKey;
//手机号码正则
+ (BOOL)valiMobile:(NSString *)mobile;

//将可能存在model数组转化为普通数组
+ (id)arrayOrDicWithObject:(id)origin;
//model转化为字典
+ (NSDictionary *)dicFromObject:(NSObject *)object;

//获取当前时间戳
+(NSString*)getCurrentTimes ;

//返回星期
+ (NSString *)getThisWeek:(NSString *)date ;

//判断时间是否在这个范围
+ (BOOL)judgeTimeByStartAndEnd:(NSString *)startTime withExpireTime:(NSString *)expireTime;

//两个时间相差多少天多少小时多少分多少秒
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime withFormatter:(NSString *)formatter;

@end

NS_ASSUME_NONNULL_END
