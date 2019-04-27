//
//  SFCommon.h
//  SFWork
//
//  Created by fox on 2019/4/22.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFCommon : NSObject

+(NSString*)getNULLString:(NSObject*)obj;
+(NSString*)getNULLStringReturnZero:(NSObject*)obj;
#pragma mark showAlterView
+ (void)ShowAlterViewWithTitle:(NSString *)title IsShowCancel:(BOOL)isCancel Message:(NSString *)message RootVC:(UIViewController *)rootVc SureBlock:(void(^)(void) )sureBlock;
+ (NSDate *)stringToDate:(NSString *)dateStr;
+ (NSInteger)getDateMonthDay:(NSDate *)date;
@end

NS_ASSUME_NONNULL_END
