//
//  SFPointAnnotation.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/15.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFPointAnnotation : MAPointAnnotation

//区分符号
@property (nonatomic, assign) NSInteger siteNumber;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
