//
//  NSString+SFSFExtension.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "NSString+SFExtension.h"
#import "CoreText/CoreText.h"

@implementation NSString (SFExtension)


/**
 *  计算指定宽度的字符串高度
 
 */
- (float) calculateHeightWithFont: (UIFont *)font Width: (float) width
{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:font}
                                         context:nil];
    return ceil(textRect.size.height);
}

- (instancetype)Encoding
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
}

- (BOOL)isBlankString
{
    if (self == nil || self == NULL) {
        return YES;
    }
    if ([self isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}




/**
 根据文字多少计算高度
 */
+ (float)stringHeightWithString:(NSString *)string size:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont fontWithName:kRegFont size:fontSize],NSFontAttributeName, nil];
    
    float height = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return ceilf(height);
}

/**
 *  动态计算文字的宽高（单行）
 *  @param font 文字的字体
 *  @return 计算的宽高
 */
- (CGSize)mh_sizeWithFont:(UIFont *)font
{
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    theSize = [self sizeWithAttributes:attributes];
    // 向上取整
    theSize.width = ceil(theSize.width);
    theSize.height = ceil(theSize.height);
    return theSize;
}

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input

{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"
     
                               withString:@""
     
                                  options:NSLiteralSearch
     
                                    range:NSMakeRange(0,[outputStr length])];
    
    return
    
    [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
}

/** 字典或数组转换成字符串 */
+ (NSString *)stringWithJsonData:(id)data{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}

/** 计算单行文字宽度 */
- (CGFloat)widthWithSize:(int)size{
    CGSize theSize;
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:size] forKey:NSFontAttributeName];
    theSize = [self sizeWithAttributes:attributes];
    // 向上取整
    return ceil(theSize.width);
}

/** 计算指定宽度文字高度 */
- (CGFloat)heightWithWidth:(CGFloat)width size:(int)size{
    CGRect textRect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]}
                                         context:nil];
    return ceil(textRect.size.height);
}

/** 对字符串进行URL编码 */
- (NSString *)URLEncodedString{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"?!@#$^&%*+,:;='\"`<>()[]{}/\\| "] invertedSet]];;
}

/** 对字符串进行URL解码 */
- (NSString *)URLDecodedString{
    return [self stringByRemovingPercentEncoding];
}

/** 根据size计算文件大小 */
+ (NSString *)stringWithSize:(NSInteger)size{
    if (size < 1024) {
        return [NSString stringWithFormat:@"%ldkB",(long)size];
    }else if (size < 1024*1024){
        return [NSString stringWithFormat:@"%.1fMB",size / 1024.0];
    }else if (size < 1024*1024*1024){
        return [NSString stringWithFormat:@"%.1fGB",size / 1024.0 / 1024.0];
    }else{
        return [NSString stringWithFormat:@"%.1fTB",size / 1024.0 / 1024.0 / 1024.0];
    }
    return nil;
}

/** 根据时间戳获取字符串 */
+ (NSString *)stringWithTimeInterval:(NSTimeInterval)timeInterval useDateFormatter:(NSDateFormatter *)dateFormatter{
    if (!dateFormatter) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateFormatter stringFromDate:date];
}

/** 时间戳转换时间 */
- (NSString *)stringWithDataFormatter:(NSString *)dateFormatter{
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = (dateFormatter) ? dateFormatter : @"yyyy-MM-dd HH:mm";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(self.length == 10) ? [self integerValue] : [self integerValue] * 1000];
    return [formatter stringFromDate:date];
}

/** 标准时间格式转化成任意格式*/
- (NSString *)transTimeWithDateFormatter:(NSString *)dateFormatter {
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setTimeZone:[NSTimeZone localTimeZone]]; //设置本地时区
    [dateFormatter1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter1 dateFromString:self];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];//时间戳
    return [timeSp stringWithDataFormatter:dateFormatter];
}

