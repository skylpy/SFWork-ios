//
//  SFPowerModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/3.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFPowerModel.h"


@implementation SFPowerModel

+ (NSArray *)sharePowerListModel {
    
    SFPowerModel * model1 = [SFPowerModel manageTitle:@"我的考勤" withImage:@"icon_my_attendance_small" withController:@"" withPermission:YES withValue:@"" withCode:@"myCheckin"];
    SFPowerModel * model2 = [SFPowerModel manageTitle:@"考勤管理" withImage:@"icon_attendance_management_small" withController:@"" withPermission:YES withValue:@"" withCode:@"chenkinMgt"];
    SFPowerModel * model3 = [SFPowerModel manageTitle:@"任务管理" withImage:@"icon_task_management_small" withController:@"" withPermission:YES withValue:@"" withCode:@"task"];
    SFPowerModel * model4 = [SFPowerModel manageTitle:@"日报管理" withImage:@"icon_daily_management_small" withController:@"" withPermission:YES withValue:@"" withCode:@"daily"];
    SFPowerModel * model5 = [SFPowerModel manageTitle:@"通讯目录" withImage:@"icon_communication_directory_small" withController:@"" withPermission:YES withValue:@"" withCode:@"contacts"];
    SFPowerModel * model6 = [SFPowerModel manageTitle:@"实时查岗" withImage:@"icon_real_time_on_inspection_small" withController:@"" withPermission:YES withValue:@"" withCode:@"RT-Position"];
    SFPowerModel * model7 = [SFPowerModel manageTitle:@"工作轨迹" withImage:@"icon_work_iocus_small" withController:@"" withPermission:YES withValue:@"" withCode:@"track"];
    SFPowerModel * model8 = [SFPowerModel manageTitle:@"费用报销" withImage:@"icon_reimbursement_small" withController:@"" withPermission:YES withValue:@"" withCode:@"expense"];
    SFPowerModel * model9 = [SFPowerModel manageTitle:@"工作考核" withImage:@"icon_job_rating_small" withController:@"" withPermission:YES withValue:@"" withCode:@"workAssess"];
    SFPowerModel * model10 = [SFPowerModel manageTitle:@"数据汇报" withImage:@"icon_data_report_small" withController:@"" withPermission:YES withValue:@"" withCode:@"submitReport"];
    SFPowerModel * model11 = [SFPowerModel manageTitle:@"通知公告" withImage:@"icon_announcements_small" withController:@"" withPermission:YES withValue:@"" withCode:@"announcement"];
    SFPowerModel * model12 = [SFPowerModel manageTitle:@"客户管理" withImage:@"icon_customer_management_small" withController:@"" withPermission:YES withValue:@"" withCode:@"client"];
    SFPowerModel * model13 = [SFPowerModel manageTitle:@"电话拜访" withImage:@"icon_visit_management_small" withController:@"" withPermission:YES withValue:@"" withCode:@"telVisiting"];
    SFPowerModel * model14 = [SFPowerModel manageTitle:@"走访拜访" withImage:@"icon_visit_management_small" withController:@"" withPermission:YES withValue:@"" withCode:@"interviewVisiting"];
    
    NSArray * baseArray = @[model1,model2,model3,model4,model5,model6,model7,model8,model9,model10,model11,model12,model13,model14];
    
    SFPowerModel * pmodel1 = [SFPowerModel manageTitle:@"公司总账" withImage:@"icon_company_general_ledger_small" withController:@"" withPermission:YES withValue:@"" withCode:@"companyLedger"];
    SFPowerModel * pmodel2 = [SFPowerModel manageTitle:@"固定支出" withImage:@"icon_fixed_expenses_small" withController:@"" withPermission:YES withValue:@"" withCode:@"fixedCost"];
    SFPowerModel * pmodel3 = [SFPowerModel manageTitle:@"应收付款" withImage:@"icon_should_e_paying_small" withController:@"" withPermission:YES withValue:@"" withCode:@"receivable"];
    SFPowerModel * pmodel4 = [SFPowerModel manageTitle:@"应付账款" withImage:@"icon_accounts_payable_small" withController:@"" withPermission:YES withValue:@"" withCode:@"payable"];
    SFPowerModel * pmodel5 = [SFPowerModel manageTitle:@"财务录入" withImage:@"icon_financial_input_small" withController:@"" withPermission:YES withValue:@"" withCode:@"financeEntry"];
    SFPowerModel * pmodel6 = [SFPowerModel manageTitle:@"财务文件" withImage:@"icon_company_financial_file_small" withController:@"" withPermission:YES withValue:@"" withCode:@"financeFiles"];
    SFPowerModel * pmodel7 = [SFPowerModel manageTitle:@"薪资录入" withImage:@"icon_salary_small" withController:@"" withPermission:YES withValue:@"" withCode:@"salaryEntry"];
    SFPowerModel * pmodel8 = [SFPowerModel manageTitle:@"财务审批" withImage:@"icon_financial_examination_and_approval_small" withController:@"" withPermission:YES withValue:@"" withCode:@"financeAudit"];
    
    NSArray * caiArray = @[pmodel1,pmodel2,pmodel3,pmodel4,pmodel5,pmodel6,pmodel7,pmodel8];
    
    SFPowerModel * smodel1 = [SFPowerModel manageTitle:@"合同文件" withImage:@"icon_contract_management_small" withController:@"" withPermission:YES withValue:@"" withCode:@"contractsFiles"];
    SFPowerModel * smodel2 = [SFPowerModel manageTitle:@"企业设置" withImage:@"icon_enterprises_set_up_small" withController:@"" withPermission:YES withValue:@"" withCode:@"companySetting"];
    
    NSArray * xingzArr = @[smodel1,smodel2];
    
    SFPowerModel * gmodel1 = [SFPowerModel manageTitle:@"权限管理" withImage:@"icon_authority_management_small" withController:@"" withPermission:YES withValue:@"" withCode:@"permission"];
    SFPowerModel * gmodel2 = [SFPowerModel manageTitle:@"组织构架" withImage:@"icon_organizational_structure_small" withController:@"" withPermission:YES withValue:@"" withCode:@"organization"];
    SFPowerModel * gmodel3 = [SFPowerModel manageTitle:@"考核设置" withImage:@"icon_appraisal_management_small" withController:@"" withPermission:YES withValue:@"" withCode:@"assessSetting"];
    SFPowerModel * gmodel4 = [SFPowerModel manageTitle:@"撤销或恢复员工加减分数" withImage:@"icon_cancel_score_small" withController:@"" withPermission:YES withValue:@"" withCode:@"operateScore"];
    SFPowerModel * gmodel5 = [SFPowerModel manageTitle:@"给全部员工发布通知公告" withImage:@"icon_release_small" withController:@"" withPermission:YES withValue:@"" withCode:@""];
   
    NSArray * gaoArr = @[gmodel1,gmodel2,gmodel3,gmodel4,gmodel5];
    
    return @[baseArray,caiArray,xingzArr,gaoArr];
}

