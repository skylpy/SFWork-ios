//
//  SFFileDateilViewController.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFBaseViewController.h"
#import "SFFilesMgrModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFFileDateilViewController : SFBaseViewController

@property (nonatomic, strong) SFFilesModel * model;

@end

@interface SFFileImageCell : UITableViewCell

- (void)conforfilesModel:(NSDictionary *)dict withIndex:(NSInteger)row;

@property (nonatomic, strong) NSDictionary *dict;

@end

NS_ASSUME_NONNULL_END
