//
//  DescriptionVC.m
//  QuickClick
//
//  Created by Kaushal PC on 28/06/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "DescriptionVC.h"
#import <WebKit/WebKit.h>

@interface DescriptionVC () <WKUIDelegate, WKNavigationDelegate, UIScrollViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *vwName;
@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UIView *vwAllData;
@property (weak, nonatomic) IBOutlet UIView *vwImage;

@property (strong, nonatomic) IBOutlet UIImageView *imgProduct;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblProductName;
@property (strong, nonatomic) IBOutlet UILabel *lblDescription;
@property (strong, nonatomic) IBOutlet UILabel *lblDescriptionTitle;

@property (strong, nonatomic) IBOutlet UITextView *txtDescription;
@property (strong, nonatomic) IBOutlet UIWebView *webDescription;
@property (weak, nonatomic) IBOutlet WKWebView *wkWebDescription;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *act;

@property (strong, nonatomic) IBOutlet UIScrollView *scrl;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;


@end

@implementation DescriptionVC {
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    [Util setHeaderColorView:vw];

    [self localize];
    
    [self.scrl bringSubviewToFront:self.lblDescription];
    
    self.lblProductName.text = self.strName;
    [self.act startAnimating];
    [self.imgProduct sd_setImageWithURL:[Util EncodedURL:self.strImage] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        [self.act stopAnimating];
        self.imgProduct.image=image;
    }];
    
}

-(void)viewWillLayoutSubviews
{
    self.lblDescriptionTitle.text = self.strDescTitle;
//    self.lblDescription.attributedText = self.strDesc;
    [self.lblDescription sizeToFit];
//    self.txtDescription.attributedText=self.strDesc;
    [self.txtDescription sizeToFit];
    
    NSString *strHtml1 = self.strDesc;
    if (appDelegate.isRTL) {
        strHtml1 = [NSString stringWithFormat:@"<body dir=\"rtl\" >%@</body>", strHtml1];
    }
//wk-Web View-------------------------------------
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
    [self.wkWebDescription loadHTMLString:[headerString stringByAppendingString:strHtml1] baseURL:nil];
//-----------------------------------------------


//    [self.webDescription loadHTMLString:strHtml1 baseURL:nil];

    
    [self.webDescription stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 1.2;"];
    [self.webDescription setScalesPageToFit:NO];
        
    if (self.txtDescription.frame.size.width > SCREEN_SIZE.width)
    {
//        self.scrl.contentSize = CGSizeMake(self.webDescription.frame.size.width, self.webDescription.frame.origin.y + self.webDescription.frame.size.height + 20);
        self.scrl.contentSize = CGSizeMake(self.wkWebDescription.frame.size.width, self.wkWebDescription.frame.origin.y + self.wkWebDescription.frame.size.height + 20);

    }
    else
    {
        self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.txtDescription.frame.origin.y + self.txtDescription.frame.size.height + 20);
    }
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}


#pragma mark - Localize Language
/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    [Util setPrimaryColorLabelText:self.lblProductName];

    self.lblTitle.textColor = OtherTitleColor;
    self.lblTitle.font=Font_Size_Navigation_Title;
    
    self.lblProductName.font=Font_Size_Navigation_Title;
    
    self.lblDescription.font=Font_Size_Product_Name_Not_Bold;
    self.lblDescription.textColor=FontColorGray;
    
    self.lblDescriptionTitle.font=Font_Size_Title;
    self.lblDescriptionTitle.textColor=LightBlackColor;
    
    NSString *str = [self.strDescTitle stringByReplacingOccurrencesOfString:@":" withString:@""];
    self.lblTitle.text = str;
    
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        
        
        self.vwImage.frame = CGRectMake(self.vwName.frame.size.width - self.vwImage.frame.size.width - 26, self.vwImage.frame.origin.y, self.vwImage.frame.size.width, self.vwImage.frame.size.height);
        self.lblProductName.frame = CGRectMake(self.vwName.frame.size.width - self.lblProductName.frame.size.width - 99, self.lblProductName.frame.origin.y, self.lblProductName.frame.size.width, self.lblProductName.frame.size.height);
        
        self.lblProductName.textAlignment = NSTextAlignmentRight;
        self.lblDescription.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //NonRTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }    
}
#pragma mark - Button Clicks
/*!
 * @discussion will Take you to Previous page
 * @param sender For indentifying sender
 */
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - StatusBar Delegate
/*!
 * @discussion This method is used to set Status bar text color
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - WKWebView Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    SHOW_LOADER_ANIMTION();
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    HIDE_PROGRESS;
}
- (void)webViewDidClose:(WKWebView *)webView {
    HIDE_PROGRESS;
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSString *javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    [self.wkWebDescription evaluateJavaScript:javascript completionHandler:nil];
}

@end
