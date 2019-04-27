//
//  SFBillSearchModel.h
//  SFWork
//
//  Created by fox on 2019/4/17.
//  Copyright © 2019 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFBillInfoModel.h"

NS_ASSUME_NONNULL_BEGIN
@class SFFinancialModel;
@interface SFFinancialApprovalModel : NSObject
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

+ (NSArray *)shareSearchItemArray;
+ (NSArray *)shareShowItemArray :(SFFinancialModel *)model ;
+ (NSArray *)shareShowItemArrayWithModel:(SFBillInfoModel *)model;
+ (NSArray *)shareAddItemArray;
//+ (NSArray *)shareAddSixCostModel:(SFFinancialModel *)model;
+ (NSArray *)shareAddSixCostModelWithModel:(SFBillInfoModel *)model;
+ (NSArray *)shareAddFinanSixCostModel;

+ (NSMutableDictionary *)pramApprovalJson:(NSArray *)data;

@end

@interface SFFinaApprovalModel : NSObject

@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *detitle;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isClick;
+ (NSArray *)apprpvalModel:(SFFinancialModel *)model;
+ (NSArray *)apprpvalSixModel:(SFFinancialModel *)model;
+ (NSArray *)apprpvalSixShowModel:(SFBillInfoModel *)model;
+ (NSArray *)apprpvalShowModel:(SFBillInfoModel *)model;
+ (NSArray *)addFinaSixModel;

//+ (NSArray *)apprpvalModel:(ExpenseListModel *)model;
@end


NS_ASSUME_NONNULL_END
