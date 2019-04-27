//
//  SFWebViewController.m
//  SFWork
//
//  Created by Wilbur Galahad on 2019/3/12.
//  Copyright © 2019年 SkyWork. All rights reserved.
//

#import "SFWebViewController.h"
#import <WebKit/WebKit.h>

@interface SFWebViewController ()<WKNavigationDelegate, WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic, strong) WKWebView *wkWebView;
//进度条view
@property (nonatomic, strong) UIProgressView *wkProgressView;
@end

@implementation SFWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.urlString = self.urlString? self.urlString: @"http://www.baidu.com";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]];
    
    [self.wkWebView loadRequest:request];

}


- (void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
}

- (void)simpleExampleTest {
    // 1.创建webview，并设置大小，"20"为状态栏高度
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    // 2.创建请求
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.cnblogs.com/mddblog/"]];
    // 3.加载网页
    [webView loadRequest:request];
    
    // 最后将webView添加到界面
    [self.view addSubview:webView];
}

#pragma mark - Getter & Setter
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[self wkWebViewConfiguration]];
        
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
        
        [self.view addSubview:_wkWebView];
        [_wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.mas_topLayoutGuide);
        }];
    }
    return _wkWebView;
}

- (WKWebViewConfiguration *)wkWebViewConfiguration {
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    
    configuration.preferences                   = [WKPreferences new];
    configuration.preferences.minimumFontSize   = 10;
    configuration.preferences.javaScriptEnabled = YES;
    
    configuration.processPool = [WKProcessPool new];
    
    configuration.userContentController = [WKUserContentController new];
    [configuration.userContentController addScriptMessageHandler:self name:@"AppModel"];
    
    return configuration;
}

- (UIProgressView *)wkProgressView {
    if (!_wkProgressView) {
        _wkProgressView = [[UIProgressView alloc] init];
        [self.view addSubview:_wkProgressView];
        
        _wkProgressView.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), CGRectGetWidth(self.navigationController.navigationBar.frame), 3);
        
        _wkProgressView.progressTintColor = [UIColor blueColor];
        _wkProgressView.trackTintColor = [UIColor whiteColor];
        
        [_wkProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.wkWebView);
            make.height.offset(3);
        }];
    }
    
    return _wkProgressView;
}

- (void)registerNotification {
  
    
}

- (void)installObserver {
    
    RACSignal *singal1 = RACObserve(self.wkWebView, loading);
    RACSignal *singal2 = RACObserve(self.wkWebView, title);
    RACSignal *singal3 = RACObserve(self.wkWebView, estimatedProgress);
    
    RACSignal *mergerSingal = [[singal1 merge:singal2] merge:singal3];
    
    @weakify(self)
    [mergerSingal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        //加载完成
        if (!self.wkWebView.isLoading) {
            [self hideWKProgressView];
        }
        else {
            self.wkProgressView.alpha = 1;
            self.wkProgressView.progress = self.wkWebView.estimatedProgress;
        }
    }];
    
}

- (void)hideWKProgressView {
    //不显示进度条，返回
    [UIView animateWithDuration:0.5 animations:^{
        self.wkProgressView.alpha = 0;
    }];
}
#pragma mark - WKWebView
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    @weakify(self)
    [webView evaluateJavaScript:@"document.title" completionHandler:^(NSString *title, NSError *error) {
        @strongify(self)
        self.title = title;
    }];
    
    [webView evaluateJavaScript:@"document.getElementsByName('description')[0].content" completionHandler:^(NSString *content, NSError *error) {
        @strongify(self)
        NSString * share = content.length > 50 ? [content substringWithRange:NSMakeRange(0,50)] : content;

    }];
    
    [webView evaluateJavaScript:@"document.getElementsByName('shareimg')[0].content" completionHandler:^(NSString *content, NSError *error) {
        @strongify(self)

    }];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler();
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        completionHandler(NO);
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *))completionHandler {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:prompt preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.placeholder = defaultText;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

// 防止在HTML <a> 中的 target="_blank"不发生响应
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

- (BOOL)navigationShouldPopOnBackButton {
    [self removeAllScriptMsgHandle];
    return YES;
}

-(void)removeAllScriptMsgHandle{
    WKUserContentController *controller = self.wkWebView.configuration.userContentController;
    [controller removeScriptMessageHandlerForName:@"AppModel"];
}


@end
