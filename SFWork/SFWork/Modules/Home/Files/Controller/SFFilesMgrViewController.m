//
//  SFFilesMgrViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFFilesMgrViewController.h"
#import "SFVideoViewController.h"
#import "SFWebViewController.h"
#import "SFPublicSearchView.h"
#import "SFFilesBottomView.h"
#import "SFFilesFolderCell.h"
#import "SFFilesTypeCell.h"
#import "PickerTool.h"

static NSString * const SFFilesFolderCellID = @"SFFilesFolderCellID";
static NSString * const SFFilesTypeCellID = @"SFFilesTypeCellID";

@interface SFFilesMgrViewController ()<UITableViewDelegate,UITableViewDataSource,PickerToolDelegate,SFFilesFolderCellDelegate,SFFilesTypeCellDelegate>

@property (nonatomic,strong) PickerTool *pick;
@property (nonatomic,strong) SFPublicSearchView * headerView;
@property (nonatomic,strong) UIButton * addFileButton;
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong) NSMutableArray * searchArray;
@property (nonatomic,strong) NSMutableArray * dataCopyArray;
@property (nonatomic, strong) SFFilesBottomView *folderView;
@property (nonatomic, strong) SFFilesBottomView *fileView;

@end

@implementation SFFilesMgrViewController

- (NSMutableArray *)dataCopyArray{
    
    if (!_dataCopyArray) {
        _dataCopyArray = [NSMutableArray array];
    }
    return _dataCopyArray;
}

- (NSMutableArray *)searchArray{
    
    if (!_searchArray) {
        _searchArray = [NSMutableArray array];
    }
    return _searchArray;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (SFFilesBottomView *)folderView{
    
    if (!_folderView) {
        _folderView = [SFFilesBottomView shareThereBottomView];
    }
    return _folderView;
}

- (SFFilesBottomView *)fileView{
    
    if (!_fileView) {
        _fileView = [SFFilesBottomView shareFourBottomView];
    }
    return _fileView;
}

- (UIButton *)addFileButton{
    
    if (!_addFileButton) {
        
        _addFileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addFileButton setImage:[UIImage imageNamed:@"btn_oval_add_green"] forState:UIControlStateNormal];
    }
    return _addFileButton;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"合同文件管理";
    
    [self setDrawUI];
    [self requestData];
}

- (void)requestData {
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:self.type forKey:@"model"];
    [dict setValue:self.parentId forKey:@"parentId"];
    
    [SFFilesMgrModel getOfficeFolder:dict success:^(NSArray<SFFilesModel *> * _Nonnull lsit) {
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:lsit];
        
        [self.dataCopyArray removeAllObjects];
        [self.dataCopyArray addObjectsFromArray:lsit];
        [self.tableView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)setDrawUI {
    
    
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.offset(43);
        make.top.left.right.equalTo(self.view);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    [self.view addSubview:self.addFileButton];
    [self.addFileButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(55);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.bottom.equalTo(self.view.mas_bottom).offset(-52);
    }];
    
    @weakify(self)
    [[self.addFileButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self addOperation];
    }];
}

//批量操作
- (void)addOperation {
    
    ModelComfirm *item1 = [ModelComfirm comfirmModelWith:@"上传文件" titleColor:Color(@"#0B0B0B") fontSize:16];
    ModelComfirm *item2 = [ModelComfirm comfirmModelWith:@"新建文件夹" titleColor:Color(@"#0B0B0B") fontSize:16];
    ModelComfirm *cancelItem = [ModelComfirm comfirmModelWith:@"取消" titleColor:Color(@"#0B0B0B") fontSize:16];
    [ComfirmView showInView:LSKeyWindow cancelItemWith:cancelItem dataSource:@[ item1 ,item2] actionBlock:^(ComfirmView *view, NSInteger index) {
        
        if (index == 0) {
            
            [self uploadFiles];
        }else{
            [self addFolder];
        }
    }];
}

- (void)addFolder {
    
    SFAlertInputView * alert=[[SFAlertInputView alloc] initWithTitle:@"新建文件夹" PlaceholderText:@"请输入新建文件夹名称" WithKeybordType:LSXKeyboardTypeDefault CompleteBlock:^(NSString *contents) {
        NSLog(@"-----%@",contents);
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setValue:contents forKey:@"name"];
        [dict setValue:self.type forKey:@"model"];
        [dict setValue:self.parentId forKey:@"parentId"];
        [dict setValue:@(YES) forKey:@"folder"];
        [self addFolderUpload:dict];
    }];
    [alert show];
}

