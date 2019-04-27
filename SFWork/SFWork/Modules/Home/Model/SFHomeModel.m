//
//  SFHomeModel.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/1.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFHomeModel.h"

@implementation SFHomeModel

+ (NSArray *)shareHomeModel{
    
    SFHomeModel * office1 = [SFHomeModel manageTitle:@"我的考勤" withImage:@"icon_my_attendance_big" withController:@"" withType:0 withValue:@"" withCode:@"myCheckin"];
    SFHomeModel * office2 = [SFHomeModel manageTitle:@"考勤管理" withImage:@"icon_attendance_management_big" withController:@"" withType:1 withValue:@"" withCode:@"chenkinMgt"];
    SFHomeModel * office3 = [SFHomeModel manageTitle:@"实时查岗" withImage:@"icon_real_time_on_inspection_big" withController:@"SFRealTimeWorkViewController" withType:2 withValue:@"" withCode:@"RT-Position"];
    SFHomeModel * office4 = [SFHomeModel manageTitle:@"工作轨迹" withImage:@"icon_work_iocus_big" withController:@"SFTrackWorkViewController" withType:3 withValue:@"" withCode:@"track"];
    SFHomeModel * office5 = [SFHomeModel manageTitle:@"通讯目录" withImage:@"icon_communication_directory_big" withController:@"SFMailListViewController" withType:4 withValue:@"" withCode:@"contacts"];
    SFHomeModel * office6 = [SFHomeModel manageTitle:@"日报管理" withImage:@"icon_daily_management_big" withController:@"SFJournalViewController" withType:5 withValue:@"" withCode:@"daily"];
    SFHomeModel * office7 = [SFHomeModel manageTitle:@"任务管理" withImage:@"icon_task_management_big" withController:@"SFTaskListViewController" withType:6 withValue:@"" withCode:@"task"];
    SFHomeModel * office8 = [SFHomeModel manageTitle:@"费用报销" withImage:@"icon_reimbursement_big" withController:@"" withType:7 withValue:@"" withCode:@"expense"];
    SFHomeModel * office9 = [SFHomeModel manageTitle:@"权限管理" withImage:@"icon_authority_management_big" withController:@"SFPowerMgrViewController" withType:8 withValue:@"" withCode:@"permission"];
    SFHomeModel * office10 = [SFHomeModel manageTitle:@"数据汇报" withImage:@"icon_data_report_big" withController:@"SFDataReportViewController" withType:9 withValue:@"" withCode:@"submitReport"];
    SFHomeModel * office11 = [SFHomeModel manageTitle:@"考核设置" withImage:@"icon_appraisal_management_big" withController:@"SFAssessmentSetViewController" withType:10 withValue:@"" withCode:@"assessSetting"];
//    SFWorkAssListViewController
    NSString * work = [[SFInstance shareInstance].userInfo.role isEqualToString:@"EMPLOYEE"] ? @"SFWorkAssessmentViewController": @"SFWorkAssListViewController";
    SFHomeModel * office12 = [SFHomeModel manageTitle:@"工作考核" withImage:@"icon_job_rating_big" withController:work withType:11 withValue:@"" withCode:@"workAssess"];
    
    SFHomeModel * office13 = [SFHomeModel manageTitle:@"通知公告" withImage:@"icon_announcements_big" withController:@"SFNoticeListViewController" withType:12 withValue:@"" withCode:@"announcement"];
    SFHomeModel * office14 = [SFHomeModel manageTitle:@"合同管理" withImage:@"icon_contract_management_big" withController:@"SFFilesMgrViewController" withType:13 withValue:@"" withCode:@"contractsFiles"];
    SFHomeModel * office15 = [SFHomeModel manageTitle:@"组织构架" withImage:@"icon_organizational_structure_big" withController:@"SFOrganizationViewController" withType:14 withValue:@"" withCode:@"organization"];
    
    NSArray * officeArr = @[office1,office2,office3,office4,office5,office6,office7,office8,office9,office10,office11,office12,office13,office14,office15];
    
    
    SFHomeModel * client1 = [SFHomeModel manageTitle:@"客户管理" withImage:@"icon_customer_management_big" withController:@"SFCustomerMgrViewController" withType:15 withValue:@"" withCode:@"client"];
    SFHomeModel * client2 = [SFHomeModel manageTitle:@"电话拜访" withImage:@"icon_telephone_call" withController:@"" withType:16 withValue:@"" withCode:@"telVisiting"];
    SFHomeModel * client3 = [SFHomeModel manageTitle:@"实地拜访" withImage:@"icon_visit_management_big" withController:@"" withType:17 withValue:@"" withCode:@"interviewVisiting"];
    
    NSArray * clientArr = @[client1,client2,client3];
    
    
    SFHomeModel * finance1 = [SFHomeModel manageTitle:@"公司总账" withImage:@"icon_company_general_ledger_big" withController:@"" withType:24 withValue:@"" withCode:@"companyLedger"];
    SFHomeModel * finance2 = [SFHomeModel manageTitle:@"财务录入" withImage:@"icon_financial_input_big"  withController:@"" withType:18 withValue:@"" withCode:@"financeEntry"];
    SFHomeModel * finance3 = [SFHomeModel manageTitle:@"固定支出" withImage:@"icon_fixed_expenses_big" withController:@"" withType:19 withValue:@"" withCode:@"fixedCost"];
    SFHomeModel * finance4 = [SFHomeModel manageTitle:@"应收付款" withImage:@"icon_should_e_paying_big" withController:@"" withType:20 withValue:@"" withCode:@"receivable"];
    SFHomeModel * finance5 = [SFHomeModel manageTitle:@"应付账款" withImage:@"icon_accounts_payable_big" withController:@"" withType:21 withValue:@"" withCode:@"payable"];
    SFHomeModel * finance6 = [SFHomeModel manageTitle:@"财务文件" withImage:@"icon_company_financial_file_big"  withController:@"SFFilesMgrViewController" withType:22 withValue:@"" withCode:@"financeFiles"];
    SFHomeModel * finance7 = [SFHomeModel manageTitle:@"薪资录入" withImage:@"icon_salary_big" withController:@"SFSalaryEntryViewController" withType:23 withValue:@"" withCode:@"salaryEntry"];
    
    SFHomeModel * finance8 = [SFHomeModel manageTitle:@"财务审批" withImage:@"icon_financial_examination_and_approval_big" withController:@"" withType:25 withValue:@"" withCode:@"financeAudit"];
    
    NSArray * financeArr = @[finance1,finance2,finance3,finance4,finance5,finance6,finance7,finance8];
    
    return @[officeArr,clientArr,financeArr];
    
}

+ (SFHomeModel *)manageTitle:(NSString *)title withImage:(NSString *)icon withController:(NSString *)controller withType:(NSInteger)type withValue:(NSString *)value withCode:(NSString *)code{
    
    SFHomeModel * model = [[SFHomeModel alloc] init];
    model.title = title;
    model.icon = icon;
    model.controller = controller;
    model.type = type;
    model.value = value;
    model.code = code;
    return model;
}

@end
