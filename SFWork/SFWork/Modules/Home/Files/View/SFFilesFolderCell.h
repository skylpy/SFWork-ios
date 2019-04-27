//
//  SFFilesFolderCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFFilesMgrModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol SFFilesFolderCellDelegate <NSObject>

- (void)selectFolder:(SFFilesModel *)model;

@end

@interface SFFilesFolderCell : UITableViewCell

@property (nonatomic, strong) SFFilesModel *model;

@property (nonatomic, weak) id <SFFilesFolderCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
