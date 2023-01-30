//
//  WebViewContainVC.m
//  CiyaShop
//
//  Created by Potenza ` on 14/06/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import "WebViewContainVC.h"

@interface WebViewContainVC()<UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate>

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIImageView *imgHeaderImage;

@end

@implementation WebViewContainVC {
    UIView *vw;
    NSMutableArray *arrFromWeb;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString *strURL = [[appDelegate.arrFromWebView objectAtIndex:self.index] valueForKey:@"web_view_pages_page_id"];
    NSString *strTitle = [[appDelegate.arrFromWebView objectAtIndex:self.index] valueForKey:@"web_view_pages_page_title"];

    self.lblTitle.text = strTitle;
    
    NSURL *targetURL = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];

    [self.webViewContain loadRequest:request];
    
    [self.view addSubview:self.webViewContain];
    
    [self setUpWKWebView];

}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self localize];
}
- (void)setUpWKWebView {
    [self setupWebView];
}

- (void)setupWebView {
    self.wkWebViewContain.allowsBackForwardNavigationGestures = YES;
    self.wkWebViewContain.navigationDelegate = self;
    [self.vwAllData addSubview: self.wkWebViewContain];
}

- (void)setURL:(NSString *)requestURLString {
    NSString *strURL = [[appDelegate.arrFromWebView objectAtIndex:self.index] valueForKey:@"web_view_pages_page_id"];

    NSURL *targetURL = [NSURL URLWithString:strURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.wkWebViewContain loadRequest:request];
    
//    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
//    [self.webView loadHTMLString:[headerString stringByAppendingString:yourHTMLString] baseURL:nil];

}

- (void)localize {
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = [UIColor whiteColor];
    self.lblTitle.font = Font_Size_Navigation_Title;
    if (appDelegate.isRTL) {
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
}

#pragma mark - Button Clicked

- (IBAction)btnBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

#pragma mark - UIWebView Delegate

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    SHOW_LOADER_ANIMTION();
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    HIDE_PROGRESS;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    HIDE_PROGRESS;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSString *javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    [self.wkWebViewContain evaluateJavaScript:javascript completionHandler:nil];
}

#pragma mark - StatusBar Delegate
/*!
 * @discussion This method is used to set Status bar text color
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#pragma mark - hide bottom bar

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}
@end
