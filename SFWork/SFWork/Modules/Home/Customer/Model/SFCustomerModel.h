//
//  SFCustomerModel.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/13.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CustomerType){
    //以下是枚举成员
    customerType = 0,//客户类型
    businessType = 1//商家类型
    
};

@class ClientLinkModel,SFClientModel;

@interface SFCustomerModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *stars;
@property (nonatomic, copy) NSString *destitle;
@property (nonatomic, copy) NSString *descolor;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) BOOL isClick;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *limitCount;

//添加客户
+ (NSArray *)shareCustomerModel:(CustomerType)type;
+ (NSMutableDictionary *)pramCustomerJson:(NSArray *)data;
//详情数据
+ (NSArray *)shareDateilModel:(CustomerType)type withModel:(SFClientModel *)model;
//新增联系人
+ (NSArray *)shareContactsModel;
+ (NSMutableDictionary *)pramContactsJson:(NSArray *)data;

//编辑
+ (NSArray *)shareCustomerModel:(SFClientModel *)model withType:(CustomerType)type;
//搜索
+ (NSArray *)shareSearchModel:(CustomerType)type;
//Search
+ (NSMutableDictionary *)pramSearchJson:(NSArray *)data;
@end

@interface SFClientModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *clientGroup;
//客户名称
@property (nonatomic, copy) NSString *name;
//客户所属
@property (nonatomic, copy) NSString *clientBelong;
@property (nonatomic, copy) NSString *belongToWhoID;
@property (nonatomic, copy) NSString *typeId;
//类型名称
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *levelId;
//等级名称
@property (nonatomic, copy) NSString *levelName;
@property (nonatomic, copy) NSString *areaId;
//区域名称
@property (nonatomic, copy) NSString *areaName;
@property (nonatomic, copy) NSString *intentionId;
//意图名称
@property (nonatomic, copy) NSString *intentionName;
//经手人名称
@property (nonatomic, copy) NSString *operatorName;
@property (nonatomic, copy) NSString *operatorId;

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *detailedAddress;

@property (nonatomic, strong) NSArray *photos;
//备注
@property (nonatomic, copy) NSString *note;
@property (nonatomic, strong) NSArray <ClientLinkModel *> *clientLinkmanDTOList;


@end

@interface ClientLinkModel : NSObject

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *tel;
@property (nonatomic, assign) BOOL major;
@property (nonatomic, copy) NSString *gender;
@property (nonatomic, copy) NSString *department;
@property (nonatomic, copy) NSString *duty;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *weChat;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *fax;
@property (nonatomic, copy) NSString *birth;
@property (nonatomic, copy) NSString *note;

@end

NS_ASSUME_NONNULL_END
