//
//  HomeVC.m
//  QuickClick
//
//  Created by Umesh on 4/15/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "HomeVC.h"
#import "ShopNowCell.h"
#import "BannerAdCell.h"
#import "MostPopularProductCell.h"
#import "DealOfTheDayCell.h"
#import "OfferByCatagoriesCell.h"
#import "HomeShopDataVC.h"
#import "HeaderTabCell.h"
#import "GroupItemDetailVC.h"
#import "VariableItemDetailVC.h"
#import "ItemDetailVC.h"
#import "RecentProductMainCell.h"
#import "ReasonToBuyWithUsCell.h"
#import "GTMNSString+HTML.h"
#import "SubCategoryVC.h"
#import "SigninVC.h"
#import "IntroductionVC.h"

#import <FBShimmering.h>
#import <FBShimmeringView.h>

@import ListPlaceholder;
@import Firebase;
@import GoogleSignIn;

@interface HomeVC () <UITabBarDelegate, UITableViewDelegate, UITableViewDataSource, RedirectToMostPopularProductDelegate, RedirectToDealOfTheDayDelegate, SetCategoryDelegate, ClickOnRecentProductDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imgHeaderAppName;

@property (strong, nonatomic) IBOutlet UIImageView *imgBg;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderInfinite;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderInfinite1;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderInfinite2;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderInfinite3;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderInfinite4;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderInfinite5;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderInfinite6;

@property (weak, nonatomic) IBOutlet UIView *vwLoader;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderHeader;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderHeaderCategory;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderCategory;
@property (weak, nonatomic) IBOutlet UIView *vwLoaderBanner;
@property (weak, nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UIView *vwHeaderContent;
@property (weak, nonatomic) IBOutlet UIView *vwSearch;
@property (weak, nonatomic) IBOutlet UIView *vwContent;
@property (weak, nonatomic) IBOutlet UIView *vwBG;

@property (weak, nonatomic) IBOutlet UIScrollView *scrlImages;
@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@property (weak, nonatomic) IBOutlet UIView *vwTableHeader;
@property (weak, nonatomic) IBOutlet UIView *vwTableFooter;

@property(strong,nonatomic) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UITableView *tblShopDetail;
@property (weak, nonatomic) IBOutlet UITableView *tblFooter;
@property (strong, nonatomic) IBOutlet UICollectionView *colHeader;
@property (weak, nonatomic) IBOutlet UICollectionView *colInfiniteData;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIImageView *imgSearch;
@property (weak, nonatomic) IBOutlet UIButton *btnNotification;

@end

@implementation HomeVC {
    NSMutableArray *imagesArray, *arrInfiniteProductData;
    NSInteger prevOffset;
    int set, page, pageInfiniteData, noProductFound, selectedIndex;
    UIRefreshControl *refreshControl;
    UIRefreshControl *refreshControlInfiniteScroll;
    CGRect HeaderFrame, SearchFrame, ContentViewFrame, originalFrame;
    UIView *vw;
    
    BOOL isEnablePopularProduct, isEnableRecentlyAdded, isEnableSelected, isEnableDealofTheDay, isEnableTopRatedProduct, isEnabledSelectedProductList;
    NSMutableArray *arrItemIndex;// 1=PopularProduct, 2=RecentlyAddedProduct, 3=SelectedProduct, 4=DealOofTheDay, 5=BrandsCarosol, 6=CategorySlider
    NSString *strPopularProduct, *strRecentlyAddedProduct, *strSelectedProduct, *strDealOofTheDay, *strTopRatedProduct, *strSelectedProductList;
    
    BOOL apiCallRunning;
    NSMutableArray *arrWishList, *arrGroupedProduct;
    NSArray *arrselect,*arrUnselect;
    NSString *selectedProductId;
    
    UIActivityIndicatorView *actInfiniteScroll;
    
    BOOL successData, homeResponse;
    NSString *messageData;
    NSDictionary *dictionaryData;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrInfiniteProductData = [[NSMutableArray alloc] init];
    Product *p = [[Product alloc] init];
    [arrInfiniteProductData addObject:p];
    [arrInfiniteProductData addObject:p];
    [arrInfiniteProductData addObject:p];
    [arrInfiniteProductData addObject:p];
    [arrInfiniteProductData addObject:p];

    NSLog(@"plugin version : %@",PLUGIN_VERSION1);
    selectedIndex = -1;
    
    if (IS_FROM_STATIC_DATA && IS_INTRO_SLIDER) {
        appDelegate.isSliderScreen = true;
    }
    if (IS_FROM_STATIC_DATA && IS_LOGIN) {
        appDelegate.isLoginScreen = true;
    }

    self->actInfiniteScroll = [[UIActivityIndicatorView alloc] init];
    [self->actInfiniteScroll setHidesWhenStopped:true];
    self->actInfiniteScroll.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self->actInfiniteScroll.frame = CGRectMake((SCREEN_SIZE.width/2) - self->actInfiniteScroll.frame.size.width, SCREEN_SIZE.height - self.tabBarController.tabBar.frame.size.height - 20, self->actInfiniteScroll.frame.size.width, self->actInfiniteScroll.frame.size.height);
    [self.view addSubview:self->actInfiniteScroll];

    arrItemIndex = [[NSMutableArray alloc] initWithObjects: @"3", @"4", @"2", @"1", @"5", @"6", nil];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [refreshControl setTintColor:[Util colorWithHexString:[Util getStringData:kPrimaryColor]]];
    [self.tblShopDetail addSubview:refreshControl];

    [refreshControl addTarget:self action:@selector(homePagePulltoRefreshApi) forControlEvents:UIControlEventValueChanged];
    
    refreshControlInfiniteScroll = [[UIRefreshControl alloc]init];
    [refreshControlInfiniteScroll setTintColor:[Util colorWithHexString:[Util getStringData:kPrimaryColor]]];
    [self.colInfiniteData addSubview:refreshControlInfiniteScroll];
    [refreshControlInfiniteScroll addTarget:self action:@selector(getHomeScrolling) forControlEvents:UIControlEventValueChanged];
    
    page = 1;
    appDelegate.arrCategory = [[NSMutableArray alloc] init];
    
    if (IS_FROM_STATIC_DATA) {
        if (IS_INFINITE_SCROLL){
            [self getHomeScrolling];
        } else {
            homeResponse = true;
            [self homePageApi];
        }
    } else {
        [self getHomeScrolling];
    }

    [self updateDots];
    
    self.timer= [NSTimer scheduledTimerWithTimeInterval:7.0 target:self selector:@selector(onTimer) userInfo:nil repeats:YES];
    self.navigationController.navigationBarHidden = YES;

    self.tblShopDetail.delegate=self;
    self.tblShopDetail.dataSource=self;
    
    self.scrlImages.showsHorizontalScrollIndicator=NO;
    self.scrlImages.pagingEnabled = YES;
    
    //nib registration for cell

    [self.tblShopDetail registerNib:[UINib nibWithNibName:@"ShopNowCell" bundle:nil] forCellReuseIdentifier:@"ShopNowCell"];
    [self.tblShopDetail registerNib:[UINib nibWithNibName:@"BannerAdCell" bundle:nil] forCellReuseIdentifier:@"BannerAdCell"];
    [self.tblShopDetail registerNib:[UINib nibWithNibName:@"MostPopularProductCell" bundle:nil] forCellReuseIdentifier:@"MostPopularProductCell"];
    [self.tblShopDetail registerNib:[UINib nibWithNibName:@"DealOfTheDayCell" bundle:nil] forCellReuseIdentifier:@"DealOfTheDayCell"];
    [self.tblShopDetail registerNib:[UINib nibWithNibName:@"OfferByCatagoriesCell" bundle:nil] forCellReuseIdentifier:@"OfferByCatagoriesCell"];
    
    [self.tblFooter registerNib:[UINib nibWithNibName:@"RecentProductMainCell" bundle:nil] forCellReuseIdentifier:@"RecentProductMainCell"];
    [self.tblFooter registerNib:[UINib nibWithNibName:@"ReasonToBuyWithUsCell" bundle:nil] forCellReuseIdentifier:@"ReasonToBuyWithUsCell"];

    [self.colHeader registerNib:[UINib nibWithNibName:@"HeaderTabCell" bundle:nil] forCellWithReuseIdentifier:@"HeaderTabCell"];
    [self.colInfiniteData registerNib:[UINib nibWithNibName:@"ShopDataGridCell" bundle:nil] forCellWithReuseIdentifier:@"ShopDataGridCell"];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    set = 0;
    self.pageController.transform = CGAffineTransformMakeScale(0.7, 0.7);
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (![Util getBoolData:kFirstTime] && appDelegate.isSliderScreen) {
        IntroductionVC *vc=[[IntroductionVC alloc] initWithNibName:@"IntroductionVC" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        navigationController.navigationBar.hidden = YES;
        navigationController.modalPresentationStyle=UIModalPresentationFullScreen;
        [self presentViewController:navigationController animated:YES completion:nil];
    } else if (![Util getBoolData:kLogin] && appDelegate.isLoginScreen) {
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [[GIDSignIn sharedInstance] signOut];
        SigninVC *vc=[[SigninVC alloc] initWithNibName:@"SigninVC" bundle:nil];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        navigationController.navigationBar.hidden = YES;
        navigationController.modalPresentationStyle=UIModalPresentationFullScreen;
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    if (appDelegate.currency)
    {
        appDelegate.currency = false;
        [appDelegate setDataForCiyashopOauth];
        [self getHomeScrolling];
    }
    [appDelegate showBadge];
    [self addFooterToTableView];

    [self hidesBottomBarWhenPushed];
    
    [self localize];
    [Util setHeaderColorView:vw];
    
    arrWishList = [[NSMutableArray alloc] init];
    
    [arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];

    [self.tblShopDetail reloadData];

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
    [self.colInfiniteData reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);

    if (set == 0) {
        self.pageController.frame = CGRectMake(self.pageController.frame.origin.x, self.pageController.frame.origin.y, self.pageController.frame.size.width, 45*SCREEN_SIZE.width/375);
        
        self.vwLoader.frame = CGRectMake(0, self.vwLoader.frame.origin.y +  self.vwHeader.frame.origin.y + self.vwBG.frame.origin.y, SCREEN_SIZE.width, self.vwLoader.frame.size.height);
        
        self.vwTableHeader.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 196*SCREEN_SIZE.width/375);
        self.vwLoaderHeaderCategory.frame = CGRectMake(0, 0, SCREEN_SIZE.width, self.vwLoaderHeaderCategory.frame.size.height);
        self.vwLoaderHeader.frame = CGRectMake(0, self.vwLoaderHeaderCategory.frame.size.height + 15, SCREEN_SIZE.width, 196*SCREEN_SIZE.width/375);
        self.vwLoaderCategory.frame = CGRectMake(0, self.vwLoaderHeader.frame.origin.y + self.vwLoaderHeader.frame.size.height + 8, SCREEN_SIZE.width, self.vwLoaderCategory.frame.size.height);
        self.vwLoaderBanner.frame = CGRectMake(0, self.vwLoaderCategory.frame.origin.y + self.vwLoaderCategory.frame.size.height + 8, SCREEN_SIZE.width, self.vwLoaderBanner.frame.size.height);
        
        self.vwTableHeader.frame = CGRectMake(0, 0, SCREEN_SIZE.width, 196*SCREEN_SIZE.width/375);
        
        self.tblShopDetail.tableHeaderView = self.vwTableHeader;
        
        HeaderFrame = self.vwHeader.frame;
        SearchFrame = self.vwSearch.frame;
        self.vwContent.frame = CGRectMake(0, self.vwContent.frame.origin.y, self.vwContent.frame.size.width, self.vwContent.frame.size.height + self.vwHeader.frame.size.height - 60);
        ContentViewFrame = self.vwContent.frame;
        
        UITabBar *tb = self.tabBarController.tabBar;
        originalFrame = tb.frame;
        tb.frame = CGRectMake(tb.frame.origin.x, SCREEN_SIZE.height, tb.frame.size.width, tb.frame.size.height);
        
        self.vwBG.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        
        set = 1;
    }

    self->actInfiniteScroll.frame = CGRectMake((SCREEN_SIZE.width/2) - self->actInfiniteScroll.frame.size.width, SCREEN_SIZE.height - self.tabBarController.tabBar.frame.size.height - statusBarSize.height - 10, self->actInfiniteScroll.frame.size.width, self->actInfiniteScroll.frame.size.height);

    self.scrlImages.contentSize = CGSizeMake(SCREEN_SIZE.width * (imagesArray.count - 1),self.scrlImages.frame.size.height);
    
    [self setScrollingImageViews];
    
    [self.tblShopDetail reloadData];
}

#pragma mark - Check Deep-link Data

-(void)checkDeepLinkData {
    if (![appDelegate.productID isEqualToString:@""] && appDelegate.productID != nil) {
        [self getSingleProduct:appDelegate.productID];
        appDelegate.productID = nil;
    }
}

#pragma mark - Localize Language

- (void)localize {
    [Util setHeaderColorView:self.vwSearch];
    [Util setHeaderColorView:self.vwHeaderContent];
    [Util setPrimaryColorActivityIndicator:actInfiniteScroll];
    
    self.txtSearch.attributedPlaceholder = [[NSAttributedString alloc] initWithString:[MCLocalization stringForKey:@"Search for products"] attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor],NSFontAttributeName:Font_Size_Product_Name_Not_Bold}];
    
    self.txtSearch.font = Font_Size_Product_Name_Not_Bold;
    
    if (appDelegate.isRTL) {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.txtSearch.frame = CGRectMake(self.vwSearch.frame.size.width - self.txtSearch.frame.size.width - 27, self.txtSearch.frame.origin.y, self.txtSearch.frame.size.width, self.txtSearch.frame.size.height);
        self.txtSearch.textAlignment = NSTextAlignmentRight;
        self.imgSearch.frame = CGRectMake(27*SCREEN_SIZE.width/375, self.imgSearch.frame.origin.y, self.imgSearch.frame.size.width, self.imgSearch.frame.size.height);
    } else {
        //No RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.txtSearch.frame = CGRectMake(27, self.txtSearch.frame.origin.y, self.txtSearch.frame.size.width, self.txtSearch.frame.size.height);
        self.txtSearch.textAlignment = NSTextAlignmentLeft;
        self.imgSearch.frame = CGRectMake(self.vwSearch.frame.size.width - self.imgSearch.frame.size.width - 27*SCREEN_SIZE.width/375, self.imgSearch.frame.origin.y, self.imgSearch.frame.size.width, self.imgSearch.frame.size.height);
    }
    [self.tblShopDetail reloadData];
    [self.tblFooter reloadData];
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

#pragma mark - image scrolling Method

-(void)onTimer {
    if(self.pageController.currentPage == imagesArray.count - 1) {
        self.pageController.currentPage = 0;
        [self.scrlImages setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    } else {
        self.pageController.currentPage = self.pageController.currentPage + 1;
        [self.scrlImages setContentOffset:CGPointMake((self.pageController.currentPage * SCREEN_SIZE.width), 0.0) animated:YES];
    }
}


#pragma mark - Scroll View Delegates

//method to manage tab bar show and hide

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 100 || scrollView == self.colInfiniteData) {
        NSInteger yOffset = scrollView.contentOffset.y;
        
        float scrollViewHeight = scrollView.frame.size.height;
        float scrollContentSizeHeight = scrollView.contentSize.height;
        if (yOffset <= 0) {
            [UIView animateWithDuration:0.4 animations:^{
                self.vwHeader.frame = self->HeaderFrame;
                self.vwSearch.frame = self->SearchFrame;
                self.vwContent.frame = self->ContentViewFrame;
                self.imgHeaderAppName.frame = CGRectMake(self.imgHeaderAppName.frame.origin.x, 0, self.imgHeaderAppName.frame.size.width, self.imgHeaderAppName.frame.size.height);
            }];
            return;
        }
        if (yOffset + scrollViewHeight >= scrollContentSizeHeight) {
            return;
        }
        if (yOffset<prevOffset) {
        } else if (yOffset>prevOffset) {
            [UIView animateWithDuration:0.4 animations:^{
                self.vwSearch.frame = CGRectMake(0, 0, SCREEN_SIZE.width, self.vwSearch.frame.size.height);
                self.vwHeader.frame = CGRectMake(0, 60 - self.vwHeader.frame.size.height, SCREEN_SIZE.width, self.vwHeader.frame.size.height);
                self.vwContent.frame = CGRectMake(0, self.vwSearch.frame.origin.y + self.vwSearch.frame.size.height, SCREEN_SIZE.width, self.vwContent.frame.size.height);
                self.imgHeaderAppName.frame = CGRectMake(self.imgHeaderAppName.frame.origin.x,-self.imgHeaderAppName.frame.size.height, self.imgHeaderAppName.frame.size.width, self.imgHeaderAppName.frame.size.height);
            }];
        }
        prevOffset = yOffset;
    } else if (scrollView.tag == 103) {
        if (scrollView.contentOffset.x >= (self.scrlImages.frame.size.width * (imagesArray.count - 1)) + 50) {
            [self.scrlImages setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
            self.pageController.currentPage = 0;
        }
        if (scrollView.contentOffset.x <= 0 - 50) {
            self.pageController.currentPage = imagesArray.count - 1;
            [self.scrlImages setContentOffset:CGPointMake(self.pageController.currentPage * self.scrlImages.frame.size.width, 0.0) animated:YES];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.scrlImages)
    {
        self.pageController.currentPage = floorf(scrollView.contentOffset.x/scrollView.frame.size.width);
    }
}


#pragma mark - Set Slider Images

-(void)setScrollingImageViews {
    CGFloat xPos = 0.0;
    
    NSArray *viewsToRemove = [self.scrlImages subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    for (int i = 0; i < imagesArray.count; i++)
    {
        @autoreleasepool
        {
            UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(xPos + (self.scrlImages.frame.size.width/2) - 19, (self.scrlImages.frame.size.height/2) - 19, 38, 38)];
            act.hidesWhenStopped = YES;
            
            act.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
            [Util setPrimaryColorActivityIndicator:act];
            
            UIImageView * imageview = [[UIImageView alloc] init];
            imageview.contentMode = UIViewContentModeScaleToFill;
            
            imageview.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGestureOnScrollingImages:)];
            tapGesture1.numberOfTapsRequired = 1;
            [tapGesture1 setDelegate:self];
            [imageview addGestureRecognizer:tapGesture1];
            
            imageview.tag = i;

            [act startAnimating];
            [imageview sd_setImageWithURL:[Util EncodedURL:[[imagesArray objectAtIndex:i] valueForKey:@"upload_image_url"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                if (image == nil)
                {
                    imageview.image = [UIImage imageNamed:@"SliderNoImage"];
                }
                else
                {
                    imageview.image = image;
                }
                [act stopAnimating];
            }];
            
            imageview.frame = CGRectMake(xPos, 0.0,self.scrlImages.frame.size.width ,self.scrlImages.frame.size.height);
            
            [self.scrlImages addSubview:imageview];
            [self.scrlImages addSubview:act];

            xPos += SCREEN_SIZE.width;
        }
    }
    self.scrlImages.contentSize = CGSizeMake(self.scrlImages.frame.size.width * imagesArray.count, self.scrlImages.frame.size.height);

    _pageController.numberOfPages = imagesArray.count;
    
}

- (void)tapGestureOnScrollingImages: (id)sender
{
    //handle Tap...
    UIImageView *imgView = (UIImageView *)[(UITapGestureRecognizer*)sender view];

    HomeShopDataVC *vc = [[HomeShopDataVC alloc]initWithNibName:@"HomeShopDataVC" bundle:nil];
    vc.CategoryID = [[[imagesArray objectAtIndex:imgView.tag] valueForKey:@"slider_cat_id"] intValue];
    
    if (vc.CategoryID != (int)nil) {
        vc.fromCategory = YES;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - Button Clicks

-(IBAction)btnSearchClicked:(id)sender {
    appDelegate.from = 1;
    [appDelegate Search:self];
}

-(IBAction)btnNotificationClicked:(id)sender {
//    [appDelegate Notification:self];
}

-(void)btnWishListClicked:(UIButton *)sender {
    selectedIndex = (int)sender.tag;
    
    Product *object = [arrInfiniteProductData objectAtIndex:selectedIndex];
    Boolean set1 = NO;
    for (int i=0; i<arrWishList.count; i++) {
        if ([[arrWishList objectAtIndex:i] integerValue] == object.product_id) {
            set1 = YES;
            [arrWishList removeObjectAtIndex:i];
            break;
        }
    }
    
    if (set1 == NO) {
        // Facebook Pixel for Add to Wishlist
        
        [Util logAddedToWishlistEvent:[NSString stringWithFormat:@"%d",object.product_id]  contentType:object.name currency:appDelegate.strCurrencySymbol valToSum:object.price];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        arrselect = [[NSArray alloc] initWithObjects:indexPath, nil];
        
        Product *object = [arrInfiniteProductData objectAtIndex:indexPath.row];
        
        if ([Util getBoolData:kLogin]) {
            selectedProductId = [NSString stringWithFormat:@"%d",object.product_id];
            [self addItemToWishList:selectedProductId];
        } else {
            NSString *message = [MCLocalization stringForKey:@"Item Added to your Wish List."];
            [Util showPositiveMessage:message];
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
        [arr addObject:[NSString stringWithFormat:@"%d",object.product_id]];
        
        [Util setArray:arr setData:kWishList];
        [arrWishList addObject:[NSString stringWithFormat:@"%d",object.product_id]];
        
        NSLog(@"%@",[Util getArrayData:kWishList]);
        
        [self.colInfiniteData reloadData];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        Product *object = [arrInfiniteProductData objectAtIndex:indexPath.row];
        
        [arrWishList removeObject:[NSString stringWithFormat:@"%d",object.product_id]];
        
        arrUnselect = [[NSArray alloc] initWithObjects:indexPath, nil];
        
        if ([Util getBoolData:kLogin])
        {
            selectedProductId = [NSString stringWithFormat:@"%d",object.product_id];
            [self removeItemFromWishList:selectedProductId];
        }
        else
        {
            NSString *message = [MCLocalization stringForKey:@"Item Removed From your Wish List."];
            [Util showPositiveMessage:message];
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
        
        [arr removeObject:[NSString stringWithFormat:@"%d",object.product_id]];
        
        //        for (int i = 0; i < arr.count; i++)
        //        {
        //            if ([[arr objectAtIndex:i] integerValue] == object.product_id)
        //            {
        //                [arr removeObjectAtIndex:i];
        //                break;
        //            }
        //        }
        
        [Util setArray:arr setData:kWishList];
        NSLog(@"%@",[Util getArrayData:kWishList]);
        
        [self.colInfiniteData reloadData];
    }
}

-(void)btnAddToCartClicked:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:[MCLocalization stringForKey:@"GO TO CART"]])
    {
        if(self.tabBarController.selectedIndex == 2)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            self.tabBarController.selectedIndex = 2;
        }
        return;
    }
    
    Product *object = [arrInfiniteProductData objectAtIndex:sender.tag];
    
    if ([object.type1 isEqualToString:@"external"])
    {
        //external product
        NSString *strUrl = object.external_url;
        NSURL *_url = [Util EncodedURL:strUrl];
        [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
    }
    else if ([object.type1 isEqualToString:@"grouped"])
    {
        //Group product
        arrGroupedProduct = [[NSMutableArray alloc] init];
        [self GetGroupedProductDetail:object];
    }
    else if ([object.type1 isEqualToString:@"variable"])
    {
        //Variable product
        [Util showVariationPage:self product:object];
        
    }
    else
    {
        //Simple product
        [self AddToCart:object];
    }
    
//    dispatch_async(dispatch_get_main_queue(), ^(void){
        //Run UI Updates
        [self.colInfiniteData reloadData];
//    });
}

//MARK: - Add items to cart

- (void)AddToCart:(Product*)product
{
    // Facebook Pixel for Add To cart
    [Util logAddedToCartEvent:[NSString stringWithFormat:@"%d", product.product_id] contentType:product.name currency:appDelegate.strCurrencySymbol valToSum:product.price];
    
    //Old Logic
    AddToCartData *object = [[AddToCartData alloc] init];
    object.name = product.name;
    object.rating = product.average_rating;
    if ([product.arrImages count] > 0)
    {
        object.imgUrl = [[product.arrImages objectAtIndex:0] valueForKey:@"src"];
    }
    else
    {
        object.imgUrl = @"";
    }
    object.html_Price = product.price_html;
    object.productId = product.product_id;
    object.variation_id = 0;
    object.quantity = 1;
    
    object.price = product.price;
    
    object.arrVariation = nil;
    object.isSoldIndividually = (BOOL)product.sold_individually;
    
    object.manageStock = (BOOL)product.manageStock;
    object.stockQuantity = product.stockQuantity;
    
    BOOL flag = [Util saveCustomObject:object key:kMyCart];
    if (flag)
    {
        [Util showPositiveMessage:[MCLocalization stringForKey:@"Item Added to Your Cart Successfully"]];
    }
    else
    {
        //        NSString *str = [MCLocalization stringForKey:@"Out of Stock"];
        //        ALERTVIEW(str, appDelegate.window.rootViewController);
    }
    [appDelegate showBadge];
}
-(void)GetGroupedProductDetail:(Product*)product
{
    SHOW_LOADER_ANIMTION();
    if (product.arrGrouped_products.count == 0)
    {
        
    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        //        NSString *str = [[NSString alloc] init];
        NSString *str = [product.arrGrouped_products componentsJoinedByString:@","];
        //        for (int i = 0; i < product.arrGrouped_products.count; i++)
        //        {
        //            if (i == 0)
        //            {
        //                str = [NSString stringWithFormat:@"%@",[product.arrGrouped_products objectAtIndex:i]];
        //            }
        //            else
        //            {
        //                str = [NSString stringWithFormat:@"%@,%@",str,[product.arrGrouped_products objectAtIndex:i]];
        //            }
        //        }
        [dict setValue:str forKey:@"include"];
        
        [CiyaShopAPISecurity productListing:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
            
            NSLog(@"%@",dictionary);
            if (success)
            {
                if (dictionary.count>0)
                {
                    NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                    
                    for (int i = 0; i < arrData.count; i++)
                    {
                        [self->arrGroupedProduct addObject:[arrData objectAtIndex:i]];
                    }
                    [Util logAddedToCartEvent:[NSString stringWithFormat:@"%d", product.product_id] contentType:product.name currency:appDelegate.strCurrencySymbol valToSum:product.price];
                    
                    BOOL saveData = NO;
                    BOOL alreadyincart = NO;
                    int count = 0;
                    for (int i = 0; i < self->arrGroupedProduct.count; i++)
                    {
                        if ([[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"variable"] || [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"grouped"]  || [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"external"])
                        {
                            
                        }
                        else
                        {
                            AddToCartData *object = [[AddToCartData alloc] init];
                            object.name = [[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"name"];
                            object.rating = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"average_rating"] doubleValue];
                            if ([[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"images"] count] > 0)
                            {
                                object.imgUrl = [[[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"images"] objectAtIndex:0] valueForKey:@"src"];
                            }
                            else
                            {
                                object.imgUrl = @"";
                            }
                            object.html_Price = [[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"price_html"];
                            object.productId = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"id"] intValue];
                            object.variation_id = 0;
                            object.quantity = 1;
                            
                            object.price = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"price"] doubleValue];
                            
                            object.arrVariation = nil;
                            object.isSoldIndividually = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"sold_individually"] boolValue];
                            
                            object.manageStock = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"manage_stock"] boolValue];
                            if  (object.manageStock){
                                object.stockQuantity = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
                            }
                            
                            BOOL flag = [Util saveCustomObject:object key:kMyCart];
                            
                            if (flag)
                            {
                                saveData = YES;
                                count ++;
                                NSLog(@"Product Added");
                            }
                            else
                            {
                                alreadyincart = true;
                                NSLog(@"Already in cart");
                            }
                        }
                    }
                    if (count > 0)
                    {
                        [Util showPositiveMessage:[MCLocalization stringForKey:@"Item Added to Your Cart Successfully"]];
                    }
                }
                else
                {
                    HIDE_PROGRESS;
                    if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"])
                    {
                        NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                        
                        NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                        NSAttributedString *decodedString;
                        decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                         options:options
                                                              documentAttributes:NULL
                                                                           error:NULL];
                        ALERTVIEW(decodedString.string, self);
                    }
                    else
                    {
                        ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                    }
                }
            }
            else
            {
                HIDE_PROGRESS;
                if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"])
                {
                    NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                    NSAttributedString *decodedString;
                    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                     options:options
                                                          documentAttributes:NULL
                                                                       error:NULL];
                    ALERTVIEW(decodedString.string, self);
                }
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
                }
            }
            HIDE_PROGRESS;
            [appDelegate showBadge];
        }];
    }
}

