//
//  SFPunchClockTimeViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class AttendanceDateModel;
@interface SFPunchClockTimeViewController : SFBaseViewController

@property (nonatomic, copy) NSArray *array;
@property (nonatomic, copy) void (^selectTimeClick)(AttendanceDateModel * model);
@property (nonatomic, copy) void (^selectTimesClick)(NSArray * array);

@end

NS_ASSUME_NONNULL_END
