//
//  SFAnnounceModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/4/6.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAnnounceModel.h"
#import "SFAnnounceHttpModel.h"

@implementation SFAnnounceModel

+ (NSMutableDictionary *)pramMyAnnounceJson:(NSArray *)data {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    [data enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        SFAnnounceModel * model = (SFAnnounceModel *)obj;
        switch (model.type) {
            case 1:
                [dict setValue:model.destitle forKey:@"title"];
                break;
            case 2:
                [dict setValue:model.destitle forKey:@"publishTime"];
                break;
                
            case 4:
                [dict setValue:model.destitle forKey:@"content"];
                break;
            
            default:
                break;
        }
    }];
    return dict;
}


+ (NSArray *)shareDateilAnnounceModel:(SFAnnounceListModel *)model {
    
    
    SFAnnounceModel * model1 = [SFAnnounceModel manageTitle:@"标题：" withDestitle:model.title withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:1 withValue:@"" withPersons:@[]];
    
    
    SFAnnounceModel * model2 = [SFAnnounceModel manageTitle:@"发布时间：" withDestitle:model.createTime withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    
    NSString * title = @"";
    for (int i = 0; i < model.informationUserList.count; i ++) {
        InformationUserModel * user = model.informationUserList[i];
        if (i == 0) {
            title = user.name;
        }else{
            title = [NSString stringWithFormat:@"%@ %@",title,user.name];
        }
    }
    SFAnnounceModel * model3 = [SFAnnounceModel manageTitle:@"接收人：" withDestitle:title withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:YES withType:3 withValue:@"" withPersons:@[]];
    
    
    SFAnnounceModel * model4 = [SFAnnounceModel manageTitle:@"公告内容：" withDestitle:model.content withPlaceholder:@"" withStars:@"*" withDescolor:@"" withClick:NO withType:4 withValue:@"" withPersons:@[]];
    
    
    SFAnnounceModel * model5 = [SFAnnounceModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]];
    
    
    
    
    return @[model1,model2,model3,model4,model5];
}

+ (NSArray *)shareAddAnnounceModel {
    
    
    SFAnnounceModel * model1 = [SFAnnounceModel manageTitle:@"标题：" withDestitle:@"" withPlaceholder:@"请输入标题" withStars:@"*" withDescolor:@"" withClick:YES withType:1 withValue:@"" withPersons:@[]];

    
    SFAnnounceModel * model2 = [SFAnnounceModel manageTitle:@"发布时间：" withDestitle:@"" withPlaceholder:@"请选择发布时间" withStars:@"*" withDescolor:@"" withClick:NO withType:2 withValue:@"" withPersons:@[]];
    
    SFAnnounceModel * model3 = [SFAnnounceModel manageTitle:@"接收人：" withDestitle:@"" withPlaceholder:@"请选择接收人" withStars:@"*" withDescolor:@"" withClick:NO withType:3 withValue:@"" withPersons:@[]];

    
    SFAnnounceModel * model4 = [SFAnnounceModel manageTitle:@"公告内容：" withDestitle:@"" withPlaceholder:@"请输入公告内容" withStars:@"*" withDescolor:@"" withClick:YES withType:4 withValue:@"" withPersons:@[]];

    
    SFAnnounceModel * model5 = [SFAnnounceModel manageTitle:@"相片：" withDestitle:@"" withPlaceholder:@"" withStars:@"" withDescolor:@"" withClick:NO withType:5 withValue:@"" withPersons:@[]];
    
    return @[model1,model2,model3,model4,model5];
}

+ (SFAnnounceModel *)manageTitle:(NSString *)title withDestitle:(NSString *)destitle withPlaceholder:(NSString *)placeholder withStars:(NSString *)stars withDescolor:(NSString *)descolor withClick:(BOOL)isClick withType:(NSInteger)type withValue:(NSString *)value withPersons:(NSArray *)persons{
    
    SFAnnounceModel * model = [[SFAnnounceModel alloc] init];
    model.title = title;
    model.descolor = descolor;
    model.stars = stars;
    model.destitle = destitle;
    model.isClick = isClick;
    model.placeholder = placeholder;
    model.type = type;
    model.value = value;
    model.persons = persons;
    
    return model;
}

@end
