
//
//  SFRegisterModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/2.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFRegisterModel.h"
#import "HttpManager.h"
@implementation SFRegisterModel

+ (NSMutableDictionary *)pramJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    NSMutableArray * array = [NSMutableArray array];
    for (NSArray * arr in data) {
        
        for (SFRegisterModel * model in arr) {
            [array addObject:model];
        }
    }
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFRegisterModel * model = (SFRegisterModel *)obj;
        
        switch (model.type) {
            case 0:
                [dict setObject:model.value forKey:@"companyName"];
                break;
            case 1:
                 [dict setObject:model.value forKey:@"companyAccount"];
                break;
            case 2:
                [dict setObject:model.value forKey:@"areaId"];
                break;
            case 3:
                [dict setObject:model.value forKey:@"adminName"];
                break;
            case 4:
                [dict setObject:model.value forKey:@"phone"];
                break;
            case 5:
                [dict setObject:model.value forKey:@"vercode"];
                break;
            case 6:
                [dict setObject:model.value forKey:@"password"];
                break;
            default:
                [dict setObject:model.value forKey:@"invitationCode"];
                break;
        }
    }];
    return dict;
}

+ (NSArray *)shareRegisterModel{
    
    SFRegisterModel * company1 = [SFRegisterModel manageTitle:@"企业名称" withValue:@"" withPlaceholder:@"请输入企业的真实名称" withType:0 withClick:YES];
    SFRegisterModel * company2 = [SFRegisterModel manageTitle:@"企业账号" withValue:@"" withPlaceholder:@"建议公司拼音首字母加数字" withType:1 withClick:YES];
    SFRegisterModel * company3 = [SFRegisterModel manageTitle:@"企业地区" withValue:@"" withPlaceholder:@"请选择公司所在地区" withType:2 withClick:NO];
    
    NSArray * array1 = @[company1,company2,company3];
    
    SFRegisterModel * admin1 = [SFRegisterModel manageTitle:@"管理员名字" withValue:@"" withPlaceholder:@"请输入您的名字" withType:3 withClick:YES];
    SFRegisterModel * admin2 = [SFRegisterModel manageTitle:@"手机号码" withValue:@"" withPlaceholder:@"请输入手机号码" withType:4 withClick:YES];
    SFRegisterModel * admin3 = [SFRegisterModel manageTitle:@"验证码" withValue:@"" withPlaceholder:@"请输入验证码" withType:5 withClick:YES];
    SFRegisterModel * admin4 = [SFRegisterModel manageTitle:@"账号密码" withValue:@"" withPlaceholder:@"6位以上数字或字母" withType:6 withClick:YES];
    
    NSArray * array2 = @[admin1,admin2,admin3,admin4];
    
    SFRegisterModel * register1 = [SFRegisterModel manageTitle:@"推荐码" withValue:@"" withPlaceholder:@"请输入推荐码" withType:7 withClick:YES];
    
    NSArray * array3 = @[register1];
    
    SFRegisterModel * server = [SFRegisterModel manageTitle:@"" withValue:@"" withPlaceholder:@"" withType:8 withClick:YES];
    
    NSArray * array4 = @[server];
    
    return @[array1,array2,array3,array4];
    
}

+ (SFRegisterModel *)manageTitle:(NSString *)title withValue:(NSString *)value withPlaceholder:(NSString *)placeholder withType:(NSInteger)type withClick:(BOOL)isClick{
    
    SFRegisterModel * model = [[SFRegisterModel alloc] init];
    model.title = title;
    model.value = value;
    model.placeholder = placeholder;
    model.type = type;
    model.isClick = isClick;
    
    return model;
}


@end

@implementation SFRegHttpModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"token" : @"id"
             };
}

/**
 * des:获取城市j数据GET /common/getCityData
 * author:SkyWork
 */
+(void)getCityDataSuccess:(void (^)(NSArray<AddressModel *>*address))success
                  failure:(void (^)(NSError *))failure{
    
    [NoTokenManager LRGET:BASE_URL(getCityData) parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray * list = [NSArray modelArrayWithClass:[AddressModel class] json:responseObject];
        !success?:success(list);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !failure?:failure(error);
    }];
    
}

/**
 * des:企业注册
 * author:SkyWork
 */
+(void)registerCompany:(NSDictionary *)prame
               success:(void (^)(void))success
               failure:(void (^)(NSError *))failure{
    [NoTokenManager LRPOST:BASE_URL(regCompany) parameters:prame success:^(NSURLSessionDataTask *task, id responseObject) {
        [self userInformationModel:[SFRegHttpModel modelWithJSON:responseObject]];
        !success?:success();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !failure?:failure(error);
    }];
}

/**
 * des:注册登录归档用户信息
 * author:SkyWork
 */
+ (void)userInformationModel:(SFRegHttpModel *)model{
    
    SFInstance *instance = [SFInstance shareInstance];
    instance.companyId = model.companyId;
    instance.employeeId = model.employeeId;
    instance.token = model.token;
    instance.type = model.type;
    instance.validTime = model.validTime;
    instance.rongCloud = model.rongCloud;
}

/**
 * des:登录
 * author:SkyWork
 */
+(void)loginWithUser:(NSDictionary *)prame
             success:(void (^)(void))success
             failure:(void (^)(BaseModel *model))failure{
    [NoTokenManager LoginPOST:BASE_URL(login) parameters:prame success:^(NSURLSessionDataTask *task, id responseObject) {
        [self userInformationModel:[SFRegHttpModel modelWithJSON:responseObject]];
        !success?:success();
    } failure:^(BaseModel *model) {
        !failure?:failure(model);
    }];
    
}

/**
 * des:重置密码
 * author:SkyWork
 */
+(void)resetPwdWithUser:(NSDictionary *)prame
                success:(void (^)(void))success
                failure:(void (^)(NSError *))failure {
    
    [NoTokenManager LRPOST:BASE_URL(resetPwd) parameters:prame success:^(NSURLSessionDataTask *task, id responseObject) {
        
        !success?:success();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !failure?:failure(error);
    }];
}

/**
 * des:重置密码发送验证码
 * author:SkyWork
 */
+(void)resetPwdSendVercodes:(NSDictionary *)prame
                    success:(void (^)(NSArray <ForGetModel *> *list))success
                    failure:(void (^)(NSError *))failure {
    
    [NoTokenManager LRPOST:BASE_URL(resetPwdSendVercode) parameters:prame success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSArray * array = [NSArray modelArrayWithClass:[ForGetModel class] json:responseObject];
        !success?:success(array);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        !failure?:failure(error);
    }];
}


/**
 * des:获取当前公司信息
 * author:SkyWork
 */
+(void)getCompanyInfoSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BGET:BASE_URL(getCompanyInfo) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFCompanyInfo * company = [SFCompanyInfo modelWithJSON:model.result];
        [SFInstance shareInstance].companyInfo = company;
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

/**
 * des:获取当前员工资料
 * author:SkyWork
 */
+(void)getSelfInfoSuccess:(void (^)(void))success
                  failure:(void (^)(NSError *))failure{
    
    [SFBaseModel BGET:BASE_URL(getSelfInfo) parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, SFBaseModel * _Nonnull model) {
        
        SFUserInfo * user = [SFUserInfo modelWithJSON:model.result];
        [SFInstance shareInstance].userInfo = user;
        !success?:success();
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        !failure?:failure(error);
    }];
}

@end