#pragma mark - Table Delegate and Data Source Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView.tag == 100)
    {
        return 9;
    }
    else
    {
        //table Footer
        return 2;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 100)
    {
        switch (section) {
                
            case 0:
                //Shop Now
                if (appDelegate.arrHomeCatagoryData.count > 0)
                {
                    return 1;
                }
                return 0;
                break;
                
            case 1:
                //Banner ads
                if (appDelegate.arrBanner.count > 0)
                {
                    return appDelegate.arrBanner.count;
                }
                return 0;
                break;
                
            case 2:
                //check for data
                if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"1"]) {
                    //Most Popular Product
                    if (appDelegate.arrMostPopularProducts.count > 0 && isEnablePopularProduct)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"2"]) {
                    //Recently Added Products
                    if (appDelegate.arrRecentlyAddedProducts.count > 0 && isEnableRecentlyAdded)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"3"]) {
                    //Selected Product
                    if (appDelegate.arrSelectedProduct.count > 0 && isEnableSelected)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"4"]) {
                    //Deal of The Day
                    if (appDelegate.arrDealOfTheDay.count > 0 && isEnableDealofTheDay)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"5"]) {
                    //top Rated Product
                    if (appDelegate.arrTopRatedData.count > 0 && isEnableTopRatedProduct)
                    {
                        return  1;
                    }
                }
                return 0;
                break;
                
            case 3:
                //check for data
                if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"1"]) {
                    //Most Popular Product
                    if (appDelegate.arrMostPopularProducts.count > 0 && isEnablePopularProduct)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"2"]) {
                    //Recently Added Products
                    if (appDelegate.arrRecentlyAddedProducts.count > 0 && isEnableRecentlyAdded)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"3"]) {
                    //Selected Product
                    if (appDelegate.arrSelectedProduct.count > 0 && isEnableSelected)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"4"]) {
                    //Deal of The Day
                    if (appDelegate.arrDealOfTheDay.count > 0 && isEnableDealofTheDay)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"5"]) {
                    //top Rated Product
                    if (appDelegate.arrTopRatedData.count > 0 && isEnableTopRatedProduct)
                    {
                        return  1;
                    }
                }
                return 0;
                break;

            case 4:
                //check for data
                if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"1"]) {
                    //Most Popular Product
                    if (appDelegate.arrMostPopularProducts.count > 0 && isEnablePopularProduct)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"2"]) {
                    //Recently Added Products
                    if (appDelegate.arrRecentlyAddedProducts.count > 0 && isEnableRecentlyAdded)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"3"]) {
                    //Selected Product
                    if (appDelegate.arrSelectedProduct.count > 0 && isEnableSelected)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"4"]) {
                    //Deal of The Day
                    if (appDelegate.arrDealOfTheDay.count > 0 && isEnableDealofTheDay)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"5"]) {
                    //top Rated Product
                    if (appDelegate.arrTopRatedData.count > 0 && isEnableTopRatedProduct)
                    {
                        return  1;
                    }
                }
                return 0;
                break;
                
            case 5:
                //check for data
                if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"1"]) {
                    //Most Popular Product
                    if (appDelegate.arrMostPopularProducts.count > 0 && isEnablePopularProduct)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"2"]) {
                    //Recently Added Products
                    if (appDelegate.arrRecentlyAddedProducts.count > 0 && isEnableRecentlyAdded)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"3"]) {
                    //Selected Product
                    if (appDelegate.arrSelectedProduct.count > 0 && isEnableSelected)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"4"]) {
                    //Deal of The Day
                    if (appDelegate.arrDealOfTheDay.count > 0 && isEnableDealofTheDay)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"5"]) {
                    //top Rated Product
                    if (appDelegate.arrTopRatedData.count > 0 && isEnableTopRatedProduct)
                    {
                        return  1;
                    }
                }
                return 0;
                break;

            case 6:
                //check for data
                if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"1"]) {
                    //Most Popular Product
                    if (appDelegate.arrMostPopularProducts.count > 0 && isEnablePopularProduct)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"2"]) {
                    //Recently Added Products
                    if (appDelegate.arrRecentlyAddedProducts.count > 0 && isEnableRecentlyAdded)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"3"]) {
                    //Selected Product
                    if (appDelegate.arrSelectedProduct.count > 0 && isEnableSelected)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"4"]) {
                    //Deal of The Day
                    if (appDelegate.arrDealOfTheDay.count > 0 && isEnableDealofTheDay)
                    {
                        return  1;
                    }
                }
                else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"5"]) {
                    //top Rated Product
                    if (appDelegate.arrTopRatedData.count > 0 && isEnableTopRatedProduct)
                    {
                        return  1;
                    }
                }
                return 0;
                break;
                
            case 7:
                //check for data
                //Selected Product List
                if (appDelegate.arrSelectedProductData.count > 0 && isEnabledSelectedProductList)
                {
                    return  1;
                }
                return 0;
                break;
                
            default:
                return 0;
                break;
        }
        return 0;
    }
    else
    {
        //table Footer
        switch (section) {
                
            case 0:
                //Recently Viewed Products
                if (appDelegate.isFeatureEnabled)
                {
                    if (appDelegate.arrReasonToBuyWithUs.count == 0)
                    {
                        return 0;
                        break;
                    }
                    else if(appDelegate.arrReasonToBuyWithUs.count == 1)
                    {
                        if([[[appDelegate.arrReasonToBuyWithUs objectAtIndex:0] valueForKey:@"feature_content"] isEqualToString:@""] &&
                           [[[appDelegate.arrReasonToBuyWithUs objectAtIndex:0] valueForKey:@"feature_image_id"] isEqualToString:@""] &&
                           [[[appDelegate.arrReasonToBuyWithUs objectAtIndex:0] valueForKey:@"feature_title"] isEqualToString:@""])
                        {
                            return 0;
                        }
                    }
                }
                else
                {
                    return 0;
                }
                return 1;
                break;
                
            case 1:
                //Recently Viewed Products
                if (imagesArray.count == 0 &&
                    appDelegate.arrCategory.count == 0 &&
                    appDelegate.arrHomeCatagoryData.count == 0 &&
                    appDelegate.arrMostPopularProducts.count == 0 &&
                    appDelegate.arrDealOfTheDay.count == 0 &&
                    appDelegate.arrMainCategory.count == 0 &&
                    appDelegate.arrBanner.count == 0 &&
                    appDelegate.dictSocialData.count == 0)
                {
                    return 0;
                    break;
                }
                
                if ([[appDelegate getRecentArray] count] > 0)
                {
                    return 1;
                }
                return 0;
                break;
                
            default:
                return 0;
                break;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100)
    {
        if(indexPath.section==0)
        {
            static NSString *simpleTableIdentifier = @"ShopNowCell";
            
            ShopNowCell *cell = (ShopNowCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
            if (cell == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopNowCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.delegate = self;
            
            if (appDelegate.isRTL) {
                [cell.colShopNowCategory setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            } else {
                [cell.colShopNowCategory setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
            }
            
            [cell.colShopNowCategory reloadData];
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        else if(indexPath.section==1)
        {
            static NSString *simpleTableIdentifier2 = @"BannerAdCell";
            BannerAdCell *cell2 = (BannerAdCell *)[self.tblShopDetail dequeueReusableCellWithIdentifier:simpleTableIdentifier2 forIndexPath:indexPath];
            if (cell2 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BannerAdCell" owner:self options:nil];
                cell2 = [nib objectAtIndex:0];
            }
            
            cell2.selectionStyle=UITableViewCellSelectionStyleNone;
            
            [Util setPrimaryColorActivityIndicator:cell2.act];

            [cell2.act startAnimating];
            
            [cell2.img sd_setImageWithURL:[Util EncodedURL:[[appDelegate.arrBanner objectAtIndex:indexPath.row] valueForKey:@"banner_ad_image_url"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                if (image == nil) {
                    cell2.img.image = [UIImage imageNamed:@"BannerNoImage"];
                } else
                {
                    cell2.img.image = image;
                }
                [cell2.act stopAnimating];
            }];
            
            return cell2;
        }
        else if(indexPath.section==2)
        {
            if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"5"])
            {
                //Top Rated product
                return [self topRatedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"4"])
            {
                //Deal of the day
                return [self dealoftheday:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"3"])
            {
                //Selected Product
                return [self selectedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"2"])
            {
                //Recently Added Product
                return [self recentlyAddedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"1"])
            {
                //Most Popular product
                return [self mostPopularProduct:indexPath];
            }
        }
        else if(indexPath.section==3)
        {
            if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"5"])
            {
                //Top Rated product
                return [self topRatedProduct:indexPath];
            }
            else  if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"4"])
            {
                //Deal of the day
                return [self dealoftheday:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"3"])
            {
                //Selected Product
                return [self selectedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"2"])
            {
                //Recently Added Product
                return [self recentlyAddedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"1"])
            {
                //Most Popular product
                return [self mostPopularProduct:indexPath];
            }
        }
        else if(indexPath.section==4)
        {
            if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"5"])
            {
                //Top Rated product
                return [self topRatedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"4"])
            {
                //Deal of the day
                return [self dealoftheday:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"3"])
            {
                //Selected Product
                return [self selectedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"2"])
            {
                //Recently Added Product
                return [self recentlyAddedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"1"])
            {
                //Most Popular product
                return [self mostPopularProduct:indexPath];
            }
        }
        else if(indexPath.section==5)
        {
            if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"5"])
            {
                //Top Rated product
                return [self topRatedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"4"])
            {
                //Deal of the day
                return [self dealoftheday:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"3"])
            {
                //Selected Product
                return [self selectedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"2"])
            {
                //Recently Added Product
                return [self recentlyAddedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"1"])
            {
                //Most Popular product
                return [self mostPopularProduct:indexPath];
            }
        }
        else if(indexPath.section==6)
        {
            if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"5"])
            {
                //Top Rated product
                return [self topRatedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"4"])
            {
                //Deal of the day
                return [self dealoftheday:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"3"])
            {
                //Selected Product
                return [self selectedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"2"])
            {
                //Recently Added Product
                return [self recentlyAddedProduct:indexPath];
            }
            else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"1"])
            {
                //Most Popular product
                return [self mostPopularProduct:indexPath];
            }
        }
        else if(indexPath.section==7)
        {
            //Selected product List
            return [self selectedProductList:indexPath];
        }
        return nil;
    }
    else
    {
        //table Footer
        if (indexPath.section == 0)
        {
            static NSString *simpleTableIdentifier5 = @"ReasonToBuyWithUsCell";
            ReasonToBuyWithUsCell *cell5 = (ReasonToBuyWithUsCell *)[self.tblFooter dequeueReusableCellWithIdentifier:simpleTableIdentifier5 forIndexPath:indexPath];
            if (cell5 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReasonToBuyWithUsCell" owner:self options:nil];
                cell5 = [nib objectAtIndex:0];
            }
            
            cell5.vwHeader.frame = CGRectMake(0, 0, cell5.frame.size.width, 65*SCREEN_SIZE.width/375);
            
            cell5.lblTitle.textColor = LightBlackColor;
            cell5.lblTitle.text = appDelegate.strReasonsToBuy;
            cell5.lblTitle.frame = CGRectMake(8, cell5.lblTitle.frame.origin.y, cell5.frame.size.width - 16, cell5.lblTitle.frame.size.height);
            cell5.lblTitle.font=Font_Size_Title;

            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^()
                           {
                               dispatch_async(dispatch_get_main_queue(), ^()
                                              {
                                                  [cell5.colReasons reloadData];
                                                  cell5.colReasons.frame = CGRectMake(cell5.colReasons.frame.origin.x, 57*SCREEN_SIZE.width/375, cell5.frame.size.width - 16, cell5.colReasons.contentSize.height);
                                                  
                                                  cell5.colReasons.layer.shadowColor = [UIColor darkGrayColor].CGColor;
                                                  cell5.colReasons.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
                                                  cell5.colReasons.layer.shadowRadius = 1.0f;
                                                  cell5.colReasons.layer.shadowOpacity = 0.5f;
                                                  cell5.colReasons.layer.masksToBounds = NO;
                                                  cell5.colReasons.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell5.colReasons.bounds cornerRadius:cell5.colReasons.layer.cornerRadius].CGPath;
                                              });
                           });
            
            cell5.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!appDelegate.isRTL)
            {
                //No RTL
                cell5.lblTitle.textAlignment = NSTextAlignmentLeft;
            }
            else
            {
                cell5.lblTitle.textAlignment = NSTextAlignmentRight;
            }
            [cell5.colReasons reloadData];

            return cell5;
        }
        else if (indexPath.section == 1)
        {
            static NSString *simpleTableIdentifier5 = @"RecentProductMainCell";
            RecentProductMainCell *cell5 = (RecentProductMainCell *)[self.tblFooter dequeueReusableCellWithIdentifier:simpleTableIdentifier5 forIndexPath:indexPath];
            if (cell5 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"RecentProductMainCell" owner:self options:nil];
                cell5 = [nib objectAtIndex:0];
            }
            
            cell5.delegate = self;
            
            cell5.lblTitle.text = [MCLocalization stringForKey:@"RECENTLY VIEWED PRODUCTS"];
            cell5.lblTitle.textColor = LightBlackColor;
            cell5.lblTitle.font=Font_Size_Title;
            
            
            [cell5.colRecentlyViewedProducts reloadData];
            
            cell5.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!appDelegate.isRTL)
            {
                //No RTL
                cell5.lblTitle.textAlignment = NSTextAlignmentLeft;
                [cell5 setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            }
            else
            {
                cell5.lblTitle.textAlignment = NSTextAlignmentRight;
                [cell5 setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
            }

            return cell5;
        }
        return nil;
    }
}

