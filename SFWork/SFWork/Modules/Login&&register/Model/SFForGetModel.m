//
//  SFForGetModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/17.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFForGetModel.h"

@implementation SFForGetModel

+ (NSMutableDictionary *)pramJson:(NSArray *)data{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFForGetModel * model = (SFForGetModel *)obj;
        
        switch (model.type) {
            
            case 1:
                [dict setObject:model.value forKey:@"phone"];
                break;
            case 2:
                [dict setObject:model.value forKey:@"vercode"];
                break;
            case 3:
                [dict setObject:model.value forKey:@"password"];
                break;
            
                break;
        }
    }];
    return dict;
}

+ (NSArray *)shareForGetModel {
    
    SFForGetModel  * model1 = [SFForGetModel manageIcon:@"icon_phone_black_small" withValue:@"" withPlaceholder:@"请输入您的手机号码" withType:1 withClick:YES];
    SFForGetModel  * model2 = [SFForGetModel manageIcon:@"icon_code_black_small" withValue:@"" withPlaceholder:@"请输入验证码" withType:2 withClick:YES];
    SFForGetModel  * model3 = [SFForGetModel manageIcon:@"icon_lock_black_small" withValue:@"" withPlaceholder:@"请输入新密码" withType:3 withClick:YES];
    
    return @[model1,model2,model3];
}

+ (SFForGetModel *)addForGetModel {
    
    SFForGetModel  * model = [SFForGetModel manageIcon:@"icon_company_black_small" withValue:@"" withPlaceholder:@"请选择公司" withType:4 withClick:NO];
    return model;
}

+ (SFForGetModel *)manageIcon:(NSString *)icon withValue:(NSString *)value withPlaceholder:(NSString *)placeholder withType:(NSInteger)type withClick:(BOOL)isClick{
    
    SFForGetModel * model = [[SFForGetModel alloc] init];
    model.icon = icon;
    model.value = value;
    model.placeholder = placeholder;
    model.type = type;
    model.isClick = isClick;
    
    return model;
}

@end

@implementation ForGetModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"_id" : @"id"};
}

@end
