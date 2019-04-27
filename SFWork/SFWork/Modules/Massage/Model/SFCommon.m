//
//  SFCommon.m
//  SFWork
//
//  Created by fox on 2019/4/22.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import "SFCommon.h"

@implementation SFCommon
+(NSString*)getNULLString:(NSObject*)obj
{
    if (obj == nil||obj==NULL) {
        return @"";
    }
    if([obj isKindOfClass:[NSNull class]])
    {
        return @"";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString*)obj;
    }
    else if([obj isKindOfClass:[NSNumber class]])
    {
        NSNumber* number = (NSNumber*)obj;
        return  [number stringValue];
    }
    return @"";
}

+(NSString*)getNULLStringReturnZero:(NSObject*)obj{
    if (obj == nil||obj==NULL) {
        return @"0";
    }
    if([obj isKindOfClass:[NSNull class]])
    {
        return @"0";
    }
    if ([obj isKindOfClass:[NSString class]]) {
        return (NSString*)obj;
    }
    else if([obj isKindOfClass:[NSNumber class]])
    {
        NSNumber* number = (NSNumber*)obj;
        return  [number stringValue];
    }
    return @"0";
}

#pragma mark showAlterView
+ (void)ShowAlterViewWithTitle:(NSString *)title IsShowCancel:(BOOL)isCancel Message:(NSString *)message RootVC:(UIViewController *)rootVc SureBlock:(void(^)(void) )sureBlock{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              if (sureBlock) {
                                                                  sureBlock();
                                                              }
                                                          }];
    [alert addAction:defaultAction];
    if (isCancel) {
        UIAlertAction* canCelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 
                                                             }];
        [alert addAction:canCelAction];
    }
    
    [rootVc presentViewController:alert animated:YES completion:nil];
}

+ (NSDate *)stringToDate:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];//解决8小时时间差问题
    NSDate *birthdayDate = [dateFormatter dateFromString:dateStr];
    return birthdayDate;
}

+ (NSInteger)getDateMonthDay:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    [calendar rangeOfUnit:<#(NSCalendarUnit)#> inUnit:<#(NSCalendarUnit)#> forDate:<#(nonnull NSDate *)#>]
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

@end
