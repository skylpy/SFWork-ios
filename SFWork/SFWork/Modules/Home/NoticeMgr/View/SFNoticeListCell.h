//
//  SFNoticeListCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFAnnounceHttpModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFNoticeListCell : UITableViewCell

@property (nonatomic, strong) SFAnnounceListModel * model;

@end

NS_ASSUME_NONNULL_END
