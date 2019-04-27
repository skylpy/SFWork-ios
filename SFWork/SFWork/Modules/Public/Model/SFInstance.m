//
//  SFInstance.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/5.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFInstance.h"
#import "SFNavigationViewController.h"

static SFInstance * instance;

@interface SFInstance (){
    SFUserInfo  *_userInfo;
    SFCompanyInfo   *_companyInfo;
    NSString    *_companyId;
    NSString    *_employeeId;
    NSString    *_token;
    NSString    *_type;
    NSString    *_validTime;
    NSString    *_bucketName;
    NSString    *_endpoint;
    NSString    *_expiration;
    NSString    *_rongCloud;
}


@property (nonatomic, copy) NSString *filePath;

@end

@implementation SFInstance


/** 注销账号 */
- (void)logout{
    
    SFInstance *instan = [SFInstance shareInstance] ;
    instan.token = nil;
    instan.companyId = nil;
    instan.employeeId = nil;
    instan.userInfo = nil;
    instan.companyInfo = nil;
    instan = nil;
    UIViewController * vc = [[UIStoryboard storyboardWithName:@"RegisterLogin" bundle:nil]
                             instantiateViewControllerWithIdentifier:@"SFLogin"];
    SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
    [[UIViewController getCurrentVC] presentViewController:nvs animated:YES completion:nil];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


#pragma mark- onceToken  初始化
+ (instancetype) shareInstance{
    @synchronized (self) {
        if (instance == nil) {
            return [[self alloc] init];
        }
    }
    return instance;
}


//获取expiration
- (NSString *)expiration{
    
    @synchronized (self) {
        if (!_expiration) {
            _expiration = [[NSUserDefaults standardUserDefaults] objectForKey:@"expiration"];
        }
    }
    return _expiration;
}
//设置expiration
- (void)setExpiration:(NSString *)expiration{
    
    if (![_expiration isEqualToString:expiration]) {
        _expiration = expiration;
        [[NSUserDefaults standardUserDefaults] setObject:expiration forKey:@"expiration"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


//获取endpoint
- (NSString *)endpoint{
    
    @synchronized (self) {
        if (!_endpoint) {
            _endpoint = [[NSUserDefaults standardUserDefaults] objectForKey:@"endpoint"];
        }
    }
    return _endpoint;
}
//设置endpoint
- (void)setEndpoint:(NSString *)endpoint{
    
    if (![_endpoint isEqualToString:endpoint]) {
        _endpoint = endpoint;
        [[NSUserDefaults standardUserDefaults] setObject:endpoint forKey:@"endpoint"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//获取bucketName
- (NSString *)bucketName{
    
    @synchronized (self) {
        if (!_bucketName) {
            _bucketName = [[NSUserDefaults standardUserDefaults] objectForKey:@"bucketName"];
        }
    }
    return _bucketName;
}
//设置bucketName
- (void)setBucketName:(NSString *)bucketName{
    
    if (![_bucketName isEqualToString:bucketName]) {
        _bucketName = bucketName;
        [[NSUserDefaults standardUserDefaults] setObject:bucketName forKey:@"bucketName"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 * des:归档用户资料
 * author:SkyWork
 */
- (void)setUserInfo:(SFUserInfo *)userInfo{
    if (_userInfo != userInfo) {
        _userInfo = userInfo;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_userInfo];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}

/**
 * des:归档公司资料
 * author:SkyWork
 */
- (void)setCompanyInfo:(SFCompanyInfo *)companyInfo{
    if (_companyInfo != companyInfo) {
        _companyInfo = companyInfo;
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_companyInfo];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"companyInfo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

/**
 * des:获取用户资料
 * author:SkyWork
 */
- (SFUserInfo *)userInfo{
    @synchronized(self) {
        if (!_userInfo) {
            NSData *userdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
            _userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:userdata];
        }
    }
    return _userInfo;
}

/**
 * des:获取公司资料
 * author:SkyWork
 */
- (SFCompanyInfo *)companyInfo {
    @synchronized(self) {
        if (!_companyInfo) {
            NSData *companydata = [[NSUserDefaults standardUserDefaults] objectForKey:@"companyInfo"];
            _companyInfo = [NSKeyedUnarchiver unarchiveObjectWithData:companydata];
        }
    }
    return _companyInfo;
}

//获取公司ID
- (NSString *)companyId{
    @synchronized (self) {
        if (!_companyId) {
            _companyId = [[NSUserDefaults standardUserDefaults] objectForKey:@"companyId"];
        }
    }
    return _companyId;
}

//设置公司ID
- (void)setCompanyId:(NSString *)companyId{
    if (![_companyId isEqualToString:companyId]) {
        _companyId = companyId;
        [[NSUserDefaults standardUserDefaults] setObject:companyId forKey:@"companyId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//获取管理员ID
- (NSString *)employeeId{
    
    @synchronized (self) {
        if (!_employeeId) {
            _employeeId = [[NSUserDefaults standardUserDefaults] objectForKey:@"employeeId"];
        }
    }
    return _employeeId;
}
//设置管理员ID
- (void)setEmployeeId:(NSString *)employeeId{
    if (![_employeeId isEqualToString:employeeId]) {
        _employeeId = employeeId;
        [[NSUserDefaults standardUserDefaults] setObject:employeeId forKey:@"employeeId"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//融云token
- (NSString *)rongCloud{
    
    @synchronized (self) {
        if (!_rongCloud) {
            _rongCloud = [[NSUserDefaults standardUserDefaults] objectForKey:@"rongCloud"];
        }
    }
    return _rongCloud;
}

//融云token
- (void)setRongCloud:(NSString *)rongCloud{
    if (![_rongCloud isEqualToString:rongCloud]) {
        _rongCloud = rongCloud;
        [[NSUserDefaults standardUserDefaults] setObject:rongCloud forKey:@"rongCloud"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//获取token
- (NSString *)token{
    
    @synchronized (self) {
        if (!_token) {
            _token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
        }
    }
    return _token;
}
//设置token
- (void)setToken:(NSString *)token{
    
    if (![_token isEqualToString:token]) {
        _token = token;
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

//获取类型
- (NSString *)type{
    
    @synchronized (self) {
        if (!_type) {
            _type = [[NSUserDefaults standardUserDefaults] objectForKey:@"type"];
        }
    }
    return _type;
}
//设置类型
- (void)setType:(NSString *)type{
    
    if (![_type isEqualToString:type]) {
        _type = type;
        [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"type"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
//获取有效期
- (NSString *)validTime{
    
    @synchronized (self) {
        if (!_validTime) {
            _validTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"validTime"];
        }
    }
    return _type;
}
//设置有效期
- (void)setValidTime:(NSString *)validTime{
    
    if (![_validTime isEqualToString:validTime]) {
        _validTime = validTime;
        [[NSUserDefaults standardUserDefaults] setObject:validTime forKey:@"validTime"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end

@implementation SFUserInfo

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"permissions" : [PermissionsModel class]};
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

@end


@implementation SFCompanyInfo

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}

@end

@implementation PermissionsModel

//+ (NSDictionary *)modelCustomPropertyMapper {
//    
//    return @{@"_id" : @"id"};
//}
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [self modelEncodeWithCoder:aCoder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    return [self modelInitWithCoder:aDecoder];
}


@end
