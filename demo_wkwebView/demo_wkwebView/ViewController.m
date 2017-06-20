//
//  ViewController.m
//  demo_wkwebView
//
//  Created by Chao on 2017/4/24.
//  Copyright © 2017年 Chao. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "CCViewController.h"
static NSString *name = @"appModel";

@interface ViewController ()<WKScriptMessageHandler,WKNavigationDelegate,CCViewControllerDelegate>
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initWk];
}

- (void)initWk {

    WKWebViewConfiguration *config =[[WKWebViewConfiguration alloc]init];
    // 设置偏好设置
    config.preferences = [[WKPreferences alloc] init];
    // 默认为0
    config.preferences.minimumFontSize = 10;
    // 默认认为YES
    config.preferences.javaScriptEnabled = YES;
    // 在iOS上默认为NO，表示不能自动通过窗口打开
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    /**
     *  这个name注入JS对象名称Xxxx，当JS通过Xxx来调用时，
     *  JS对象可以注入多个，用于不同的功能
     *  我们可以在WKScriptMessageHandler代理中接收到
     */
    [config.userContentController addScriptMessageHandler:self name:name];
    _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];
    _webView.navigationDelegate = self;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"demo.html" ofType:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    if ([message.name isEqualToString:name]) {
        //
        NSLog(@"接收到js传递到消息");
        //执行js代码
        [_webView evaluateJavaScript:@"js_code" completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            
        }];
    }
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {

    NSString *scheme = navigationAction.request.URL.scheme;
    if ([scheme isEqualToString:@"chao"]) {
        // 在这里做 js 调 native 的事情
        NSLog(@"%@",navigationAction.request.URL.relativeString);
        CCViewController *VC = [[CCViewController alloc] initWithNibName:@"CCViewController" bundle:nil];
        VC.delegate = self;
        [self presentViewController:VC animated:YES completion:^{
            
        }];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
- (void)CCViewControllerDidClickBtn:(NSString *)text
{
    NSString *jsCode = [NSString stringWithFormat:@"document.body.innerHTML +='<br>%@'",text];
    [_webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
        
    }];
}
@end
