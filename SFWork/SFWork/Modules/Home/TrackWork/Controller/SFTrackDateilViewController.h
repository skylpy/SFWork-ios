//
//  SFTrackDateilViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
@class TrackModel;
@interface SFTrackDateilViewController : SFBaseViewController

@property (nonatomic, copy) NSArray *data;

@end

@interface TrackModel : NSObject

@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *address;

@end


NS_ASSUME_NONNULL_END