- (void)addFolderUpload:(NSMutableDictionary *)dict{
    
    [SFFilesMgrModel addOfficeFolder:dict success:^{
        
        [self requestData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

- (void)addFolderView{
    [self.view addSubview:self.folderView];
    [self.folderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.left.bottom.right.equalTo(self.view);
    }];
}

- (void)addFileView{
    [self.view addSubview:self.fileView];
    [self.fileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.left.bottom.right.equalTo(self.view);
    }];
}

#pragma SFFilesFolderCellDelegate,SFFilesTypeCellDelegate
- (void)selectFile:(SFFilesModel *)model{
    
    NSMutableArray * array = [NSMutableArray array];
    for (SFFilesModel * fmodel in self.dataArray) {
        
        if (!fmodel.folder && fmodel.isSelect) {
            [array addObject:fmodel];
        }
    }
    if (array.count > 0) {
        [self addFileView];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTFILE" object:array];
    }else{
        [self.fileView removeFromSuperview];
    }
    [self.tableView reloadData];
}

- (void)selectFolder:(SFFilesModel *)model{
    
    NSMutableArray * array = [NSMutableArray array];
    for (SFFilesModel * fmodel in self.dataArray) {
        
        if (fmodel.folder && fmodel.isSelect) {
            [array addObject:fmodel];
        }
    }
    if (array.count > 0) {
        [self addFolderView];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECTFOLDER" object:array];
    }else{
        [self.folderView removeFromSuperview];
    }
    [self.tableView reloadData];
}

//文件详情
- (void)goDateilFile:(SFFilesModel *)model{
    
    UIViewController * vc = [NSClassFromString(@"SFFileDateilViewController") new];
    [vc setValue:model forKey:@"model"];
    [self.navigationController pushViewController:vc animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 72;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SFFilesModel * model = self.dataArray[indexPath.row];
    if (model.folder) {
        SFFilesFolderCell * cell = [tableView dequeueReusableCellWithIdentifier:SFFilesFolderCellID forIndexPath:indexPath];
        cell.delegate = self;
        cell.model = model;
        return cell;
    }
    SFFilesTypeCell * cell = [tableView dequeueReusableCellWithIdentifier:SFFilesTypeCellID forIndexPath:indexPath];
    cell.delegate = self;
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SFFilesModel * model = self.dataArray[indexPath.row];
//
    if (model.folder) {
        UIViewController * vc = [NSClassFromString(@"SFFilesMgrViewController") new];
        [vc setValue:model._id forKey:@"parentId"];
        [vc setValue:self.type forKey:@"type"];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        NSString * constrainURL = [NSString getAliOSSConstrainURL:model.fileKey];
        if ([model.fileType isEqualToString:@"IMAGES"]) {
            
            NSMutableArray<YYPhotoGroupItem *> *items = [NSMutableArray array];
            
            YYPhotoGroupItem *item = [YYPhotoGroupItem new];
            item.largeImageURL = [NSURL URLWithString:constrainURL];
            
            [items addObject:item];
            
            YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
            
            [v presentFromImageView:self.view toContainer:[UIApplication sharedApplication].keyWindow animated:YES completion:nil];
        }
        if ([model.fileType isEqualToString:@"VIDEO"]) {
            
            SFVideoViewController * videoVc = [NSClassFromString(@"SFVideoViewController") new];
            [videoVc initPlayerWithURL:[NSURL URLWithString:constrainURL]];
            
            SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:videoVc];
            [self presentViewController:nvs animated:YES completion:nil];
        }
        if([model.fileType isEqualToString:@"TXT"]||
                [model.fileType isEqualToString:@"EXCEL"]||
                [model.fileType isEqualToString:@"PPT"]||
                [model.fileType isEqualToString:@"WORD"]||
                [model.fileType isEqualToString:@"PDF"]){
            
            SFWebViewController * vc = [SFWebViewController new];
            vc.urlString = constrainURL;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    SFFilesModel * model = self.dataArray[indexPath.row];
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了删除");
        [self deleteField:@[model._id]];
    }];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"重命名" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了编辑");
        [self renameFolder:model._id];
    }];
    editAction.backgroundColor = [UIColor grayColor];
    
    UITableViewRowAction *moveAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"移动" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        NSLog(@"点击了移动");
        UIViewController * vc = [NSClassFromString(@"SFFolderViewController") new];
        [vc setValue:model._id forKey:@"parentId"];
        [vc setValue:self.type forKey:@"type"];
        SFNavigationViewController * nvs = [[SFNavigationViewController alloc] initWithRootViewController:vc];
        [self presentViewController:nvs animated:YES completion:nil];
    }];
    moveAction.backgroundColor = [UIColor grayColor];
    
    return @[deleteAction, editAction,moveAction];
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
        [self requestData];
        
    } failure:^(NSError * _Nonnull error) {
        
         [MBProgressHUD showErrorMessage:@"失败"];
    }];
    
}

- (void)deleteField:(NSArray *)ids{
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setObject:ids forKey:@"ids"];
    
    [SFFilesMgrModel deleteOfficeFolder:dict success:^{
        
        [MBProgressHUD showSuccessMessage:@"删除成功"];
        [self requestData];
        
    } failure:^(NSError * _Nonnull error) {
        
        [MBProgressHUD showErrorMessage:@"删除失败"];
    }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    editingStyle = UITableViewCellEditingStyleDelete;
}

