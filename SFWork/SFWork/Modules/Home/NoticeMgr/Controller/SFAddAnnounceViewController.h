//
//  SFAddAnnounceViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFBaseTableCell.h"

NS_ASSUME_NONNULL_BEGIN

@class SFAnnounceModel;
@interface SFAddAnnounceViewController : SFBaseViewController


@end

@interface SFAnnounceTitleCell :SFBaseTableCell

@property (nonatomic, strong) SFAnnounceModel *model;
@property (nonatomic, copy) void (^inputChacneClick) (NSString * value);;

@end
NS_ASSUME_NONNULL_END
