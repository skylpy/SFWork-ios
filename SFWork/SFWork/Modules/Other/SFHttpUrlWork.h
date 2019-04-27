//
//  SFHttpUrlWork.h
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/5.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#ifndef SFHttpUrlWork_h
#define SFHttpUrlWork_h

#define BASE_URL(__param)   [NSString stringWithFormat:@"%@%@",SFURL,__param]

//请求地址140  http://192.168.0.134:8089  http://sanfan.vipgz1.idcfengye.com/ http://192.168.0.146:8089  http://192.168.0.145:8089 http://47.107.165.66:8289

#define SFURL                 @"http://192.168.0.192:8089"



/**
 * des:下面是接口
 * author:SkyWork
 */

//OSS token
#define getOssRoleToken                       @"/common/getOssRole"

//获取城市数据
#define getCityData               @"/common/getCityData"

//企业注册
#define regCompany                    @"/register"

//用户登录
#define login                       @"/login"

//重置密码
#define resetPwd                       @"/resetPwd"

//获取当前公司信息
#define getCompanyInfo              @"/org/company/getCompanyInfo"

// 获取当前员工资料
#define getSelfInfo                 @"/org/employee/getSelfInfo"

// 新增员工
#define addEmployee                 @"/org/employee/"

// 修改员工
#define updateEmployee               @"/org/employee/"

// 获取员工资料后面带ID
#define getEmployee                  @"/org/employee/"

// 获取组织架构
#define getOrganizationTree          @"/org/department/getOrganizationTree"

//获取组织架构
#define getOrganization              @"/org/department/getOrganization/"

// 新增部门
#define addDepartment                  @"/org/department/"

// 修改部门
#define updateDepartment                  @"/org/department/"

// 修改员工角色
#define changeRole                  @"/org/employee/changeRole"

// 删除部门
#define deleteDepartment                 @"/org/department/"

// 批量删除员工
#define deleteEmployee                 @"/org/employee/delete"

// 批量移动员工
#define moveEmployee                 @"/org/employee/move"

//企业设置选项
#define getCompanySettings                       @"/org/company/getCompanySetting/"
#define companySettingModel                       @"/org/company/companySettingModel"
//获取直属上司接口
#define getDirectlyAdmin                      @"/org/employee/getDirectlyAdmin/"
//获取直属下属接口
#define getDirectlyEmployee                      @"/org/employee/getDirectlyEmployee/"


//文件管理
//添加文件或文件夹
#define addOfficeFile                           @"/office/file"
//获取文件列表
#define getOfficeFileList                                @"/office/file/listFiles"
//删除和移动文件
#define deleteFiles                                         @"/office/file/delete"
//重命名文件
#define renameFiles                                        @"/office/file/rename"



//=============================//
//新增客户
#define clientAdd                                       @"/client/add"
//获取部门客户或商家
#define getDepartmentClient                             @"/client/getDepartmentClient"
//获取个人客户或商家
#define getMyClient                                     @"/client/getMyClient"
//通过员工id获取其私有客户
#define getDirectly                                     @"/client/directly"
//获取客户
#define getClient                                         @"/client/"
//搜索客户
#define searchClient                                         @"/client"
//获取客户
#define updateClient                                      @"/client/update"

//日报
#define officeDaily                                    @"/office/daily"

//日报模版
#define autoCreateDailyTemplate                  @"/office/dailySetting/autoCreateDailyTemplate/"

//获取自己部门的日报设置列表
#define dailySetting                  @"/office/dailySetting/dailySetting"

//修改日报设置
#define updateDailySetting            @"/office/dailySetting/updateDailySetting"

//获取直属下属日报
#define getManagerDailyList            @"/office/daily/getManagerDailyList"

//获取自己的日报
#define getMyDailyList              @"/office/daily/getMyDailyList"

//获取自己部门的日报模版
#define getMyTemplate             @"/office/dailySetting/dailySetting"

//获取直属下属日报
#define getManagerDailyList             @"/office/daily/getManagerDailyList"
//根据条件查询日报
#define searchDailyList            @"/office/daily/searchDailyList"

