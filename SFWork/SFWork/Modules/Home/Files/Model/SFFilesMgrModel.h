//
//  SFFilesMgrModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SFFilesModel;
@interface SFFilesMgrModel : NSObject

/**
 * des:重命名文件夹或文件
 * author:SkyWork
 */
+(void)renameOfficeFolder:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure;

/**
 * des:移动文件夹或文件
 * author:SkyWork
 */
+(void)removeOfficeFolder:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure;

/**
 * des:删除文件夹或文件
 * author:SkyWork
 */
+(void)deleteOfficeFolder:(NSDictionary *)prame
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *))failure;

/**
 * des:获取文件列表
 * author:SkyWork
 */
+(void)getOfficeFolder:(NSDictionary *)prame
               success:(void (^)(NSArray <SFFilesModel *> *lsit))success
               failure:(void (^)(NSError *))failure;
/**
 * des:添加文件夹
 * author:SkyWork
 */
+(void)addOfficeFolder:(NSDictionary *)prame
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure;

/** 设置OSSClient */
+ (void)setupOSSClient;

@end

@interface SFFilesModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *fileType;
@property (nonatomic, copy) NSString *companyId;
@property (nonatomic, copy) NSString *model;
@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *fileKey;
@property (nonatomic, assign) BOOL root;
@property (nonatomic, assign) BOOL folder;
@property (nonatomic, copy) NSString *creatorId;
@property (nonatomic, copy) NSString *path;
@property (nonatomic, copy) NSString *creatorName;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) BOOL isFolder;
@end

NS_ASSUME_NONNULL_END