-(UITableViewCell*)mostPopularProduct:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier3 = @"MostPopularProductCell";
    MostPopularProductCell *cell3 = (MostPopularProductCell *)[self.tblShopDetail dequeueReusableCellWithIdentifier:simpleTableIdentifier3 forIndexPath:indexPath];
    if (cell3 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MostPopularProductCell" owner:self options:nil];
        cell3 = [nib objectAtIndex:0];
    }
    
    if (appDelegate.arrMostPopularProducts.count > 0)
    {
        cell3.arrMostPopularProducts = [[NSMutableArray alloc] initWithArray:[appDelegate.arrMostPopularProducts mutableCopy]];
    }
    
    cell3.delegate = self;
    
    cell3.btnViewAll.layer.cornerRadius = 3;
    cell3.btnViewAll.layer.masksToBounds = true;
    cell3.btnViewAll.titleLabel.font = Font_Size_Product_Name_Not_Bold;
    
    
    [cell3.btnViewAll setTitle:[MCLocalization stringForKey:@"View All"] forState:UIControlStateNormal];
    cell3.lblTitle.text = strPopularProduct;//[MCLocalization stringForKey:@"MOST POPULAR PRODUCTS"];
    cell3.lblTitle.textColor = LightBlackColor;
    cell3.lblTitle.font = Font_Size_Title;
    
    [Util setSecondaryColorButton:cell3.btnViewAll];
    [cell3.btnViewAll addTarget:self action:@selector(ButtonViewAllClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell3.btnViewAll.tag = 1;
    
    cell3.vwTop.frame = CGRectMake(0, 0, self.tblShopDetail.frame.size.width, 63*SCREEN_SIZE.width/375);
    
    if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
        if (appDelegate.arrMostPopularProducts.count > 2)
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 572*SCREEN_SIZE.width/375);
        }
        else
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 286*SCREEN_SIZE.width/375);
        }
    } else {
        if (appDelegate.arrMostPopularProducts.count > 2)
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 512*SCREEN_SIZE.width/375);
        }
        else
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 256*SCREEN_SIZE.width/375);
        }
    }

    [cell3.colProducts reloadData];
    
    cell3.colProducts.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell3.colProducts.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell3.colProducts.layer.shadowRadius = 1.0f;
    cell3.colProducts.layer.shadowOpacity = 0.5f;
    cell3.colProducts.layer.masksToBounds = NO;
    cell3.colProducts.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell3.colProducts.bounds cornerRadius:cell3.colProducts.layer.cornerRadius].CGPath;
    
    if (appDelegate.isRTL)
    {
        //RTL
        cell3.lblTitle.frame = CGRectMake(cell3.frame.size.width - cell3.lblTitle.frame.size.width - 8, cell3.lblTitle.frame.origin.y, cell3.lblTitle.frame.size.width, cell3.lblTitle.frame.size.height);
        cell3.btnViewAll.frame = CGRectMake(8, cell3.btnViewAll.frame.origin.y, cell3.btnViewAll.frame.size.width, cell3.btnViewAll.frame.size.height);
        cell3.lblTitle.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //No RTL
        cell3.lblTitle.frame = CGRectMake(8, cell3.lblTitle.frame.origin.y, cell3.lblTitle.frame.size.width, cell3.lblTitle.frame.size.height);
        cell3.lblTitle.textAlignment = NSTextAlignmentLeft;
        cell3.btnViewAll.frame = CGRectMake(cell3.frame.size.width - cell3.btnViewAll.frame.size.width - 8, cell3.btnViewAll.frame.origin.y, cell3.btnViewAll.frame.size.width, cell3.btnViewAll.frame.size.height);
    }
    
    cell3.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell3;
}
-(UITableViewCell*)recentlyAddedProduct:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier3 = @"MostPopularProductCell";
    MostPopularProductCell *cell3 = (MostPopularProductCell *)[self.tblShopDetail dequeueReusableCellWithIdentifier:simpleTableIdentifier3 forIndexPath:indexPath];
    if (cell3 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MostPopularProductCell" owner:self options:nil];
        cell3 = [nib objectAtIndex:0];
    }
    
    if (appDelegate.arrRecentlyAddedProducts.count > 0)
    {
        cell3.arrMostPopularProducts = [[NSMutableArray alloc] initWithArray:[appDelegate.arrRecentlyAddedProducts mutableCopy]];
    }
    
    cell3.delegate = self;
    
    cell3.btnViewAll.layer.cornerRadius = 3;
    cell3.btnViewAll.layer.masksToBounds = true;
    cell3.btnViewAll.titleLabel.font = Font_Size_Product_Name_Not_Bold;
    
    
    [cell3.btnViewAll setTitle:[MCLocalization stringForKey:@"View All"] forState:UIControlStateNormal];
    cell3.lblTitle.text = strRecentlyAddedProduct;//[MCLocalization stringForKey:@"Recently Added Product"];
    cell3.lblTitle.textColor = LightBlackColor;
    cell3.lblTitle.font = Font_Size_Title;
    
    [Util setSecondaryColorButton:cell3.btnViewAll];
    [cell3.btnViewAll addTarget:self action:@selector(ButtonRecentlyAddedViewAllClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell3.btnViewAll.tag = 2;
    
    cell3.vwTop.frame = CGRectMake(0, 0, self.tblShopDetail.frame.size.width, 63*SCREEN_SIZE.width/375);
    
    if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
        if (appDelegate.arrRecentlyAddedProducts.count > 2)
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 572*SCREEN_SIZE.width/375);
        }
        else
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 286*SCREEN_SIZE.width/375);
        }
    } else {
        if (appDelegate.arrRecentlyAddedProducts.count > 2)
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 512*SCREEN_SIZE.width/375);
        }
        else
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 256*SCREEN_SIZE.width/375);
        }
    }
    

    [cell3.colProducts reloadData];

    cell3.colProducts.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell3.colProducts.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell3.colProducts.layer.shadowRadius = 1.0f;
    cell3.colProducts.layer.shadowOpacity = 0.5f;
    cell3.colProducts.layer.masksToBounds = NO;
    cell3.colProducts.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell3.colProducts.bounds cornerRadius:cell3.colProducts.layer.cornerRadius].CGPath;
    
//    if (appDelegate.arrRecentlyAddedProducts.count > 4) {
//        cell3.btnViewAll.hidden = false;
//    } else {
//        cell3.btnViewAll.hidden = true;
//    }

    if (appDelegate.isRTL)
    {
        //RTL
        cell3.lblTitle.frame = CGRectMake(cell3.frame.size.width - cell3.lblTitle.frame.size.width - 8, cell3.lblTitle.frame.origin.y, cell3.lblTitle.frame.size.width, cell3.lblTitle.frame.size.height);
        cell3.btnViewAll.frame = CGRectMake(8, cell3.btnViewAll.frame.origin.y, cell3.btnViewAll.frame.size.width, cell3.btnViewAll.frame.size.height);
        cell3.lblTitle.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //No RTL
        cell3.lblTitle.frame = CGRectMake(8, cell3.lblTitle.frame.origin.y, cell3.lblTitle.frame.size.width, cell3.lblTitle.frame.size.height);
        cell3.lblTitle.textAlignment = NSTextAlignmentLeft;
        cell3.btnViewAll.frame = CGRectMake(cell3.frame.size.width - cell3.btnViewAll.frame.size.width - 8, cell3.btnViewAll.frame.origin.y, cell3.btnViewAll.frame.size.width, cell3.btnViewAll.frame.size.height);
    }
    
    cell3.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell3;
}
-(UITableViewCell*)selectedProduct:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier3 = @"MostPopularProductCell";
    MostPopularProductCell *cell3 = (MostPopularProductCell *)[self.tblShopDetail dequeueReusableCellWithIdentifier:simpleTableIdentifier3 forIndexPath:indexPath];
    if (cell3 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MostPopularProductCell" owner:self options:nil];
        cell3 = [nib objectAtIndex:0];
    }
    
    if (appDelegate.arrSelectedProduct.count > 0)
    {
        cell3.arrMostPopularProducts = [[NSMutableArray alloc] initWithArray:[appDelegate.arrSelectedProduct mutableCopy]];
    }
    
    cell3.delegate = self;
    
    cell3.btnViewAll.layer.cornerRadius = 3;
    cell3.btnViewAll.layer.masksToBounds = true;
    cell3.btnViewAll.titleLabel.font = Font_Size_Product_Name_Not_Bold;
    
    
    [cell3.btnViewAll setTitle:[MCLocalization stringForKey:@"View All"] forState:UIControlStateNormal];
    cell3.lblTitle.text = strSelectedProduct;//[MCLocalization stringForKey:@"Selected Product"];
    cell3.lblTitle.textColor = LightBlackColor;
    cell3.lblTitle.font = Font_Size_Title;
    
    [Util setSecondaryColorButton:cell3.btnViewAll];
    cell3.btnViewAll.hidden = false;
    [cell3.btnViewAll addTarget:self action:@selector(ButtonSelectedProductViewAllClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell3.btnViewAll.tag = 3;
    
    cell3.vwTop.frame = CGRectMake(0, 0, self.tblShopDetail.frame.size.width, 63*SCREEN_SIZE.width/375);

    if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
        if (appDelegate.arrSelectedProduct.count > 2)
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 572*SCREEN_SIZE.width/375);
        }
        else
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 286*SCREEN_SIZE.width/375);
        }
    } else {
        if (appDelegate.arrSelectedProduct.count > 2)
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 512*SCREEN_SIZE.width/375);
        }
        else
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 256*SCREEN_SIZE.width/375);
        }
    }

    [cell3.colProducts reloadData];
    
    cell3.colProducts.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell3.colProducts.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell3.colProducts.layer.shadowRadius = 1.0f;
    cell3.colProducts.layer.shadowOpacity = 0.5f;
    cell3.colProducts.layer.masksToBounds = NO;
    cell3.colProducts.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell3.colProducts.bounds cornerRadius:cell3.colProducts.layer.cornerRadius].CGPath;
    
