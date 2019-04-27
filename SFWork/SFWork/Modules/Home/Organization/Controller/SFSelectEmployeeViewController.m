//
//  SFSelectEmployeeViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/7.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFSelectEmployeeViewController.h"

static NSString * const SFSelectEmpCellID = @"SFSelectEmpCellID";

@interface SFSelectEmployeeViewController ()<UITableViewDelegate,UITableViewDataSource,SFSelectEmpCellDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic, strong) UIButton *letfButton;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UILabel *personLabel;
@property (nonatomic, strong) UIButton * sureButton;

@end

@implementation SFSelectEmployeeViewController

- (UIButton *)letfButton{
    
    if (!_letfButton) {
        
        _letfButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _letfButton.frame = CGRectMake(0, 0, 12, 20);
        [_letfButton setImage:[UIImage imageNamed:@"arrow_return_gray"] forState:UIControlStateNormal];
        @weakify(self)
        [[_letfButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
            @strongify(self)
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    return _letfButton;
}

- (UIView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 1)];
        lineView.backgroundColor = Color(@"#D8D8D8");
        [_bottomView addSubview:lineView];
    }
    return _bottomView;
}

- (UIButton *)sureButton{
    
    if (!_sureButton) {
        
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"确定" forState:UIControlStateNormal];
        _sureButton.backgroundColor = defaultColor;
        _sureButton.layer.cornerRadius = 2;
        _sureButton.clipsToBounds = YES;
    
    }
    return _sureButton;
}

- (UILabel *)personLabel{
    
    if (!_personLabel) {
        _personLabel = [UILabel createALabelText:@"已选0人" withFont:[UIFont fontWithName:kRegFont size:14] withColor:Color(@"#333333")];
    }
    return _personLabel;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择员工";
    
    [self initDrawUI];
    [self initData];
}


- (void)initData{
    
    [self.dataArray addObjectsFromArray:self.model.employees];
    [self.tableView reloadData];
}

-(void)initDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.view);
    }];
    
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithCustomView:self.letfButton];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.sureButton];
    [self.bottomView addSubview:self.personLabel];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.offset(50);
    }];
    
    [self.sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(-15);
        make.centerY.equalTo(self.bottomView);
        make.height.offset(36);
        make.width.offset(57);
    }];
    
    [self.personLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(15);
        make.centerY.equalTo(self.bottomView);
    }];
    
    @weakify(self)
    [[self.sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        [self changeRoles];
    }];
}

- (void)changeRoles{
    
    NSMutableArray * ids = [NSMutableArray array];
    for (SFEmployeesModel * model in self.selectEmp) {
        [ids addObject:model._id];
    }
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:ids forKey:@"ids"];
    [dict setObject:@"DEPARTMENTADMIN" forKey:@"role"];
    [SFOrganizationModel updateEmployeeRole:dict success:^{
        
        !self.didSaveClick?:self.didSaveClick();
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFSelectEmpCell * cell = [tableView dequeueReusableCellWithIdentifier:SFSelectEmpCellID forIndexPath:indexPath];
    
    SFEmployeesModel * model = self.dataArray[indexPath.row];
    cell.model = model;
    cell.delegate = self;
    
    return cell;
}

- (void)selectEmpNumber {

    self.personLabel.text = [NSString stringWithFormat:@"已选%ld人",self.selectEmp.count];
    
}

- (NSArray *)selectEmp{
    NSMutableArray * array = [NSMutableArray array];
    for (SFEmployeesModel * model in self.dataArray) {
        
        if (model.isSelect) {
            [array addObject:model];
        }
    }
    return array;
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerClass:[SFSelectEmpCell class] forCellReuseIdentifier:SFSelectEmpCellID];
        
    }
    return _tableView;
}

@end

@interface SFSelectEmpCell ()

@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UIButton * selectButton;
@property (nonatomic, strong) UIImageView * avatarImage;

@end

@implementation SFSelectEmpCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
}

- (void)setModel:(SFEmployeesModel *)model{
    
    _model = model;
    self.nameLabel.text = model.name;
    self.selectButton.selected = model.isSelect;
    [self.avatarImage setImageWithURL:[NSURL URLWithString:model.avatar] placeholder:DefaultImage];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    
    [self addSubview:self.selectButton];
    [self addSubview:self.avatarImage];
    [self addSubview:self.nameLabel];
    
    [self.selectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(19);
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self.avatarImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.left.equalTo(self.selectButton.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      
        make.left.equalTo(self.avatarImage.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
    
    @weakify(self)
    [[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        x.selected = !x.selected;
        self.model.isSelect = x.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectEmpNumber)]) {
            
            [self.delegate selectEmpNumber];
        }
        
    }];
    
}

- (UILabel *)nameLabel{

    if (!_nameLabel) {
        
        _nameLabel = [UILabel createALabelText:@"龙腾飞" withFont:[UIFont fontWithName:kRegFont size:16] withColor:Color(@"#333333")];
    }
    return _nameLabel;
}

- (UIImageView *)avatarImage{
    
    if (!_avatarImage) {
        
        _avatarImage = [[UIImageView alloc] init];
        
    }
    return _avatarImage;
}

- (UIButton *)selectButton{
    
    if (!_selectButton) {
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectButton setImage:[UIImage imageNamed:@"btn_tick_empty_gray"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"btn_tick_green"] forState:UIControlStateSelected];
        
    }
    return _selectButton;
}

@end
