//
//  SFAliOSSManager.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/8.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFAliOSSManager.h"

@interface SFAliOSSManager ()

@property(assign,nonatomic) NSInteger totalCount ;

@property(assign,nonatomic) NSInteger compeleteIndex ;

@property(strong,nonatomic) NSMutableArray * imageNameArr ;

@end
@implementation SFAliOSSManager


+ (instancetype)sharedInstance {
    static SFAliOSSManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SFAliOSSManager new];
    });
    return instance;
}


/** 异步上传图片*/
- (void)asyncUploadMultiImages:(NSArray *)images withFile:(NSString *)fileName withFolderName:(NSString *)folderName CompeleteBlock:(CompeleteBlock)compelete ErrowBlock:(ErrorBlock)error{
    
    self.imageNameArr = [NSMutableArray array];
    
    self.compelete = compelete;
    self.error  = error;
    _totalCount = images.count;
    
    if (images.count == 0) {
        !compelete ? : compelete(nil);
        return;
    }
//    [MBProgressHUD showActivityMessageInWindow:@"上传中"];
    [self multithreadingUploadingWithImages:images withFile:fileName withFolderName:folderName];
    
}

// 多线程上传
- (void)multithreadingUploadingWithImages:(NSArray *)images withFile:(NSString *)fileName withFolderName:(NSString *)folderName{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    NSMutableArray * ops = [NSMutableArray array];
    
    for (int i = 0 ; i < images.count ; i++) {
        UIImage * image = [images objectAtIndex:i];
        NSData * imageData = [self compressImageQuality:image toByte:0.2];
        NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
            
            [self uploadObjectAsyncWithDate:imageData WithIndex:i withFile:fileName withFolderName:folderName];
        }];
        
        [ops addObject:op];
    }
    
    [queue addOperations:ops waitUntilFinished:YES];
}

- (void)uploadObjectAsyncWithDate:(NSData *)data WithIndex:(int )index withFile:(NSString *)fileName withFolderName:(NSString *)folderName{
    
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = [SFInstance shareInstance].bucketName;

    
    put.objectKey = [NSString stringWithFormat:@"%@/%@/%@_%@",[SFInstance shareInstance].companyId,folderName,[NSDate getNowTimeTimestamp3],fileName];
    put.uploadingData = data; // 直接上传NSData
    OSSTask * putTask = [self.client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            // 回到主线程
            [self performSelectorOnMainThread:@selector(uploadOSSCompeleteWithObjectKey:) withObject:put.objectKey waitUntilDone:NO];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:@"上传失败"];
            });
            
        }
        return nil;
    }];
}

- (void)uploadObjectAsyncWithURL:(NSURL *)URLString withFile:(NSString *)fileName withFolderName:(NSString *)folderName CompeleteBlock:(CompeleteVideoBlock)compelete ErrowBlock:(ErrorBlock)error{
    
    self.compeleteVideoBlock = compelete;
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    // 必填字段
    put.bucketName = [SFInstance shareInstance].bucketName;
    
    
    put.objectKey = [NSString stringWithFormat:@"%@/%@/%@_%@",[SFInstance shareInstance].companyId,folderName,[NSDate getNowTimeTimestamp3],fileName];
    put.uploadingFileURL = URLString; // 直接上传URLString
    OSSTask * putTask = [self.client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            // 回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [MBProgressHUD hideHUD];
                NSLog(@"%@",put.objectKey);
                if (self.compeleteVideoBlock){
                    self.compeleteVideoBlock(put.objectKey);
                }
                
                [MBProgressHUD showTipMessageInWindow:@"上传成功"];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新代码
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:@"上传失败"];
            });
            
        }
        return nil;
    }];
}


- (void)uploadOSSCompeleteWithObjectKey:(NSString *)objectKey {
    
    _compeleteIndex ++;
    NSDictionary * dict = [NSDictionary dictionaryWithObject:objectKey forKey:@"Img"];
    [self.imageNameArr addObject:dict];
    
    if (_compeleteIndex == _totalCount) {
        
        if (self.compelete) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUD];
            });
            _compeleteIndex = 0;
            self.compelete(self.imageNameArr);
        }
    }
    
}

- (NSData *)compressImageQuality:(UIImage *)image toByte:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}

- (void)download:(NSString *)objectKey {
    
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    
    // 必填字段
    request.bucketName = [SFInstance shareInstance].bucketName;
    request.objectKey = objectKey;
    
    // 可选字段
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        // 当前下载段长度、当前已经下载总长度、一共需要下载的总长度
        NSLog(@"%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    };
    // request.range = [[OSSRange alloc] initWithStart:0 withEnd:99]; // bytes=0-99，指定范围下载
    // request.downloadToFileURL = [NSURL fileURLWithPath:@"<filepath>"]; // 如果需要直接下载到文件，需要指明目标文件地址
    
    OSSTask * getTask = [[SFAliOSSManager sharedInstance].client getObject:request];
    
    [getTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            NSLog(@"download object success!");
            OSSGetObjectResult * getResult = task.result;
//            NSLog(@"download result: %@", getResult.dowloadedData);
        } else {
            NSLog(@"download object failed, error: %@" ,task.error);
        }
        return nil;
    }];
}

@end
