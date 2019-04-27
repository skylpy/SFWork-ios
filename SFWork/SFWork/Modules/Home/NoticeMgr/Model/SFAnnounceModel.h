//
//  SFAnnounceModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class SFAnnounceListModel;
@interface SFAnnounceModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *stars;
@property (nonatomic, copy) NSString *destitle;
@property (nonatomic, copy) NSString *descolor;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *color;

@property (nonatomic, copy) NSArray *persons;


+ (NSArray *)shareAddAnnounceModel;
+ (NSArray *)shareDateilAnnounceModel:(SFAnnounceListModel *)model;
+ (NSMutableDictionary *)pramMyAnnounceJson:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
