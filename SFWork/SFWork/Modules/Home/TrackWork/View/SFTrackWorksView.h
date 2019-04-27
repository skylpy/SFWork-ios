//
//  SFTrackWorkView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface SFTrackWorksModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *destitle;
@property (nonatomic, assign) NSInteger type;

+ (NSArray *)shareTrackModel ;

+ (instancetype)comfirmModelWith:(NSString *)title withIcon:(NSString *)icon withDestitle:(NSString *)destitle withType:(NSInteger)type;

@end

@interface SFTrackWorksView : UIView

+ (instancetype)shareSFTrackWorkView;
@property (nonatomic, copy) void (^selectTrackClick)(SFTrackWorksModel *);
@property (nonatomic, copy) NSArray *array;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
