//
//  SFSelectWeekView.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/16.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol SFSelectWeekViewDelegate <NSObject>

- (void)selectWeekValueArr:(NSArray *)valueArray withTitleArr:(NSArray *)titleArray;

@end

@class SFSelectWeekModel;
@interface SFSelectWeekView : UIView

+ (instancetype)shareSFSelectWeekView;
- (void)showView;
@property (nonatomic, copy) NSArray *data;
@property (nonatomic, weak) id <SFSelectWeekViewDelegate>delegate;
@end

@interface SFSelectWeekCell : UITableViewCell

@property (nonatomic, strong) SFSelectWeekModel *model;

@end

@interface SFSelectWeekModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign) BOOL isClick;

+ (NSArray *)manageSelectWeekModel;

@end

NS_ASSUME_NONNULL_END