//    if (appDelegate.arrSelectedProduct.count > 4) {
//        cell3.btnViewAll.hidden = false;
//    } else {
//        cell3.btnViewAll.hidden = true;
//    }

    if (appDelegate.isRTL)
    {
        //RTL
        cell3.lblTitle.frame = CGRectMake(cell3.frame.size.width - cell3.lblTitle.frame.size.width - 8, cell3.lblTitle.frame.origin.y, cell3.lblTitle.frame.size.width, cell3.lblTitle.frame.size.height);
        cell3.btnViewAll.frame = CGRectMake(8, cell3.btnViewAll.frame.origin.y, cell3.btnViewAll.frame.size.width, cell3.btnViewAll.frame.size.height);
        cell3.lblTitle.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //No RTL
        cell3.lblTitle.frame = CGRectMake(8, cell3.lblTitle.frame.origin.y, cell3.lblTitle.frame.size.width, cell3.lblTitle.frame.size.height);
        cell3.lblTitle.textAlignment = NSTextAlignmentLeft;
        cell3.btnViewAll.frame = CGRectMake(cell3.frame.size.width - cell3.btnViewAll.frame.size.width - 8, cell3.btnViewAll.frame.origin.y, cell3.btnViewAll.frame.size.width, cell3.btnViewAll.frame.size.height);
    }
    
    cell3.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell3;
}
-(UITableViewCell*)dealoftheday:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier4 = @"DealOfTheDayCell";
    DealOfTheDayCell *cell4 = (DealOfTheDayCell *)[self.tblShopDetail dequeueReusableCellWithIdentifier:simpleTableIdentifier4 forIndexPath:indexPath];
    if (cell4 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DealOfTheDayCell" owner:self options:nil];
        cell4 = [nib objectAtIndex:0];
    }
    cell4.delegate = self;
    
    cell4.lblTitle.text = strDealOofTheDay;//[MCLocalization stringForKey:@"DEAL OF THE DAY"];
    cell4.lblTitle.textColor = LightBlackColor;
    cell4.lblTitle.font=Font_Size_Title;

    if (appDelegate.isRTL) {
        [cell4.colProducts setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    } else {
        [cell4.colProducts setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }

    cell4.btnViewAll.layer.cornerRadius = 3;
    cell4.btnViewAll.layer.masksToBounds = true;
    
    [Util setSecondaryColorButton:cell4.btnViewAll];
    [cell4.btnViewAll setTitle:[MCLocalization stringForKey:@"View All"] forState:UIControlStateNormal];
    [cell4.btnViewAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cell4.btnViewAll.titleLabel.font = Font_Size_Product_Name_Not_Bold;
    [cell4.btnViewAll addTarget:self action:@selector(ButtonDealViewAllClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell4.btnViewAll.tag = 4;
    
    cell4.vwHead.frame = CGRectMake(0, 0, cell4.vwHead.frame.size.width, SCREEN_SIZE.width*69/375);
    
    cell4.lblTimer.font=Font_Size_Title_Not_Bold;
    
    cell4.colProducts.frame = CGRectMake(cell4.colProducts.frame.origin.x, SCREEN_SIZE.width*58/375, cell4.colProducts.frame.size.width, cell4.colProducts.frame.size.height);
    
    [cell4.colProducts reloadData];
    [Util setPrimaryColorImageView:cell4.imgTimer];
    
//    if (appDelegate.arrDealOfTheDay.count > 4) {
//        cell4.btnViewAll.hidden = false;
//    } else {
//        cell4.btnViewAll.hidden = true;
//    }
    
    if (appDelegate.isRTL)
    {
        //No RTL
        cell4.lblTitle.frame = CGRectMake(cell4.frame.size.width - cell4.lblTitle.frame.size.width - 8, cell4.lblTitle.frame.origin.y, cell4.lblTitle.frame.size.width, cell4.lblTitle.frame.size.height);
        cell4.btnViewAll.frame = CGRectMake(8, cell4.btnViewAll.frame.origin.y, cell4.btnViewAll.frame.size.width, cell4.btnViewAll.frame.size.height);
        cell4.vwTimer.frame = CGRectMake(cell4.btnViewAll.frame.size.width + 10, cell4.vwTimer.frame.origin.y, cell4.vwTimer.frame.size.width, cell4.vwTimer.frame.size.height);
        cell4.imgTimer.frame = CGRectMake(cell4.vwTimer.frame.size.width - cell4.imgTimer.frame.size.width, cell4.imgTimer.frame.origin.y, cell4.imgTimer.frame.size.width, cell4.imgTimer.frame.size.height);
        cell4.lblTimer.frame = CGRectMake(0, cell4.lblTimer.frame.origin.y, cell4.lblTimer.frame.size.width, cell4.lblTimer.frame.size.height);
        cell4.lblTimer.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        cell4.lblTitle.frame = CGRectMake(8, cell4.lblTitle.frame.origin.y, cell4.lblTitle.frame.size.width, cell4.lblTitle.frame.size.height);
        cell4.btnViewAll.frame = CGRectMake(cell4.frame.size.width - cell4.btnViewAll.frame.size.width - 8, cell4.btnViewAll.frame.origin.y, cell4.btnViewAll.frame.size.width, cell4.btnViewAll.frame.size.height);
        cell4.vwTimer.frame = CGRectMake(cell4.frame.size.width - cell4.btnViewAll.frame.size.width - 10 - cell4.vwTimer.frame.size.width, cell4.vwTimer.frame.origin.y, cell4.vwTimer.frame.size.width, cell4.vwTimer.frame.size.height);
        cell4.imgTimer.frame = CGRectMake(0, cell4.imgTimer.frame.origin.y, cell4.imgTimer.frame.size.width, cell4.imgTimer.frame.size.height);
        cell4.lblTimer.frame = CGRectMake(cell4.imgTimer.frame.size.width, cell4.lblTimer.frame.origin.y, cell4.lblTimer.frame.size.width, cell4.lblTimer.frame.size.height);
        cell4.lblTimer.textAlignment = NSTextAlignmentLeft;
    }
    cell4.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell4;
}

-(UITableViewCell*)topRatedProduct:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier3 = @"MostPopularProductCell";
    MostPopularProductCell *cell3 = (MostPopularProductCell *)[self.tblShopDetail dequeueReusableCellWithIdentifier:simpleTableIdentifier3 forIndexPath:indexPath];
    if (cell3 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MostPopularProductCell" owner:self options:nil];
        cell3 = [nib objectAtIndex:0];
    }
    
    if (appDelegate.arrTopRatedData.count > 0)
    {
        cell3.arrMostPopularProducts = [[NSMutableArray alloc] initWithArray:[appDelegate.arrTopRatedData mutableCopy]];
    }
    
    cell3.delegate = self;
    
    cell3.btnViewAll.layer.cornerRadius = 3;
    cell3.btnViewAll.layer.masksToBounds = true;
    cell3.btnViewAll.titleLabel.font = Font_Size_Product_Name_Not_Bold;
    
    [cell3.btnViewAll setTitle:[MCLocalization stringForKey:@"View All"] forState:UIControlStateNormal];
    cell3.lblTitle.text = strTopRatedProduct;//[MCLocalization stringForKey:@"TOP RATED PRODUCTS"];
    cell3.lblTitle.textColor = LightBlackColor;
    cell3.lblTitle.font = Font_Size_Title;
    
    [Util setSecondaryColorButton:cell3.btnViewAll];
    [cell3.btnViewAll addTarget:self action:@selector(ButtonTopRatedViewAllClicked:) forControlEvents:UIControlEventTouchUpInside];
    cell3.btnViewAll.tag = 5;
    
    cell3.vwTop.frame = CGRectMake(0, 0, self.tblShopDetail.frame.size.width, 63*SCREEN_SIZE.width/375);
    
    if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
        if (appDelegate.arrTopRatedData.count > 2)
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 572*SCREEN_SIZE.width/375);
        }
        else
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 286*SCREEN_SIZE.width/375);
        }
    } else {
        if (appDelegate.arrTopRatedData.count > 2)
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 512*SCREEN_SIZE.width/375);
        }
        else
        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 256*SCREEN_SIZE.width/375);
        }
    }

    [cell3.colProducts reloadData];
    
    cell3.colProducts.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell3.colProducts.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell3.colProducts.layer.shadowRadius = 1.0f;
    cell3.colProducts.layer.shadowOpacity = 0.5f;
    cell3.colProducts.layer.masksToBounds = NO;
    cell3.colProducts.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell3.colProducts.bounds cornerRadius:cell3.colProducts.layer.cornerRadius].CGPath;
    
    if (appDelegate.isRTL)
    {
        //RTL
        cell3.lblTitle.frame = CGRectMake(cell3.frame.size.width - cell3.lblTitle.frame.size.width - 8, cell3.lblTitle.frame.origin.y, cell3.lblTitle.frame.size.width, cell3.lblTitle.frame.size.height);
        cell3.btnViewAll.frame = CGRectMake(8, cell3.btnViewAll.frame.origin.y, cell3.btnViewAll.frame.size.width, cell3.btnViewAll.frame.size.height);
        cell3.lblTitle.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //No RTL
        cell3.lblTitle.frame = CGRectMake(8, cell3.lblTitle.frame.origin.y, cell3.lblTitle.frame.size.width, cell3.lblTitle.frame.size.height);
        cell3.lblTitle.textAlignment = NSTextAlignmentLeft;
        cell3.btnViewAll.frame = CGRectMake(cell3.frame.size.width - cell3.btnViewAll.frame.size.width - 8, cell3.btnViewAll.frame.origin.y, cell3.btnViewAll.frame.size.width, cell3.btnViewAll.frame.size.height);
    }
    
    cell3.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell3;
}
-(UITableViewCell*)selectedProductList:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier3 = @"MostPopularProductCell";
    MostPopularProductCell *cell3 = (MostPopularProductCell *)[self.tblShopDetail dequeueReusableCellWithIdentifier:simpleTableIdentifier3 forIndexPath:indexPath];
    if (cell3 == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MostPopularProductCell" owner:self options:nil];
        cell3 = [nib objectAtIndex:0];
    }
    cell3.isCustomSection = true;
    
    if (appDelegate.arrSelectedProductData.count > 0) {
        cell3.arrMostPopularProducts = [[NSMutableArray alloc] initWithArray:[appDelegate.arrSelectedProductData mutableCopy]];
    }
    
    cell3.delegate = self;
    
//    cell3.btnViewAll.layer.cornerRadius = 3;
//    cell3.btnViewAll.layer.masksToBounds = true;
//    cell3.btnViewAll.titleLabel.font = Font_Size_Product_Name_Not_Bold;
    
    [cell3.btnViewAll setTitle:[MCLocalization stringForKey:@"View All"] forState:UIControlStateNormal];
    cell3.lblTitle.text = strSelectedProductList;//[MCLocalization stringForKey:@"TOP RATED PRODUCTS"];
    cell3.lblTitle.textColor = LightBlackColor;
    cell3.lblTitle.font = Font_Size_Title;
    
//    [Util setSecondaryColorButton:cell3.btnViewAll];
//    [cell3.btnViewAll addTarget:self action:@selector(ButtonTopRatedViewAllClicked:) forControlEvents:UIControlEventTouchUpInside];
//    cell3.btnViewAll.tag = 5;
    cell3.btnViewAll.hidden = true;

    cell3.vwTop.frame = CGRectMake(0, 0, self.tblShopDetail.frame.size.width, 63*SCREEN_SIZE.width/375);
    
    if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
