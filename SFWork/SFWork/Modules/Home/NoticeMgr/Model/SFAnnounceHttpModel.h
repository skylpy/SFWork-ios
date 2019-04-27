//
//  SFAnnounceHttpModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SFAnnounceListModel,InformationUserModel;
@interface SFAnnounceHttpModel : NSObject

/**
 * des: 获取公告列表
 * author:SkyWork
 */
+(void)getAnnounceList:(NSDictionary *)prame
               success:(void (^)(NSArray <SFAnnounceListModel *>* list))success
               failure:(void (^)(NSError *))failure;

/**
 * des:  获取详情
 * author:SkyWork
 */
+(void)getApprovalDetails:(NSString *)a_id
                  success:(void (^)(SFAnnounceListModel * model))success
                  failure:(void (^)(NSError *))failure;
/**
 * des:保存发布修改
 * author:SkyWork
 */
+(void)submitInformation:(NSDictionary *)prame
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure;

/**
 * des:删除拜访
 * author:SkyWork
 */
+(void)deleteInformation:(NSString *)URLString
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *))failure ;

@end

@interface SFAnnounceListModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, copy) NSArray <InformationUserModel *>*informationUserList;
@property (nonatomic, copy) NSArray *informationUserIds;
@property (nonatomic, copy) NSString *infoEndTime;
@property (nonatomic, assign) BOOL publish;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *createName;
@property (nonatomic, copy) NSString *createId;

@end

@interface InformationUserModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
