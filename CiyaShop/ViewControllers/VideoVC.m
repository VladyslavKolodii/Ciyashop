//
//  VideoVC.m
//  CiyaShop
//
//  Created by Jitendra on 22/11/18.
//  Copyright © 2018 Potenza. All rights reserved.
//

#import "VideoVC.h"

@interface VideoVC ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwVideo;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;
@property (strong, nonatomic) IBOutlet UIImageView *imgHeaderImage;
@property (strong, nonatomic) IBOutlet UIWebView *wvVideo;

@end

@implementation VideoVC {
    TRVideoView *vtrView;
    UIView *vw;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if([Util getStringData:kAppNameWhiteImage] !=nil){
        
        [self.imgHeaderImage sd_setImageWithURL:[Util EncodedURL:[Util getStringData:kAppNameWhiteImage]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            if (image == nil)
            {
                self.imgHeaderImage.image = [UIImage imageNamed:@"HeaderClickShop"];
            }
            else
            {
                self.imgHeaderImage.image = image;
            }
        }];
    }

    vtrView = [[TRVideoView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    vtrView.delegate = self;
    NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]initWithURL: [NSURL URLWithString:self.url]];
    [vtrView loadRequest:request1];
    [self.vwVideo addSubview:vtrView];
    [Util setHeaderColorView:self.vwHeader];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    vtrView.frame = CGRectMake(0, 0, self.vwVideo.frame.size.width, self.vwVideo.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

-(IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIWebView Delegate

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

#pragma mark - StatusBar Delegate
/*!
 * @discussion This method is used to set Status bar text color
 */
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
