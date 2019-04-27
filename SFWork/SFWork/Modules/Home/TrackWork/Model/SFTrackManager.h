//
//  SFTrackManager.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/15.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFTrackManager : NSObject

+ (instancetype) shareTrackManager;

//初始化轨迹管理
- (void)initTrackManager;
//开启服务
- (void)startTrackService ;
//轨迹采集
- (void)startTrackGather;
//停止服务
- (void)stopTrackService;

//查询历史轨迹
- (void)queryTrackHisAction;

- (void)queryTrackInfoAction;

@end

NS_ASSUME_NONNULL_END
