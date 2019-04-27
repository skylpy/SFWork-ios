//
//  SFDownloadingCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFDownloadManager.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^SFDownloadBlock)(UIButton *);
@interface SFDownloadingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;


@property (nonatomic, copy  ) SFDownloadBlock downloadBlock;
@property (nonatomic, strong) ZFSessionModel  *sessionModel;
@end

NS_ASSUME_NONNULL_END
