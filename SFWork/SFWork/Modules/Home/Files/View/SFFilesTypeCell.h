//
//  SFFilesTypeCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFFilesMgrModel.h"
NS_ASSUME_NONNULL_BEGIN
@protocol SFFilesTypeCellDelegate <NSObject>

- (void)selectFile:(SFFilesModel *)model;
- (void)goDateilFile:(SFFilesModel *)model;
@end
@interface SFFilesTypeCell : UITableViewCell

@property (nonatomic, strong) SFFilesModel *model;
@property (nonatomic, weak) id <SFFilesTypeCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
