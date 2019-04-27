//
//  SFServiceAgreeCell.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/22.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFServiceAgreeCell : UITableViewCell

@property (nonatomic, copy) void (^selectClick)(UIButton * sender);
@property (nonatomic, copy) void (^serviceClick)(void);
@end

NS_ASSUME_NONNULL_END
