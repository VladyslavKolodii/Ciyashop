//
//  IntroductionVC.m
//  CiyaShop
//
//  Created by Kaushal Parmar on 12/04/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import "IntroductionVC.h"

@interface IntroductionVC () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnSkip;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet UIScrollView *scrl;

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;
@property (weak, nonatomic) IBOutlet UIImageView *img3;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle1;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle2;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle3;

@property (weak, nonatomic) IBOutlet UILabel *lblDesc1;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc2;
@property (weak, nonatomic) IBOutlet UILabel *lblDesc3;

@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@end

@implementation IntroductionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    if (@available(iOS 13, *))
    {
        UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
        statusBar.backgroundColor = [UIColor whiteColor];
        [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
    }
    else
    {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [UIColor whiteColor];
        }
    }


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self localize];
}

- (void)localize {
    
    //page 1 text
    self.lblTitle1.text = [MCLocalization stringForKey:@"E-Commerce App"];
    self.lblDesc1.text = [MCLocalization stringForKey:@"E-Commerce Application template, buy this code template from Codecanyon"];
    
    //page 2 text
    self.lblTitle2.text = [MCLocalization stringForKey:@"Choose Items"];
    self.lblDesc2.text = [MCLocalization stringForKey:@"Choose item wherever you are with this application to make life easier"];
    
    //page 3 text
    self.lblTitle3.text = [MCLocalization stringForKey:@"Buy Item"];
    self.lblDesc3.text = [MCLocalization stringForKey:@"Shop from thousand brands in the world from one application at throw away price"];

    if (appDelegate.isRTL) {
        [self.scrl setContentOffset:CGPointMake(self.scrl.contentSize.width - self.scrl.frame.size.width, 0) animated:true];
        [self.pageController setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        [self.view layoutIfNeeded];
    } else {
        [self.scrl setContentOffset:CGPointZero animated:true];
    }

    [self.pageController setCurrentPageIndicatorTintColor:[Util colorWithHexString:[Util getStringData:kSecondaryColor]]];
    
    self.lblTitle1.font = Font_Size_Big_Title;
    self.lblTitle2.font = Font_Size_Big_Title;
    self.lblTitle3.font = Font_Size_Big_Title;
    
    self.lblDesc1.font = Font_Size_Price_Sale;
    self.lblDesc2.font = Font_Size_Price_Sale;
    self.lblDesc3.font = Font_Size_Price_Sale;
    
    [self.btnNext setTitle:[MCLocalization stringForKey:@"NEXT"] forState:UIControlStateNormal];
    [self.btnSkip setTitle:[MCLocalization stringForKey:@"SKIP"] forState:UIControlStateNormal];
    
    [Util setGrayColorLabelText:self.lblDesc1];
    [Util setGrayColorLabelText:self.lblDesc2];
    [Util setGrayColorLabelText:self.lblDesc3];
    
    [self.btnNext setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
    [self.btnSkip setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
}

#pragma mark - Navigation

- (IBAction)btnSkipClicked:(id)sender {
    [Util setBoolData:YES setBoolData:kFirstTime];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)btnNextClicked:(id)sender {
    float width = self.scrl.frame.size.width;
    float contentYoffset = self.scrl.contentOffset.x;
    
    if (appDelegate.isRTL) {
        if (contentYoffset < self.scrl.frame.size.width) {
            [Util setBoolData:YES setBoolData:kFirstTime];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            float index = self.scrl.contentOffset.x/ self.scrl.frame.size.width;
//            index = 3 - index;
            [self.scrl setContentOffset:CGPointMake((index - 1) * width, 0) animated:true];
        }
    } else {
        float distanceFromBottom = self.scrl.contentSize.width - contentYoffset;
        if (distanceFromBottom <= width) {
            [Util setBoolData:YES setBoolData:kFirstTime];
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            float index = self.scrl.contentOffset.x/ self.scrl.frame.size.width;
            [self.scrl setContentOffset:CGPointMake((index + 1) * width, 0) animated:true];
        }
    }
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentSize.width > scrollView.frame.size.width) {
        [self setScrollIndex:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self setScrollIndex:scrollView];
}

- (void) setScrollIndex:(UIScrollView *)scrollView {
    int pageindex = scrollView.contentOffset.x/scrollView.frame.size.width;
    [self.pageController setCurrentPage:pageindex];
    
    float width = scrollView.frame.size.width;
    float contentYoffset = scrollView.contentOffset.x;
    
    if (appDelegate.isRTL) {
//        float distanceFromBottom = (2 * scrollView.contentSize.width) - contentYoffset;
        if (contentYoffset < scrollView.frame.size.width) {
            [self.btnNext setTitle:[MCLocalization stringForKey:@"DONE"] forState:UIControlStateNormal];
            [Util setPrimaryColorButtonTitle:self.btnNext];
//            [self.btnSkip setHidden:true];
        } else {
            [self.btnNext setTitle:[MCLocalization stringForKey:@"NEXT"] forState:UIControlStateNormal];
            [self.btnNext setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            [self.btnSkip setHidden:false];
        }
    } else {
        float distanceFromBottom = scrollView.contentSize.width - contentYoffset;
        if (distanceFromBottom <= width) {
            [self.btnNext setTitle:[MCLocalization stringForKey:@"DONE"] forState:UIControlStateNormal];
            [Util setPrimaryColorButtonTitle:self.btnNext];
//            [self.btnSkip setHidden:true];
        } else {
            [self.btnNext setTitle:[MCLocalization stringForKey:@"NEXT"] forState:UIControlStateNormal];
            [self.btnNext setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//            [self.btnSkip setHidden:false];
        }
    }
}

@end
