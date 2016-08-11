# JS2OCDemo
webView与OC交互
首先UIWebView会加载html页面，和javaScript到UIWebView的上下文中。

OC操作JS调用：

①- (NSString *)stringByEvaluatingJavaScriptFromString :( NSString *)script；
有了这个函数，我们可以

1）传递string给JS，调用webview上下文中的函数和变量。

2）取JS的返回值，根据返回值来调用相应的OC函数等。

但是，上面这个函数是OC主动调用的，JS端无法直接操作，JS里面有很多内容，但是只能等OC去取，不能主动送出来。所以，我们需要有一个触发条件，来告诉OC，我大JS准备好各种变量，函数等内容了，你来调用我吧。这个触发条件就是：请求URL。

我们的JS通过请求一个非法（特定）的URL，触发UIWebViewDelegate的回调函数：

②- (BOOL)webView :( UIWebView *)webView shouldStartLoadWithRequest :( NSURLRequest *)request navigationType :( UIWebViewNavigationType)navigationType

告知OC，我JS有话说。。。具体想说啥内容，你OC可以通过

1）上面①中的函数来自己查询。

2）或者我JS把想说的话，放到URL里面，你OC自己解析.