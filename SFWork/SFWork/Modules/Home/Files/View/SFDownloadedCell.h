//
//  SFDownloadedCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFDownloadManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFDownloadedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (nonatomic, strong) ZFSessionModel *sessionModel;
@end

NS_ASSUME_NONNULL_END