//修改日报未读状态
#define dailyUpdate            @"/office/daily/dailyUpdate/"

//日报详情
#define dailyDetails            @"/office/daily/dailyDetails/"

//修改日报审批状态
#define changeAuditStatus             @"/office/daily/changeAuditStatus"

//新增任务
#define officeAddTask             @"/office/task"

//我的任务列表
#define myTaskList             @"/office/task/myTaskList"

//管理员查看直属员工列表
#define taskManager             @"/office/task/taskManager"

//获取任务详情
#define taskDetail             @"/office/task/taskDetail/"

//修改任务状态
#define changeTaskStatus             @"/office/task/changeTaskStatus"

//取消任务-删除
#define deleteTask             @"/office/task/deleteTask/"

//提交任务总结
#define submitTaskSummary             @"/office/task/submitTaskSummary"

//修改任务审批状态
#define changeAuditTaskStatus            @"/office/task/changeAuditStatus"

//任务搜索
#define searchTask           @"/office/task/searchTask"


//添加拜访
#define clientVisiting           @"/client/visiting"

//拜访列表
#define visitingSearch           @"/client/visiting/search"

//统计拜访信息
#define visitingCount           @"/client/visiting/count"

//获取子部门
#define orgGetChildren           @"/org/department/getChildren/"

//获取客户联系人
#define orgGetLinkman           @"/client/getLinkman/"

//拜访打卡
#define visitingUpdate           @"/client/visiting/update"

//取消拜访
#define deletevisiting           @"/client/visiting/"

//获取联系人
#define employeeContacts           @"/org/employee/contacts"

//完成拜访
#define completeVisit           @"/client/visiting/visit"


//根据权限类型获取授权列表
#define employeePermissionList           @"/org/permission/employeePermissionList/"

//根据权限类型获取授权列表
#define employeePermission           @"/org/permission/employeePermission/"

//对用户进行授权
#define permissionAuthorization           @"/org/permission/authorization"

//获取根据类型获取默认权限设置
#define getDefaultPermissions           @"/org/permission/getDefaultPermissions/"

//汇报统计
#define dataReportStatistics           @"/office/dataReport/statistics"

//根据部门数据汇报模板
#define dataReportTemplate           @"/office/dataReport/template"

//根据ID获取汇报
#define officeDataReport           @"/office/dataReport/"

// 提交汇报
#define submitReportDataReport           @"/office/dataReport/submitReport"

// 获取个人汇报历史记录
#define dataReportMyHistory           @"/office/dataReport/myHistory"

// 获取员工ID获取员工汇报
#define dataReportFindByEmployee           @"/office/dataReport/employee/findByEmployee"


//获取当前员工所有直属下属的汇报列表
#define getDirectlyEmployeeReport          @"/office/dataReport/getDirectlyEmployeeReport"
//获取当前周期的模板
#define getCurrentReport          @"/office/dataReport/getCurrentReport"

//审核汇报
#define dataReportAudit          @"/office/dataReport/audit"

// 检查当前用户是否有审核改汇报的权限
#define checkAuditPermission          @"/office/dataReport/checkAuditPermission/"

//撤回汇报
#define dataReportRecall          @"/office/dataReport/recall/"



//新增费用报销 //撤回报销  //获取报销详情
#define officeReimbursement          @"/office/reimbursement"

//审批
#define doApproveDoApprove         @"/office/reimbursement/doApprove"

//获取待我审批/我审批的
#define getApproveReimbursement         @"/office/reimbursement/getApprove"

//获取抄送给我的
#define getCopyToMe         @"/office/reimbursement/getCopyToMe"

//获取我的报销
#define getMineReimbursement         @"/office/reimbursement/getMine"

//撤回报销
//#define recallReimbursement         @"/office/reimbursement/"


//考勤模板列表
#define attendanceGetTemplateList         @"/office/attendance/getTemplateList"
//获取考勤模板详情
#define attendanceTemplateDetail         @"/office/attendance/templateDetail/"
//新增保存考勤模板
#define attendanceSaveTemplate         @"/office/attendance/saveTemplate"

//获取所有员工
#define getAllEmployee         @"/org/employee/getAllEmployee"