/** 时间戳转换成时间(刚刚、几分钟前、几小时前形式) */
- (NSString *)translateDateFormatter:(NSString *)dateFormatter{
    NSTimeInterval timeInterval = (self.length == 10) ? [self integerValue] : [self integerValue] * 1000;
    NSTimeInterval currentTimeInterval = [NSDate date].timeIntervalSince1970;
    NSInteger seconds = currentTimeInterval - timeInterval; // 时间差
    if (seconds < 60) {
        return @"刚刚";
    }else if (seconds < 60 * 60){
        return [NSString stringWithFormat:@"%ld分钟前",seconds / 60];
    }else if (seconds < 60 * 60 * 24){
        return [NSString stringWithFormat:@"%ld小时前",seconds / 60 /60];
    }else{
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = (dateFormatter) ? dateFormatter : @"yyyy-MM-dd HH:mm";
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        return [formatter stringFromDate:date];
    }
    return nil;
}

- (NSArray *)getSeparatedLinesFromLabel:(UILabel *)label
{
    NSString *text = [label text];
    UIFont *font = [label font];
    CGRect rect = [label frame];
    CTFontRef myFont = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)myFont range:NSMakeRange(0, attStr.length)];
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0,0,rect.size.width,100000));
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
    
    NSArray *lines = (__bridge NSArray *)CTFrameGetLines(frame);
    NSMutableArray *linesArray = [[NSMutableArray alloc]init];
    
    for (id line in lines){
        CTLineRef lineRef = (__bridge CTLineRef )line;
        CFRange lineRange = CTLineGetStringRange(lineRef);
        NSRange range = NSMakeRange(lineRange.location, lineRange.length);
        NSString *lineString = [text substringWithRange:range];
        [linesArray addObject:lineString];
    }
    return linesArray;
}

/**
 按行数截取字符串
 
 @param lines 要截取的行数
 @param width 字符串宽度
 @return 截取后的字符串
 */
- (NSString *)subStringWithLines:(int)lines width:(CGFloat)width font:(UIFont *)font{
    if (self.length > 0) {
        NSArray *textArray = [self componentsSeparatedByFont:font width:width];
        if (lines <= textArray.count) {
            NSMutableString *mStr = [NSMutableString string];
            for (int i = 0; i < lines; i++) {
                [mStr appendString:textArray[i]];
            }
            return mStr;
        }else{
            // 如果行数不够的话直接返回原字符串
            return self;
        }
    }
    return @"";
}
/**
 将文字按行分割成字符串
 
 @param font 字体
 @param width 字符串宽度
 @return 字符串数组
 */
- (NSArray<NSString *> *)componentsSeparatedByFont:(UIFont *)font width:(CGFloat)width{
    if (self.length > 0) {
        CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)([font fontName]), [font pointSize], NULL);
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:self];
        [attStr addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0, attStr.length)];
        CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attStr);
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0,0,width,MAXFLOAT));
        CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, 0), path, NULL);
        CFArrayRef linesRef = CTFrameGetLines(frame);
        NSArray *linesArr = (__bridge NSArray *)linesRef;
        NSMutableArray *linesArray = [[NSMutableArray alloc]init];
        for (id line in linesArr){
            CTLineRef lineRef = (__bridge CTLineRef )line;
            CFRange lineRange = CTLineGetStringRange(lineRef);
            NSRange range = NSMakeRange(lineRange.location, lineRange.length);
            NSString *lineString = [self substringWithRange:range];
            [linesArray addObject:lineString];
        }
        return linesArray;
    }else{
        return @[];
    }
    
}

/**
 过滤html标签
 
 @param html htmt字符串
 @return 过滤后的文字
 */
+ (NSString *)filterHTML:(NSString *)html{
    if (html.length > 0) {
        NSScanner * scanner = [NSScanner scannerWithString:html];
        NSString * text = nil;
        while([scanner isAtEnd]==NO){
            [scanner scanUpToString:@"<" intoString:nil];
            [scanner scanUpToString:@">" intoString:&text];
            html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
        }
        return html;
    }else{
        return @"";
    }
    
}

