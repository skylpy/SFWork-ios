//
//  SFSelectEmpView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/14.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFSelectEmpView : UIView

+ (instancetype)shareSFSelectEmpView;

@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, copy) void (^selectEmpClick)(NSArray * list);

@end

@interface SFEmpButtonCell : UICollectionViewCell

@property (nonatomic, strong) SFOrgListModel * model;

@end

NS_ASSUME_NONNULL_END