//获取所有管理者
#define getAllManager         @"/org/employee/getAllManager"

//获取系统消息
#define systemMessage           @"/message/notification/getMyNotifications"


//发起列表
#define approvalMyApprovalList           @"/office/approval/myApprovalList"

//审批列表
#define approvalManagerList           @"/office/approval/approvalManagerList"

//抄送列表
#define approvalCopyList           @"/office/approval/copyList"


//发起申请
#define SenderApproval           @"/office/approval/approval"

//申请详情
#define approvalDetails           @"/office/approval/details/"

//拒绝申请
#define approvalOverruled           @"/office/approval/overruled"

//通过申请
#define approvalAgreement           @"/office/approval/agreement/"

//撤回申请
#define approvalWithdraw           @"/office/approval/withdraw/"

//搜索发起列表
#define seachmyApprovalList           @"/office/approval/myApprovalList/"

//搜索审批列表
#define seachManagerList           @"/office/approval/approvalManagerList/"

//获取考勤规则
#define attendanceGetRules           @"/office/attendance/getRules"

//打卡
#define attendanceTimeRecord           @"/office/attendance/timeRecord"

//获取打卡记录
#define attendanceGetRecord           @"/office/attendance/getRecord"

//查看打卡详情
#define attendanceRecord           @"/office/attendance/record/"

//更新打卡
#define attendanceUpdateRecord           @"/office/attendance/updateRecord"

//审批打卡详情
#define attendanceAuditUpdate           @"/office/attendance/record/"

//考勤统计
#define attendanceStatistics           @"/office/attendance/statistics"

//考勤统计列表
#define attendanceStatisticsList          @"/office/attendance/statisticsList"

#define attendanceStatisticsByCheck          @"/office/attendance/statisticsByCheck"
#define attendanceStatisticsByApproval          @"/office/attendance/statisticsByApproval"

//获取公告列表
#define getInformationLists          @"/office/information/getInformationList"

//保存发布修改
#define saveInformation          @"/office/information/information"

//删除公告
#define delInformation          @"/office/information/del/"

//获取详情
#define informationDetail          @"/office/information/detail/"

//保存轨迹ID
#define gaodeSaveTrid          @"/office/gaode/saveTrid/"

//重置密码发送验证码
#define resetPwdSendVercode          @"/resetPwd/sendVercode"


//设置薪资计算规则
#define setSalaryRule          @"/org/company/setSalaryRule"

//设置薪资
#define setSalary          @"/org/employee/setSalary"

//获取考核模块列表
#define checkModules          @"/office/check/modules"

//获取考核项列表
#define checkModulesItem          @"/office/check/item/"

//考核规则搜索
#define checkModulesSearch          @"/office/check/rule/search"

//新增考核规则
#define checkModulesRule          @"/office/check/rule"

//查询考核规则详情
#define checkModulesRuleDateil          @"/office/check/rule/"

//删除考核规则
#define checkModulesRuleDel          @"/office/check/rule/"

//获取某人某月的考核分数 /获取考核分数详情 /考核分数处理
#define checkModulesRuleScore          @"/office/check/score"

//获取名字和头像
#define getNameAndAvatar          @"/org/employee/getNameAndAvatar/"
#define chatGroupInfo          @"/message/chat/group/info/"

//获取我的审批列表(分组数据)，组内列表数据最多5条
#define myApproveBillGroup          @"/finace/bill/myApprove/group"

//获取我的审批列表，支持分页
#define myApproveBillfinace          @"/finace/bill/myApprove"

//获取我的发起列表(分组数据)，组内列表数据最多5条
#define myLaunchBillfinaceGroup          @"/finace/bill/myLaunch/group"

//获取我发起的财务审批列表
#define myLaunchBillfinace          @"/finace/bill/myLaunch"

//单据s详情
#define finacebillDateil          @"/finace/bill/"

//财务单据审批处理
#define finacebillprocess          @"/finace/bill/process"

//查询财务单据列表
#define finacebillList          @"/finace/bill/billList"

//新增财务单据
#define addfinacebill          @"/finace/bill"

#endif /* SFHttpUrlWork_h */
