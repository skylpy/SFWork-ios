//
//  SFSalaryEntryModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/18.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFSalaryEntryModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *destitle;
@property (nonatomic, copy) NSString *calculate;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger type;

+ (NSArray *)shareSalaryEntryModel;
/**
 * des:设置薪资
 * author:SkyWork
 */
+(void)empSetSalary:(NSDictionary *)prame
            success:(void (^)(void))success
            failure:(void (^)(NSError *))failure;

/**
 * des:设置薪资计算规则
 * author:SkyWork
 */
+(void)companySetSalaryRule:(NSDictionary *)prame
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *))failure;

@end

NS_ASSUME_NONNULL_END