//        if (appDelegate.arrSelectedProductData.count > 2)
//        {
//            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 572*SCREEN_SIZE.width/375);
//        }
//        else
//        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, (int)((cell3.arrMostPopularProducts.count + 1)/2) * (286*SCREEN_SIZE.width/375));
//        }
    } else {
//        if (appDelegate.arrSelectedProductData.count > 2)
//        {
//            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, 512*SCREEN_SIZE.width/375);
//        }
//        else
//        {
            cell3.colProducts.frame = CGRectMake(8, 57*SCREEN_SIZE.width/375, self.tblShopDetail.frame.size.width - 16, (int)((cell3.arrMostPopularProducts.count + 1)/2) * (256*SCREEN_SIZE.width/375));
//        }
    }
    
    [cell3.colProducts reloadData];
    
    cell3.colProducts.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell3.colProducts.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell3.colProducts.layer.shadowRadius = 1.0f;
    cell3.colProducts.layer.shadowOpacity = 0.5f;
    cell3.colProducts.layer.masksToBounds = NO;
    cell3.colProducts.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell3.colProducts.bounds cornerRadius:cell3.colProducts.layer.cornerRadius].CGPath;
    
    if (appDelegate.isRTL)
    {
        //RTL
        cell3.lblTitle.frame = CGRectMake(cell3.frame.size.width - cell3.lblTitle.frame.size.width - 8, cell3.lblTitle.frame.origin.y, cell3.lblTitle.frame.size.width, cell3.lblTitle.frame.size.height);
        cell3.btnViewAll.frame = CGRectMake(8, cell3.btnViewAll.frame.origin.y, cell3.btnViewAll.frame.size.width, cell3.btnViewAll.frame.size.height);
        cell3.lblTitle.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //No RTL
        cell3.lblTitle.frame = CGRectMake(8, cell3.lblTitle.frame.origin.y, cell3.lblTitle.frame.size.width, cell3.lblTitle.frame.size.height);
        cell3.lblTitle.textAlignment = NSTextAlignmentLeft;
        cell3.btnViewAll.frame = CGRectMake(cell3.frame.size.width - cell3.btnViewAll.frame.size.width - 8, cell3.btnViewAll.frame.origin.y, cell3.btnViewAll.frame.size.width, cell3.btnViewAll.frame.size.height);
    }
    
    cell3.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell3;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100)
    {
        if(indexPath.section==0)
        {
            //ShopNowCell
        }
        else if(indexPath.section==1)
        {
            //BannerAdCell
            HomeShopDataVC *vc = [[HomeShopDataVC alloc]initWithNibName:@"HomeShopDataVC" bundle:nil];
            vc.CategoryID = [[[appDelegate.arrBanner objectAtIndex:indexPath.row] valueForKey:@"banner_ad_cat_id"]intValue];
            if (vc.CategoryID != (int)nil)
            {
                vc.fromCategory = YES;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.section==2)
        {
            //MostPopularProductCell
        }
        else if(indexPath.section==3)
        {
            //MostPopularProductCell
        }
        else if(indexPath.section==4)
        {
            //MostPopularProductCell
        }
        else if(indexPath.section==5)
        {
            //DealOfTheDayCell
        }
        else if(indexPath.section==6)
        {
            //TopRatedProduct
        }
        else if(indexPath.section==7)
        {
            //BrandCarousel
        }
        else if(indexPath.section==8)
        {
            //CategorySlider
        }
    }
    else
    {
        //table Footer
        if(indexPath.section == 0)
        {
            //six Reasos to buy with us
        }
        else if(indexPath.section == 1)
        {
            //RecentProductMainCell
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 100)
    {
        if(indexPath.section == 0)
        {
            return 170*SCREEN_SIZE.width/375;
        }
        else if(indexPath.section == 1)
        {
            return 140*SCREEN_SIZE.width/375;
        }
        else if(indexPath.section == 2)
        {
            int size = 1;
            if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"1"])
            {
                //Most Popular product
                if (!isEnablePopularProduct) {
                    return 0;
                } else if (appDelegate.arrMostPopularProducts.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"2"])
            {
                //Recently Added Product
                if (!isEnableRecentlyAdded) {
                    return 0;
                } else if (appDelegate.arrRecentlyAddedProducts.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"3"])
            {
                //Selected Product
                if (!isEnableSelected) {
                    return 0;
                } else if (appDelegate.arrSelectedProduct.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"4"])
            {
                //Deal of the day
                if (!isEnableDealofTheDay) {
                    return 0;
                }
                if (appDelegate.arrDealOfTheDay.count > 2)
                {
                    return (259*SCREEN_SIZE.width/375);
                }
                return (259*SCREEN_SIZE.width/375) - (92*SCREEN_SIZE.width/375);
            }
            else if ([[arrItemIndex objectAtIndex:0] isEqualToString:@"5"])
            {
                //Top Rated Product
                if (!isEnableTopRatedProduct) {
                    return 0;
                } else if (appDelegate.arrTopRatedData.count <= 2) {
                    size = 2;
                }
            }
            if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
                if (size == 1)
                {
                    return 651*SCREEN_SIZE.width/375;
                }
                else
                {
                    return 365*SCREEN_SIZE.width/375;
                }
            } else {
                if (size == 1)
                {
                    return 591*SCREEN_SIZE.width/375;
                }
                else
                {
                    return 335*SCREEN_SIZE.width/375;
                }
            }
        }
        else if(indexPath.section == 3)
        {
            int size = 1;
            if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"1"])
            {
                //Most Popular product
                if (!isEnablePopularProduct) {
                    return 0;
                } else if (appDelegate.arrMostPopularProducts.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"2"])
            {
                //Recently Added Product
                if (!isEnableRecentlyAdded) {
                    return 0;
                } else if (appDelegate.arrRecentlyAddedProducts.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"3"])
            {
                //Selected Product
                if (!isEnableSelected) {
                    return 0;
                } else if (appDelegate.arrSelectedProduct.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"4"])
            {
                //Deal of the day
                if (!isEnableDealofTheDay) {
                    return 0;
                }
                if (appDelegate.arrDealOfTheDay.count > 2)
                {
                    return (259*SCREEN_SIZE.width/375);
                }
                return (259*SCREEN_SIZE.width/375) - (92*SCREEN_SIZE.width/375);
            }
            else if ([[arrItemIndex objectAtIndex:1] isEqualToString:@"5"])
            {
                //Top Rated Product
                if (!isEnableTopRatedProduct) {
                    return 0;
                } else if (appDelegate.arrTopRatedData.count <= 2) {
                    size = 2;
                }
            }
            if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
                if (size == 1)
                {
                    return 651*SCREEN_SIZE.width/375;
                }
                else
                {
                    return 365*SCREEN_SIZE.width/375;
                }
            } else {
                if (size == 1)
                {
                    return 591*SCREEN_SIZE.width/375;
                }
                else
                {
                    return 335*SCREEN_SIZE.width/375;
                }
            }
        }
        else if(indexPath.section == 4)
        {
            int size = 1;
            if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"1"])
            {
                //Most Popular product
                if (!isEnablePopularProduct) {
                    return 0;
                } else if (appDelegate.arrMostPopularProducts.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"2"])
            {
                //Recently Added Product
                if (!isEnableRecentlyAdded) {
                    return 0;
                } else if (appDelegate.arrRecentlyAddedProducts.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"3"])
            {
                //Selected Product
                if (!isEnableSelected) {
                    return 0;
                } else if (appDelegate.arrSelectedProduct.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"4"])
            {
                //Deal of the day
                if (!isEnableDealofTheDay) {
                    return 0;
                }
                if (appDelegate.arrDealOfTheDay.count > 2)
                {
                    return (259*SCREEN_SIZE.width/375);
                }
                return (259*SCREEN_SIZE.width/375) - (92*SCREEN_SIZE.width/375);
            }
            else if ([[arrItemIndex objectAtIndex:2] isEqualToString:@"5"])
            {
                //Top Rated Product
                if (!isEnableTopRatedProduct) {
                    return 0;
                } else if (appDelegate.arrTopRatedData.count <= 2) {
                    size = 2;
                }
            }
            if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
                if (size == 1)
                {
                    return 651*SCREEN_SIZE.width/375;
                }
                else
                {
                    return 365*SCREEN_SIZE.width/375;
                }
            } else {
                if (size == 1)
                {
                    return 591*SCREEN_SIZE.width/375;
                }
                else
                {
                    return 335*SCREEN_SIZE.width/375;
                }
            }
        }
        else if(indexPath.section == 5)
        {
            int size = 1;
            if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"1"])
            {
                //Most Popular product
                if (!isEnablePopularProduct) {
                    return 0;
                } else if (appDelegate.arrMostPopularProducts.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"2"])
            {
                //Recently Added Product
                if (!isEnableRecentlyAdded) {
                    return 0;
                } else if (appDelegate.arrRecentlyAddedProducts.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"3"])
            {
                //Selected Product
                if (!isEnableSelected) {
                    return 0;
                } else if (appDelegate.arrSelectedProduct.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"4"])
            {
                //Deal of the day
                if (!isEnableDealofTheDay) {
                    return 0;
                }
                if (appDelegate.arrDealOfTheDay.count > 2)
                {
                    return (259*SCREEN_SIZE.width/375);
                }
                return (259*SCREEN_SIZE.width/375) - (92*SCREEN_SIZE.width/375);
            }
            else if ([[arrItemIndex objectAtIndex:3] isEqualToString:@"5"])
            {
                //Top Rated Product
                if (!isEnableTopRatedProduct) {
                    return 0;
                } else if (appDelegate.arrTopRatedData.count <= 2) {
                    size = 2;
                }
            }
            if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
                if (size == 1)
                {
                    return 651*SCREEN_SIZE.width/375;
                }
                else
                {
                    return 365*SCREEN_SIZE.width/375;
                }
            } else {
                if (size == 1)
                {
                    return 591*SCREEN_SIZE.width/375;
                }
                else
                {
                    return 335*SCREEN_SIZE.width/375;
                }
            }
        }
        else if(indexPath.section == 6)
        {
            int size = 1;
            if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"1"])
            {
                //Most Popular product
                if (!isEnablePopularProduct) {
                    return 0;
                } else if (appDelegate.arrMostPopularProducts.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"2"])
            {
                //Recently Added Product
                if (!isEnableRecentlyAdded) {
                    return 0;
                } else if (appDelegate.arrRecentlyAddedProducts.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"3"])
            {
                //Selected Product
                if (!isEnableSelected) {
                    return 0;
                } else if (appDelegate.arrSelectedProduct.count <= 2) {
                    size = 2;
                }
            }
            else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"4"])
            {
                //Deal of the day
                if (!isEnableDealofTheDay) {
                    return 0;
                }
                if (appDelegate.arrDealOfTheDay.count > 2)
                {
                    return (259*SCREEN_SIZE.width/375);
                }
                return (259*SCREEN_SIZE.width/375) - (92*SCREEN_SIZE.width/375);
            }
            else if ([[arrItemIndex objectAtIndex:4] isEqualToString:@"5"])
            {
                //Top Rated Product
                if (!isEnableTopRatedProduct) {
                    return 0;
                } else if (appDelegate.arrTopRatedData.count <= 2) {
                    size = 2;
                }
            }
            if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
                if (size == 1)
                {
                    return 651*SCREEN_SIZE.width/375;
                }
                else
                {
                    return 365*SCREEN_SIZE.width/375;
                }
            } else {
                if (size == 1)
                {
                    return 591*SCREEN_SIZE.width/375;
                }
                else
                {
                    return 335*SCREEN_SIZE.width/375;
                }
            }
        }
        else if(indexPath.section == 7)
        {
            //Selected Product List
            if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
                return ((int)((appDelegate.arrSelectedProductData.count + 1)/2) * (286*SCREEN_SIZE.width/375)) + (75*SCREEN_SIZE.width/375);
            } else {
                return ((int)((appDelegate.arrSelectedProductData.count + 1)/2) * (256*SCREEN_SIZE.width/375)) + (75*SCREEN_SIZE.width/375);
            }
        }
        return 0.0;
    }
    else
    {
        //table Footer
        if(indexPath.section == 0)
        {
            static NSString *simpleTableIdentifier = @"ReasonToBuyWithUsCell";
            
            ReasonToBuyWithUsCell *cell5 = (ReasonToBuyWithUsCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            if(cell5 == nil)
            {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReasonToBuyWithUsCell" owner:self options:nil];
                cell5 = [nib objectAtIndex:0];
            }

            float count = 0.5 + (appDelegate.arrReasonToBuyWithUs.count/2.0);
            return cell5.colReasons.frame.origin.y + (((int)count*97)*SCREEN_SIZE.width/375) + (30*SCREEN_SIZE.width/375);
        }
        else if(indexPath.section == 1)
        {
            return (313*SCREEN_SIZE.width/375);
        }
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

#pragma mark - Table Cell Button Clicks

-(void)ButtonViewAllClicked:(UIButton*)button{
    
    //Most Popular Product
    if (button.tag == 1) {
        NSLog(@"in Most Popular product %ld", (long)button.tag);
        HomeShopDataVC *vc = [[HomeShopDataVC alloc] initWithNibName:@"HomeShopDataVC" bundle:nil];
        vc.fromViewAll = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)ButtonRecentlyAddedViewAllClicked:(UIButton*)button{
    if (button.tag == 2) {
        HomeShopDataVC *vc = [[HomeShopDataVC alloc] initWithNibName:@"HomeShopDataVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)ButtonSelectedProductViewAllClicked:(UIButton*)button{
    if (button.tag == 3) {
        HomeShopDataVC *vc = [[HomeShopDataVC alloc] initWithNibName:@"HomeShopDataVC" bundle:nil];
        vc.fromFeaturedProducts = true;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)ButtonDealViewAllClicked:(UIButton*)button {
    //Deal of the Day
    if (button.tag == 4) {
        NSLog(@"in Deal of the Day %ld", (long)button.tag);
        HomeShopDataVC *vc = [[HomeShopDataVC alloc] initWithNibName:@"HomeShopDataVC" bundle:nil];
        vc.fromDealofTheDay = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)ButtonTopRatedViewAllClicked:(UIButton*)button {
    //Most Popular Product
    if (button.tag == 5) {
        NSLog(@"in toprated product %ld", (long)button.tag);
        HomeShopDataVC *vc = [[HomeShopDataVC alloc] initWithNibName:@"HomeShopDataVC" bundle:nil];
        vc.fromTopRatedProducts = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.colInfiniteData) {
        return self->arrInfiniteProductData.count;
    } else {
        if (appDelegate.arrMainCategory.count == 0)
        {
            return 0;
        }
        else if (appDelegate.arrMainCategory.count > 5)
        {
            return 6;
        }
        return appDelegate.arrMainCategory.count + 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.colInfiniteData) {
        static NSString *identifier = @"ShopDataGridCell";
        
        ShopDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopDataGridCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        Product *object = [arrInfiniteProductData objectAtIndex:indexPath.row];

        cell.product = object;
        if (appDelegate.isCatalogMode) {
            cell.btnAddToCart.hidden = true;
        } else {
            if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
                cell.btnAddToCart.hidden = false;
                [Util setSecondaryColorButton:cell.btnAddToCart];
                
                [cell.btnAddToCart setTitle:[MCLocalization stringForKey:@"ADD TO CART"] forState:UIControlStateNormal];
                
                if ([object.type1 isEqualToString:@"external"]) {
                    //external product
                } else if ([object.type1 isEqualToString:@"grouped"]) {
                    //Group product
                } else if ([object.type1 isEqualToString:@"variable"]) {
                    //Variable product
                } else {
                    //Simple product
                    if ([Util checkInCart:object variation:0 attribute:nil]) {
                        [cell.btnAddToCart setTitle:[MCLocalization stringForKey:@"GO TO CART"] forState:UIControlStateNormal];
                    } else {
                        [cell.btnAddToCart setTitle:[MCLocalization stringForKey:@"ADD TO CART"] forState:UIControlStateNormal];
                    }
                }
                if (object.in_stock == 1) {
                    [Util setSecondaryColorButton:cell.btnAddToCart];
                    cell.btnAddToCart.userInteractionEnabled = true;
                    cell.btnAddToCart.alpha = 1.0;
                    cell.alpha = 1.0;
                } else {
                    [Util setRedButton:cell.btnAddToCart];
                    cell.btnAddToCart.userInteractionEnabled = false;
                    cell.btnAddToCart.alpha = 0.5;
                    [cell.btnAddToCart setTitle:[MCLocalization stringForKey:@"Out of Stock"] forState:UIControlStateNormal];
                }
            } else {
                cell.btnAddToCart.hidden = true;
            }
        }
        Boolean set11 = [arrWishList containsObject:[NSString stringWithFormat:@"%d",object.product_id]];
        //image change for wish list
        if (set11) {
            [Util setPrimaryColorButtonImageBG:cell.btnWishList image:[UIImage imageNamed:@"IconInWishList"]];
        } else {
            [cell.btnWishList setImage:[UIImage imageNamed:@"IconWishList"] forState:UIControlStateNormal];
        }
        cell.btnWishList.tag = indexPath.row;
        cell.btnStore.tag = indexPath.row;
        cell.btnAddToCart.tag = indexPath.row;
        
        [cell.btnAddToCart addTarget:self action:@selector(btnAddToCartClicked:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnWishList addTarget:self action:@selector(btnWishListClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.lblTitle.textColor = FontColorGray;
        cell.lblTitle.text = object.name;
        cell.lblTitle.font=Font_Size_Product_Name_Small;
        
        [cell.act startAnimating];
        [Util setPrimaryColorActivityIndicator:cell.act];
        
        if (object.arrImages.count > 0) {
            [cell.imgProduct sd_setImageWithURL:[Util EncodedURL:[[object.arrImages objectAtIndex:0] valueForKey:@"src"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [cell.act stopAnimating];
                cell.imgProduct.image=image;
            }];
        }
        NSString * htmlString = object.price_html;
        cell.lblRate.attributedText = [Util setPriceForItem:htmlString];
        [cell.lblRate setTextAlignment:NSTextAlignmentCenter];
        if (arrselect.count > 0) {
            NSIndexPath *indexPath1 = [arrselect objectAtIndex:0];
            if (indexPath.row == indexPath1.row) {
                cell.btnWishList.userInteractionEnabled = NO;
                [UIView animateWithDuration:0.4f animations:^{
                    cell.btnWishList.transform = CGAffineTransformMakeScale(1.5, 1.5);
                } completion:^(BOOL finished) {
                    [Util setPrimaryColorButtonImageBG:cell.btnWishList image:[UIImage imageNamed:@"IconInWishList"]];
                    // for zoom out
                    [UIView animateWithDuration:0.4f animations:^{
                        cell.btnWishList.transform = CGAffineTransformMakeScale(1, 1);
                    } completion:^(BOOL finished) {
                        cell.btnWishList.userInteractionEnabled = YES;
                    }];
                }];
                arrselect = [[NSArray alloc] init];
            }
        }
        if (arrUnselect.count>0) {
            NSIndexPath *indexPath1 = [arrUnselect objectAtIndex:0];
            if (indexPath.row == indexPath1.row) {
                [cell.btnWishList setImage:[UIImage imageNamed:@"IconWishList"] forState:UIControlStateNormal];
                arrUnselect = [[NSArray alloc] init];
            }
        }
        BOOL flg = false;
        for (UIView *subview in cell.vwRating.subviews) {
            if (subview.tag >= 1000) {
                flg = YES;
                HCSStarRatingView *starRatingView = (HCSStarRatingView *)subview;
                starRatingView.value = object.average_rating;
                starRatingView.frame = CGRectMake(0, 0, cell.vwRating.frame.size.width, cell.vwRating.frame.size.height);
                break;
            }
        }
        if (!flg) {
            [cell.vwRating addSubview:[Util setStarRating:object.average_rating frame:CGRectMake(0, 0, cell.vwRating.frame.size.width, cell.vwRating.frame.size.height) tag:1000+indexPath.row]];
        }
        
        cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        cell.layer.shadowRadius = 1.0f;
        cell.layer.shadowOpacity = 0.5f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        
        if (!apiCallRunning && noProductFound != 1 && indexPath.row == arrInfiniteProductData.count - 6) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                self->apiCallRunning = YES;
                [self getProductRandom];
            });
        }
        [Util setTriangleLable:cell.vwDiscount product:object];
        
        if (appDelegate.isWishList) {
            cell.btnWishList.hidden = NO;
        } else {
            cell.btnWishList.hidden = YES;
        }
        cell.lblTimer.font = Font_Size_Price_Sale_Small_Bold;
        if ([object.date_on_sale_to isKindOfClass:[NSString class]] || appDelegate.isCartButtonEnabled) {
            if (!appDelegate.isCatalogMode && appDelegate.isCartButtonEnabled && [object.date_on_sale_to isKindOfClass:[NSString class]]) {
                //manage both frame
                cell.heightTimer.constant = 24;
                cell.heightAddToCart.constant = 30;
            } else if (!appDelegate.isCatalogMode && appDelegate.isCartButtonEnabled) {
                    //manage both frame
                cell.heightTimer.constant = 0;
                    cell.heightAddToCart.constant = 30;
            } else if ([object.date_on_sale_to isKindOfClass:[NSString class]]) {
                //manage both frame
                cell.heightTimer.constant = 24;
                cell.heightAddToCart.constant = 0;
            } else {
                cell.heightTimer.constant = 0;
                cell.heightAddToCart.constant = 0;
            }
            if ([object.date_on_sale_to isKindOfClass:[NSString class]]) {
                cell.lblTimer.hidden = false;
                [cell startTimer:object.date_on_sale_to];
            } else {
                cell.lblTimer.hidden = true;
            }
        } else {
            cell.heightTimer.constant = 0;
            cell.heightAddToCart.constant = 0;
            cell.lblTimer.hidden = true;
        }
        cell.heightRating.constant = 13*SCREEN_SIZE.width/375;
        [cell layoutIfNeeded];
        return cell;
    } else {
        //colHeaderContent
        static NSString *identifier = @"HeaderTabCell";
        HeaderTabCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HeaderTabCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        if (appDelegate.isRTL) {
            [cell setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        } else {
            [cell setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
        if (appDelegate.arrMainCategory.count > 5 && indexPath.row == 5) {
            //LastCell
            cell.imgIcon.image = [UIImage imageNamed:@"IconHeaderTab6"];
            cell.lblText.text = [MCLocalization stringForKey:@"More.."];
        } else if (indexPath.row == appDelegate.arrMainCategory.count) {
            //LastCell
            cell.imgIcon.image = [UIImage imageNamed:@"IconHeaderTab6"];
            cell.lblText.text = [MCLocalization stringForKey:@"More.."];
        } else {
            [cell.imgIcon sd_setImageWithURL:[Util EncodedURL:[[appDelegate.arrMainCategory objectAtIndex:indexPath.row] valueForKey:@"main_cat_image"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                cell.imgIcon.image = image;
            }];
            cell.lblText.text = [[[appDelegate.arrMainCategory objectAtIndex:indexPath.row] valueForKey:@"main_cat_name"] capitalizedString];
        }
        cell.lblText.font=Font_Size_Price_Sale_Small;
        return cell;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (pageInfiniteData != 1) {
        if (collectionView == self.colInfiniteData) {
            [appDelegate setRecentProduct:[arrInfiniteProductData objectAtIndex:indexPath.row]];
            Product *object = [arrInfiniteProductData objectAtIndex:indexPath.row];
            
            if ([object.type1 isEqualToString:@"external"]) {
                NSString *strUrl = object.external_url;
                NSURL *_url = [Util EncodedURL:strUrl];
                [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
            } else if ([object.type1 isEqualToString:@"grouped"]) {
                //GroupItemDetailVC
                GroupItemDetailVC *vc = [[GroupItemDetailVC alloc] initWithNibName:@"GroupItemDetailVC" bundle:nil];
                vc.product = object;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([object.type1 isEqualToString:@"variable"]) {
                //VariableItemDetailVC
                VariableItemDetailVC *vc = [[VariableItemDetailVC alloc] initWithNibName:@"VariableItemDetailVC" bundle:nil];
                vc.product = object;
                [self.navigationController pushViewController:vc animated:YES];
            } else {
                ItemDetailVC *vc = [[ItemDetailVC alloc] initWithNibName:@"ItemDetailVC" bundle:nil];
                vc.product = [arrInfiniteProductData objectAtIndex:indexPath.row];
                [self.navigationController pushViewController:vc animated:YES];
            }
            return;
        }
    }
    if (appDelegate.arrMainCategory.count > 5 && indexPath.row == 5) {
        //LastCell
        appDelegate.fromMore = YES;
        [appDelegate Search:self];
    } else if (indexPath.row == appDelegate.arrMainCategory.count) {
        //LastCell
        appDelegate.fromMore = YES;
        [appDelegate Search:self];
    } else {
        int setSubCategory = 0;
        NSMutableArray *arrContent = [[NSMutableArray alloc] initWithArray:appDelegate.arrCategory];
        NSMutableArray *arrSubContent = [[NSMutableArray alloc] init];
        
        NSString *val = [NSString stringWithFormat:@"%d",[[[appDelegate.arrMainCategory objectAtIndex:indexPath.row] valueForKey:@"main_cat_id"] intValue]];
        for (int i = 0; i < arrContent.count; i++) {
            NSString *val2 = [NSString stringWithFormat:@"%@",[[arrContent objectAtIndex:i] valueForKey:@"parent"]];
            if ([val isEqualToString:val2]) {
                //parent Category
                [arrSubContent addObject:[arrContent objectAtIndex:i]];
                setSubCategory = 1;
            }
        }
        if (setSubCategory == 1) {
            SubCategoryVC *vc = [[SubCategoryVC alloc] initWithNibName:@"SubCategoryVC" bundle:nil];
            vc.arrSubCategory = arrSubContent;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            HomeShopDataVC *vc = [[HomeShopDataVC alloc]initWithNibName:@"HomeShopDataVC" bundle:nil];
            vc.fromCategory = YES;
            vc.CategoryID = [[[appDelegate.arrMainCategory objectAtIndex:indexPath.row] valueForKey:@"main_cat_id"] intValue];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.colInfiniteData) {
        return 6.0;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (collectionView == self.colInfiniteData) {
        return UIEdgeInsetsMake(6, 6, 6, 6);
    }
    return UIEdgeInsetsMake(0, 3, 0, 3);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.colInfiniteData) {
        if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
            return CGSizeMake((collectionView.frame.size.width/2)-10, (SCREEN_SIZE.width*300/375));
        } else {
            return CGSizeMake((collectionView.frame.size.width/2)-10, (SCREEN_SIZE.width*300/375) - (SCREEN_SIZE.width*30/375));
        }
    }
    if(appDelegate.arrMainCategory.count > 5) {
        return CGSizeMake((collectionView.frame.size.width/6) - 6, collectionView.frame.size.height);
    }
    return CGSizeMake((collectionView.frame.size.width/(appDelegate.arrMainCategory.count + 1.0)) - 6, collectionView.frame.size.height);
}

#pragma mark - Page controller

- (void)updateDots
{
    // this only needs to be done one time
    // 7x7 image (@1x)
    self.pageController.currentPageIndicatorTintColor = [Util colorWithHexString:[Util getStringData:kPrimaryColor]];
    self.pageController.pageIndicatorTintColor = [UIColor darkGrayColor];
}

#pragma mark - API calls

-(void)getHomeScrolling
{
    if (!homeResponse) {
        SHOW_LOADER_ANIMTION();
        self.vwHeader.hidden = YES;
        self.vwSearch.hidden = YES;
        self.vwContent.hidden = YES;
    } //else {
    if (appDelegate.isShimmerLoader) {
        [self.vwLoaderInfinite1 showLoader];
        [self.vwLoaderInfinite2 showLoader];
        [self.vwLoaderInfinite3 showLoader];
        [self.vwLoaderInfinite4 showLoader];
        [self.vwLoaderInfinite5 showLoader];
        [self.vwLoaderInfinite6 showLoader];
        self.vwLoaderInfinite.hidden = false;
    }
//    }

    imagesArray = [[NSMutableArray alloc] init];
    [self setScrollingImageViews];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:PLUGIN_VERSION1 forKey:@"app-ver"];

    [CiyaShopAPISecurity homeScrolling:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        NSLog(@"%@", dictionary);
        if (success) {
            if (dictionary.count > 0) {
                if (appDelegate.isShimmerLoader) {
                    HIDE_PROGRESS;
                    [self.vwLoaderHeader showLoader];
                    [self.vwLoaderCategory showLoader];
                    [self.vwLoaderHeaderCategory showLoader];
                    [self.vwLoaderBanner showLoader];
                    self.vwLoader.hidden = false;
                    if (!self->homeResponse) {
                        self.vwHeader.hidden = NO;
                        self.vwSearch.hidden = NO;
                        self.vwContent.hidden = NO;
                    }
                }
                if (IS_FROM_STATIC_DATA) {
                    //get data from static
                    if (IS_INFINITE_SCROLL) {
                        //get data from static from infinite scroll
                        [self setColorData:dictionary];
                        self->successData = success;
                        self->messageData = message;
                        self->dictionaryData = [[NSDictionary alloc] initWithDictionary:dictionary];
                        
                        appDelegate.isGetScroll = true;
                        self.tblShopDetail.hidden = true;
                        self.colInfiniteData.hidden = false;
                        self->pageInfiniteData = 1;
                        
                        [self.vwLoaderHeader hideLoader];
                        [self.vwLoaderCategory hideLoader];
                        [self.vwLoaderHeaderCategory hideLoader];
                        [self.vwLoaderBanner hideLoader];
                        
                        self.vwLoader.hidden = true;

                        [self getProductRandom];
                    } else {
                        appDelegate.isGetScroll = true;
                        self.tblShopDetail.hidden = false;
                        self.colInfiniteData.hidden = true;
                        [self homePageApi];
                    }
                } else {
                    //set data from server
                    if ([[dictionary valueForKey:@"pgs_woo_api_home_layout"] isEqualToString:@"scroll"] || self->homeResponse) {
                        //scroll view
                        [self setColorData:dictionary];
                        self->successData = success;
                        self->messageData = message;
                        self->dictionaryData = [[NSDictionary alloc] initWithDictionary:dictionary];
                        
                        appDelegate.isGetScroll = true;
                        self.tblShopDetail.hidden = true;
                        self.colInfiniteData.hidden = false;
                        self->pageInfiniteData = 1;
                        
                        [self.vwLoaderHeader hideLoader];
                        [self.vwLoaderCategory hideLoader];
                        [self.vwLoaderHeaderCategory hideLoader];
                        [self.vwLoaderBanner hideLoader];
                        
                        self.vwLoader.hidden = true;

                        [self getProductRandom];
                    } else {
                        //regular data
                        appDelegate.isGetScroll = true;
                        self.tblShopDetail.hidden = false;
                        self.colInfiniteData.hidden = true;
                        [self homePageApi];
                    }
                }
                self->homeResponse = true;
            } else {
                [self->refreshControlInfiniteScroll endRefreshing];
                [self->refreshControl endRefreshing];
                HIDE_PROGRESS;
                //error
                appDelegate.isGetScroll = false;
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
                self.vwHeader.hidden = NO;
                self.vwSearch.hidden = NO;
                self.vwContent.hidden = NO;
                
                [self.vwLoaderHeader hideLoader];
                [self.vwLoaderCategory hideLoader];
                [self.vwLoaderHeaderCategory hideLoader];
                [self.vwLoaderBanner hideLoader];
                
                self.vwLoader.hidden = true;
                self.vwLoaderInfinite.hidden = true;

                self.tblShopDetail.hidden = false;
                self.colInfiniteData.hidden = true;
            }
        } else {
            [self->refreshControlInfiniteScroll endRefreshing];
            [self->refreshControl endRefreshing];
            HIDE_PROGRESS;
            appDelegate.isGetScroll = false;
            ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
            self.vwHeader.hidden = NO;
            self.vwSearch.hidden = NO;
            self.vwContent.hidden = NO;
            
            self.tblShopDetail.hidden = false;
            self.colInfiniteData.hidden = true;

            [self.vwLoaderHeader hideLoader];
            [self.vwLoaderCategory hideLoader];
            [self.vwLoaderHeaderCategory hideLoader];
            [self.vwLoaderBanner hideLoader];
            self.vwLoader.hidden = true;
            self.vwLoaderInfinite.hidden = true;
        }
    }];
}

-(void)getProductRandom {
    if (self->pageInfiniteData == 1) {
        if (appDelegate.isShimmerLoader) {
//            [self.colInfiniteData showLoader];
            [self.vwLoaderInfinite1 showLoader];
            [self.vwLoaderInfinite2 showLoader];
            [self.vwLoaderInfinite3 showLoader];
            [self.vwLoaderInfinite4 showLoader];
            [self.vwLoaderInfinite5 showLoader];
            [self.vwLoaderInfinite6 showLoader];
            self.vwLoaderInfinite.hidden = false;
        }
    } else {
        if (arrInfiniteProductData.count > 0) {
            //show loader a bottom
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.view bringSubviewToFront:self->actInfiniteScroll];
                [self->actInfiniteScroll startAnimating];
            });
        }
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setValue:@"10" forKey:@"product-per-page"];
    
    if (self->pageInfiniteData != 1) {
        if (self->arrInfiniteProductData.count > 0) {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (Product *item in arrInfiniteProductData)
            {
                [arr addObject:[NSString stringWithFormat:@"%d", item.product_id]];
            }
            [dict setValue:arr forKey:@"loaded"];
        }
    }
    self->apiCallRunning = YES;
    [CiyaShopAPISecurity productRandom:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        if (self->pageInfiniteData == 1) {
            [self manageHomeAPIData:self->successData message:self->messageData dictionary:self->dictionaryData];
            self->arrInfiniteProductData = [[NSMutableArray alloc] init];
        }
        [self->refreshControlInfiniteScroll endRefreshing];
        self->apiCallRunning = NO;
        NSLog(@"%@",dictionary);
        if (success) {
            if (dictionary.count > 0) {
                if ([dictionary isKindOfClass:[NSArray class]]) {
                    //Is array
                    self->noProductFound = 0;
                    if (self->pageInfiniteData == 1) {
                        self->arrInfiniteProductData = [[NSMutableArray alloc] init];
                    }
                    NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                    for (int i = 0; i < arrData.count; i++) {
                        Product *object = [Util setProductData:[arrData objectAtIndex:i]];
                        [self->arrInfiniteProductData addObject:object];
                    }
                    self->pageInfiniteData++;
                } else if ([dictionary isKindOfClass:[NSDictionary class]]) {
                    //is dictionary
                    if ([[dictionary valueForKey:@"message"] isEqualToString:@"No product found"]) {
                        self->noProductFound = 1;
                    }
                }
            }
        } else {
            //error
            self->noProductFound = 1;
        }
        HIDE_PROGRESS;
        self.vwLoaderInfinite.hidden = true;
        [self.colInfiniteData reloadData];
        [self->actInfiniteScroll stopAnimating];
    }];
}

- (void)homePageApi
{
    self.vwLoaderInfinite.hidden = true;

    if (appDelegate.isShimmerLoader) {
        [self.vwLoaderHeader showLoader];
        [self.vwLoaderCategory showLoader];
        [self.vwLoaderHeaderCategory showLoader];
        [self.vwLoaderBanner showLoader];
        self.vwLoader.hidden = false;
    } else {
        SHOW_LOADER_ANIMTION();
        if (!homeResponse) {
            self.vwHeader.hidden = YES;
            self.vwSearch.hidden = YES;
            self.vwContent.hidden = YES;
        }
    }
    imagesArray = [[NSMutableArray alloc] init];
    [self setScrollingImageViews];

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:PLUGIN_VERSION1 forKey:@"app-ver"];
    
    [CiyaShopAPISecurity homeData:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        /*
        status = disable / enable;
        screen_order = 0 / 1 / 2 / 3;
        title = "Feature Products" / "Popular Products" / "Special Deal Products" / "Recent product title"
        key = feature_products / popular_products / recent_products / special_deal_products
         
        feature_products
            screen_order = 1;
            status = enable;
            title = "Feature Products";

        popular_products
            screen_order = 2;
            status = enable;
            title = "Popular Products";

        recent_products
            screen_order = 0;
            status = enable;
            title = "Recent product title";

         special_deal_products
            screen_order = 3;
            status = enable;
            title = "Special Deal Products";
         */
        [self manageHomeAPIData:success message:message dictionary:dictionary];
        [self->refreshControl endRefreshing];
    }];
}

- (void)homePagePulltoRefreshApi
{
    if (!(self->homeResponse)) {
        [self getHomeScrolling];
        return;
    }
    if (appDelegate.isShimmerLoader) {
        [self.vwLoaderHeader showLoader];
        [self.vwLoaderCategory showLoader];
        [self.vwLoaderHeaderCategory showLoader];
        [self.vwLoaderBanner showLoader];
        self.vwLoader.hidden = false;
    } else {
        SHOW_LOADER_ANIMTION();
        if (!homeResponse) {
            self.vwHeader.hidden = YES;
            self.vwSearch.hidden = YES;
            self.vwContent.hidden = YES;
        }
    }
    imagesArray = [[NSMutableArray alloc] init];
    [self setScrollingImageViews];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:PLUGIN_VERSION1 forKey:@"app-ver"];
    
    [CiyaShopAPISecurity homeData:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        [self manageHomeAPIData:success message:message dictionary:dictionary];
        [self->refreshControl endRefreshing];
    }];
}

-(void)manageHomeAPIData:(BOOL)success message:(NSString*)message dictionary:(NSDictionary*)dictionary{
    NSLog(@"%@", dictionary);
    self.vwHeader.hidden = NO;
    self.vwSearch.hidden = NO;
    self.vwContent.hidden = NO;

    if (success)
    {
        if (dictionary.count > 0)
        {
            UITabBar *tb = self.tabBarController.tabBar;
            [UIView animateWithDuration:0.5 animations:^{
                tb.frame = self->originalFrame;
            }];
            imagesArray = [[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"main_slider"] mutableCopy]];
            
            if (appDelegate.AppUrl.length == 0 || [appDelegate.AppUrl isEqualToString:@""] || appDelegate.AppUrl == nil)
            {
                appDelegate.AppUrl=[dictionary valueForKey:@"ios_app_url"] ;
            }
            
            //Adding image s
            if(!([dictionary valueForKey:@"app_logo"] == [NSNull null]))
            {
                if([dictionary valueForKey:@"app_logo"] !=nil && ![[dictionary valueForKey:@"app_logo"] isEqualToString:@""])
                {
                    [Util setData:[dictionary valueForKey:@"app_logo"] key:kAppNameImage];
                }
            }
            else
            {
                [Util setData:nil key:kAppNameImage];
            }
            if(!([dictionary valueForKey:@"app_logo_light"] == [NSNull null]))
            {
                if([dictionary valueForKey:@"app_logo_light"] !=nil && ![[dictionary valueForKey:@"app_logo_light"] isEqualToString:@""])
                {
                    [Util setData:[dictionary valueForKey:@"app_logo_light"] key:kAppNameWhiteImage];
                    [self.imgHeaderAppName sd_setImageWithURL:[Util EncodedURL:[dictionary valueForKey:@"app_logo_light"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                        
                        if (image == nil)
                        {
                            self.imgHeaderAppName.image = [UIImage imageNamed:@"HeaderClickShop"];
                        }
                        else
                        {
                            self.imgHeaderAppName.image = image;
                            if (self.imgHeaderAppName.image.size.height >= self.imgHeaderAppName.image.size.width)
                            {
                                CGSize size = [self.imgHeaderAppName sizeThatFits:self.imgHeaderAppName.frame.size];
                                CGSize actualSize;
                                actualSize.height = self.imgHeaderAppName.frame.size.height;
                                actualSize.width = size.width / (1.0 * (size.height / self.imgHeaderAppName.frame.size.height));
                                CGRect frame = self.imgHeaderAppName.frame;
                                frame.size = actualSize;
                                [self.imgHeaderAppName setFrame:frame];
                            }
                            self.imgHeaderAppName.contentMode= UIViewContentModeScaleAspectFit;
                        }
                    }];
                }
                else
                {
                    self.imgHeaderAppName.image = [UIImage imageNamed:@"HeaderClickShop"];
                }
            }
            else
            {
                self.imgHeaderAppName.image = [UIImage imageNamed:@"HeaderClickShop"];
                [Util setData:nil key:kAppNameWhiteImage];
            }
            
            if (IS_FROM_STATIC_DATA) {
                if (IS_ADD_TO_CART) {
                    appDelegate.isCartButtonEnabled = true;
                } else {
                    appDelegate.isCartButtonEnabled = false;
                }
            } else {
                if ([dictionary objectForKey:@"pgs_woo_api_add_to_cart_option"]) {
                    if ([[dictionary valueForKey:@"pgs_woo_api_add_to_cart_option"] isEqualToString:@"enable"]) {
                        appDelegate.isCartButtonEnabled = true;
                    } else {
                        appDelegate.isCartButtonEnabled = false;
                    }
                } else {
                    appDelegate.isCartButtonEnabled = false;
                }
            }            
            
            if ([dictionary objectForKey:@"woocommerce_enable_reviews"]) {
                if ([[dictionary valueForKey:@"woocommerce_enable_reviews"] isEqualToString:@"yes"]) {
                    appDelegate.isReviewEnabled = true;
                } else {
                    appDelegate.isReviewEnabled = false;
                }
            } else {
                appDelegate.isReviewEnabled = true;
            }
            
            if ([dictionary objectForKey:@"woocommerce_review_rating_verification_required"]) {
                if ([[dictionary valueForKey:@"woocommerce_review_rating_verification_required"] isEqualToString:@"yes"]) {
                    appDelegate.isReviewLoginEnabled = true;
                } else {
                    appDelegate.isReviewLoginEnabled = false;
                }
            } else {
                appDelegate.isReviewLoginEnabled = false;
            }
            
            if ([dictionary objectForKey:@"pgs_woo_api_deliver_pincode"]) {
                if ([[[dictionary valueForKey:@"pgs_woo_api_deliver_pincode"] valueForKey:@"status"] isEqualToString:@"enable"]) {
                    appDelegate.isPincodeCheckActive = true;
                    //set setting data for pin code
                    appDelegate.pincodeConfigData = [[PincodeData alloc] init];
                    if ([[dictionary valueForKey:@"pgs_woo_api_deliver_pincode"] objectForKey:@"setting_options"]) {
                        NSDictionary *dictPinConfig = [[dictionary valueForKey:@"pgs_woo_api_deliver_pincode"] valueForKey:@"setting_options"];
                        appDelegate.pincodeConfigData.availableat_text = [dictPinConfig valueForKey:@"availableat_text"];
                        appDelegate.pincodeConfigData.cod_available_msg = [dictPinConfig valueForKey:@"cod_available_msg"];
                        appDelegate.pincodeConfigData.cod_data_label = [dictPinConfig valueForKey:@"cod_data_label"];
                        appDelegate.pincodeConfigData.cod_help_text = [dictPinConfig valueForKey:@"cod_help_text"];
                        appDelegate.pincodeConfigData.cod_not_available_msg = [dictPinConfig valueForKey:@"cod_not_available_msg"];
                        appDelegate.pincodeConfigData.del_data_label = [dictPinConfig valueForKey:@"del_data_label"];
                        appDelegate.pincodeConfigData.del_help_text = [dictPinConfig valueForKey:@"del_help_text"];
                        appDelegate.pincodeConfigData.del_saturday = [dictPinConfig valueForKey:@"del_saturday"];
                        appDelegate.pincodeConfigData.del_sunday = [dictPinConfig valueForKey:@"del_sunday"];
                        appDelegate.pincodeConfigData.error_msg_blank = [dictPinConfig valueForKey:@"error_msg_blank"];
                        appDelegate.pincodeConfigData.error_msg_check_pincode = [dictPinConfig valueForKey:@"error_msg_check_pincode"];
                        appDelegate.pincodeConfigData.pincode_placeholder_txt = [dictPinConfig valueForKey:@"pincode_placeholder_txt"];
                        appDelegate.pincodeConfigData.show_city_on_product = [dictPinConfig valueForKey:@"show_city_on_product"];
                        appDelegate.pincodeConfigData.show_cod_on_product = [dictPinConfig valueForKey:@"show_cod_on_product"];
                        appDelegate.pincodeConfigData.show_estimate_on_product = [dictPinConfig valueForKey:@"show_estimate_on_product"];
                        appDelegate.pincodeConfigData.show_product_page = [dictPinConfig valueForKey:@"show_product_page"];
                        appDelegate.pincodeConfigData.show_state_on_product = [dictPinConfig valueForKey:@"show_state_on_product"];
                    } else {
                        appDelegate.pincodeConfigData.availableat_text = [MCLocalization stringForKey:@"Available at"];
                        appDelegate.pincodeConfigData.cod_available_msg = [MCLocalization stringForKey:@"Available"];
                        appDelegate.pincodeConfigData.cod_data_label = [MCLocalization stringForKey:@"Cash On Delivery"];
                        appDelegate.pincodeConfigData.cod_help_text = [MCLocalization stringForKey:@"Cash On Delivery"];
                        appDelegate.pincodeConfigData.cod_not_available_msg = [MCLocalization stringForKey:@"Not Available"];
                        appDelegate.pincodeConfigData.del_data_label = [MCLocalization stringForKey:@"Cash On Delivery"];
                        appDelegate.pincodeConfigData.del_help_text = [MCLocalization stringForKey:@"Delivery Date Help Text"];
                        appDelegate.pincodeConfigData.del_saturday = 1;
                        appDelegate.pincodeConfigData.del_sunday = 1;
                        appDelegate.pincodeConfigData.error_msg_blank = [MCLocalization stringForKey:@"Pincode should not be blank."];
                        appDelegate.pincodeConfigData.error_msg_check_pincode = [MCLocalization stringForKey:@"Please Enter Valid Pincode"];
                        appDelegate.pincodeConfigData.pincode_placeholder_txt = [MCLocalization stringForKey:@"Enter Your Pincode"];
                        appDelegate.pincodeConfigData.show_city_on_product = 1;
                        appDelegate.pincodeConfigData.show_cod_on_product = 1;
                        appDelegate.pincodeConfigData.show_estimate_on_product = 1;
                        appDelegate.pincodeConfigData.show_product_page = 1;
                        appDelegate.pincodeConfigData.show_state_on_product = 1;
                    }
                } else {
                    appDelegate.isPincodeCheckActive = false;
                }
            } else {
                appDelegate.isPincodeCheckActive = false;
            }
            
            if(!([dictionary valueForKey:@"all_categories"] == [NSNull null]))
            {
                appDelegate.arrCategory = [[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"all_categories"] mutableCopy]];
            }
            else
            {
                appDelegate.arrCategory = [[NSMutableArray alloc] init];
            }
            if(!([dictionary valueForKey:@"category_banners"] == [NSNull null]))
            {
                appDelegate.arrHomeCatagoryData = [[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"category_banners"] mutableCopy]];
            }
            else
            {
                appDelegate.arrHomeCatagoryData = [[NSMutableArray alloc] init];
            }
            [self manageProductCarousal:dictionary];

            if(!([dictionary valueForKey:@"main_category"] == [NSNull null]))
            {
                appDelegate.arrMainCategory = [[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"main_category"] mutableCopy]];
            }
            else
            {
                appDelegate.arrMainCategory = [[NSMutableArray alloc] init];
            }
            if(!([dictionary valueForKey:@"banner_ad"] == [NSNull null]))
            {
                appDelegate.arrBanner = [[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"banner_ad"] mutableCopy]];
            }
            else
            {
                appDelegate.arrBanner = [[NSMutableArray alloc] init];
            }
            
            if ([dictionary objectForKey:@"feature_box_status"]) {
                if ([[dictionary valueForKey:@"feature_box_status"] isEqualToString:@"enable"]) {
                    appDelegate.isFeatureEnabled = true;
                } else {
                    appDelegate.isFeatureEnabled = false;
                }
            } else {
                appDelegate.isFeatureEnabled = false;
            }

            if(!([dictionary valueForKey:@"feature_box"] == [NSNull null]))
            {
                appDelegate.arrReasonToBuyWithUs = [[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"feature_box"] mutableCopy]];
                
                if (appDelegate.arrReasonToBuyWithUs.count>0)
                {
                    appDelegate.isFeatureEnabled = true;
                }
                else
                {
                    appDelegate.isFeatureEnabled = false;

                }
            }
            else
            {
                appDelegate.arrReasonToBuyWithUs = [[NSMutableArray alloc] init];
            }
            if(!([dictionary valueForKey:@"pgs_app_social_links"] == [NSNull null]))
            {
                appDelegate.dictSocialData = [[NSMutableDictionary alloc] initWithDictionary:[dictionary valueForKey:@"pgs_app_social_links"]];
            }
            else
            {
                appDelegate.dictSocialData = [[NSMutableDictionary alloc] init];
            }
            if(!([dictionary valueForKey:@"feature_box_heading"] == [NSNull null]))
            {
                appDelegate.strReasonsToBuy = [dictionary valueForKey:@"feature_box_heading"];
            }
            else
            {
                appDelegate.strReasonsToBuy = @"";
            }
            
            // Currency Symbol
            if(!([dictionary valueForKey:@"price_formate_options"] == [NSNull null]))
            {
                appDelegate.strCurrencySymbolPosition = [[dictionary valueForKey:@"price_formate_options"] valueForKey:@"currency_pos"];
                appDelegate.strCurrencySymbol = [[[dictionary valueForKey:@"price_formate_options"] valueForKey:@"currency_symbol"] gtm_stringByUnescapingFromHTML];
                appDelegate.decimal = [[[dictionary valueForKey:@"price_formate_options"] valueForKey:@"decimals"] intValue];
                appDelegate.strThousandSeparatore = [[dictionary valueForKey:@"price_formate_options"] valueForKey:@"thousand_separator"];
                appDelegate.strDecimalSeparatore = [[dictionary valueForKey:@"price_formate_options"] valueForKey:@"decimal_separator"] ;
            }
            else
            {
                appDelegate.strCurrencySymbolPosition = @"";
                appDelegate.strCurrencySymbol = @"";
                appDelegate.decimal = 0;
                appDelegate.strThousandSeparatore = @"";
                appDelegate.strDecimalSeparatore = @"";
            }
            
            if(!([dictionary valueForKey:@"pgs_app_contact_info"] == [NSNull null]))
            {
                appDelegate.strContactUsEmail = [[dictionary valueForKey:@"pgs_app_contact_info"] valueForKey:@"email"];
                appDelegate.strContactUsPhoneNumber = [[dictionary valueForKey:@"pgs_app_contact_info"] valueForKey:@"phone"];
                NSString *strFormateAddress = [NSString stringWithFormat:@"%@\n%@",[[dictionary valueForKey:@"pgs_app_contact_info"] valueForKey:@"address_line_1"],[[dictionary valueForKey:@"pgs_app_contact_info"] valueForKey:@"address_line_2"]];
                appDelegate.strContactUsAddress = strFormateAddress;
                appDelegate.strWhatsAppNumber = [[dictionary valueForKey:@"pgs_app_contact_info"] valueForKey:@"whatsapp_no"];
                
                if ([[[dictionary valueForKey:@"pgs_app_contact_info"] valueForKey:@"whatsapp_floating_button"] isEqualToString:@"enable"])
                {
                    appDelegate.isWhatsAppFloatingEnabled = true;
                }
                else
                {
                    appDelegate.isWhatsAppFloatingEnabled = false;
                }
            }
            else
            {
                appDelegate.strContactUsEmail = @"";
                appDelegate.strContactUsPhoneNumber = @"";
                appDelegate.strContactUsAddress = @"";
                appDelegate.strWhatsAppNumber = @"";
                appDelegate.isWhatsAppFloatingEnabled = false;
            }
            [appDelegate showWhatsAppFloatingButton];
            
            
            if ([dictionary objectForKey:@"is_wishlist_active"]) {
                NSNumber* wishListActive = [dictionary valueForKey:@"is_wishlist_active"];
                appDelegate.isWishList = [wishListActive boolValue] ? YES : NO;
            } else {
                appDelegate.isWishList = NO;
            }
            
            if ([dictionary objectForKey:@"is_currency_switcher_active"]) {
                NSNumber* currencySwitcher = [dictionary valueForKey:@"is_currency_switcher_active"];
                appDelegate.isCurrencySet = [currencySwitcher boolValue] ? YES : NO;
            } else {
                appDelegate.isCurrencySet = NO;
            }
            
            if ([dictionary objectForKey:@"is_order_tracking_active"]) {
                NSNumber* orderTrackingActive = [dictionary valueForKey:@"is_order_tracking_active"];
                appDelegate.isOrderTrackingActive = [orderTrackingActive boolValue] ? YES : NO;
            } else {
                appDelegate.isOrderTrackingActive = NO;
            }
            
            if ([dictionary objectForKey:@"is_reward_points_active"]) {
                NSNumber* myRewardsPointActive = [dictionary valueForKey:@"is_reward_points_active"];
                appDelegate.isMyRewardPointsActive = [myRewardsPointActive boolValue] ? YES : NO;
            } else {
                appDelegate.isMyRewardPointsActive = NO;
            }
            
            if ([dictionary objectForKey:@"is_guest_checkout_active"]) {
                NSNumber* guestCheckoutActive = [dictionary valueForKey:@"is_guest_checkout_active"];
                appDelegate.isGuestCheckoutActive = [guestCheckoutActive boolValue] ? YES : NO;
            } else {
                appDelegate.isGuestCheckoutActive = YES;
            }
            
            if ([dictionary objectForKey:@"is_wpml_active"]) {
                NSNumber* wpmlActive = [dictionary valueForKey:@"is_wpml_active"];
                appDelegate.isWpmlActive = [wpmlActive boolValue] ? YES : NO;
            } else {
                appDelegate.isWpmlActive = NO;
            }
            
            if ([dictionary objectForKey:@"is_yith_featured_video_active"]) {
                NSNumber* yithactive = [dictionary valueForKey:@"is_yith_featured_video_active"];
                appDelegate.isYithVideoEnabled = [yithactive boolValue] ? YES : NO;
            } else {
                appDelegate.isYithVideoEnabled = NO;
            }
            
            
            if (![[Util getStringData:kLanguaageSet] isEqualToString:[dictionary valueForKey:@"site_language"]])
            {
                if (![[MCLocalization sharedInstance].language isEqualToString:[dictionary valueForKey:@"site_language"]])
                {
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [Util setArray:arr setData:kRecentItem];
                    appDelegate.isLanguageChange = YES;
                }
                else
                {
                    appDelegate.isLanguageChange = NO;
                }
            }
            else
            {
                appDelegate.isLanguageChange = NO;
            }
            
            //get data for WPML language
            if ([dictionary objectForKey:@"wpml_languages"])
            {
                NSArray *arrLanguages = [[NSArray alloc] initWithArray:[dictionary valueForKey:@"wpml_languages"]];
                appDelegate.arrWpmlLanguages = [[NSMutableArray alloc] initWithArray:arrLanguages];
            }
            
            // get data from Web-View
            
            if(!([dictionary valueForKey:@"pgs_woo_api_web_view_pages"] == [NSNull null]))
            {
                appDelegate.arrFromWebView = [[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"pgs_woo_api_web_view_pages"] mutableCopy]];
            }
            else
            {
                appDelegate.arrFromWebView = [[NSMutableArray alloc] init];
            }
            
            //set language
            
            if (appDelegate.isWpmlActive)
            {
                appDelegate.isLanguageChange = true;
            }
            if (![Util getBoolData:kLanguage] || !appDelegate.isWpmlActive)
            {
                [Util setData:[dictionary valueForKey:@"site_language"] key:kLanguaageSet];
                appDelegate.isRTL = [[dictionary valueForKey:@"is_rtl"] boolValue];
                [MCLocalization sharedInstance].language = [dictionary valueForKey:@"site_language"];
                
                if (appDelegate.isWpmlActive)
                {
                    //wpml on
                    for (int i = 0; i < appDelegate.arrWpmlLanguages.count; i++)
                    {
                        if ([[[appDelegate.arrWpmlLanguages objectAtIndex:i] valueForKey:@"site_language"] isEqualToString:[dictionary valueForKey:@"site_language"]])
                        {
                            [Util setBoolData:true setBoolData:kLanguage];
                            [Util setData:[[appDelegate.arrWpmlLanguages objectAtIndex:i] valueForKey:@"code"] key:kLanguageText];
                            break;
                        }
                    }
                }
                else
                {
                    //wpml not on
                    [Util setBoolData:false setBoolData:kLanguage];
                    [Util setData:@"" key:kLanguageText];
                }
                [appDelegate setDataForCiyashopOauth];
            }
            else
            {
                for (int i = 0; i < appDelegate.arrWpmlLanguages.count; i++)
                {
                    if ([[[appDelegate.arrWpmlLanguages objectAtIndex:i] valueForKey:@"code"] isEqualToString:[Util getStringData:kLanguageText]])
                    {
                        appDelegate.isRTL = [[[appDelegate.arrWpmlLanguages objectAtIndex:i] valueForKey:@"is_rtl"] boolValue];
                        break;
                    }
                }
            }
//            appDelegate.isRTL = true;
//            [MCLocalization sharedInstance].language = @"ar";

            //Show slider or login page
            if (IS_FROM_STATIC_DATA) {
                if (IS_INTRO_SLIDER) {
                    appDelegate.isSliderScreen = true;
                } else{
                    appDelegate.isSliderScreen = false;
                }
            } else {
                if ([dictionary objectForKey:@"is_slider"]) {
                    NSNumber* wishListActive = [dictionary valueForKey:@"is_slider"];
                    appDelegate.isSliderScreen = [wishListActive boolValue] ? YES : NO;
                } else if ([dictionary objectForKey:@"pgs_woo_api_scroll_is_slider"]) {
                    if ([[dictionary valueForKey:@"pgs_woo_api_scroll_is_slider"] isEqualToString:@"enable"]) {
                        appDelegate.isSliderScreen = true;
                    } else {
                        appDelegate.isSliderScreen = false;
                    }
                } else {
                    appDelegate.isSliderScreen = NO;
                }
            }
            
            if (IS_FROM_STATIC_DATA){
                if (IS_LOGIN) {
                    appDelegate.isLoginScreen = true;
                } else{
                    appDelegate.isLoginScreen = false;
                }
            } else {
                if ([dictionary objectForKey:@"is_login"]) {
                    NSNumber* wishListActive = [dictionary valueForKey:@"is_login"];
                    appDelegate.isLoginScreen = [wishListActive boolValue] ? YES : NO;
                } else if ([dictionary objectForKey:@"pgs_woo_api_scroll_is_login"]) {
                    if ([[dictionary valueForKey:@"pgs_woo_api_scroll_is_login"] isEqualToString:@"enable"]) {
                        appDelegate.isLoginScreen = true;
                    } else {
                        appDelegate.isLoginScreen = false;
                    }
                } else {
                    appDelegate.isLoginScreen = NO;
                }
            }
            
            //show catalog mode
            
            if (IS_FROM_STATIC_DATA){
                if (IS_CATALOG_MODE) {
                    appDelegate.isCatalogMode = true;
                } else{
                    appDelegate.isCatalogMode = false;
                }
            } else {
                if ([dictionary objectForKey:@"pgs_woo_api_catalog_mode_option"]) {
                    if ([[dictionary valueForKey:@"pgs_woo_api_catalog_mode_option"] isEqualToString:@"enable"]) {
                        appDelegate.isCatalogMode = true;
                    } else {
                        appDelegate.isCatalogMode = false;
                    }
                } else {
                    appDelegate.isCatalogMode = false;
                }
            }
            appDelegate.isLanguageChange = true;
            
            if (!IS_FROM_STATIC_DATA) {
                
                if (![Util getBoolData:kFirstTime] && appDelegate.isSliderScreen) {
                    IntroductionVC *vc = [[IntroductionVC alloc] initWithNibName:@"IntroductionVC" bundle:nil];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                    navigationController.modalPresentationStyle=UIModalPresentationFullScreen;
                    [self presentViewController:navigationController animated:YES completion:nil];
                } else if (![Util getBoolData:kLogin] && appDelegate.isLoginScreen) {
                    [FBSDKAccessToken setCurrentAccessToken:nil];
                    [[GIDSignIn sharedInstance] signOut];
                    SigninVC *vc=[[SigninVC alloc] initWithNibName:@"SigninVC" bundle:nil];
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
                    navigationController.modalPresentationStyle=UIModalPresentationFullScreen;
                    [self presentViewController:navigationController animated:YES completion:nil];
                }
            }

            //get data for currency
            NSDictionary *dictCurrency = [[NSDictionary alloc] initWithDictionary:[dictionary valueForKey:@"currency_switcher"]];
            
            NSArray *keys = [dictCurrency allKeys];
            appDelegate.arrCurrency = [[NSMutableArray alloc] init];
            
            for (int i = 0; i < keys.count; i++)
            {
                NSMutableDictionary *dictData = [[NSMutableDictionary alloc] init];
                [dictData setValue:[[dictCurrency valueForKey:[keys objectAtIndex:i]] valueForKey:@"name"] forKey:@"title"];
                [dictData setValue:[[dictCurrency valueForKey:[keys objectAtIndex:i]] valueForKey:@"symbol"] forKey:@"symbol"];
                [appDelegate.arrCurrency addObject:dictData];
            }

            //set data in localize manner
            [self localize];
            
            //get check cart data
            if ([dictionary objectForKey:@"checkout_redirect_url"])
            {
                if(!([dictionary valueForKey:@"checkout_redirect_url"] == [NSNull null]))
                {
                    appDelegate.arrCheckoutOptions = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"checkout_redirect_url"]];
                }
                else
                {
                    appDelegate.arrCheckoutOptions = [[NSMutableArray alloc] init];
                }
            }
            else
            {
                appDelegate.arrCheckoutOptions = [[NSMutableArray alloc] init];
            }
            
            //Check that MyCartVc is in the tab  bar or not
            BOOL contains = false;
            NSArray * controllers = [self.tabBarController viewControllers];
            for (int i = 0; i < [controllers count]; i++){
                UINavigationController *nav = [controllers objectAtIndex:i];
                NSArray *viewController = nav.viewControllers;
                for (int j = 0; j < [viewController count]; j++){
                    UIViewController *controller = [viewController objectAtIndex:j];
                    if([controller isKindOfClass:[MyCartVC class]]){
                        NSLog(@"Class is available");
                        contains = true;
                        break;
                    }
                }
                if (contains) {
                    break;
                }
            }
            
            //show or hide the cart button from the tab bar
            
            if (appDelegate.isCatalogMode && contains){
                NSMutableArray *tabbarViewControllers = [NSMutableArray arrayWithArray: [self.tabBarController viewControllers]];
                [tabbarViewControllers removeObjectAtIndex: 2];
                [self.tabBarController setViewControllers: tabbarViewControllers ];
            } else if (!appDelegate.isCatalogMode && !contains) {
                MyCartVC *secondViewController = [[MyCartVC alloc] initWithNibName:@"MyCartVC" bundle:nil];
                secondViewController.title = [MCLocalization stringForKey:@"My Cart"];
                UINavigationController *myCartView = [[UINavigationController alloc] initWithRootViewController:secondViewController];
                NSMutableArray *mutableViewControllers = [self.tabBarController.viewControllers mutableCopy];
                [mutableViewControllers insertObject:myCartView atIndex:2];
                self.tabBarController.viewControllers = mutableViewControllers;
                UITabBarItem *item3 = self.tabBarController.tabBar.items[2];
                item3.image=[UIImage imageNamed:@"FooterUnselected3"];
                item3.tag=3;
            }

            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tblShopDetail reloadData];
                [self.colHeader reloadData];
            });
            [self.colInfiniteData reloadData];


            CGRect sectionRect = [self.tblShopDetail rectForSection:3];
            sectionRect.size.height = self.tblShopDetail.frame.size.height;
            [self.tblShopDetail scrollRectToVisible:sectionRect animated:NO];
            
            [self setScrollingImageViews];
            
            [self.tblShopDetail setContentOffset:CGPointZero animated:NO];
            
            [self addFooterToTableView];
            
            [[TimerHelper sharedInstance] startTimer];
            
            appDelegate.firstViewController.title = [MCLocalization stringForKey:@"Search"];
            appDelegate.secondViewController.title = [MCLocalization stringForKey:@"My Cart"];
            appDelegate.thirdViewController.title = [MCLocalization stringForKey:@"Home"];
            appDelegate.forthViewController.title = [MCLocalization stringForKey:@"Account"];
            appDelegate.fifthViewController.title = [MCLocalization stringForKey:@"Wishlist"];
            
            [self setColorData:dictionary];
            
            [self updateUI];
            HIDE_PROGRESS;
        }
        else
        {
            HIDE_PROGRESS;
            if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"])
            {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, self);
            }
            else
            {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
            }
        }
    }
    else
    {
        HIDE_PROGRESS;
        if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
            NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
            NSAttributedString *decodedString;
            decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                             options:options
                                                  documentAttributes:NULL
                                                               error:NULL];
            ALERTVIEW(decodedString.string, self);
        }
        else
        {
            ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
        }
    }
    
    [appDelegate setDataForCiyashopOauth];
    [self.vwLoaderHeader hideLoader];
    [self.vwLoaderCategory hideLoader];
    [self.vwLoaderHeaderCategory hideLoader];
    [self.vwLoaderBanner hideLoader];
    
    self.vwLoader.hidden = true;
    self.vwHeader.hidden = NO;
    self.vwSearch.hidden = NO;
    self.vwContent.hidden = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkDeepLinkData)
                                                 name:DeepLinkData
                                               object:nil];
    [self checkDeepLinkData];
}

