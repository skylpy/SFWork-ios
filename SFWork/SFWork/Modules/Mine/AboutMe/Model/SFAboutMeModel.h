//
//  SFAboutMeModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFAboutMeModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detitle;
@property (nonatomic, copy) NSString *controller;
@property (nonatomic, assign) NSInteger type;


+ (NSArray *)shareAboutModel;

@end

NS_ASSUME_NONNULL_END
