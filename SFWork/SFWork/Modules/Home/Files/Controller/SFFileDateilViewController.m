//
//  SFFileDateilViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/11.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFFileDateilViewController.h"
#import "SFFileDateilCell.h"
#import "SFFilesBottomView.h"
#import "ZFDownloadManager.h"

static NSString * const SFFileDateilCellID = @"SFFileDateilCellID";
static NSString * const SFFileImageCellID = @"SFFileImageCellID";

@interface SFFileDateilViewController ()<UITableViewDelegate,UITableViewDataSource,SFFilesBottomViewDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataArray;

@property (nonatomic, strong) SFFilesBottomView * bottomView;

@end

@implementation SFFileDateilViewController

- (SFFilesBottomView *)bottomView{
    
    if (!_bottomView) {
        _bottomView = [SFFilesBottomView shareAllBottomView];
        _bottomView.delegate = self;
    }
    return _bottomView;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文件详情";
    [self setDrawUI];
}

- (void)setModel:(SFFilesModel *)model{
    
    _model = model;
    [self.dataArray addObject:@{@"name":model.name,@"fileType":model.fileType}];
    [self.dataArray addObject:@{@"size":model.size}];
    [self.dataArray addObject:@{@"fileType":model.fileType}];
    [self.dataArray addObject:@{@"path":model.path}];
    [self.dataArray addObject:@{@"createTime":model.createTime,@"creatorName":model.creatorName}];
 
    [self.tableView reloadData];
}

- (void)setDrawUI {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view);
    }];
    
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.bottom.right.equalTo(self.view);
        make.height.offset(50);
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == self.dataArray.count-1) {
        
        return 83;
    }
    return 69;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        SFFileImageCell * cell = [tableView dequeueReusableCellWithIdentifier:SFFileImageCellID forIndexPath:indexPath];
        NSDictionary * dict = self.dataArray[indexPath.row];
        [cell conforfilesModel:dict withIndex:indexPath.row];
        return cell;
    }
    SFFileDateilCell * cell = [tableView dequeueReusableCellWithIdentifier:SFFileDateilCellID forIndexPath:indexPath];
    NSDictionary * dict = self.dataArray[indexPath.row];
    [cell conforfilesModel:dict withIndex:indexPath.row];
    return cell;
}

#pragma SFFilesBottomViewDelegate

- (void)filesOpationType:(FilesButtonType)type{
    
    switch (type) {
        case deleteType:
            [self deleteField:@[self.model._id]];
            break;
        case downloadType:
            [self downLoad];
            break;
        case sendType:
            
            break;
        case renameType:
            [self renameFolder:self.model._id];
            break;
        case removeType:
            
            break;
            
        default:
            break;
    }
}

- (void)downLoad{
     NSString * constrainURL = [NSString getAliOSSConstrainURL:self.model.fileKey];
    UIViewController * vc = [NSClassFromString(@"SFFileDownLoadViewController") new];
    [vc setValue:constrainURL forKey:@"URLString"];
    [self.navigationController pushViewController:vc animated:YES];
    
}

//重命名
- (void)renameFolder:(NSString *)oid {
    
    SFAlertInputView * alert=[[SFAlertInputView alloc] initWithTitle:@"重命名" PlaceholderText:@"请输入文件夹名称" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
        NSLog(@"-----%@",contents);
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:contents forKey:@"name"];
        [dict setValue:oid forKey:@"id"];
        
        [self renameField:dict];
    }];
    [alert show];
}

- (void)renameField:(NSMutableDictionary *)dict{
    
    [SFFilesMgrModel renameOfficeFolder:dict success:^{
        
        [MBProgressHUD showSuccessMessage:@"成功"];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showErrorMessage:@"失败"];
    }];
    
}
//删除
- (void)deleteField:(NSArray *)ids{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:ids forKey:@"ids"];
    
    [SFFilesMgrModel deleteOfficeFolder:dict success:^{
        
        [MBProgressHUD showSuccessMessage:@"删除成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showErrorMessage:@"删除失败"];
    }];
}
#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFFileDateilCell" bundle:nil] forCellReuseIdentifier:SFFileDateilCellID];
        [_tableView registerClass:[SFFileImageCell class] forCellReuseIdentifier:SFFileImageCellID];
    }
    return _tableView;
}

@end

@interface SFFileImageCell ()

@property (nonatomic, strong) UIImageView *iconImage;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SFFileImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self drawUI];
    }
    return self;
}

- (void)conforfilesModel:(NSDictionary *)dict withIndex:(NSInteger)row{
    
    _dict = dict;
    self.titleLabel.text = dict[@"name"];
    
    if ([dict[@"fileType"] isEqualToString:@"IMAGES"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_picture_orange"];
    }
    if ([dict[@"fileType"] isEqualToString:@"VIDEO"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_video_black"];
    }
    if ([dict[@"fileType"] isEqualToString:@"ZIP"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_zip_multicolor"];
    }
    if ([dict[@"fileType"] isEqualToString:@"TXT"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_txt_purple"];
    }
    if ([dict[@"fileType"] isEqualToString:@"EXCEL"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_excel_green"];
    }
    if ([dict[@"fileType"] isEqualToString:@"PPT"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_ppt_red"];
    }
    if ([dict[@"fileType"] isEqualToString:@"WORD"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_word_blue"];
    }
    if ([dict[@"fileType"] isEqualToString:@"PDF"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_pdf_pink"];
    }
    if ([dict[@"fileType"] isEqualToString:@"OTHER"]) {
        self.iconImage.image = [UIImage imageNamed:@"icon_document_unknown_gray"];
    }
}

- (void)drawUI {
    
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.offset(27);
        make.height.offset(31);
    }];
    
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.iconImage.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self);
    }];
}

- (UIImageView *)iconImage{
    
    if (!_iconImage) {
        _iconImage = [[UIImageView alloc] init];
    }
    return _iconImage;
}

- (UILabel *)titleLabel{
    
    if (!_titleLabel) {
        
        _titleLabel = [UILabel createALabelText:@"" withFont:[UIFont fontWithName:kRegFont size:15] withColor:Color(@"#0B0B0B")];
    }
    return _titleLabel;
}



@end
