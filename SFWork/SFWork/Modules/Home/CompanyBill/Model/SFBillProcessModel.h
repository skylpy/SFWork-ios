//
//  SFBillProcessModel.h
//  SFWork
//
//  Created by fox on 2019/4/22.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFBillProcessModel : LJBaseModel
@property (nonatomic, copy) NSString *ID;// 4028804069e793a10169e79a3f2d0005,
@property (nonatomic, copy) NSString *createTime;// 2019-04-04 17;//07;//19,
@property (nonatomic, copy) NSString *billId;// 4028804069e793a10169e79a3ef30004,
@property (nonatomic, copy) NSString *processorId;// 402880086950ab4c016950b1a4460002,
@property (nonatomic, copy) NSString *processorName;// 管理员,
@property (nonatomic, copy) NSString *processorAvatar;// https;////sanfan-public.oss-cn-hangzhou.aliyuncs.com/default/avatar.png,
@property (nonatomic, copy) NSString *processTime;// null,
@property (nonatomic, copy) NSString *processStage;// LISTER,
@property (nonatomic, copy) NSString *processResult;// APPROVING,
@property (nonatomic, copy) NSString *processStatus;// NOTSTART,
@property (nonatomic, copy) NSString *note;// null,
@property (nonatomic, copy) NSString *nextBillProcessId;// null
@end

NS_ASSUME_NONNULL_END
