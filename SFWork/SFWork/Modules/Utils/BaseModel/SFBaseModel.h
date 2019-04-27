//
//  SFBaseModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseErrorModel;
@interface SFBaseModel : NSObject

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString *errorMsg;
@property (nonatomic, strong) id  result;

+ (void)BGET:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *task,SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

+ (void)BGETWithCache:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *task,BOOL fromCache, SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

+ (void)BPOST:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *task,SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

+ (void)BPOSTWithCache:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *task,BOOL fromCache, SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

+ (void)BPUT:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *task,SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

+ (void)DELETE:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *task,SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

+ (void)uploadImages:(NSString *)urlString parameters:(id)params images:(NSArray *)images keys:(NSArray *)keys success:(void (^)(NSURLSessionDataTask *task,SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;

+ (NSError *)errorFormatBaseModel:(SFBaseModel *)baseModel;

+ (NSString *)errorMessageFromError:(NSError *)error;

+ (void)BPOSTGroup:(NSString *)urlString parameters:(id)params success:(void (^)(NSURLSessionDataTask *task,SFBaseModel *model))success failure:(void (^)(NSURLSessionDataTask *task,NSError *error))failure;


@end

@interface BaseModel : NSObject

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSArray <BaseErrorModel *>*arguments;
@property (nonatomic, assign) NSInteger  errorCode;
@property (nonatomic, copy) NSString *errorMsg;

@end

@interface BaseErrorModel : NSObject

@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *msg;
@property (nonatomic, assign) BOOL status;

@end

NS_ASSUME_NONNULL_END
