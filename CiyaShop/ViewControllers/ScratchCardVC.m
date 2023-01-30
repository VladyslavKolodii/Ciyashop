//
//  ScratchCardVC.m
//  CiyaShop
//
//  Created by Kaushal PC on 03/04/18.
//  Copyright © 2018 Potenza. All rights reserved.
//

#import "ScratchCardVC.h"
#import "MDScratchImageView.h"



@interface ScratchCardVC ()<MDScratchImageViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *lblCouponCode;
@property (strong, nonatomic) IBOutlet UILabel *lblScretchDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblScratchCode;

@property (strong, nonatomic) IBOutlet UILabel *lblScratchHere;

@property (strong, nonatomic) IBOutlet UIView *vwScratch;
@property (strong, nonatomic) IBOutlet UIView *vwScratchBG;

@property (strong, nonatomic) IBOutlet UIView *vwAllData;

@property (strong,nonatomic) IBOutlet UIImageView *imgCoupon;

@end

@implementation ScratchCardVC
{
    BOOL scratch,first;
    UIView *vw;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    scratch = false;
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.vwScratch.layer.cornerRadius = 8;
    self.vwScratch.layer.masksToBounds = true;
    
    self.lblScratchCode.text = self.strCouponCode;
    self.lblScretchDesc.text = self.strCouponDesc;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    first = false;
    
    self.vwScratchBG.hidden = NO;
    self.vwScratchBG.alpha = 0;
    self.vwScratch.hidden=NO;
    self.vwScratch.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.4 animations:^{
        
        self.vwScratchBG.alpha = 0.8;
        self.vwScratch.transform = CGAffineTransformIdentity;
        
    }];

}

-(void)localize {
    self.lblScratchHere.text = [MCLocalization stringForKey:@"Scratch here to get coupon Code."];
    self.lblCouponCode.text = [MCLocalization stringForKey:@"Coupon Code"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self localize];
    [Util setHeaderColorView:vw];

    
    if (@available(iOS 13, *))
    {
        UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
        statusBar.backgroundColor = [UIColor blackColor];
        [statusBar setHidden:NO];
        [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
    }
    else
    {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        [statusBar setHidden:NO];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor blackColor];
        }
    }


}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    
    if (@available(iOS 13, *))
    {
        UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
        [Util setHeaderColorView:statusBar];
        [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
    }
    else
    {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            [Util setHeaderColorView:statusBar];
        }
    }
}

-(void)viewDidLayoutSubviews {

    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    self.vwAllData.backgroundColor = [UIColor clearColor];
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];

    self.vwScratch.frame = CGRectMake(self.vwScratch.frame.origin.x, self.vwScratch.frame.origin.y, self.vwScratch.frame.size.width, self.vwScratch.frame.size.width);
    
    if(!first) {
        first = true;
        MDScratchImageView *scratchImageView = [[MDScratchImageView alloc] initWithFrame:CGRectMake(0, 0, self.vwScratch.frame.size.width, self.vwScratch.frame.size.height)];
        scratchImageView.image = [UIImage imageNamed:@"scratchCard"];
        scratchImageView.delegate = self;
        [self.vwScratch addSubview:scratchImageView];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Clicks

- (IBAction)btnCancelClick:(id)sender {    
    self.vwScratch.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.vwScratch.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.vwScratchBG.alpha = 0.0;
        
    } completion:^(BOOL finished){
        
        self.vwScratch.hidden = YES;
        self.vwScratchBG.hidden = YES;
        [self.navigationController popViewControllerAnimated:NO];
    }];
}

#pragma mark - MDScratchCard Delegate

- (void)mdScratchImageView:(MDScratchImageView *)scratchImageView didChangeMaskingProgress:(CGFloat)maskingProgress {
    NSLog(@"%s %p progress == %.2f", __PRETTY_FUNCTION__, scratchImageView, maskingProgress);
    
    if (!scratch) {
        if (maskingProgress > 0.65) {
            //API call here
            scratch = true;
            if (self.delegate != nil) {
                [self.delegate scratchView];
            }
        }
    }
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
