//
//  SFRealTimeListViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class RealTimeListModel;
@interface SFRealTimeListViewController : SFBaseViewController

@property (nonatomic, strong) NSArray *data;

@end

@interface RealTimeListModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *minute;
@property (nonatomic, copy) NSString *smallAvatar;
@property (nonatomic, copy) NSString *speed;

@end

NS_ASSUME_NONNULL_END
