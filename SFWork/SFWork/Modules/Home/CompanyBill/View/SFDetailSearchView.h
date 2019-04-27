//
//  SFDetailSearchView.h
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFDetailSearchView : UIView
@property (copy, nonatomic) void (^selectIndexBlock)(NSInteger index);//101 历史收入 102历史支出
@property (copy,nonatomic) NSString * titleStr;
- (void)createItemWithTitleArray:(NSArray *)titleArray;
@end

NS_ASSUME_NONNULL_END
