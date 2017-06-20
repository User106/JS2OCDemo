# JS2OCDemo
webView与OC交互
首先UIWebView会加载html页面，和javaScript到WebView容器的上下文中。

###OC操作JS调用：
UIWebView
```
①- (NSString *)stringByEvaluatingJavaScriptFromString :( NSString *)script
```
WKWebView
```
①- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(void (^ _Nullable)(_Nullable id, NSError * _Nullable error))completionHandler;
```
有了这个函数，我们可以

- 传递js代码给JS，调用webview上下文中的函数和变量。

- 取JS的返回值，根据返回值来调用相应的OC函数等。

但是，上面这个函数是OC主动调用的，JS端无法直接操作，JS里面有很多内容，但是只能等OC去取，不能主动送出来。所以，我们需要一个触发条件，来告诉OC，我大JS准备好各种变量，函数等内容了，你来调用我吧。
#####触发条件:请求非法URL
我们的JS通过请求一个非法（特定）的URL，触发UIWebViewDelegate的回调函数：
```
②- (BOOL)webView :( UIWebView *)webView shouldStartLoadWithRequest :( NSURLRequest *)request navigationType :( UIWebViewNavigationType)navigationType
```
或者WKNavigationDelegate的代理函数
```
②- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
```

告知OC，我JS有话说。。。具体想说啥内容，你OC可以通过

1. 上面①中的函数来自己查询。

2. 或者我JS把想说的话，放到URL里面，你OC自己解析。

#####触发条件:scriptMessageHandler(WKWebView专用)
创建WKWebView

```
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
```
WKScriptMessageHandler代理方法接收

```
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {

    if ([message.name isEqualToString:name]) {
        //
        NSLog(@"接收到js传递到消息");
    }
}
```

网页端示例代码

```
<html>
<body>
    <button onclick="test()">clickMe</button>
</body>
</html>
<script type="text/javascript">
  function test(){
window.webkit.messageHandlers.appModel.postMessage({"name":"aname"})
  }
</script>
```
