//
//  SFRootViewController.h
//  SFWork
//
//  Created by fox on 2019/4/22.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SFRootViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) UITableViewStyle tableViewStyle;
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger pageSize;

- (void)mj_headerLoading;
- (void)mj_footLoading;

@end

NS_ASSUME_NONNULL_END