+ (NSArray *)shareAddPowerModel:(SFPowerListModel *)model withType:(NSString *)type {
    
    NSArray * array = @[];
    if ([type isEqualToString:@"DEPARTMENT"]) {
        NSString * title1 = model ? model.employeeName:@"请添加";
        SFPowerModel * model1 = [SFPowerModel manageTitle:@"成员"  withController:@"" withType:@"1" withPlaceholder:title1];
        NSString * title2 = model ? model.departmentName:@"请选择";
        SFPowerModel * model2 = [SFPowerModel manageTitle:@"部门选择"  withController:@"" withType:@"2" withPlaceholder:title2];
        NSString * title3 = model ? [NSString stringWithFormat:@"已分配%ld项权限",model.permissionIds.count]:@"请选择";
        SFPowerModel * model4 = [SFPowerModel manageTitle:@"分配权限"  withController:@"" withType:@"3" withPlaceholder:title3];
        array = @[model1,model2,model4];
    }
    if ([type isEqualToString:@"FINANCE"]||[type isEqualToString:@"ADMINISTRATION"]) {
        NSString * title1 = model ? model.employeeName:@"请添加";
        SFPowerModel * model1 = [SFPowerModel manageTitle:@"成员"  withController:@"" withType:@"1" withPlaceholder:title1];
        NSString * title3 = model ? [NSString stringWithFormat:@"已分配%ld项权限",model.permissionIds.count]:@"请选择";
        SFPowerModel * model4 = [SFPowerModel manageTitle:@"分配权限"  withController:@"" withType:@"3" withPlaceholder:title3];
        array = @[model1,model4];
    }
    if ([type isEqualToString:@"SUPERADMIN"]) {
        NSString * title1 = model ? model.employeeName:@"请添加";
        SFPowerModel * model1 = [SFPowerModel manageTitle:@"成员"  withController:@"" withType:@"1" withPlaceholder:title1];
        array = @[model1];
    }
    if ([type isEqualToString:@"TEMPORARY"]) {
        
        NSString * title1 = model ? model.employeeName:@"请添加";
        SFPowerModel * model1 = [SFPowerModel manageTitle:@"成员"  withController:@"" withType:@"1" withPlaceholder:title1];
        NSString * title2 = model ? model.startTime:@"请选择";
        SFPowerModel * model2 = [SFPowerModel manageTitle:@"开始时间"  withController:@"" withType:@"4" withPlaceholder:title2];
        
        NSString * title5 = model ? model.endTime:@"请选择";
        SFPowerModel * model5 = [SFPowerModel manageTitle:@"结束时间"  withController:@"" withType:@"5" withPlaceholder:title5];
        
        NSString * title3 = model ? [NSString stringWithFormat:@"已分配%ld项权限",model.permissionIds.count]:@"请选择";
        SFPowerModel * model4 = [SFPowerModel manageTitle:@"分配权限"  withController:@"" withType:@"3" withPlaceholder:title3];
        array = @[model1,model2,model5,model4];
    }
    
    
    return array;
    
}