/** 根据<p>标签分隔html字符串 */
- (NSArray<NSString *> *)componentsSeparatedByTapP{
    if (self.length > 0) {
        NSRange range = [self rangeOfString:@"</p>"];
        if (range.location == NSNotFound) { // 判断有没有完整的p标签
            return @[self];
        }else{
            NSString *string = [NSString stringWithString:self];
            NSScanner *scanner = [NSScanner scannerWithString:string];
            NSString *text = nil;
            NSMutableArray *array = [NSMutableArray array];
            while (![scanner isAtEnd]) {
                string = [string substringFromIndex:text.length];
                if (string.length == 0) {
                    break;
                }
                [scanner scanUpToString:@"<p" intoString:nil];
                [scanner scanUpToString:@"</p>" intoString:&text];
                text = [NSString stringWithFormat:@"%@</p>",text];
                [array addObject:text];
            }
            return array;
        }
    }else{
        return @[];
    }
}

//获取阿里oss fileKey
+ (NSString *)getAliOSSConstrainURL:(NSString *)fileKey {
    
    NSString * constrainURL = nil;
    
    // sign constrain url
    NSLog(@"%@",[SFAliOSSManager sharedInstance].client);
    OSSTask * task = [[SFAliOSSManager sharedInstance].client presignConstrainURLWithBucketName:[SFInstance shareInstance].bucketName
                                                                                  withObjectKey:fileKey
                                                                         withExpirationInterval: 30 * 60];
    
    if (!task.error) {
        constrainURL = task.result;
    } else {
        NSLog(@"error: %@", task.error);
    }
    return constrainURL;
}