-(void)setColorData:(NSDictionary*)dictionary {
    if ([fromServer isEqualToString:@"1"])
    {
        if([[dictionary valueForKey:@"app_color"] valueForKey:@"primary_color"] == nil || [[[dictionary valueForKey:@"app_color"] valueForKey:@"primary_color"] isEqualToString:@""])
        {
            //set static color
            [Util setData:titleColor key:kPrimaryColor];
        }
        else
        {
            NSString *strPrimaryColor = [[[dictionary valueForKey:@"app_color"] valueForKey:@"primary_color"] stringByReplacingOccurrencesOfString:@"#" withString:@""];
            [Util setData:strPrimaryColor key:kPrimaryColor];
        }
        
        if([[dictionary valueForKey:@"app_color"] valueForKey:@"secondary_color"] == nil || [[[dictionary valueForKey:@"app_color"] valueForKey:@"secondary_color"] isEqualToString:@""])
        {
            //set static color
            [Util setData:titleColor key:kSecondaryColor];
        }
        else
        {
            NSString *strPrimaryColor = [[[dictionary valueForKey:@"app_color"] valueForKey:@"secondary_color"] stringByReplacingOccurrencesOfString:@"#" withString:@""];
            [Util setData:strPrimaryColor key:kSecondaryColor];
        }
        
        if([[dictionary valueForKey:@"app_color"] valueForKey:@"header_color"] == nil || [[[dictionary valueForKey:@"app_color"] valueForKey:@"header_color"] isEqualToString:@""])
        {
            //set static color
            [Util setData:titleHeader key:kHeaderColor];
        }
        else
        {
            NSString *strPrimaryColor = [[[dictionary valueForKey:@"app_color"] valueForKey:@"header_color"] stringByReplacingOccurrencesOfString:@"#" withString:@""];
            [Util setData:strPrimaryColor key:kHeaderColor];
        }
    }
    else
    {
        [Util setData:titleColor key:kPrimaryColor];
        [Util setData:titleSecodary key:kSecondaryColor];
        [Util setData:titleHeader key:kHeaderColor];
    }
}

