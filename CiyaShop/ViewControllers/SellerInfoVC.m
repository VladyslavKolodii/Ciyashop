//
//  SellerInfoVC.m
//  CiyaShop
//
//  Created by Kaushal PC on 04/11/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "SellerInfoVC.h"

@interface SellerInfoVC () <WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIScrollView *scrl;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@end

@implementation SellerInfoVC {
    UIView *vw;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
    [self.wkWebDetails loadHTMLString:[headerString stringByAppendingString:self.strDesc] baseURL:nil];



//    [self.wvDetails loadHTMLString:self.strDesc baseURL:nil];
//    [self.wvDetails stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 1.2;"];

    
    self.lblTitle.text = self.strTitle;
    self.lblDesc.text = self.strDesc;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self localize];
    [Util setHeaderColorView:vw];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
 
    [self.lblDesc sizeToFit];
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.lblDesc.frame.origin.y + self.lblDesc.frame.size.height + 15);
}

#pragma mark - Localize Language

- (void)localize
{
    self.lblTitle.textColor = OtherTitleColor;
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.font=Font_Size_Navigation_Title;
    self.lblDesc.font = Font_Size_Product_Name_Regular;
    
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        
        self.lblDesc.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //NonRTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        
        self.lblDesc.textAlignment = NSTextAlignmentLeft;
    }

    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

#pragma mark - Button Clicks

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
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    SHOW_LOADER_ANIMTION();
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    HIDE_PROGRESS;
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    NSString *javascript = @"var meta = document.createElement('meta');meta.setAttribute('name', 'viewport');meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    [self.wkWebDetails evaluateJavaScript:javascript completionHandler:nil];
}


@end
