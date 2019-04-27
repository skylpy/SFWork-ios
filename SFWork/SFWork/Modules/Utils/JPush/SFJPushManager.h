//
//  SFJPushManager.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SFJPushManager : NSObject

+(SFJPushManager *)shareJPushManager;

// 在应用启动的时候调用
- (void)setupWithOption:(NSDictionary *)launchingOption
                     appKey:(NSString *)appKey
                    channel:(NSString *)channel
           apsForProduction:(BOOL)isProduction
      advertisingIdentifier:(NSString *)advertisingId;

// 在appdelegate注册设备处调用
- (void)registerDeviceToken:(NSData *)deviceToken;

//设置角标
- (void)setBadge:(int)badge;

//获取注册ID
- (void)getRegisterIDCallBack:(void(^)(NSString *registerID))completionHandler;

//处理推送信息
- (void)handleRemoteNotification:(NSDictionary *)remoteInfo;

@end

NS_ASSUME_NONNULL_END