- (void)uploadFiles {
    
    self.pick = [[PickerTool alloc]initWithMaxCount:1 selectedAssets:nil];
    self.pick.delegate = self;
    self.pick.allowPickingVideo = YES;
    [self presentViewController:self.pick.imagePickerVcC animated:YES completion:nil];
}

#pragma mark- PickerToolDelegate
- (void)didPickedPhotos:(NSString *)fileName{
    
    if (self.pick.selectedPhotos.count > 0) {
        [[SFAliOSSManager sharedInstance] asyncUploadMultiImages:self.pick.selectedPhotos withFile:fileName withFolderName:self.type CompeleteBlock:^(NSArray *nameArray) {
            NSLog(@"nameArray is %@", nameArray);
            [self files:nameArray];
        } ErrowBlock:^(NSString *errrInfo) {
            
        }];
        
    }
}
/** 选择视频回调 **/
- (void)didPickedVedioWithCoverImage:(UIImage *)coverImage asset:(id)asset{
    
    NSLog(@"%@",asset);
    
    PHAsset *phAsset = asset;
    NSString *fileName = [phAsset valueForKey:@"filename"];
    [[TZImageManager manager] getVideoWithAsset:asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        AVAsset *currentPlayerAsset = playerItem.asset;
        NSURL *urlString = [(AVURLAsset *)currentPlayerAsset URL];
        NSLog(@"url%@",urlString);
        @weakify(self)
        [[SFAliOSSManager sharedInstance] uploadObjectAsyncWithURL:urlString withFile:fileName withFolderName:self.type CompeleteBlock:^(NSString *videoString) {
            @strongify(self)
            [self filesVideo:videoString];
            
        } ErrowBlock:^(NSString *errrInfo) {
            
        }];
    }];
    NSLog(@"%@",fileName);
}

- (void)filesVideo:(NSString *)name{

    NSArray *array = [name componentsSeparatedByString:@"/"];
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    NSString * names = array.lastObject;
    NSArray * nameArray = [names componentsSeparatedByString:@"_"];
    
    [dict setValue:nameArray.lastObject forKey:@"name"];
    [dict setValue:self.type forKey:@"model"];
    [dict setValue:self.parentId forKey:@"parentId"];
    [dict setValue:@(NO) forKey:@"folder"];
    [dict setValue:name forKey:@"fileKey"];
    [self addFolderUpload:dict];
}

- (void)files:(NSArray *)nameArr {
    
    NSDictionary * dic = nameArr[0];
    NSString *img = dic[@"Img"];
    NSArray *array = [img componentsSeparatedByString:@"/"];
    NSString * name = array.lastObject;
    NSArray * nameArray = [name componentsSeparatedByString:@"_"];
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    [dict setValue:nameArray.lastObject forKey:@"name"];
    [dict setValue:self.type forKey:@"model"];
    [dict setValue:self.parentId forKey:@"parentId"];
    [dict setValue:@(NO) forKey:@"folder"];
    [dict setValue:img forKey:@"fileKey"];
    [self addFolderUpload:dict];
}


- (SFPublicSearchView *)headerView {
    
    if (!_headerView) {
        _headerView = [SFPublicSearchView shareSFPublicSearchView];
        _headerView.seachTextField.placeholder = @"请输入文件名";
        @weakify(self)
        [_headerView setSearchKeywordAction:^(NSString * _Nonnull keyword) {
            @strongify(self)
            [self searchKeyWord:keyword];
        }];
        [_headerView setTextSignalClick:^(NSString * _Nonnull keyword) {
            @strongify(self)
            [self searchKey:keyword];
        }];
    }
    return _headerView;
}

- (void)searchKey:(NSString *)key{
    
    if ([key isEqualToString:@""]) {
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:self.dataCopyArray];
        [self.tableView reloadData];
    }
}

- (void)searchKeyWord:(NSString *)key{
    
    [self.searchArray removeAllObjects];
    for (SFFilesModel * fmodel in self.dataArray) {
        
        if ([fmodel.name rangeOfString: key].location != NSNotFound) {
            
            [self.searchArray addObject:fmodel];
        }
    }
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:self.searchArray];
    
    if ([key isEqualToString:@""] && self.searchArray.count == 0) {
        
        [self.dataArray addObjectsFromArray:self.dataCopyArray];
    }
    
    [self.tableView reloadData];
}

#pragma mark- Getter
- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = bgColor;
        
        [_tableView registerNib:[UINib nibWithNibName:@"SFFilesTypeCell" bundle:nil] forCellReuseIdentifier:SFFilesTypeCellID];
        [_tableView registerNib:[UINib nibWithNibName:@"SFFilesFolderCell" bundle:nil] forCellReuseIdentifier:SFFilesFolderCellID];
    }
    return _tableView;
}

@end
