//
//  SFFilesMgrViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFFilesMgrModel.h"
NS_ASSUME_NONNULL_BEGIN

@class SFFilesModel;
@interface SFFilesMgrViewController : SFBaseViewController

@property (nonatomic, copy) NSString *parentId;
@property (nonatomic, copy) NSString *type;

//当前文件夹名称
@property (nonatomic, strong) SFFilesModel * model;

@end

NS_ASSUME_NONNULL_END
