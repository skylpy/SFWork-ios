//
//  SFAliOSSManager.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>



typedef void(^CompeleteBlock)(NSArray * nameArray);
typedef void(^CompeleteVideoBlock)(NSString * videoString);
typedef void(^ErrorBlock)(NSString * errrInfo);
NS_ASSUME_NONNULL_BEGIN

@interface SFAliOSSManager : NSObject

+ (instancetype)sharedInstance;

/* 完成回调 */
@property(copy,nonatomic) CompeleteBlock  compelete ;
@property(copy,nonatomic) CompeleteVideoBlock  compeleteVideoBlock ;
/* 失败回调 */
@property(copy,nonatomic) ErrorBlock error ;
@property (nonatomic, strong) OSSClient * client;

- (void)download:(NSString *)objectKey;

/** 异步上传*/
- (void)asyncUploadMultiImages:(NSArray *)images withFile:(NSString *)fileName withFolderName:(NSString *)folderName CompeleteBlock:(CompeleteBlock)compelete ErrowBlock:(ErrorBlock)error;

/** 异步上传*/
- (void)uploadObjectAsyncWithURL:(NSURL *)URLString withFile:(NSString *)fileName withFolderName:(NSString *)folderName CompeleteBlock:(CompeleteVideoBlock)compelete ErrowBlock:(ErrorBlock)error;

@end

NS_ASSUME_NONNULL_END