-(void)manageProductCarousal:(NSDictionary*)dictionary
{
    if ([dictionary objectForKey:@"products_carousel"])
    {
        if([[dictionary valueForKey:@"products_carousel"] isKindOfClass:[NSDictionary class]])
        {
            //is dictionary
            
            // 1=PopularProduct, 2=RecentlyAddedProduct, 3=SelectedProduct, 4=DealOofTheDay
            
            //Most Popular Product
            if ([[dictionary valueForKey:@"products_carousel"] objectForKey:@"popular_products"])
            {
                if([[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"popular_products"] valueForKey:@"products"] isKindOfClass:[NSArray class]])
                {
                    strPopularProduct = [[[dictionary valueForKey:@"products_carousel"] valueForKey:@"popular_products"] valueForKey:@"title"];
                    
                    isEnablePopularProduct = [[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"popular_products"] valueForKey:@"status"] isEqualToString:@"enable"] ? YES : NO;
                    
                    appDelegate.arrMostPopularProducts = [[[NSMutableArray alloc] initWithArray:[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"popular_products"] valueForKey:@"products"]] mutableCopy];
                }
                else if([[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"popular_products"] valueForKey:@"products"] isKindOfClass:[NSDictionary class]]) {
                    isEnablePopularProduct = NO;
                    appDelegate.arrMostPopularProducts = [[NSMutableArray alloc] init];
                } else {
                    isEnablePopularProduct = NO;
                    appDelegate.arrMostPopularProducts = [[NSMutableArray alloc] init];
                }
            } else {
                isEnablePopularProduct = NO;
                appDelegate.arrMostPopularProducts = [[NSMutableArray alloc] init];
            }
            //Recent Products
            if ([[dictionary valueForKey:@"products_carousel"] objectForKey:@"recent_products"]) {
                if([[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"recent_products"] valueForKey:@"products"] isKindOfClass:[NSArray class]]) {
                    strRecentlyAddedProduct = [[[dictionary valueForKey:@"products_carousel"] valueForKey:@"recent_products"] valueForKey:@"title"];
                    
                    isEnableRecentlyAdded = [[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"recent_products"] valueForKey:@"status"] isEqualToString:@"enable"] ? YES : NO;
                    
                    appDelegate.arrRecentlyAddedProducts = [[[NSMutableArray alloc] initWithArray:[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"recent_products"] valueForKey:@"products"]] mutableCopy];
                } else if([[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"recent_products"] valueForKey:@"products"] isKindOfClass:[NSDictionary class]]) {
                    isEnableRecentlyAdded = NO;
                    appDelegate.arrRecentlyAddedProducts = [[NSMutableArray alloc] init];
                } else {
                    isEnableRecentlyAdded = NO;
                    appDelegate.arrRecentlyAddedProducts = [[NSMutableArray alloc] init];
                }
            } else {
                isEnableRecentlyAdded = NO;
                appDelegate.arrRecentlyAddedProducts = [[NSMutableArray alloc] init];
            }
            
            //Selected Product
            if ([[dictionary valueForKey:@"products_carousel"] objectForKey:@"feature_products"]) {
                if([[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"feature_products"] valueForKey:@"products"] isKindOfClass:[NSArray class]]) {
                    strSelectedProduct = [[[dictionary valueForKey:@"products_carousel"] valueForKey:@"feature_products"] valueForKey:@"title"];
                    
                    isEnableSelected = [[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"feature_products"] valueForKey:@"status"] isEqualToString:@"enable"] ? YES : NO;
                    
                    appDelegate.arrSelectedProduct = [[[NSMutableArray alloc] initWithArray:[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"feature_products"] valueForKey:@"products"]] mutableCopy];
                } else if([[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"feature_products"] valueForKey:@"products"] isKindOfClass:[NSDictionary class]]) {
                    isEnableSelected = NO;
                    appDelegate.arrSelectedProduct = [[NSMutableArray alloc] init];
                } else {
                    isEnableSelected = NO;
                    appDelegate.arrSelectedProduct = [[NSMutableArray alloc] init];
                }
            } else {
                isEnableSelected = NO;
                appDelegate.arrSelectedProduct = [[NSMutableArray alloc] init];
            }
            
            //Deal of the Day
            if ([[dictionary valueForKey:@"products_carousel"] objectForKey:@"special_deal_products"]) {
                if([[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"special_deal_products"] valueForKey:@"products"] isKindOfClass:[NSArray class]]) {
                    strDealOofTheDay = [[[dictionary valueForKey:@"products_carousel"] valueForKey:@"special_deal_products"] valueForKey:@"title"];
                    
                    isEnableDealofTheDay = [[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"special_deal_products"] valueForKey:@"status"] isEqualToString:@"enable"] ? YES : NO;
                    
                    appDelegate.arrDealOfTheDay = [[[NSMutableArray alloc] initWithArray:[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"special_deal_products"] valueForKey:@"products"]] mutableCopy];
                } else if([[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"special_deal_products"] valueForKey:@"products"] isKindOfClass:[NSDictionary class]]) {
                    isEnableDealofTheDay = NO;
                    appDelegate.arrDealOfTheDay = [[NSMutableArray alloc] init];
                } else {
                    isEnableDealofTheDay = NO;
                    appDelegate.arrDealOfTheDay = [[NSMutableArray alloc] init];
                }
            } else {
                isEnableDealofTheDay = NO;
                appDelegate.arrDealOfTheDay = [[NSMutableArray alloc] init];
            }
            
            //Top Rated Product
            if ([[dictionary valueForKey:@"products_carousel"] objectForKey:@"top_rated_products"]) {
                if([[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"top_rated_products"] valueForKey:@"products"] isKindOfClass:[NSArray class]]) {
                    strTopRatedProduct = [[[dictionary valueForKey:@"products_carousel"] valueForKey:@"top_rated_products"] valueForKey:@"title"];
                    
                    isEnableTopRatedProduct = [[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"top_rated_products"] valueForKey:@"status"] isEqualToString:@"enable"] ? YES : NO;
                    
                    appDelegate.arrTopRatedData = [[[NSMutableArray alloc] initWithArray:[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"top_rated_products"] valueForKey:@"products"]] mutableCopy];
                } else if([[[[dictionary valueForKey:@"products_carousel"] valueForKey:@"top_rated_products"] valueForKey:@"products"] isKindOfClass:[NSDictionary class]]) {
                    isEnableTopRatedProduct = NO;
                    appDelegate.arrTopRatedData = [[NSMutableArray alloc] init];
                } else {
                    isEnableTopRatedProduct = NO;
                    appDelegate.arrTopRatedData = [[NSMutableArray alloc] init];
                }
            } else {
                isEnableTopRatedProduct = NO;
                appDelegate.arrTopRatedData = [[NSMutableArray alloc] init];
            }
            
            if ([dictionary objectForKey:@"products_view_orders"]) {
                arrItemIndex = [[NSMutableArray alloc] init];
                NSArray *arrPos = [[NSArray alloc] initWithArray:[dictionary objectForKey:@"products_view_orders"]];
                for (int i = 0; i < arrPos.count; i++) {
                    // 1=PopularProduct, 2=RecentlyAddedProduct, 3=SelectedProduct, 4=DealOofTheDay, 5=TopRatedProduct
                    if ([[[arrPos objectAtIndex:i] valueForKey:@"name"] isEqualToString:@"popular_products"]) {
                        [arrItemIndex addObject:@"1"];
                    } else if ([[[arrPos objectAtIndex:i] valueForKey:@"name"] isEqualToString:@"recent_products"]) {
                        [arrItemIndex addObject:@"2"];
                    } else if ([[[arrPos objectAtIndex:i] valueForKey:@"name"] isEqualToString:@"feature_products"]) {
                        [arrItemIndex addObject:@"3"];
                    } else if ([[[arrPos objectAtIndex:i] valueForKey:@"name"] isEqualToString:@"special_deal_products"]) {
                        [arrItemIndex addObject:@"4"];
                    } else if ([[[arrPos objectAtIndex:i] valueForKey:@"name"] isEqualToString:@"top_rated_products"]) {
                        [arrItemIndex addObject:@"5"];
                    }
                }
                
                if (![arrItemIndex containsObject:@"5"]) {
                    [arrItemIndex addObject:@"5"];
                    isEnableTopRatedProduct = NO;
                }
            } else {
                arrItemIndex = [[NSMutableArray alloc] initWithObjects:@"1", @"4", @"2", @"3", @"5", nil];
            }
        } else {
            isEnablePopularProduct = NO;
            isEnableSelected = NO;
            isEnableRecentlyAdded = NO;
            isEnableDealofTheDay = NO;
            isEnableTopRatedProduct = NO;
        }
    } else {
        isEnableSelected = NO;
        isEnableRecentlyAdded = NO;
        isEnableTopRatedProduct = NO;
        isEnablePopularProduct = YES;
        isEnableDealofTheDay = YES;
        if([[dictionary valueForKey:@"popular_products"] isKindOfClass:[NSArray class]]) {
            //Is array
            appDelegate.arrMostPopularProducts = [[NSMutableArray alloc] initWithArray:[[dictionary valueForKey:@"popular_products"] mutableCopy]];
        } else if([dictionary isKindOfClass:[NSDictionary class]]) {
            //is dictionary
            appDelegate.arrMostPopularProducts = [[NSMutableArray alloc] init];
        }
        strDealOofTheDay = [MCLocalization stringForKey:@"DEAL OF THE DAY"];
        strPopularProduct = [MCLocalization stringForKey:@"MOST POPULAR PRODUCTS"];
        
        appDelegate.arrDealOfTheDay = [[NSMutableArray alloc] initWithArray:[[[dictionary valueForKey:@"scheduled_sale_products"] valueForKey:@"products"] mutableCopy]];
        
        arrItemIndex = [[NSMutableArray alloc] initWithObjects:@"1", @"4", @"2", @"3", @"5", @"6", nil];
    }
    
    if ([dictionary objectForKey:@"product_banners_cat_value"]) {
        if ([dictionary objectForKey:@"product_banners_title"]) {
            strSelectedProductList = [dictionary objectForKey:@"product_banners_title"];
        } else {
            strSelectedProductList = @"";
        }
        if ([[dictionary valueForKey:@"product_banners_cat_value"] isEqualToString:@"enable"]) {
            if ([dictionary objectForKey:@"custom_section"]) {
                //Enable custom_section product
                isEnabledSelectedProductList = true;
                appDelegate.arrSelectedProductData = [[NSMutableArray alloc] initWithArray:[[dictionary objectForKey:@"custom_section"] mutableCopy]];
            } else {
                isEnabledSelectedProductList = false;
                appDelegate.arrSelectedProductData = [[NSMutableArray alloc] init];
            }
        } else {
            isEnabledSelectedProductList = false;
        }
    } else {
        isEnabledSelectedProductList = false;
    }
}

