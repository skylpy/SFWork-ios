//
//  SFTemplateListViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/27.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFTemplateListViewController.h"
#import "SFDataProjectsViewController.h"
#import "SFTemplateDayViewController.h"
#import "SFTemplateMonthViewController.h"
#import "SFTemplateWeekViewController.h"
#import "SFDataReportHttpModel.h"
@interface SFTemplateListViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewLayoutWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *setupView;
@property (weak, nonatomic) IBOutlet UIView *periodView;

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic,strong) UIButton * saveButton;

@property (nonatomic, assign) NSInteger dateType;

@end

@implementation SFTemplateListViewController

- (NSMutableArray *)items{
    
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}


- (void)updateViewConstraints{
    
    [super updateViewConstraints];
    
    self.viewLayoutWidth.constant = kWidth*3;
}

- (IBAction)switchChangeClick:(UISwitch *)sender {
    
    if (sender.on) {
        self.setupView.hidden = NO;
        self.nameView.hidden = NO;
        self.periodView.hidden = NO;
        self.scrollView.hidden = NO;
    }else{
        self.setupView.hidden = YES;
        self.nameView.hidden = YES;
        self.periodView.hidden = YES;
        self.scrollView.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置汇报模板";
    
    [self setDrawUI];
    [self requestData];
    
    SFTemplateDayViewController * vc = self.childViewControllers[0];
    SFTemplateWeekViewController * vc1 = self.childViewControllers[1];
    SFTemplateMonthViewController * vc2 = self.childViewControllers[2];
    vc.departmentId = self.departmentId;
    vc1.departmentId = self.departmentId;
    vc2.departmentId = self.departmentId;
    
    @weakify(self)
    [[self.nameTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        @strongify(self)
        vc.name = x;
        vc1.name = x;
        vc2.name = x;
    }];
    
}

- (void)requestData{

    
    [SFDataReportHttpModel templateDataReport:self.departmentId success:^(TemplateModel * _Nonnull model) {
        
        TemplateModel * smodel = [TemplateModel shareManager];
        smodel = model;
        self.nameTextField.text = model.name;
        NSString * title = @"";
        
        [self.items addObjectsFromArray:model.items];
        for (int i = 0; i < self.items.count; i ++) {
            ItemsModel *item = self.items[i];
            if (i == 0) {
                title = item.name;
            }else{
                title = [NSString stringWithFormat:@"%@,%@",title,item.name];
            }
        }
        self.titleTextField.text = title;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MyTemplateModelID" object:model];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (UIButton *)saveButton{
    
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"提交" forState:UIControlStateNormal];
        [_saveButton setTitleColor:Color(@"#FFFFFF") forState:UIControlStateNormal];
        _saveButton.backgroundColor = Color(@"#01B38B");
        _saveButton.titleLabel.font = [UIFont fontWithName:kRegFont size:16];
        @weakify(self)
        [[_saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            switch (self.dateType) {
                case 0:
                {
                    SFTemplateDayViewController * vc = self.childViewControllers[0];
                    [vc savaJournalSetData];
                }
                    break;
                case 1:
                {
                    SFTemplateWeekViewController * vc1 = self.childViewControllers[1];
                    [vc1 savaJournalSetData];
                }
                    break;
                case 2:
                {
                    SFTemplateMonthViewController * vc2 = self.childViewControllers[2];
                    [vc2 savaJournalSetData];
                }
                    break;
                default:
                    break;
            }
            
        } ];
        
    }
    return _saveButton;
}

- (void)setDrawUI {
    
    self.dateType = 0;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupClick)];
    [self.setupView addGestureRecognizer:tap];
    
    [self.view addSubview:self.saveButton];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.offset(45);
    }];
}

- (void)setupClick{
    
    [self.view endEditing:YES];
    SFDataProjectsViewController * vc = [SFDataProjectsViewController new];
    vc.array = self.items;
    @weakify(self)
    [vc setDatasClick:^(NSArray * _Nonnull list) {
        @strongify(self)
        SFTemplateDayViewController * vc = self.childViewControllers[0];
        SFTemplateWeekViewController * vc1 = self.childViewControllers[1];
        SFTemplateMonthViewController * vc2 = self.childViewControllers[2];
        vc.datas = list;
        vc1.datas = list;
        vc2.datas = list;
        NSString * title = @"";
        for (int i = 0; i < list.count; i ++) {
            ItemsModel * model = list[i];
            if (i == 0) {
                title = model.name;
            }else{
                title = [NSString stringWithFormat:@"%@,%@",title,model.name];
            }
        }
        self.titleTextField.text = title;
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)segmentClick:(UISegmentedControl *)sender {
    
    NSLog(@"%ld",sender.selectedSegmentIndex);
    self.dateType = sender.selectedSegmentIndex;
    switch (sender.selectedSegmentIndex) {
        case 0:
            [self.scrollView setContentOffset:CGPointMake(0, 0)];
            break;
        case 1:
            [self.scrollView setContentOffset:CGPointMake(kWidth, 0)];
            break;
        case 2:
            [self.scrollView setContentOffset:CGPointMake(kWidth*2, 0)];
            break;
        default:
            break;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
