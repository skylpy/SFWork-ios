//
//  SFProfileModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFOrganizationModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SFProfileModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *stars;
@property (nonatomic, copy) NSString *destitle;
@property (nonatomic, copy) NSString *descolor;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *value;
//个人资料
+ (NSArray *)shareProfileModel:(SFEmployeesModel *)employees depName:(NSString *)depname withIsOrg:(BOOL)isOrg; 
//部门
+ (NSArray *)shareDepModel:(NSString *)parentName withParentId:(NSString *)parentId;
//部门设置
+ (NSArray *)shareDepSetModel:(SFOrgListModel *)model withDepName:(NSString *)depName withParentId:(NSString *)parentId;
+ (NSMutableDictionary *)pramGetDepSetJson:(NSArray *)data;
//获取部门数组
+ (NSMutableDictionary *)pramGetDepJson:(NSArray *)data;

//获取员工信息数组
+ (NSMutableDictionary *)pramEmployeeJson:(NSArray *)data;

+ (NSArray *)shareSalaryModel:(NSString *)empName withSalary:(NSString *)salary;

@end

NS_ASSUME_NONNULL_END