-(void)getSingleProduct:(NSString*)productId {
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:productId forKey:@"include"];
    
    [CiyaShopAPISecurity productListing:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {

        NSLog(@"%@", dictionary);
        if (success) {
            HIDE_PROGRESS;
            if (dictionary.count > 0) {
                NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                
                Product *object = [Util setProductData:[arrData objectAtIndex:0]];
                [self redirectToProductDetail:object];
            }
        } else {
            HIDE_PROGRESS;
            ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
        }
    }];
}

- (void)addItemToWishList:(NSString*)productID {
    SHOW_LOADER_ANIMTION();    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    [dict setValue:productID forKey:@"product_id"];
    
    [CiyaShopAPISecurity addItemtoWishList:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success) {
            HIDE_PROGRESS;
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"]) {
                NSString *message = [MCLocalization stringForKey:@"Item Added to your Wish List."];
                
                NSLog(@"Product Added to wishlist successfully!");
                [Util showPositiveMessage:message];
            } else {
                NSLog(@"Something Went Wrong while adding in Wishlist.");
                
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                [arr addObject:productID];
                
                [Util setArray:arr setData:kWishList];
                
                self->arrWishList = [[NSMutableArray alloc] init];
                [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            }
        } else {
            HIDE_PROGRESS;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            [arr addObject:productID];
            
            [Util setArray:arr setData:kWishList];
            
            self->arrWishList = [[NSMutableArray alloc] init];
            [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            
            if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, self);
            } else {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
            }
        }
        if([[dictionary valueForKey:@"sync_list"] isKindOfClass:[NSArray class]]) {
            //Is array
            NSMutableArray *arrData = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"sync_list"]];
            [appDelegate setWishList:arrData];
        } else if([dictionary isKindOfClass:[NSDictionary class]]) {
            //is dictionary
            NSMutableArray *arrData = [[NSMutableArray alloc] init];
            [appDelegate setWishList:arrData];
        }
        [self.colInfiniteData reloadData];
    }];
}

- (void)removeItemFromWishList:(NSString*)productID {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    [dict setValue:productID forKey:@"product_id"];
    [CiyaShopAPISecurity removeItemFromWishList:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success) {
            HIDE_PROGRESS;
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"]) {
                NSString *message = [MCLocalization stringForKey:@"Item Removed From your Wish List."];
                
                NSLog(@"Item Removed From wishlist successfully!");
                [Util showPositiveMessage:message];
            } else {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                [arr addObject:productID];
                
                [Util setArray:arr setData:kWishList];
                
                self->arrWishList = [[NSMutableArray alloc] init];
                [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                
                NSLog(@"Something Went Wrong while adding in Wishlist.");
            }
            
            if([[dictionary valueForKey:@"sync_list"] isKindOfClass:[NSArray class]]) {
                //Is array
                NSMutableArray *arrData = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"sync_list"]];
                [appDelegate setWishList:arrData];
            } else if([dictionary isKindOfClass:[NSDictionary class]]) {
                //is dictionary
                NSMutableArray *arrData = [[NSMutableArray alloc] init];
                [appDelegate setWishList:arrData];
            }
        } else {
            HIDE_PROGRESS;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            [arr addObject:productID];
            
            [Util setArray:arr setData:kWishList];
            
            self->arrWishList = [[NSMutableArray alloc] init];
            [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
        }
        [self.colInfiniteData reloadData];
    }];
}

//-(void)getpaymentDetail {
//    [CiyaShopAPISecurity getPaymentGatewayList:^(BOOL success, NSString *message, NSDictionary *dictionary) {
//        NSLog(@"%@", dictionary);
//    }];
//}

#pragma mark - Update UI Data

- (void)updateUI {
    [appDelegate setRTLView];
    
    [Util setPrimaryColorImageView:self.imgBg];
    //Update status bar color
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

    [refreshControl setTintColor:[Util colorWithHexString:[Util getStringData:kPrimaryColor]]];
    [refreshControlInfiniteScroll setTintColor:[Util colorWithHexString:[Util getStringData:kPrimaryColor]]];

    [Util setHeaderColorView:self.vwSearch];
    [Util setHeaderColorView:self.vwHeaderContent];
    
    appDelegate.baseTabBarController.tabBar.tintColor = [Util colorWithHexString:[Util getStringData:kPrimaryColor]];
    
    [appDelegate showBadge];
    [appDelegate.baseTabBarController setSelectedIndex:0];
    [self updateDots];
    
    if (appDelegate.isRTL) {
        [self.colHeader setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnNotification.frame = CGRectMake(SCREEN_SIZE.width - self.btnNotification.frame.size.width, 0, self.btnNotification.frame.size.width, self.btnNotification.frame.size.height);
        self.imgHeaderAppName.frame = CGRectMake((self.view.frame.size.width - self.imgHeaderAppName.frame.size.width) / 2, self.imgHeaderAppName.frame.origin.y, self.imgHeaderAppName.frame.size.width, self.imgHeaderAppName.frame.size.height);
    } else {
        [self.colHeader setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnNotification.frame = CGRectMake(0, 0, self.btnNotification.frame.size.width, self.btnNotification.frame.size.height);
        self.imgHeaderAppName.frame = CGRectMake((self.view.frame.size.width - self.imgHeaderAppName.frame.size.width) / 2, self.imgHeaderAppName.frame.origin.y, self.imgHeaderAppName.frame.size.width, self.imgHeaderAppName.frame.size.height);
    }
}

-(void)addFooterToTableView {
    [self.tblFooter reloadData];
    
    static NSString *simpleTableIdentifier = @"ReasonToBuyWithUsCell";
    
    ReasonToBuyWithUsCell *cell5 = (ReasonToBuyWithUsCell *)[self.tblFooter dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell5 == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ReasonToBuyWithUsCell" owner:self options:nil];
        cell5 = [nib objectAtIndex:0];
    }
    float size;
    if (appDelegate.arrReasonToBuyWithUs.count == 0) {
        size =  0.0;
    } else {
        if(appDelegate.arrReasonToBuyWithUs.count == 1) {
            if([[[appDelegate.arrReasonToBuyWithUs objectAtIndex:0] valueForKey:@"feature_content"] isEqualToString:@""] &&
               [[[appDelegate.arrReasonToBuyWithUs objectAtIndex:0] valueForKey:@"feature_image_id"] isEqualToString:@""] &&
               [[[appDelegate.arrReasonToBuyWithUs objectAtIndex:0] valueForKey:@"feature_title"] isEqualToString:@""]) {
                size =  0.0;
            } else {
                float count = 0.5 + (appDelegate.arrReasonToBuyWithUs.count/2.0);
                size =  cell5.colReasons.frame.origin.y + (((int)count*97)*SCREEN_SIZE.width/375) + (25*SCREEN_SIZE.width/375);
            }
        } else {
            float count = 0.5 + (appDelegate.arrReasonToBuyWithUs.count/2.0);
            size =  cell5.colReasons.frame.origin.y + (((int)count*97)*SCREEN_SIZE.width/375) + (25*SCREEN_SIZE.width/375);
        }
    }
    
    if([[appDelegate getRecentArray] count] > 0) {
        //recent item is there
        self.vwTableFooter.frame = CGRectMake(0, 0, SCREEN_SIZE.width, size + 313*SCREEN_SIZE.width/375);
    } else {
        //no recent item
        self.vwTableFooter.frame = CGRectMake(0, 0, SCREEN_SIZE.width, size);
    }
    self.tblShopDetail.tableFooterView = self.vwTableFooter;
}

#pragma  mark - Redirect To Most Popular Product Delegate

-(void)RedirectToMostPopularProduct:(Product *)dict {
    [self redirectToProductDetail:dict];
}

#pragma  mark - Deal of the Day Delegate

-(void)RedirectToDealOfTheDay:(Product *)dict {
    [self redirectToProductDetail:dict];
}

-(void)redirectToProductDetail:(Product*)product {
    [appDelegate setRecentProduct:product];
    if ([product.type1 isEqualToString:@"external"]) {
        NSString *strUrl = product.external_url;
        NSURL *_url = [Util EncodedURL:strUrl];
        [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
//        [[UIApplication sharedApplication] openURL:_url];
    } else if ([product.type1 isEqualToString:@"grouped"]) {
        //GroupItemDetailVC
        GroupItemDetailVC *vc = [[GroupItemDetailVC alloc] initWithNibName:@"GroupItemDetailVC" bundle:nil];
        vc.product = product;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([product.type1 isEqualToString:@"variable"]) {
        //VariableItemDetailVC
        VariableItemDetailVC *vc = [[VariableItemDetailVC alloc] initWithNibName:@"VariableItemDetailVC" bundle:nil];
        vc.product = product;
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        ItemDetailVC *vc = [[ItemDetailVC alloc] initWithNibName:@"ItemDetailVC" bundle:nil];
        vc.product = product;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Set Category Data Delegate

-(void)setCategoryData:(NSIndexPath *)indexPath {
    HomeShopDataVC *vc = [[HomeShopDataVC alloc]initWithNibName:@"HomeShopDataVC" bundle:nil];
    vc.CategoryID = [[[appDelegate.arrHomeCatagoryData objectAtIndex:indexPath.row] valueForKey:@"cat_banners_cat_id"] intValue];
    
    if (vc.CategoryID != (int)nil)
    {
        vc.fromCategory = YES;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Click On Recent Product Delegate

-(void)setClickOnRecentProducts:(Product *)product {
    [self redirectToProductDetail:product];
}


#pragma mark - hide Bottom Bar

-(BOOL)hidesBottomBarWhenPushed {
    return NO;
}

#pragma mark - StatusBar Delegate
/*!
 * @discussion This method is used to set Status bar text color
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)clearAllCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}

@end