+ (NSArray *)sharePowerModel{
    
    SFPowerModel * model1 = [SFPowerModel manageTitle:@"设置部门管理员"  withController:@"" withType:@"DEPARTMENT" withPlaceholder:@""];
    SFPowerModel * model2 = [SFPowerModel manageTitle:@"设置财务人员"  withController:@"" withType:@"FINANCE" withPlaceholder:@""];
    SFPowerModel * model3 = [SFPowerModel manageTitle:@"设置行政人员"  withController:@"" withType:@"ADMINISTRATION" withPlaceholder:@""];
    SFPowerModel * model4 = [SFPowerModel manageTitle:@"设置超级管理员(老板)"  withController:@"" withType:@"SUPERADMIN" withPlaceholder:@""];
    SFPowerModel * model5 = [SFPowerModel manageTitle:@"设置临时权限"  withController:@"" withType:@"TEMPORARY" withPlaceholder:@""];
    
    return @[model1,model2,model3,model4,model5];
    
}

+ (SFPowerModel *)manageTitle:(NSString *)title withController:(NSString *)controller withType:(NSString * )type withPlaceholder:(NSString *)placeholder{
    
    SFPowerModel * model = [[SFPowerModel alloc] init];
    model.title = title;
    model.controller = controller;
    model.placeholder = placeholder;
    model.type = type;
    
    return model;
}

+ (SFPowerModel *)manageTitle:(NSString *)title withImage:(NSString *)icon withController:(NSString *)controller withPermission:(BOOL)permission withValue:(NSString *)value withCode:(NSString *)code{
    
    SFPowerModel * model = [[SFPowerModel alloc] init];
    model.title = title;
    model.icon = icon;
    model.controller = controller;
    model.hasPermission = permission;
    model.code = code;
    return model;
}


@end