//手机号码正则
+ (BOOL)valiMobile:(NSString *)mobile {
    if (mobile.length != 11) {
        return NO;
    }
    
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,155,156,170,171,175,176,185,186
     * 电信号段: 133,149,153,170,173,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[0135678]|8[0-9])\\d{8}$";
    
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,155,156,170,171,175,176,185,186
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[56]|7[0156]|8[56])\\d{8}$";
    
    /**
     * 中国电信：China Telecom
     * 133,149,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[3]|4[9]|53|7[037]|8[019])\\d{8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobile] == YES) ||
        ([regextestcm evaluateWithObject:mobile] == YES) ||
        ([regextestct evaluateWithObject:mobile] == YES) ||
        ([regextestcu evaluateWithObject:mobile] == YES)) {
        return YES;
    }else {
        return NO;
    }
}

//将可能存在model数组转化为普通数组
+ (id)arrayOrDicWithObject:(id)origin {
    if ([origin isKindOfClass:[NSArray class]]) {
        //数组
        NSMutableArray *array = [NSMutableArray array];
        for (NSObject *object in origin) {
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger [array addObject:object];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [array addObject:[self arrayOrDicWithObject:(NSArray *)object]];
                
            } else {
                //model
                [array addObject:[self dicFromObject:object]];
                
            }
            
        }
        return [array copy];
    } else if ([origin isKindOfClass:[NSDictionary class]]) {
        //字典
        NSDictionary *originDic = (NSDictionary *)origin;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        for (NSString *key in originDic.allKeys) {
            id object = [originDic objectForKey:key];
            if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
                //string , bool, int ,NSinteger
                [dic setObject:object forKey:key];
                
            } else if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
                //数组或字典
                [dic setObject:[self arrayOrDicWithObject:object] forKey:key];
                
            } else {
                //model
                [dic setObject:[self dicFromObject:object] forKey:key];
                
            }
            
        }
        return [dic copy];
        
    }
    return [NSNull null];
}

//model转化为字典
+ (NSDictionary *)dicFromObject:(NSObject *)object {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *propertyList = class_copyPropertyList([object class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        const char *cName = property_getName(property);
        NSString *name = [NSString stringWithUTF8String:cName];
        NSObject *value = [object valueForKey:name];
        //valueForKey返回的数字和字符串都是对象
        if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
            //string , bool, int ,NSinteger
            [dic setObject:value forKey:name];
            
        } else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
            //字典或字典
            [dic setObject:[self arrayOrDicWithObject:(NSArray*)value] forKey:name];
            
        } else if (value == nil) {
            //null
            //[dic setObject:[NSNull null] forKey:name];//这行可以注释掉?????
            
        } else {
            //model
            [dic setObject:[self dicFromObject:value] forKey:name];
            
        }
        
    }
    return [dic copy];
    
}

//获取当前时间戳
+(NSString*)getCurrentTimes {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
    
}

+ (NSString *)getThisWeek:(NSString *)date {
    
    NSString * week = [date isEqualToString:@"1"]?@"周一":
    [date isEqualToString:@"2"]?@"周二":
    [date isEqualToString:@"3"]?@"周三":
    [date isEqualToString:@"4"]?@"周四":
    [date isEqualToString:@"5"]?@"周五":
    [date isEqualToString:@"6"]?@"周六":@"周日";
    
    return week;
}

+ (BOOL)judgeTimeByStartAndEnd:(NSString *)startTime withExpireTime:(NSString *)expireTime {
    
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    // 时间格式,此处遇到过坑,建议时间HH大写,手机24小时进制和12小时禁止都可以完美格式化
    [dateFormat setDateFormat:@"HH:mm"];
    NSString * todayStr=[dateFormat stringFromDate:today];//将日期转换成字符串
    today=[ dateFormat dateFromString:todayStr];//转换成NSDate类型。日期置为方法默认日期
    //startTime格式为 02:22   expireTime格式为 12:44
    NSDate *start = [dateFormat dateFromString:startTime];
    NSDate *expire = [dateFormat dateFromString:expireTime];
    
    if ([today compare:start] == NSOrderedDescending && [today compare:expire] == NSOrderedAscending) {
        return YES;
    }
    return NO;
}

//两个时间相差多少天多少小时多少分多少秒
+ (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime withFormatter:(NSString *)formatter{
    
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:formatter];
    
    NSDate *startDate =[date dateFromString:startTime];
    NSDate *endDdate = [date dateFromString:endTime];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponents = [cal components:unitFlags fromDate:startDate toDate:endDdate options:0];
    
    // 天
    NSInteger day = [dateComponents day];
    // 小时
    NSInteger house = [dateComponents hour];
    // 分
    NSInteger minute = [dateComponents minute];
    // 秒
    NSInteger second = [dateComponents second];
    
    NSString *timeStr;
    
    if (day != 0) {
        if ([formatter isEqualToString:@"yyyy-MM-dd hh:mm"]){
            timeStr = [NSString stringWithFormat:@"%zd天%zd小时%zd分",day,house,minute];
        }else{
            timeStr = [NSString stringWithFormat:@"%zd天%zd小时%zd分%zd秒",day,house,minute,second];
        }
        
    }
    else if (day==0 && house !=0) {
        if ([formatter isEqualToString:@"yyyy-MM-dd hh:mm"]){
            timeStr = [NSString stringWithFormat:@"%zd小时%zd分",house,minute];
        }else{
            timeStr = [NSString stringWithFormat:@"%zd小时%zd分%zd秒",house,minute,second];
        }
        
    }
    else if (day==0 && house==0 && minute!=0) {
        if ([formatter isEqualToString:@"yyyy-MM-dd hh:mm"]) {
            timeStr = [NSString stringWithFormat:@"%zd分",minute];
        }else{
            timeStr = [NSString stringWithFormat:@"%zd分%zd秒",minute,second];
        }
    }
    else{
        if ([formatter isEqualToString:@"yyyy-MM-dd hh:mm"]) {
            
            timeStr = [NSString stringWithFormat:@"0分"];
        }else{
            timeStr = [NSString stringWithFormat:@"%zd秒",second];
        }
        
    }
    
    return timeStr;
}
   
@end
