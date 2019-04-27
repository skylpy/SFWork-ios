//
//  SFExpenseModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/26.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class ExpenseListModel;
@interface SFExpenseModel : NSObject

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

@property (nonatomic, copy) NSString *limitCount;

+ (NSArray *)shareCostListModel;
+ (NSArray *)shareAddCostModel;
+ (NSArray *)shareSearchItemArray;
+ (NSArray *)shareAddSixCostModel;
+ (NSArray *)shareCostDateilModel:(ExpenseListModel *)model;


@end

@interface SFApprpvalModel : NSObject

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detitle;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isClick;
+ (NSArray *)apprpvalModel;
+ (NSArray *)apprpvalSixModel;
+ (NSArray *)apprpvalModel:(ExpenseListModel *)model;
@end


NS_ASSUME_NONNULL_END
