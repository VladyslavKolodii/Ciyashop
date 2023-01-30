//
//  VariableItemDetailVC.m
//  QuickClick
//
//  Created by Kaushal PC on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "VariableItemDetailVC.h"
#import "ItemDetailVC.h"
#import "ShopDataGridCell.h"
#import "Rate&ReviewCell.h"
#import "ColorAndSizeCell.h"
#import "ColorCell.h"
#import "DescriptionVC.h"
#import "MHFacebookImageViewer.h"
#import "UIImageView+MHFacebookImageViewer.h"

#import "ContactSellerVC.h"

#import "VariationCell.h"
#import "VariationItemCell.h"
#import "RateAndReviewVC.h"

#import "GroupItemDetailVC.h"
#import "VariableItemDetailVC.h"
#import "AllReviewsVC.h"

@import Firebase;
@import GoogleSignIn;

@interface VariableItemDetailVC () <UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MHFacebookImageViewerDatasource, UIScrollViewDelegate, UITableViewDataSource, ClickDelegate>

@property (weak, nonatomic) IBOutlet UIView *vwPincode;
@property (weak, nonatomic) IBOutlet UITextField *txtPincode;
@property (weak, nonatomic) IBOutlet UILabel *lblPincodeLine;
@property (weak, nonatomic) IBOutlet UILabel *lblPincodeAvailabilityText;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckPincode;

@property (strong, nonatomic) IBOutlet UIView *vwDiscountTag;

@property (strong, nonatomic) IBOutlet UICollectionView *colColor;      //Tag = 1

@property (strong, nonatomic) IBOutlet UIView *vwColorSizePopup;
@property (strong, nonatomic) IBOutlet UIView *vwPopupBG;

@property (strong, nonatomic) IBOutlet UITableView *tblRateReview;
@property (strong, nonatomic) IBOutlet UITableView *tblVariationData;
@property (strong, nonatomic) IBOutlet UITableView *tblVariationDataInView;

@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwColorSize;
@property (strong, nonatomic) IBOutlet UIView *vwSelectColor;
@property (strong, nonatomic) IBOutlet UIView *vwRatingCircle;
@property (strong, nonatomic) IBOutlet UIView *vwName;
@property (strong, nonatomic) IBOutlet UIView *vwQuickOverview;
@property (strong, nonatomic) IBOutlet UIView *vwDetail;
@property (strong, nonatomic) IBOutlet UIView *vwRateWriteReview;
@property (strong, nonatomic) IBOutlet UIView *vwLast;
@property (strong, nonatomic) IBOutlet UIView *vwAddToCart;
@property (strong, nonatomic) IBOutlet UIView *vwPopupBottom;
@property (strong, nonatomic) IBOutlet UIView *vwAddToCartContent;
@property (strong, nonatomic) IBOutlet UIView *vwBuyNowContent;
@property (strong, nonatomic) IBOutlet UIView *vwOptions;

@property (strong, nonatomic) IBOutlet UIScrollView *scrl;

@property (strong, nonatomic) IBOutlet UISlider *sliderFive;
@property (strong, nonatomic) IBOutlet UISlider *sliderFour;
@property (strong, nonatomic) IBOutlet UISlider *sliderThree;
@property (strong, nonatomic) IBOutlet UISlider *sliderTwo;
@property (strong, nonatomic) IBOutlet UISlider *sliderOne;

@property (strong, nonatomic) IBOutlet UIImageView *imgWishList;

@property (nonatomic, assign) BOOL wrap;

@property (weak, nonatomic) IBOutlet UIPageControl *pageController;

@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UIButton *btnWishList;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnNotification;

@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberofColor;
@property (weak, nonatomic) IBOutlet UILabel *lblRating;
@property (weak, nonatomic) IBOutlet UILabel *lblAvailability;
@property (weak, nonatomic) IBOutlet UILabel *lblInStock;
@property (weak, nonatomic) IBOutlet UILabel *lblQuickOverview;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblProductHighlight;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscountRate;
@property (weak, nonatomic) IBOutlet UILabel *lblRateCircle;
@property (weak, nonatomic) IBOutlet UILabel *lblOptionLine;

@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (weak, nonatomic) IBOutlet UIButton *btnMoreQuickOverview;
@property (weak, nonatomic) IBOutlet UIButton *btnRateAndReview;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToCart;
@property (weak, nonatomic) IBOutlet UIButton *btnBuyNow;
@property (weak, nonatomic) IBOutlet UIButton *btnNumberOfColor;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property (weak, nonatomic) IBOutlet UITextView *txtQuickOverview;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property int CellNumber;
@property NSMutableArray *arrData;

@property (weak, nonatomic) IBOutlet UIView *vwQuickViewData;
@property (weak, nonatomic) IBOutlet UIView *vwDetailViewData;
@property (weak, nonatomic) IBOutlet UIView *vwBorder;

@property (weak, nonatomic) IBOutlet UIView *vwAllData;

@property (weak, nonatomic) IBOutlet UIView *vwShareRate;
@property (weak, nonatomic) IBOutlet UILabel *lblDeviderShareRate;

@property (weak, nonatomic) IBOutlet UILabel *lblOne;
@property (weak, nonatomic) IBOutlet UILabel *lblTwo;
@property (weak, nonatomic) IBOutlet UILabel *lblThree;
@property (weak, nonatomic) IBOutlet UILabel *lblFour;
@property (weak, nonatomic) IBOutlet UILabel *lblFive;

@property (weak, nonatomic) IBOutlet UIView *vwSellerInfo;
@property (weak, nonatomic) IBOutlet UIView *vwSellerDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblSellerTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblSoldBy;
@property (weak, nonatomic) IBOutlet UIButton *btnSellerMoreDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnSellerDescMore;
@property (weak, nonatomic) IBOutlet UIButton *btnContactSeller;
@property (weak, nonatomic) IBOutlet UIButton *btnViewStore;
@property (strong, nonatomic) IBOutlet UIImageView *imgHeaderImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgRatingCircle;


@property (weak, nonatomic) IBOutlet UIView *vwPoints;
@property (weak, nonatomic) IBOutlet UILabel *lblPoints;

@property (weak, nonatomic) IBOutlet UIWebView *wvQuickOverview;
@property (weak, nonatomic) IBOutlet UIWebView *wvDetail;
@property (weak, nonatomic) IBOutlet UIWebView *wvSellerDetails;

@property (weak, nonatomic) IBOutlet WKWebView *wkWebQuickOverview;
@property (weak, nonatomic) IBOutlet WKWebView *wkWebDetail;
@property (weak, nonatomic) IBOutlet WKWebView *wkWebSellerDetails;



@property (weak, nonatomic) IBOutlet UIView *vwCheckMoreReviews;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckMoreReviews;

@property (weak, nonatomic) IBOutlet UIView *vwRelatedProducts;
@property (weak, nonatomic) IBOutlet UILabel *lblRelatedProducts;

@property (weak, nonatomic) IBOutlet UIView *vwRelatedTitle;
@property (weak, nonatomic) IBOutlet UICollectionView *colRelatedProducts;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actRelatedProduct;

@property (strong, nonatomic) IBOutlet UIView *vwInfo;
@property (strong, nonatomic) IBOutlet UIView *vwAttributes;
@property (weak, nonatomic) IBOutlet UILabel *lblInfo;
@property (weak, nonatomic) IBOutlet UILabel *lblAttributes;

@property (weak, nonatomic) IBOutlet UIWebView *wvAttributes;
@property (weak, nonatomic) IBOutlet WKWebView *wkWebAttributes;


@property (weak, nonatomic) IBOutlet UIView *vwProductImage;

@end

@implementation VariableItemDetailVC
{
    int productId;
    NSMutableArray *arrColor, *arrImages, *arrSize, *arrComments, *arrColorImage, *arrProductPrice, *arrPreviousSelection, *arrPreviousImages, *arrRelatedProducts, *arrSelectedVariationOption;
    UIColor *color1;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
    int set, page;
    int oneStar, twoStar, threeStar, fourStar, fiveStar;
    HCSStarRatingView *starRatingView;
    UIView *vw;
    BOOL loadedRelatedProducts;
    CGRect rectPopUpFrame;
    NSString *strSellerDetails;
}
@synthesize wrap, product, arrVariations;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrlImages.delegate = self;
    self.scrl.delegate = self;
    
    self.scrl.tag = 1001;
    self.scrlImages.tag = 1002;
    
    self.colRelatedProducts.showsHorizontalScrollIndicator=NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.colRelatedProducts setCollectionViewLayout:flowLayout];
    
    [self.colRelatedProducts registerNib:[UINib nibWithNibName:@"ShopDataGridCell" bundle:nil] forCellWithReuseIdentifier:@"ShopDataGridCell"];
    
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < product.arrAttributes.count; i++) {
        NSNumber* flag = [[product.arrAttributes objectAtIndex:i] valueForKey:@"variation"];
        if ([flag boolValue]) {
            [arrTemp addObject:[product.arrAttributes objectAtIndex:i]];
        }
    }
    self.product.arrAttributes = arrTemp;
    
    if([Util getStringData:kAppNameWhiteImage] !=nil) {
        
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
    appDelegate.arrVariations = [[NSMutableArray alloc] init];
    appDelegate.arrSelectedVariable = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [product.arrAttributes count]; i++)
    {
        if ([[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] count] > 0)
        {
            [appDelegate.arrSelectedVariable addObject:[[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] objectAtIndex:0]];
        }
    }
    [self setSlider];
    [self setCollectionViewLayout];
    
    productId = product.product_id;
    
    NSArray *arr = [[NSArray alloc] initWithArray:[[Util getArrayData:kWishList] mutableCopy]];
    BOOL get = NO;
    for (int i = 0; i < arr.count; i++)
    {
        if (product.product_id == [[arr objectAtIndex:i] integerValue])
        {
            get = YES;
            break;
        }
    }
    if (get)
    {
        [self.imgWishList setImage:[UIImage imageNamed:@"IconInWishList"]];
        [Util setPrimaryColorImageView:self.imgWishList];
    }
    else
    {
        [self.imgWishList setImage:[UIImage imageNamed:@"IconWishList"]];
    }
    self.vwPopupBG.hidden = YES;
    self.vwColorSizePopup.hidden = YES;
    if ([product.arrAttributes count] > 0)
    {
        self.lblNumberofColor.text = [NSString stringWithFormat:@"%d %@", (int)[[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] count], [[[product.arrAttributes objectAtIndex:0] valueForKey:@"name"] capitalizedString]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
    set = 0;
    [self getAllReviews];
    [Util setSecondaryColorButton:self.btnBuyNow];
    [Util setPrimaryColorImageView:self.imgRatingCircle];
    [self updateDots];
    
    // check catalog mode
    if (appDelegate.isCatalogMode){
        self.btnAddToCart.hidden = true;
        self.btnBuyNow.hidden = true;
        self.vwAddToCart.hidden = true;
    } else {
        self.btnAddToCart.hidden = false;
        self.btnBuyNow.hidden = false;
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setScrollingImages];
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self localize];
    
    [self getSelectedVariation];
    
    [Util setHeaderColorView:vw];
    
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

    //shadow to add to cart view
    
    
    self.vwAddToCart.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.vwAddToCart.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.vwAddToCart.layer.shadowRadius = 1.0f;
    self.vwAddToCart.layer.shadowOpacity = 0.5f;
    self.vwAddToCart.layer.masksToBounds = NO;
    self.vwAddToCart.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.vwAddToCart.bounds cornerRadius:self.vwAddToCart.layer.cornerRadius].CGPath;
    
    [self setDefaultData];
    [self checkVariationAvailability];
    
    NSMutableArray *arrMyCart = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
    
    BOOL flag = NO;
    for (int i = 0; i < arrMyCart.count; i++)
    {
        AddToCartData *object;
        if([[arrMyCart objectAtIndex:i] isKindOfClass:[NSData class]])
        {
            object = [Util loadCustomObjectWithKey:[arrMyCart objectAtIndex:i]];
        }
        else
        {
            object = [arrMyCart objectAtIndex:i];
        }
        
        if (product.product_id == object.productId)
        {
            flag = YES;
        }
    }
    if (flag)
    {
        [self.btnAddToCart setTitle:[MCLocalization stringForKey:@"GO TO CART"] forState:UIControlStateNormal];
    }
    if (appDelegate.isWishList)
    {
        self.btnWishList.hidden = NO;
        self.imgWishList.hidden = NO;
    }
    else
    {
        self.btnWishList.hidden = YES;
        self.imgWishList.hidden = YES;
    }
    appDelegate.fromItemDetail = true;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:true];
    appDelegate.fromItemDetail = false;
}

-(void)viewWillLayoutSubviews
{
    
    
    // check catalog mode if statics   
    
    if (set == 0) {
        set = 1;
        [Util setTriangleLable:self.vwDiscountTag product:product];
    }
    [self.tblVariationData reloadData];
    [self.tblVariationDataInView reloadData];
    
    self.vwLast.frame = CGRectMake(self.vwLast.frame.origin.x, self.vwLast.frame.origin.y, self.vwLast.frame.size.width, self.tblRateReview.contentSize.height);
    
    self.scrl.contentSize = CGSizeMake(self.scrl.frame.size.width, self.vwLast.frame.origin.y + self.vwLast.frame.size.height + (15*SCREEN_SIZE.width/375));
    
    [self setBorderForReview];
    
    [self.lblDiscountRate sizeToFit];
    [self.lblAvailability sizeToFit];
    self.vwPopupBottom.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.vwPopupBottom.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.vwPopupBottom.layer.shadowRadius = 1.0f;
    self.vwPopupBottom.layer.shadowOpacity = 0.5f;
    self.vwPopupBottom.layer.masksToBounds = NO;
    self.vwPopupBottom.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.vwPopupBottom.bounds cornerRadius:self.vwPopupBottom.layer.cornerRadius].CGPath;
    
    float height = self.vwRatingCircle.frame.size.height;
    float width = 80 * SCREEN_SIZE.width /375 ;
    if(height > width)
    {
        height = width ;
    }
    self.vwRatingCircle.frame = CGRectMake(self.vwRatingCircle.frame.origin.x, self.vwRatingCircle.frame.origin.y, height, height );
    
    starRatingView.frame=CGRectMake((75*SCREEN_SIZE.width/375)/2 - (65*SCREEN_SIZE.width/375)/2, self.lblRateCircle.frame.origin.y + self.lblRateCircle.frame.size.height+2, 65*SCREEN_SIZE.width/375,appDelegate.FontSizeProductName);
    
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
    [self localize];
    
    [self.scrl bringSubviewToFront:self.vwRateWriteReview];
    [self.vwRateWriteReview bringSubviewToFront:self.btnRateAndReview];
    //    [self setDefaultData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setBorderForReview
{
    self.vwAttributes.layer.shadowColor = [UIColor blackColor].CGColor;
    self.vwAttributes.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.vwAttributes.layer.shadowRadius = 1.0f;
    self.vwAttributes.layer.shadowOpacity = 0.20f;
    self.vwAttributes.layer.masksToBounds = NO;
    self.vwAttributes.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.vwAttributes.bounds cornerRadius:self.vwAttributes.layer.cornerRadius].CGPath;
    
    self.vwQuickViewData.layer.shadowColor = [UIColor blackColor].CGColor;
    self.vwQuickViewData.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.vwQuickViewData.layer.shadowRadius = 1.0f;
    self.vwQuickViewData.layer.shadowOpacity = 0.20f;
    self.vwQuickViewData.layer.masksToBounds = NO;
    self.vwQuickViewData.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.vwQuickViewData.bounds cornerRadius:self.vwQuickViewData.layer.cornerRadius].CGPath;
    
    self.vwBorder.layer.shadowColor = [UIColor blackColor].CGColor;
    self.vwBorder.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.vwBorder.layer.shadowRadius = 1.0f;
    self.vwBorder.layer.shadowOpacity = 0.20f;
    self.vwBorder.layer.masksToBounds = NO;
    self.vwBorder.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.vwBorder.bounds cornerRadius:self.vwBorder.layer.cornerRadius].CGPath;
}

#pragma mark - Set scrolling images

-(void)setScrollingImages
{
    NSArray *viewsToRemove = [self.scrlImages subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    BOOL isVideo = false;
    NSMutableArray *arrImageCopy = [[NSMutableArray alloc] initWithArray:arrImages];
    if (appDelegate.isYithVideoEnabled && [product.dict_featured_video objectForKey:@"image_url"])
    {
        isVideo = true;
        [arrImageCopy insertObject:[product.dict_featured_video objectForKey:@"image_url"] atIndex:0];
    }
    
    CGFloat xPos = 0.0;
    for (int i = 0; i < arrImageCopy.count; i++)
    {
        @autoreleasepool
        {
            UIImageView * imageview = [[UIImageView alloc]init];
            
            imageview.frame = CGRectMake(xPos, 0, SCREEN_SIZE.width, self.scrlImages.frame.size.height);
            [self.scrlImages addSubview:imageview];
            
            UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(imageview.frame.origin.x + (imageview.frame.size.width/2) - 10, (imageview.frame.size.height/2) - 10, 20, 20)];
            act.hidesWhenStopped = YES;
            [act setColor:[Util colorWithHexString:[Util getStringData:kPrimaryColor]]];
            [self.scrlImages addSubview:act];
            
            if (i == 0 && appDelegate.isYithVideoEnabled && isVideo)
            {
                //show video button
                UIButton *btnVideo = [[UIButton alloc] initWithFrame:CGRectMake(xPos + (SCREEN_SIZE.width/2) - 30, (self.scrlImages.frame.size.height/2) - 30, 60, 60)];
                
                btnVideo.backgroundColor = UIColor.whiteColor;
                [btnVideo setImage:[UIImage imageNamed:@"VideoPlay"] forState:UIControlStateNormal];
                [btnVideo addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
                
                btnVideo.layer.cornerRadius = 30;
                btnVideo.layer.masksToBounds = true;
                btnVideo.layer.shadowRadius  = 1.5f;
                btnVideo.layer.shadowColor = [UIColor blackColor].CGColor;
                btnVideo.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
                btnVideo.layer.shadowOpacity = 0.9f;
                btnVideo.layer.masksToBounds = NO;
                
                [self.scrlImages addSubview:btnVideo];
            }
            
            [act startAnimating];
            [imageview sd_setImageWithURL:[Util EncodedURL:[arrImageCopy objectAtIndex:i]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [act stopAnimating];
                imageview.image=image;
            }];
            
            xPos += SCREEN_SIZE.width;
            
            //            imageview.contentMode = UIViewContentModeScaleAspectFill;
            imageview.contentMode = UIViewContentModeScaleAspectFit;
            imageview.clipsToBounds=YES;
            
            if (isVideo && i == 0)
            {
                
            }
            else
            {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^()
                               {
                                   dispatch_async(dispatch_get_main_queue(), ^()
                                                  {
                                                      [imageview setupImageViewerWithDatasource:self initialIndex:i onOpen:^{
                                                          NSLog(@"OPEN!");
                                                      } onClose:^{
                                                          NSLog(@"CLOSE!");
                                                          
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
                                                      }];
                                                  });
                               });
            }
        }
    }
    [self.scrlImages setUserInteractionEnabled:YES];
    
    self.scrlImages.contentSize = CGSizeMake(xPos, self.scrlImages.frame.size.height);
    self.pageController.numberOfPages = arrImageCopy.count;
    self.pageController.currentPage = 0;
}

- (void)setScrollView:(UIScrollView*)scrl
{
    [self.scrlImages scrollRectToVisible:CGRectMake(scrl.contentOffset.x, 0, 1, 1) animated:NO];
}

#pragma mark - image viewer Delegate methods

- (NSInteger) numberImagesForImageViewer:(MHFacebookImageViewer *)imageViewer
{
    //    if ([product.dict_featured_video objectForKey:@"url"]) {
    //        return arrImages.count + 1;
    //    }
    return arrImages.count;
}

-  (NSURL*) imageURLAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer
{
    //    NSMutableArray *arrImageCopy = [[NSMutableArray alloc] initWithArray:arrImages];
    //    if (appDelegate.isYithVideoEnabled && [product.dict_featured_video objectForKey:@"image_url"]) {
    //        [arrImageCopy insertObject:[product.dict_featured_video objectForKey:@"image_url"] atIndex:0];
    //        appDelegate.isFirstVideo = true;
    //    }
    return [Util EncodedURL:[arrImages objectAtIndex:index]];
}

- (UIImage*) imageDefaultAtIndex:(NSInteger)index imageViewer:(MHFacebookImageViewer *)imageViewer
{
    return nil;
}

#pragma mark - set default data from Dict w/o Variations

-(void)setDefaultData
{
    NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";

    if (appDelegate.isRTL) {
        self.vwDiscountTag.frame = CGRectMake(self.view.frame.size.width - self.vwDiscountTag.frame.size.width, 0, self.vwDiscountTag.frame.size.width, self.vwDiscountTag.frame.size.height);
    } else {
        self.vwDiscountTag.frame = CGRectMake(0, 0, self.vwDiscountTag.frame.size.width, self.vwDiscountTag.frame.size.height);
    }
    
    arrImages = [[NSMutableArray alloc]init];
    
    for(int i = 0; i < [product.arrImages count]; i++)
    {
        [arrImages addObject:[[product.arrImages objectAtIndex:i] valueForKey:@"src"]];
    }
    
    if (product.in_stock == 1)
    {
        self.lblInStock.text = [MCLocalization stringForKey:@"In Stock"];
        [Util setPrimaryColorLabelText:self.lblInStock];
    }
    else
    {
        self.lblInStock.text = [MCLocalization stringForKey:@"Out of Stock"];
        self.lblInStock.textColor = [UIColor redColor];
        
        self.btnAddToCart.enabled = NO;
        self.btnBuyNow.enabled = NO;
        
        self.btnAddToCart.alpha = 0.3;
        self.btnBuyNow.alpha = 0.3;
    }
    self.lblName.text = product.name;
    [self.lblInStock sizeToFit];
    
    NSString *strRating = [NSString stringWithFormat:@"%.1f", product.average_rating];
    if (strRating == nil || [strRating isEqualToString:@""])
    {
        self.lblRating.text = @"0";
        self.lblRateCircle.text = @"0/5";
    }
    else
    {
        self.lblRating.text = [NSString stringWithFormat:@"%.1f", product.average_rating];
        self.lblRateCircle.text = [NSString stringWithFormat:@"%@/5", strRating];
    }
    
    BOOL flg = false;
    for (UIView *subview in self.vwRatingCircle.subviews)
    {
        if (subview.tag>=1000)
        {
            flg=YES;
        }
    }
    if (!flg)
    {
        starRatingView = [Util setStarRating:product.average_rating frame:CGRectMake((80*SCREEN_SIZE.width/375)/2 - 30, self.lblRateCircle.frame.origin.y + self.lblRateCircle.frame.size.height + 5, 60, appDelegate.FontSizeProductName) tag:1000];
        [self.vwRatingCircle addSubview:starRatingView];
    }
    
    self.wkWebQuickOverview.userInteractionEnabled = NO;
    self.wkWebDetail.userInteractionEnabled = NO;
    
    NSString *strHtml = [product.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (appDelegate.isRTL) {
        strHtml = [NSString stringWithFormat:@"<body dir=\"rtl\" >%@</body>", [product.desc stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }
    [self.wkWebDetail loadHTMLString:[headerString stringByAppendingString:strHtml] baseURL:nil];

//    [self.wvDetail loadHTMLString:strHtml baseURL:nil];
    
//    [self.wvDetail stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 1.2;"];
    
    NSString *strHtml1 = [product.short_description stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    if (appDelegate.isRTL) {
        strHtml1 = [NSString stringWithFormat:@"<body dir=\"rtl\" >%@</body>", [product.short_description stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
    }
    [self.wkWebQuickOverview loadHTMLString:[headerString stringByAppendingString:strHtml1] baseURL:nil];

//    [self.wvQuickOverview loadHTMLString:strHtml1 baseURL:nil];
    
//    [self.wvQuickOverview loadHTMLString:[product.short_description stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
    
//    [self.wvQuickOverview stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 1.2;"];
    
    //            NSString * htmlString1 = product.short_description;
    //            NSMutableAttributedString * attrStr1 = [[NSMutableAttributedString alloc] initWithData:[htmlString1 dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //
    //            [attrStr1 addAttribute:NSFontAttributeName value:Font_Size_Product_Name_Not_Bold range:NSMakeRange(0, attrStr1.length)];
    //            [attrStr1 addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0,attrStr1.length)];
    //
    //            self.txtQuickOverview.attributedText = attrStr1;
    //
    //
    //            NSString * htmlString2 = product.desc;
    //            NSMutableAttributedString * attrStr2 = [[NSMutableAttributedString alloc] initWithData:[htmlString2 dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    //
    //            [attrStr2 addAttribute:NSFontAttributeName value:Font_Size_Product_Name_Not_Bold range:NSMakeRange(0, attrStr2.length)];
    //            [attrStr2 addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0,attrStr2.length)];
    //
    //            self.txtDescription.attributedText = attrStr2;
    
    NSString * htmlString3 = product.rewards_message;
    NSMutableAttributedString * attrStr3 = [[NSMutableAttributedString alloc] initWithData:[htmlString3 dataUsingEncoding:NSUnicodeStringEncoding allowLossyConversion:YES] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr3 addAttribute:NSFontAttributeName value:Font_Size_Product_Name_Not_Bold range:NSMakeRange(0, attrStr3.length)];
    [attrStr3 addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0,attrStr3.length)];
    self.lblPoints.attributedText=attrStr3;
    
    NSString * htmlString = product.price_html;
    [self setPriceLabel:htmlString];
    
    if ([product.arrAttributes count] == 0)
    {
        self.colColor.hidden = YES;
        self.vwColorSize.hidden = YES;
        self.vwSelectColor.frame = CGRectMake(0, self.vwSelectColor.frame.origin.y, self.vwSelectColor.frame.size.width,0);
    }
    else
    {
        self.vwSelectColor.frame = CGRectMake(0, self.vwSelectColor.frame.origin.y, self.vwSelectColor.frame.size.width,self.vwSelectColor.frame.size.height);
    }
    
    if (appDelegate.isRTL)
    {
        //RTL
        
        self.btnCheckPincode.frame = CGRectMake(8,self.btnCheckPincode.frame.origin.y,self.btnCheckPincode.frame.size.width, self.btnCheckPincode.frame.size.height);

        self.txtPincode.frame = CGRectMake(self.btnCheckPincode.frame.size.width+16,self.txtPincode.frame.origin.y,self.txtPincode.frame.size.width, self.txtPincode.frame.size.height);
        
        self.lblPincodeLine.frame = CGRectMake(self.txtPincode.frame.origin.x,self.lblPincodeLine.frame.origin.y,self.txtPincode.frame.size.width, self.lblPincodeLine.frame.size.height);
        
        self.txtPincode.textAlignment = NSTextAlignmentRight;

        self.vwShareRate.frame = CGRectMake(0, self.vwShareRate.frame.origin.y, 69*SCREEN_SIZE.width/375, 57*SCREEN_SIZE.width/375);
        
        self.lblDeviderShareRate.frame = CGRectMake(self.vwShareRate.frame.size.width - self.lblDeviderShareRate.frame.size.width, self.lblDeviderShareRate.frame.origin.y, self.lblDeviderShareRate.frame.size.width, self.lblDeviderShareRate.frame.size.height);
        
        self.lblName.frame = CGRectMake(self.view.frame.size.width - self.lblName.frame.size.width - 8, self.lblName.frame.origin.y, 294*SCREEN_SIZE.width/375, self.lblName.frame.size.height);
        [self.lblName sizeToFit];
        
        self.lblDiscountRate.frame = CGRectMake(self.view.frame.size.width - self.lblDiscountRate.frame.size.width - 8, self.lblName.frame.origin.y + self.lblName.frame.size.height + 5, self.lblDiscountRate.frame.size.width, self.lblDiscountRate.frame.size.height);
        
        self.lblAvailability.frame = CGRectMake(self.view.frame.size.width - self.lblAvailability.frame.size.width - 8, self.lblDiscountRate.frame.origin.y + self.lblDiscountRate.frame.size.height + 5, self.lblAvailability.frame.size.width, self.lblAvailability.frame.size.height);
        
        self.lblInStock.frame = CGRectMake(self.lblAvailability.frame.origin.x - self.lblInStock.frame.size.width - 8,self.lblAvailability.frame.origin.y, self.lblInStock.frame.size.width, self.lblAvailability.frame.size.height);
    }
    else
    {
        
        self.txtPincode.frame = CGRectMake(8,self.txtPincode.frame.origin.y,self.txtPincode.frame.size.width, self.txtPincode.frame.size.height);

        self.btnCheckPincode.frame = CGRectMake(self.txtPincode.frame.size.width+16,self.btnCheckPincode.frame.origin.y,self.btnCheckPincode.frame.size.width, self.btnCheckPincode.frame.size.height);
        self.lblPincodeLine.frame = CGRectMake(self.txtPincode.frame.origin.x,self.lblPincodeLine.frame.origin.y,self.txtPincode.frame.size.width, self.lblPincodeLine.frame.size.height);
        self.txtPincode.textAlignment = NSTextAlignmentLeft;

        
        
        self.vwShareRate.frame = CGRectMake(self.view.frame.size.width - 69*SCREEN_SIZE.width/375, self.vwShareRate.frame.origin.y, 69*SCREEN_SIZE.width/375, 57*SCREEN_SIZE.width/375);
        self.lblName.frame = CGRectMake(8, 10, 294*SCREEN_SIZE.width/375, self.lblName.frame.size.height);
        [self.lblName sizeToFit];
        
        self.lblDiscountRate.frame = CGRectMake(8, self.lblName.frame.origin.y + self.lblName.frame.size.height + 5, self.lblDiscountRate.frame.size.width, self.lblDiscountRate.frame.size.height);
        
        self.lblAvailability.frame = CGRectMake(8, self.lblDiscountRate.frame.origin.y + self.lblDiscountRate.frame.size.height + 5, self.lblAvailability.frame.size.width, self.lblDiscountRate.frame.size.height);
        
        self.lblInStock.frame = CGRectMake(self.lblAvailability.frame.origin.x + self.lblAvailability.frame.size.width + 8,self.lblAvailability.frame.origin.y, self.lblInStock.frame.size.width, self.lblAvailability.frame.size.height);
    }
    
    if(self.lblAvailability.frame.origin.y + self.lblAvailability.frame.size.height < self.vwShareRate.frame.size.height+self.vwShareRate.frame.origin.y){
        self.vwName.frame = CGRectMake(0, self.vwSelectColor.frame.origin.y+self.vwSelectColor.frame.size.height, SCREEN_SIZE.width, self.vwShareRate.frame.origin.y + self.vwShareRate.frame.size.height + 10);
    }
    else{
        self.vwName.frame = CGRectMake(0, self.vwSelectColor.frame.origin.y+self.vwSelectColor.frame.size.height, SCREEN_SIZE.width, self.lblAvailability.frame.origin.y + self.lblAvailability.frame.size.height + 10);
    }
    
    if (appDelegate.isPincodeCheckActive) {
        //pincode check is active
        self.vwPincode.hidden = false;
        self.vwPincode.frame = CGRectMake(self.vwPincode.frame.origin.x, self.vwName.frame.origin.y + self.vwName.frame.size.height+ (15*SCREEN_SIZE.width/375), self.vwPincode.frame.size.width, self.vwPincode.frame.size.height);
    } else {
        //pincode check not active
        self.vwPincode.hidden = true;
        self.vwPincode.frame = CGRectMake(self.vwPincode.frame.origin.x, self.vwName.frame.origin.y + self.vwName.frame.size.height, self.vwPincode.frame.size.width, 0);
    }

    if (product.additional_Info != nil && ![product.additional_Info isEqualToString:@""])
    {
        self.vwInfo.frame = CGRectMake(0, self.vwPincode.frame.origin.y + self.vwPincode.frame.size.height + (15*SCREEN_SIZE.width/375), SCREEN_SIZE.width, self.vwInfo.frame.size.height);

        self.vwAttributes.frame = CGRectMake(8, self.vwInfo.frame.origin.y + self.vwInfo.frame.size.height - (15*SCREEN_SIZE.width/375), self.vwInfo.frame.size.width - 16, self.lblAttributes.frame.size.height + 16);
        
        self.wkWebAttributes.userInteractionEnabled = NO;
        
        NSString *strHtml1 = [product.additional_Info stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        if (appDelegate.isRTL) {
            strHtml1 = [NSString stringWithFormat:@"<body dir=\"rtl\" >%@</body>", [product.additional_Info stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
        }
        
        NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
        [self.wkWebAttributes loadHTMLString:[headerString stringByAppendingString:strHtml1] baseURL:nil];

//        [self.wvAttributes loadHTMLString:strHtml1 baseURL:nil];
        
        //        [self.wvAttributes loadHTMLString:[product.additional_Info stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
        
        self.vwInfo.hidden = false;
        self.vwAttributes.hidden = false;
        [self setFrames];
    }
    else
    {
        self.vwInfo.frame = CGRectMake(0, self.vwPincode.frame.origin.y + self.vwPincode.frame.size.height, SCREEN_SIZE.width, 0);
        self.vwAttributes.frame = CGRectMake(8, self.vwPincode.frame.origin.y + self.vwPincode.frame.size.height, self.vwInfo.frame.size.width - 16, 0);
        self.vwInfo.hidden = true;
        self.vwAttributes.hidden = true;
        [self setFrames];
    }
}

-(void)setFrames {
        if (appDelegate.isCatalogMode) {
            self.btnAddToCart.hidden = true;
            self.btnBuyNow.hidden = true;
            self.vwAddToCart.hidden = true;
            
            self.scrl.frame = CGRectMake(0, self.vwHeader.frame.origin.y + self.vwHeader.frame.size.height, self.scrl.frame.size.width, self.vwAllData.frame.size.height - self.vwHeader.frame.size.height);

            self.vwProductImage.frame = CGRectMake(0, self.vwProductImage.frame.origin.y, self.scrlImages.frame.size.width, self.vwProductImage.frame.size.width + self.vwProductImage.frame.size.width/3);
            
            //            self.scrlImages.frame = CGRectMake(0, self.scrlImages.frame.origin.y, self.scrlImages.frame.size.width, self.scrlImages.frame.size.width + self.scrlImages.frame.size.width/3);
            
        } else {
            self.btnAddToCart.hidden = false;
            self.btnBuyNow.hidden = false;
            self.vwAddToCart.hidden = false;
            
            self.scrl.frame = CGRectMake(0, self.vwHeader.frame.origin.y + self.vwHeader.frame.size.height, self.scrl.frame.size.width, self.vwAllData.frame.size.height - self.vwAddToCart.frame.size.height - self.vwHeader.frame.size.height);
            
            self.vwProductImage.frame = CGRectMake(0, self.vwProductImage.frame.origin.y, self.scrlImages.frame.size.width, self.vwProductImage.frame.size.width + self.vwProductImage.frame.size.width/3);
        }

    if (appDelegate.isVariationInView)
    {
        //set variation View
        self.vwSelectColor.frame = CGRectMake(0, self.vwProductImage.frame.origin.y + self.vwProductImage.frame.size.height, self.vwSelectColor.frame.size.width, 0);
        self.vwName.frame = CGRectMake(0, self.vwSelectColor.frame.origin.y + self.vwSelectColor.frame.size.height, self.vwName.frame.size.width, self.vwName.frame.size.height);
        self.tblVariationDataInView.frame = CGRectMake(0, self.vwName.frame.origin.y + self.vwName.frame.size.height + (15*SCREEN_SIZE.width/375), SCREEN_SIZE.width, self.tblVariationDataInView.contentSize.height);
    }
    else
    {
        //no variation on page
        self.vwSelectColor.frame = CGRectMake(0,  self.vwProductImage.frame.origin.y + self.vwProductImage.frame.size.height, self.vwSelectColor.frame.size.width, 62*SCREEN_SIZE.width/375);
        self.vwName.frame = CGRectMake(0, self.vwSelectColor.frame.origin.y + self.vwSelectColor.frame.size.height, self.vwName.frame.size.width, self.vwName.frame.size.height);
        self.tblVariationDataInView.frame = CGRectMake(0, self.vwName.frame.origin.y + self.vwName.frame.size.height, SCREEN_SIZE.width, 0);
    }
    
    if (appDelegate.isPincodeCheckActive) {
        //pincode check is active
        self.vwPincode.hidden = false;
        self.vwPincode.frame = CGRectMake(self.vwPincode.frame.origin.x, self.vwName.frame.origin.y + self.vwName.frame.size.height+ (15*SCREEN_SIZE.width/375), self.vwPincode.frame.size.width, self.vwPincode.frame.size.height);
    } else {
        //pincode check not active
        self.vwPincode.hidden = true;
        self.vwPincode.frame = CGRectMake(self.vwPincode.frame.origin.x, self.vwName.frame.origin.y + self.vwName.frame.size.height, self.vwPincode.frame.size.width, 0);
    }
    if (appDelegate.isVariationInView) {
        //set variation View
        self.tblVariationDataInView.frame = CGRectMake(0, self.vwPincode.frame.origin.y + self.vwPincode.frame.size.height + (15*SCREEN_SIZE.width/375), SCREEN_SIZE.width, self.tblVariationDataInView.contentSize.height);
    } else {
        //no variation on page
        self.tblVariationDataInView.frame = CGRectMake(0, self.vwPincode.frame.origin.y + self.vwPincode.frame.size.height, SCREEN_SIZE.width, 0);
    }

    if (product.additional_Info != nil && ![product.additional_Info isEqualToString:@""])
    {
        self.vwInfo.frame = CGRectMake(0, self.tblVariationDataInView.frame.origin.y + self.tblVariationDataInView.frame.size.height + (15*SCREEN_SIZE.width/375), SCREEN_SIZE.width, 60*SCREEN_SIZE.width/375);
        
        self.vwAttributes.frame = CGRectMake(8, self.vwInfo.frame.origin.y + self.vwInfo.frame.size.height - (15*SCREEN_SIZE.width/375), self.vwInfo.frame.size.width - 16, self.lblAttributes.frame.size.height + 16);
        
        self.wkWebAttributes.frame = CGRectMake(8, 8, self.vwAttributes.frame.size.width - 16, self.wkWebAttributes.frame.size.height);
        
        CGRect frame = self.wkWebAttributes.frame;
        frame.size.height = 1;
        self.wkWebAttributes.frame = frame;
        CGSize fittingSize = [self.wkWebAttributes sizeThatFits:CGSizeZero];
        frame.size = fittingSize;
        self.wkWebAttributes.frame = frame;
        
        self.vwAttributes.frame = CGRectMake(8, self.vwInfo.frame.origin.y + self.vwInfo.frame.size.height - (15*SCREEN_SIZE.width/375), self.vwInfo.frame.size.width - 16, self.wkWebAttributes.frame.size.height + 16);
        self.vwInfo.hidden = false;
        self.vwAttributes.hidden = false;
    }
    else
    {
        self.vwInfo.frame = CGRectMake(0, self.tblVariationDataInView.frame.origin.y + self.tblVariationDataInView.frame.size.height, SCREEN_SIZE.width, 0);
        self.vwAttributes.frame = CGRectMake(8, self.vwName.frame.origin.y + self.vwName.frame.size.height, self.vwInfo.frame.size.width - 16, 0);
        self.vwInfo.hidden = true;
        self.vwAttributes.hidden = true;
    }
    
    //Code for Seller Information
    
    BOOL isSeller = [[product.dict_seller_info valueForKey:@"is_seller"] boolValue];
    if (isSeller)
    {
        //Seller is available
        self.vwSellerInfo.frame = CGRectMake(self.vwSellerInfo.frame.origin.x, self.vwAttributes.frame.origin.y + self.vwAttributes.frame.size.height + (15*SCREEN_SIZE.width/375), self.vwSellerInfo.frame.size.width, 60*SCREEN_SIZE.width/375);
        
        self.lblSoldBy.font=Font_Size_Product_Name_Not_Bold;
        [self.lblSoldBy sizeToFit];
        self.lblSoldBy.frame = CGRectMake(self.lblSoldBy.frame.origin.x, self.lblSellerTitle.frame.origin.y, self.lblSoldBy.frame.size.width, self.btnSellerMoreDetail.frame.size.height);
        
        [self.btnSellerMoreDetail setTitle:[[product.dict_seller_info valueForKey:@"store_name"] capitalizedString] forState:UIControlStateNormal];
        [Util setSecondaryColorButtonTitle:self.btnSellerMoreDetail];
        
        [self.btnSellerMoreDetail sizeToFit];
        self.btnSellerMoreDetail.frame = CGRectMake(self.lblSoldBy.frame.origin.x + self.lblSoldBy.frame.size.width + 8, (self.lblSoldBy.frame.origin.y + self.lblSoldBy.frame.size.height/2) - self.btnSellerMoreDetail.frame.size.height/2, self.btnSellerMoreDetail.frame.size.width, self.btnSellerMoreDetail.frame.size.height);
        
        if ([[product.dict_seller_info valueForKey:@"store_tnc"] length] > 0)
        {
                        
            NSString *strHtml1 = [[product.dict_seller_info valueForKey:@"store_tnc"] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            if (appDelegate.isRTL) {
                strHtml1 = [NSString stringWithFormat:@"<body dir=\"rtl\" >%@</body>", [[product.dict_seller_info valueForKey:@"store_tnc"] stringByReplacingOccurrencesOfString:@"\n" withString:@""]];
            }
            strSellerDetails = [[NSString alloc] init];
            strSellerDetails=strHtml1;
            
            NSString *headerString = @"<header><meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no'></header>";
            [self.wkWebSellerDetails loadHTMLString:[headerString stringByAppendingString:strHtml1] baseURL:nil];


//
//            [self.wvSellerDetails loadHTMLString:strHtml1 baseURL:nil];
//
//            [self.wvSellerDetails stringByEvaluatingJavaScriptFromString:@"document. body.style.zoom = 1.2;"];
            CGSize fittingSize = [self.wkWebSellerDetails sizeThatFits:CGSizeZero];
            if (fittingSize.height>80)
            {
                self.wkWebSellerDetails.frame = CGRectMake(8, self.btnSellerMoreDetail.frame.origin.y + self.btnSellerMoreDetail.frame.size.height + 2, self.view.frame.size.width - 32, 80);
            }
            else
            {
                self.wkWebSellerDetails.frame = CGRectMake(8, self.btnSellerMoreDetail.frame.origin.y + self.btnSellerMoreDetail.frame.size.height + 2, self.view.frame.size.width - 32, fittingSize.height);
            }

            
            self.btnSellerDescMore.titleLabel.font = Font_Size_Product_Name_Not_Bold;
            [self.btnSellerDescMore sizeToFit];
            [Util setPrimaryColorButtonTitle:self.btnSellerDescMore];
            
            self.btnSellerDescMore.frame = CGRectMake(8, self.wkWebSellerDetails.frame.origin.y + self.wkWebSellerDetails.frame.size.height + 5, self.btnSellerDescMore.frame.size.width, self.btnSellerDescMore.frame.size.height);
            self.wkWebSellerDetails.hidden = NO;
            self.btnSellerDescMore.hidden = NO;
        }
        else
        {
            self.wkWebSellerDetails.frame = CGRectMake(8, self.btnSellerMoreDetail.frame.origin.y + self.btnSellerMoreDetail.frame.size.height, self.view.frame.size.width - 16, 0);
            self.btnSellerDescMore.frame = CGRectMake(8, self.wkWebSellerDetails.frame.origin.y + self.wkWebSellerDetails.frame.size.height, self.btnSellerDescMore.frame.size.width, 0);
            self.wkWebSellerDetails.hidden = YES;
            self.btnSellerDescMore.hidden = YES;
        }
        
        BOOL isContactSeller = [[product.dict_seller_info valueForKey:@"contact_seller"] boolValue];
        if (!isContactSeller)
        {
            self.btnContactSeller.userInteractionEnabled = NO;
            self.btnContactSeller.hidden=YES;
        }
        else
        {
            self.btnContactSeller.userInteractionEnabled = YES;
            self.btnContactSeller.hidden=NO;
        }
        
        self.btnContactSeller.frame = CGRectMake(8, self.btnSellerDescMore.frame.origin.y + self.btnSellerDescMore.frame.size.height + 10, 110*SCREEN_SIZE.width/375, 30*SCREEN_SIZE.width/375);
        self.btnViewStore.frame = CGRectMake(SCREEN_SIZE.width - 110*SCREEN_SIZE.width/375 - 24, self.btnSellerDescMore.frame.origin.y + self.btnSellerDescMore.frame.size.height + 10, 110*SCREEN_SIZE.width/375, 30*SCREEN_SIZE.width/375);
        
        [Util setSecondaryColorButton:self.btnContactSeller];
        
        [self.btnViewStore setBackgroundColor:LightBlackColor];
        
        self.btnContactSeller.titleLabel.font = Font_Size_Product_Name;
        self.btnViewStore.titleLabel.font = Font_Size_Product_Name;
        
        self.btnContactSeller.layer.cornerRadius = 3;
        self.btnContactSeller.layer.masksToBounds = true;
        self.btnViewStore.layer.cornerRadius = 3;
        self.btnViewStore.layer.masksToBounds = true;
        
        self.vwSellerDetail.frame = CGRectMake(self.vwSellerDetail.frame.origin.x, self.vwSellerInfo.frame.origin.y + self.vwSellerInfo.frame.size.height - (15*SCREEN_SIZE.width/375), self.view.frame.size.width - 16, self.btnContactSeller.frame.origin.y + self.btnContactSeller.frame.size.height + 16);
        
        self.vwSellerDetail.layer.shadowColor = [UIColor blackColor].CGColor;
        self.vwSellerDetail.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.vwSellerDetail.layer.shadowRadius = 1.0f;
        self.vwSellerDetail.layer.shadowOpacity = 0.20f;
        self.vwSellerDetail.layer.masksToBounds = NO;
        self.vwSellerDetail.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.vwSellerDetail.bounds cornerRadius:self.vwSellerDetail.layer.cornerRadius].CGPath;
        
        [self.scrl bringSubviewToFront:self.vwSellerDetail];
        
    }
    else
    {
        //Seller is not Available
        self.vwSellerInfo.frame = CGRectMake(self.vwSellerDetail.frame.origin.x, self.vwAttributes.frame.origin.y + self.vwAttributes.frame.size.height, self.vwSellerInfo.frame.size.width, 0);
        self.vwSellerDetail.frame = CGRectMake(self.vwSellerDetail.frame.origin.x, self.vwSellerInfo.frame.origin.y + self.vwSellerInfo.frame.size.height, self.view.frame.size.width,0);
        self.vwSellerInfo.hidden = YES;
        self.vwSellerDetail.hidden = YES;
    }
    if (appDelegate.isRTL)
    {
        self.lblSellerTitle.textAlignment = NSTextAlignmentRight;
        self.lblSoldBy.frame = CGRectMake(SCREEN_SIZE.width - self.lblSoldBy.frame.size.width - 24, self.lblSoldBy.frame.origin.y, self.lblSoldBy.frame.size.width, self.lblSoldBy.frame.size.height);
        self.btnSellerMoreDetail.frame = CGRectMake(self.lblSoldBy.frame.origin.x - self.btnSellerMoreDetail.frame.size.width - 8, self.btnSellerMoreDetail.frame.origin.y, self.btnSellerMoreDetail.frame.size.width, self.btnSellerMoreDetail.frame.size.height);
        
        self.vwAddToCartContent.frame = CGRectMake(self.vwAddToCart.frame.size.width - self.vwAddToCartContent.frame.size.width, 0, self.vwAddToCartContent.frame.size.width, self.vwAddToCartContent.frame.size.height);
        self.vwBuyNowContent.frame = CGRectMake(0, 0, self.vwBuyNowContent.frame.size.width, self.vwBuyNowContent.frame.size.height);
        
        self.colColor.frame = CGRectMake(SCREEN_SIZE.width - self.colColor.frame.size.width - 8*SCREEN_SIZE.width/375, self.colColor.frame.origin.y, self.colColor.frame.size.width, self.colColor.frame.size.height);
        self.vwOptions.frame = CGRectMake(8*SCREEN_SIZE.width/375, self.vwOptions.frame.origin.y, self.vwOptions.frame.size.width, self.vwOptions.frame.size.height);
        self.lblOptionLine.frame = CGRectMake(self.vwOptions.frame.size.width - 1, self.lblOptionLine.frame.origin.y, self.lblOptionLine.frame.size.width, self.lblOptionLine.frame.size.height);
        self.vwColorSize.frame = CGRectMake(0, self.vwColorSize.frame.origin.y, self.vwColorSize.frame.size.width, self.vwColorSize.frame.size.height);
    }
    else
    {
        self.lblSellerTitle.textAlignment = NSTextAlignmentLeft;
        self.lblSoldBy.frame = CGRectMake(8, self.lblSoldBy.frame.origin.y, self.lblSoldBy.frame.size.width, self.lblSoldBy.frame.size.height);
        self.btnSellerMoreDetail.frame = CGRectMake(self.lblSoldBy.frame.origin.x + self.lblSoldBy.frame.size.width + 8, self.btnSellerMoreDetail.frame.origin.y, self.btnSellerMoreDetail.frame.size.width, self.btnSellerMoreDetail.frame.size.height);
        
        self.vwAddToCartContent.frame = CGRectMake(0, 0, self.vwAddToCartContent.frame.size.width, self.vwAddToCartContent.frame.size.height);
        self.vwBuyNowContent.frame = CGRectMake(self.vwAddToCart.frame.size.width - self.vwBuyNowContent.frame.size.width, 0, self.vwBuyNowContent.frame.size.width, self.vwBuyNowContent.frame.size.height);
        
        self.colColor.frame = CGRectMake(8*SCREEN_SIZE.width/375, self.colColor.frame.origin.y, self.colColor.frame.size.width, self.colColor.frame.size.height);
        self.vwOptions.frame = CGRectMake(SCREEN_SIZE.width - self.vwOptions.frame.size.width - 8*SCREEN_SIZE.width/375, self.vwOptions.frame.origin.y, self.vwOptions.frame.size.width, self.vwOptions.frame.size.height);
        self.lblOptionLine.frame = CGRectMake(0, self.lblOptionLine.frame.origin.y, self.lblOptionLine.frame.size.width, self.lblOptionLine.frame.size.height);
        self.vwColorSize.frame = CGRectMake(self.vwOptions.frame.size.width - self.vwColorSize.frame.size.width, self.vwColorSize.frame.origin.y, self.vwColorSize.frame.size.width, self.vwColorSize.frame.size.height);
    }
    
    if (self.lblPoints.attributedText.length>0) {
        self.vwPoints.frame = CGRectMake(15, self.vwSellerDetail.frame.origin.y + self.vwSellerDetail.frame.size.height + (15*SCREEN_SIZE.width/375), self.vwPoints.frame.size.width, 48*SCREEN_SIZE.width/375);
    }
    else
    {
        self.vwPoints.frame = CGRectMake(15, self.vwSellerDetail.frame.origin.y + self.vwSellerDetail.frame.size.height + (15*SCREEN_SIZE.width/375), self.vwPoints.frame.size.width,0);
    }
    
    float height = 0.0;
    if (self.vwPoints.frame.size.height != 0) {
        height = (15*SCREEN_SIZE.width/375);
    }
    
    self.vwQuickOverview.frame = CGRectMake(0, self.vwPoints.frame.origin.y + self.vwPoints.frame.size.height + height, self.vwQuickOverview.frame.size.width, 170*SCREEN_SIZE.width/375);
    
    self.vwDetail.frame = CGRectMake(0, self.vwQuickOverview.frame.origin.y + self.vwQuickOverview.frame.size.height, self.vwDetail.frame.size.width, 60*SCREEN_SIZE.width/375);
    self.vwDetailViewData.frame = CGRectMake(self.vwDetailViewData.frame.origin.x, self.vwDetail.frame.origin.y + self.vwDetail.frame.size.height - (15*SCREEN_SIZE.width/375), self.vwDetailViewData.frame.size.width, self.vwDetailViewData.frame.size.height);
    self.vwRateWriteReview.frame = CGRectMake(self.vwRateWriteReview.frame.origin.x, self.vwDetailViewData.frame.origin.y + self.vwDetailViewData.frame.size.height, self.vwRateWriteReview.frame.size.width, 45*SCREEN_SIZE.width/375);
    self.vwLast.frame = CGRectMake(self.vwLast.frame.origin.x, self.vwRateWriteReview.frame.origin.y + self.vwRateWriteReview.frame.size.height, self.vwLast.frame.size.width, self.vwLast.frame.size.height);
    
    self.vwRatingCircle.frame = CGRectMake(self.vwRatingCircle.frame.origin.x, self.vwRatingCircle.frame.origin.y, self.vwRatingCircle.frame.size.width, self.vwRatingCircle.frame.size.width);
    
    [self setScrollViewSize];
}

-(void)setScrollViewSize
{
    float height = 0.0;
    
    if (arrComments.count > 3)
    {
        self.vwCheckMoreReviews.hidden = NO;
        self.vwCheckMoreReviews.frame = CGRectMake(self.vwLast.frame.origin.x, self.vwLast.frame.origin.y + self.vwLast.frame.size.height + (15*SCREEN_SIZE.width/375), self.vwLast.frame.size.width, self.vwCheckMoreReviews.frame.size.height);
        height = height + self.vwCheckMoreReviews.frame.size.height + (15*SCREEN_SIZE.width/375);
    }
    else
    {
        self.vwCheckMoreReviews.hidden = YES;
    }
    
    self.vwBorder.frame = CGRectMake(self.vwDetailViewData.frame.origin.x, self.vwDetail.frame.origin.y + self.vwDetail.frame.size.height - (15*SCREEN_SIZE.width/375), self.vwDetailViewData.frame.size.width, self.vwDetailViewData.frame.size.height  + self.vwRateWriteReview.frame.size.height + self.vwLast.frame.size.height + height + 8);
    
    if (product.arrRelated_ids.count > 0 && loadedRelatedProducts)
    {
        self.vwRelatedProducts.frame = CGRectMake(0,  self.vwLast.frame.origin.y + self.vwLast.frame.size.height + height + (25*SCREEN_SIZE.width/375), SCREEN_SIZE.width, self.vwRelatedProducts.frame.size.height);
        height = height + self.vwRelatedProducts.frame.size.height + (25*SCREEN_SIZE.width/375);
    }
    
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.vwLast.frame.origin.y + self.vwLast.frame.size.height + height + 20);
    
    [self setBorderForReview];
    
    [self.scrl bringSubviewToFront:self.tblVariationDataInView];
}

#pragma mark - UIWebview Delegate

- (void)webViewDidFinishLoad:(UIWebView *)aWebView
{
    if (aWebView == self.wkWebAttributes) {
        [self setFrames];
    }
}

#pragma mark - set Collectionview Layout

-(void)setCollectionViewLayout
{
    //nib registration for cell
    [self.colColor registerNib:[UINib nibWithNibName:@"ColorAndSizeCell" bundle:nil] forCellWithReuseIdentifier:@"ColorAndSizeCell"];
    
    UICollectionViewFlowLayout *layout1 = (UICollectionViewFlowLayout *)[self.colColor collectionViewLayout];
    layout1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

#pragma mark - set Sliders for rating

-(void)setSlider
{
    [self.sliderOne setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self.sliderOne setMinimumTrackTintColor:[UIColor redColor]];
    [self.sliderOne setMaximumTrackTintColor:[UIColor lightGrayColor]];
    
    
    [self.sliderTwo setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self.sliderTwo setMinimumTrackTintColor:[UIColor orangeColor]];
    [self.sliderTwo setMaximumTrackTintColor:[UIColor lightGrayColor]];
    
    
    [self.sliderThree setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self.sliderThree setMinimumTrackTintColor:[Util colorWithHexString:@"009900"]];
    [self.sliderThree setMaximumTrackTintColor:[UIColor lightGrayColor]];
    
    
    [self.sliderFour setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self.sliderFour setMinimumTrackTintColor:[Util colorWithHexString:@"009900"]];
    [self.sliderFour setMaximumTrackTintColor:[UIColor lightGrayColor]];
    
    
    [self.sliderFive setThumbImage:[[UIImage alloc] init] forState:UIControlStateNormal];
    [self.sliderFive setMinimumTrackTintColor:[Util colorWithHexString:@"009900"]];
    [self.sliderFive setMaximumTrackTintColor:[UIColor lightGrayColor]];
    
    self.sliderOne.minimumValue = 0;
    self.sliderTwo.minimumValue = 0;
    self.sliderThree.minimumValue = 0;
    self.sliderFour.minimumValue = 0;
    self.sliderFive.minimumValue = 0;
    
    self.sliderOne.maximumValue = arrComments.count;
    self.sliderTwo.maximumValue = arrComments.count;
    self.sliderThree.maximumValue = arrComments.count;
    self.sliderFour.maximumValue = arrComments.count;
    self.sliderFive.maximumValue = arrComments.count;
    
    self.sliderOne.value = oneStar;
    self.sliderTwo.value = twoStar;
    self.sliderThree.value = threeStar;
    self.sliderFour.value = fourStar;
    self.sliderFive.value = fiveStar;
}

#pragma mark - Localize Language

- (void)localize
{
    if (appDelegate.isPincodeCheckActive)
    {
        self.txtPincode.attributedPlaceholder = [[NSAttributedString alloc] initWithString:appDelegate.pincodeConfigData.pincode_placeholder_txt attributes:@{NSForegroundColorAttributeName: SearchBG}];
        [self.btnCheckPincode setTitle:[MCLocalization stringForKey:@"Check"] forState:UIControlStateNormal];
        self.txtPincode.font = Font_Size_Product_Name_Regular;
        self.lblPincodeAvailabilityText.font = Font_Size_Product_Name_Regular;
        self.btnCheckPincode.titleLabel.font = Font_Size_Product_Name_Regular;
    }
    
    [Util setHeaderColorView:self.vwHeader];
    [Util setPrimaryColorLabelText:self.lblProductHighlight];
    [Util setPrimaryColorButtonTitle:self.btnMore];
    [Util setPrimaryColorButtonTitle:self.btnCancel];
    [Util setSecondaryColorButton:self.btnDone];
    [Util setPrimaryColorButton:self.btnCheckPincode];
    
    
    
    self.lblAvailability.text = [MCLocalization stringForKey:@"Availability:"];
    self.lblQuickOverview.text = [MCLocalization stringForKey:@"Quick Overview:"];
    self.lblDetail.text = [MCLocalization stringForKey:@"Details"];
    self.lblProductHighlight.text = [MCLocalization stringForKey:@"Product Highlights"];
    
    self.lblRelatedProducts.text = [MCLocalization stringForKey:@"Related Product"];
    self.lblInfo.text = [MCLocalization stringForKey:@"Info:"];
    
    [self.btnMoreQuickOverview setTitle:[MCLocalization stringForKey:@"More >"] forState:UIControlStateNormal];
    [Util setPrimaryColorButtonTitle:self.btnMoreQuickOverview];
    
    [self.btnMore setTitle:[MCLocalization stringForKey:@"More >"] forState:UIControlStateNormal];
    [self.btnRateAndReview setTitle:[MCLocalization stringForKey:@"RATE AND WRITE A REVIEW"] forState:UIControlStateNormal];
    
    [self.btnCheckMoreReviews setTitle:[MCLocalization stringForKey:@"ALL REVIEWS"] forState:UIControlStateNormal];
    
    //    Boolean flag = [Util checkInCart:product variation:0 attribute:nil];
    //    if (flag)
    //    {
    //        [self.btnAddToCart setTitle:[MCLocalization stringForKey:@"GO TO CART"] forState:UIControlStateNormal];
    //    }
    //    else
    //    {
    //        [self.btnAddToCart setTitle:[MCLocalization stringForKey:@"ADD TO CART"] forState:UIControlStateNormal];
    //    }
    
    [self.btnBuyNow setTitle:[MCLocalization stringForKey:@"BUY NOW"] forState:UIControlStateNormal];
    
    [self.btnCancel setTitle:[MCLocalization stringForKey:@"Cancel"] forState:UIControlStateNormal];
    [self.btnDone setTitle:[MCLocalization stringForKey:@"Done"] forState:UIControlStateNormal];
    
    self.lblSellerTitle.text = [MCLocalization stringForKey:@"Seller Information:"];
    self.lblSoldBy.text = [MCLocalization stringForKey:@"Sold By"];
    [self.btnViewStore setTitle:[MCLocalization stringForKey:@"View Store"] forState:UIControlStateNormal];
    [self.btnContactSeller setTitle:[MCLocalization stringForKey:@"Contact Seller"] forState:UIControlStateNormal];
    [self.btnSellerDescMore setTitle:[MCLocalization stringForKey:@"More >"] forState:UIControlStateNormal];
    
    [self.tblRateReview reloadData];
    
    self.lblName.font=Font_Size_Navigation_Title;
    self.lblName.textColor=LightBlackColor;
    
    self.lblRating.font=Font_Size_Price_Sale_Small;
    self.lblAvailability.font=Font_Size_Product_Name_Not_Bold;
    self.lblInStock.font=Font_Size_Product_Name_Not_Bold;
    
    self.lblQuickOverview.font=Font_Size_Title;
    self.lblQuickOverview.textColor=LightBlackColor;
    
    self.lblInfo.font=Font_Size_Title;
    self.lblInfo.textColor=LightBlackColor;
    
    self.lblDetail.font=Font_Size_Title;
    self.lblDetail.textColor=LightBlackColor;
    
    self.lblRelatedProducts.font=Font_Size_Title;
    self.lblRelatedProducts.textColor=LightBlackColor;
    
    self.lblProductHighlight.font=Font_Size_Title_Not_Bold;
    self.lblProductHighlight.textColor=LightBlackColor;
    
    self.btnDone.titleLabel.font=Font_Size_Title;
    self.btnCancel.titleLabel.font=Font_Size_Title;
    self.btnBuyNow.titleLabel.font=Font_Size_Title;
    self.btnAddToCart.titleLabel.font=Font_Size_Title;
    self.btnRateAndReview.titleLabel.font=Font_Size_Product_Name_Not_Bold;
    self.btnMore.titleLabel.font=Font_Size_Product_Name_Not_Bold;
    self.btnMoreQuickOverview.titleLabel.font=Font_Size_Product_Name_Not_Bold;
    
    [Util setPrimaryColorLabelText:self.lblOne];
    [Util setPrimaryColorLabelText:self.lblTwo];
    [Util setPrimaryColorLabelText:self.lblThree];
    [Util setPrimaryColorLabelText:self.lblFour];
    [Util setPrimaryColorLabelText:self.lblFive];
    
    if (appDelegate.isRTL) {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        self.btnNotification.frame = CGRectMake(0, self.btnNotification.frame.origin.y, self.btnNotification.frame.size.width, self.btnNotification.frame.size.height);
        
        self.lblInfo.textAlignment = NSTextAlignmentRight;
        self.lblAttributes.textAlignment = NSTextAlignmentRight;
        self.lblRelatedProducts.textAlignment = NSTextAlignmentRight;
        self.lblPoints.textAlignment = NSTextAlignmentRight;
        
        self.lblName.textAlignment = NSTextAlignmentRight;
        
        self.lblPoints.textAlignment = NSTextAlignmentRight;
        
        self.lblQuickOverview.textAlignment = NSTextAlignmentRight;
        self.lblDetail.textAlignment = NSTextAlignmentRight;
        self.lblProductHighlight.textAlignment = NSTextAlignmentRight;
        
        self.txtDescription.textAlignment = NSTextAlignmentRight;
        self.txtQuickOverview.textAlignment = NSTextAlignmentRight;
        
        
        self.btnMore.frame = CGRectMake(self.vwDetailViewData.frame.size.width - self.btnMore.frame.size.width - 10, self.btnMore.frame.origin.y, self.btnMore.frame.size.width, self.btnMore.frame.size.height);
        self.btnMoreQuickOverview.frame = CGRectMake(self.vwQuickViewData.frame.size.width - self.btnMoreQuickOverview.frame.size.width - 10, self.btnMoreQuickOverview.frame.origin.y, self.btnMoreQuickOverview.frame.size.width, self.btnMoreQuickOverview.frame.size.height);
        
        self.btnMore.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.btnMoreQuickOverview.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    } else {
        //NonRTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        self.btnNotification.frame = CGRectMake(SCREEN_SIZE.width - self.btnNotification.frame.size.width, self.btnNotification.frame.origin.y, self.btnNotification.frame.size.width, self.btnNotification.frame.size.height);
        
        self.btnMore.frame = CGRectMake(10, self.btnMore.frame.origin.y, self.btnMore.frame.size.width, self.btnMore.frame.size.height);
        self.btnMoreQuickOverview.frame = CGRectMake(10, self.btnMoreQuickOverview.frame.origin.y, self.btnMoreQuickOverview.frame.size.width, self.btnMoreQuickOverview.frame.size.height);
        self.lblName.textAlignment = NSTextAlignmentLeft;
        
        self.lblRelatedProducts.textAlignment = NSTextAlignmentLeft;
        
        self.lblQuickOverview.textAlignment = NSTextAlignmentLeft;
        self.lblDetail.textAlignment = NSTextAlignmentLeft;
        self.lblProductHighlight.textAlignment = NSTextAlignmentLeft;
        self.lblInfo.textAlignment = NSTextAlignmentLeft;
        self.lblAttributes.textAlignment = NSTextAlignmentLeft;
        
        self.txtDescription.textAlignment = NSTextAlignmentLeft;
        self.txtQuickOverview.textAlignment = NSTextAlignmentLeft;
        self.btnMore.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.btnMoreQuickOverview.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
}

#pragma mark - ScrollView Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tag == 1001) {
        //main scroll
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            // then we are at the end
            // so check related product ids
            
            if (product.arrRelated_ids.count > 0 && !loadedRelatedProducts) {
                //load data for related product
                loadedRelatedProducts = true;
                [self.actRelatedProduct setColor:[Util colorWithHexString:[Util getStringData:kPrimaryColor]]];
                
                // Related products api call
                [self getRelatedProduct];
                [self setScrollViewSize];
            }
        }
    } else if (scrollView.tag == 1002) {
        int pageNo = round(self.scrlImages.contentOffset.x / self.scrlImages.frame.size.width);
        self.pageController.currentPage = pageNo;
    }
}

#pragma mark - button Video Play click

-(void)playVideo {
    if (appDelegate.isYithVideoEnabled && [product.dict_featured_video objectForKey:@"url"]) {
        [Util PlayVideo:[product.dict_featured_video objectForKey:@"url"] viewController:self];
    }
}

#pragma mark - button Clicks

- (IBAction)btnCheckPincodeClicked:(id)sender {
    if (self.txtPincode.text.length != 0) {
        [self checkPincode];
    } else {
        ALERTVIEW([MCLocalization stringForKey:@"Enter Pincode"], self);
    }
}

-(IBAction)btnSellerClicked:(id)sender {
    AboutSellerVC *vc = [[AboutSellerVC alloc] initWithNibName:@"AboutSellerVC" bundle:nil];
    vc.strTitle = self.btnSellerMoreDetail.titleLabel.text;
    vc.strDesc = [product.dict_seller_info valueForKey:@"seller_address"];
    vc.strSellerID = [product.dict_seller_info valueForKey:@"seller_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnMoreSellerInfoClicked:(id)sender {
    SellerInfoVC *vc = [[SellerInfoVC alloc] initWithNibName:@"SellerInfoVC" bundle:nil];
    vc.strTitle = self.btnSellerMoreDetail.titleLabel.text;
    vc.strDesc = strSellerDetails;
    [self.navigationController pushViewController:vc animated:YES];
}

-(IBAction)btnContactSellerClicked:(id)sender {
    ContactSellerVC *vc = [[ContactSellerVC alloc] initWithNibName:@"ContactSellerVC" bundle:nil];
    vc.strSellerID = [product.dict_seller_info valueForKey:@"seller_id"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnBuyNow:(id)sender {
    BOOL flag1 = [self checkVariationAvailability];
    if (!flag1) {
        [Util showPositiveMessage:@"Select another variation"];
        if (!appDelegate.isVariationInView) {
            [self ShowPopUp:self.vwColorSizePopup];
        }
        return;
    }
    
    int variationId = 0;
    int stockQuantity = 0;
    double price = 0;
    BOOL manageStock = false;
    
    NSString *strHtmlPrice = [[NSString alloc] init];
    
    NSMutableDictionary *dictSelectedVariation = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < appDelegate.arrSelectedVariable.count; i++) {
        [dictSelectedVariation setValue:[appDelegate.arrSelectedVariable objectAtIndex:i] forKey:[[product.arrAttributes objectAtIndex:i] valueForKey:@"name"]];
    }
    
    for (int i = 0; i < arrVariations.count; i++) {
        NSArray *arrAtrb = [[NSArray alloc] initWithArray:[[arrVariations objectAtIndex:i] valueForKey:@"attributes"]];
        
        int flag = 0;
        
        for (int j = 0; j < arrAtrb.count; j++) {
            if ([appDelegate.arrSelectedVariable containsObject:[[arrAtrb objectAtIndex:j] valueForKey:@"option"]]) {
                //contains object
                if (arrAtrb.count < product.arrAttributes.count) {
                    flag++;
                    //less attribute in variation
                    if (flag == arrAtrb.count) {
                        flag = (int)product.arrAttributes.count;
                        break;
                    }
                } else {
                    //all variation
                    flag++;
                }
                if (flag == product.arrAttributes.count) {
                    //selected variation
                    break;
                }
            } else {
                //object is not in array
            }
        }
        if (flag == product.arrAttributes.count) {
            variationId = [[[arrVariations objectAtIndex:i] valueForKey:@"id"] intValue];
            if (product.manageStock) {
                manageStock = product.manageStock;
                stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
            } else {
                if ([[arrVariations objectAtIndex:i] objectForKey:@"manage_stock"]) {
                    //MANAGE STOCK IS AVAILABLE
                    NSNumber* stockActive = [[arrVariations objectAtIndex:i] valueForKey:@"manage_stock"];
                    if ([stockActive boolValue]) {
                        manageStock = [stockActive boolValue];
                        stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
                    } else {
                        manageStock = false;
                        stockQuantity = 0;
                    }
                } else {
                    //MANAGE STOCK IS NOT AVAILABLE
                    manageStock = product.manageStock;
                    stockQuantity = 0;
                }
            }
            
            strHtmlPrice = [[arrVariations objectAtIndex:i] valueForKey:@"price_html"];
            price = [[[arrVariations objectAtIndex:i] valueForKey:@"price"] doubleValue];
            
            break;
        } else if (arrAtrb.count == 0) {
            variationId = [[[arrVariations objectAtIndex:i] valueForKey:@"id"] intValue];
            if (product.manageStock) {
                manageStock = product.manageStock;
                stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
            } else {
                if ([[arrVariations objectAtIndex:i] objectForKey:@"manage_stock"]) {
                    //MANAGE STOCK IS AVAILABLE
                    NSNumber* stockActive = [[arrVariations objectAtIndex:i] valueForKey:@"manage_stock"];
                    if ([stockActive boolValue]) {
                        manageStock = [stockActive boolValue];
                        stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
                    } else {
                        manageStock = false;
                        stockQuantity = 0;
                    }
                } else {
                    //MANAGE STOCK IS NOT AVAILABLE
                    manageStock = product.manageStock;
                    stockQuantity = 0;
                }
            }
            
            strHtmlPrice = [[arrVariations objectAtIndex:i] valueForKey:@"price_html"];
            price = [[[arrVariations objectAtIndex:i] valueForKey:@"price"] doubleValue];
            
            break;
        }
    }
    AddToCartData *object = [[AddToCartData alloc] init];
    object.name = product.name;
    object.rating = product.average_rating;
    
    if ([arrImages count] > 0) {
        object.imgUrl = [arrImages objectAtIndex:0];
    } else {
        object.imgUrl = @"";
    }
    
    object.html_Price = strHtmlPrice;
    object.productId = product.product_id;
    object.variation_id = variationId;
    object.quantity = 1;
    
    object.price = price;
    object.arrVariation = dictSelectedVariation;
    object.isSoldIndividually = (BOOL)product.sold_individually;
    
    object.manageStock = manageStock;
    object.stockQuantity = stockQuantity;
    
    //    appDelegate.isFromBuyNow = YES;
    [Util setArray:nil setData:kBuyNow];
    
    //    BOOL flag = [Util saveCustomObject:object key:kBuyNow];
    BOOL flag = [Util saveCustomObject:object key:kMyCart];
    
    if (flag || [self.btnAddToCart.titleLabel.text isEqualToString:[MCLocalization stringForKey:@"GO TO CART"]]) {
        [Util showPositiveMessage:[MCLocalization stringForKey:@"Item Added to Your Cart Successfully"]];
        if(self.tabBarController.selectedIndex == 2) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.tabBarController.selectedIndex = 2;
        }
        [self.btnAddToCart setTitle:[MCLocalization stringForKey:@"GO TO CART"] forState:UIControlStateNormal];
        appDelegate.baseTabBarController.tabBar.selectedItem.badgeValue=nil;
    } else {
        //        NSString *str = [MCLocalization stringForKey:@"Out of Stock"];
        //        ALERTVIEW(str, appDelegate.window.rootViewController);
    }
}

- (IBAction)btnAddToCartClicked:(id)sender {
    BOOL flag1 = [self checkVariationAvailability];
    if (!flag1) {
        [Util showPositiveMessage:@"Select another variation"];
        if (!appDelegate.isVariationInView) {
            [self ShowPopUp:self.vwColorSizePopup];
        }
        return;
    }
    
    int variationId = 0;
    int stockQuantity = 0;
    double price = 0;
    int inStock = 0;
    int manageStock = false;
    
    NSString *strHtmlPrice = [[NSString alloc] init];
    
    NSMutableDictionary *dictSelectedVariation = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < appDelegate.arrSelectedVariable.count; i++) {
        [dictSelectedVariation setValue:[appDelegate.arrSelectedVariable objectAtIndex:i] forKey:[[product.arrAttributes objectAtIndex:i] valueForKey:@"name"]];
    }
    
    for (int i = 0; i < arrVariations.count; i++) {
        NSArray *arrAtrb = [[NSArray alloc] initWithArray:[[arrVariations objectAtIndex:i] valueForKey:@"attributes"]];
        int flag = 0;
        for (int j = 0; j < arrAtrb.count; j++) {
            if ([appDelegate.arrSelectedVariable containsObject:[[arrAtrb objectAtIndex:j] valueForKey:@"option"]]) {
                //contains object
                if (arrAtrb.count < product.arrAttributes.count) {
                    flag++;
                    //less attribute in variation
                    if (flag == arrAtrb.count) {
                        flag = (int)product.arrAttributes.count;
                        break;
                    }
                } else {
                    //all variation
                    flag++;
                }
                if (flag == product.arrAttributes.count) {
                    //selected variation
                    break;
                }
            } else {
                //object is not in array
            }
        }
        if (flag == product.arrAttributes.count) {
            variationId = [[[arrVariations objectAtIndex:i] valueForKey:@"id"] intValue];
            inStock = [[[arrVariations objectAtIndex:i] valueForKey:@"in_stock"] intValue];
            
            if (product.manageStock) {
                manageStock = product.manageStock;
                stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
            } else {
                if ([[arrVariations objectAtIndex:i] objectForKey:@"manage_stock"]) {
                    //MANAGE STOCK IS AVAILABLE
                    NSNumber* stockActive = [[arrVariations objectAtIndex:i] valueForKey:@"manage_stock"];
                    if ([stockActive boolValue]) {
                        manageStock = [stockActive boolValue];
                        stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
                    } else {
                        manageStock = false;
                        stockQuantity = 0;
                    }
                } else {
                    //MANAGE STOCK IS NOT AVAILABLE
                    manageStock = product.manageStock;
                    stockQuantity = 0;
                }
            }
            
            strHtmlPrice = [[arrVariations objectAtIndex:i] valueForKey:@"price_html"];
            price = [[[arrVariations objectAtIndex:i] valueForKey:@"price"] doubleValue];
            
            break;
        } else if (arrAtrb.count == 0) {
            variationId = [[[arrVariations objectAtIndex:i] valueForKey:@"id"] intValue];
            inStock = [[[arrVariations objectAtIndex:i] valueForKey:@"in_stock"] intValue];
            
            if (product.manageStock) {
                manageStock = product.manageStock;
                stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
            } else {
                if ([[arrVariations objectAtIndex:i] objectForKey:@"manage_stock"]) {
                    //MANAGE STOCK IS AVAILABLE
                    NSNumber* stockActive = [[arrVariations objectAtIndex:i] valueForKey:@"manage_stock"];
                    if ([stockActive boolValue]) {
                        manageStock = [stockActive boolValue];
                        stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
                    } else {
                        manageStock = false;
                        stockQuantity = 0;
                    }
                } else {
                    //MANAGE STOCK IS NOT AVAILABLE
                    manageStock = product.manageStock;
                    stockQuantity = 0;
                }
            }
            
            strHtmlPrice = [[arrVariations objectAtIndex:i] valueForKey:@"price_html"];
            price = [[[arrVariations objectAtIndex:i] valueForKey:@"price"] doubleValue];
            
            break;
        }
    }
    
    if (inStock == 0) {
        //No stock available
        self.lblInStock.text = [MCLocalization stringForKey:@"Out of Stock"];
        self.lblInStock.textColor = [UIColor redColor];
        
        self.btnAddToCart.enabled = NO;
        self.btnBuyNow.enabled = NO;
        
        self.btnAddToCart.alpha = 0.3;
        self.btnBuyNow.alpha = 0.3;
        return;
    } else {
        self.lblInStock.text = [MCLocalization stringForKey:@"In Stock"];
        [Util setPrimaryColorLabelText:self.lblInStock];
        
        self.btnAddToCart.enabled = YES;
        self.btnBuyNow.enabled = YES;
        
        self.btnAddToCart.alpha = 1.0;
        self.btnBuyNow.alpha = 1.0;
    }
    AddToCartData *object = [[AddToCartData alloc] init];
    object.name = product.name;
    object.rating = product.average_rating;
    if (object.price == 0)
    {
        self.btnAddToCart.hidden = true;
    }
    else
    {
        self.btnAddToCart.hidden = false;
    }
    
    if ([arrImages count] > 0) {
        object.imgUrl = [arrImages objectAtIndex:0];
    } else {
        object.imgUrl = @"";
    }
    
    object.html_Price = strHtmlPrice;
    object.productId = product.product_id;
    object.variation_id = variationId;
    object.quantity = 1;
    object.price = price;
    object.arrVariation = dictSelectedVariation;
    object.isSoldIndividually = (BOOL)product.sold_individually;
    
    object.manageStock = manageStock;
    object.stockQuantity = stockQuantity;
    
    BOOL flag = [Util saveCustomObject:object key:kMyCart];
    
    if (flag) {
        // Facebook Pixel for Add To cart
        [Util logAddedToCartEvent:[NSString stringWithFormat:@"%d", product.product_id] contentType:product.name currency:appDelegate.strCurrencySymbol valToSum:price];
        
        [Util showPositiveMessage:[MCLocalization stringForKey:@"Item Added to Your Cart Successfully"]];
        [self.btnAddToCart setTitle:[MCLocalization stringForKey:@"GO TO CART"] forState:UIControlStateNormal];
    } else if ([self.btnAddToCart.titleLabel.text isEqualToString:[MCLocalization stringForKey:@"GO TO CART"]]) {
        if(self.tabBarController.selectedIndex == 2) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.tabBarController.selectedIndex = 2;
        }
        return;
    } else {
        //        NSString *str = [MCLocalization stringForKey:@"Out of Stock"];
        //        ALERTVIEW(str, appDelegate.window.rootViewController);
    }
    if (appDelegate.isFromBuyNow) {
        if(self.tabBarController.selectedIndex == 2) {
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            self.tabBarController.selectedIndex = 2;
        }
    }
    [appDelegate showBadge];
}

-(IBAction)btnRateAndReviewCLicked:(id)sender {
    if (appDelegate.isReviewLoginEnabled) {
        if ([Util getBoolData:kLogin]) {
            [self openRateAndReview];
        } else {
            [self redirectToLogin];
        }
    } else {
        [self openRateAndReview];
    }
}

-(void)redirectToLogin {
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [[GIDSignIn sharedInstance] signOut];
    
    SigninVC *vc = [[SigninVC alloc] initWithNibName:@"SigninVC" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
}

-(void) openRateAndReview {
    RateAndReviewVC *vc = [[RateAndReviewVC alloc] initWithNibName:@"RateAndReviewVC" bundle:nil];
    if (arrImages.count > 0) {
        vc.strProductUrl = [arrImages objectAtIndex:0];
    }
    vc.strID = [NSString stringWithFormat:@"%d", productId];
    vc.strName = product.name;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnMoreQuickOverviewClicked:(id)sender {
    DescriptionVC *vc = [[DescriptionVC alloc] initWithNibName:@"DescriptionVC" bundle:nil];
    vc.strDescTitle = [MCLocalization stringForKey:@"Quick Overview:"];
    
    vc.strDesc = product.short_description;
    vc.strName = product.name;
    if (arrImages.count != 0) {
        vc.strImage = [arrImages objectAtIndex:0];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnMoreDetailClicked:(id)sender {
    DescriptionVC *vc = [[DescriptionVC alloc] initWithNibName:@"DescriptionVC" bundle:nil];
    vc.strDescTitle = [MCLocalization stringForKey:@"Details"];
    vc.strDesc = product.desc;
    vc.strName = product.name;
    if (arrImages.count != 0) {
        vc.strImage = [arrImages objectAtIndex:0];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)btnPopupDone:(id)sender {
    BOOL Check = [self checkVariationAvailability];
    if (!Check) {
        return;
    }
    [self.colColor reloadData];
    [self HidePopUp:self.vwColorSizePopup];
}

- (IBAction)btnPopupCancel:(id)sender {
    appDelegate.arrSelectedVariable = [[NSMutableArray alloc] init];
    appDelegate.arrSelectedVariable = [arrPreviousSelection mutableCopy];
    
    arrImages = [[NSMutableArray alloc] initWithArray:arrPreviousImages];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setScrollingImages];
    });
    [self.tblVariationData reloadData];
    [self.tblVariationDataInView reloadData];
    
    [self HidePopUp:self.vwColorSizePopup];
}

-(IBAction)btnColorClicked:(id)sender {
    [self ShowPopUp:self.vwColorSizePopup];
}

- (IBAction)btnWishListClicked:(UIButton*)sender {
    NSArray *arr = [[NSArray alloc] initWithArray:[[Util getArrayData:kWishList] mutableCopy]];
    BOOL get = NO;
    for (int i = 0; i < arr.count; i++) {
        if (product.product_id == [[arr objectAtIndex:i] integerValue]) {
            get = YES;
            break;
        }
    }
    
    if (get) {
        //remove from Wishlist
        if ([Util getBoolData:kLogin]) {
            [self removeItemFromWishList:[NSString stringWithFormat:@"%d", product.product_id]];
        } else {
            [self.imgWishList setImage:[UIImage imageNamed:@"IconWishList"]];
            
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            for (int i = 0; i < arr.count; i++) {
                if ([[arr objectAtIndex:i] integerValue] == product.product_id) {
                    [arr removeObjectAtIndex:i];
                }
            }
            
            [Util setArray:arr setData:kWishList];
            //        NSLog(@"%@",[Util getArrayData:kWishList]);
            NSString *message = [MCLocalization stringForKey:@"Item Removed From your Wish List."];
            
            NSLog(@"Product Removed to wishlist successfully!");
            [Util showPositiveMessage:message];
        }
    } else {
        //Add to Wishlist
        
        // Facebook Pixel for Add to Wishlist
        if (arrVariations.count > 0) {
            [Util logAddedToWishlistEvent:[NSString stringWithFormat:@"%d",product.product_id] contentType:product.name currency:appDelegate.strCurrencySymbol valToSum:[[[arrVariations objectAtIndex:0] valueForKey:@"price"] doubleValue]];
        }
        
        if ([Util getBoolData:kLogin]) {
            [self addItemToWishList:[NSString stringWithFormat:@"%d", product.product_id]];
        } else {
            //for animation of Button
            //for zoom in
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            [arr addObject:[NSString stringWithFormat:@"%d", product.product_id]];
            
            [Util setArray:arr setData:kWishList];
            //            NSLog(@"%@",[Util getArrayData:kWishList]);
            
            [UIView animateWithDuration:0.4f animations:^{
                
                [self.imgWishList setImage:[UIImage imageNamed:@"IconInWishList"]];
                [Util setPrimaryColorImageView:self.imgWishList];
                
                self.imgWishList.transform = CGAffineTransformMakeScale(1.3, 1.3);
            } completion:^(BOOL finished){
                
                // for zoom out
                [UIView animateWithDuration:0.4f animations:^{
                    
                    self.imgWishList.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }];
            NSString *message = [MCLocalization stringForKey:@"Item Added to your Wish List."];
            
            NSLog(@"Product Added to wishlist successfully!");
            [Util showPositiveMessage:message];
        }
    }
}

-(IBAction)btnImageFullViewClick:(id)sender { }

-(IBAction)btnBackClick:(id)sender {
    appDelegate.arrVariations = [[NSMutableArray alloc] init];
    appDelegate.arrSelectedVariable = [[NSMutableArray alloc] init];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnNotificationClicked:(id)sender {
    [appDelegate Notification:self];
}

-(IBAction)btnSearchClicked:(id)sender {
    [appDelegate Search:self];
}

-(IBAction)btnShareClicked:(id)sender {
    if ([DEEP_LINK_DOMAIN isEqualToString:@""]) {
        [Util shareURL:product.permalink productid:productId viewController:self];
    } else {
        NSString *strDesc = self.txtQuickOverview.text;
        if (strDesc.length >= 300) {
            strDesc = [strDesc substringToIndex:300];
        }
        [Util generateDeepLink:product desc:strDesc viewController:self];
    }
}

-(IBAction)btnAllReviewsClicked:(id)sender {
    AllReviewsVC *vc = [[AllReviewsVC alloc] initWithNibName:@"AllReviewsVC" bundle:nil];
    vc.arrComments = arrComments;
    vc.fromProductDetail = true;
    vc.strTitle = [MCLocalization stringForKey:@"Review"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.colRelatedProducts) {
        return arrRelatedProducts.count;
    } else if(collectionView.tag == 1) {
        //colColor
        if ([product.arrAttributes count] > 0) {
            return [[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] count];
        }
    } else if(collectionView.tag == 111) {
        return [self.arrData count];
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.colRelatedProducts) {
        //related view cell
        
        static NSString *identifier = @"ShopDataGridCell";
        
        ShopDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopDataGridCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        //    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary:[arrData ]]
        Product *object = [arrRelatedProducts objectAtIndex:indexPath.row];
        
        cell.btnWishList.hidden = YES;
        
        cell.lblTitle.text = object.name;
        cell.lblTitle.textColor = FontColorGray;
        cell.lblTitle.font=Font_Size_Product_Name_Small;
        
        if ([object.arrImages count] > 0) {
            [cell.act startAnimating];
            [Util setPrimaryColorActivityIndicator:cell.act];
            [cell.imgProduct sd_setImageWithURL:[Util EncodedURL:[[object.arrImages objectAtIndex:0] valueForKey:@"src"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                cell.imgProduct.image = image;
                [cell.act stopAnimating];
            }];
        }
        
        NSString * htmlString = object.price_html;
        cell.lblRate.attributedText = [Util setPriceForItemSmall:htmlString];
        [cell.lblRate setTextAlignment:NSTextAlignmentCenter];
        
        //shadow to cell
        cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        cell.layer.shadowRadius = 1.0f;
        cell.layer.shadowOpacity = 0.5f;
        cell.layer.masksToBounds = NO;
        cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
        
        [Util setTriangleLable:cell.vwDiscount product:object];

        return cell;
    } else if(collectionView.tag == 1) {
        //colColor
        static NSString *identifier = @"ColorAndSizeCell";
        
        ColorAndSizeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ColorAndSizeCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.imgIcon.hidden = YES;
        
        if([product.arrAttributes count] > 0) {
            cell.lblTitle.text = [[[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] objectAtIndex:indexPath.row] capitalizedString];
            
            if (appDelegate.arrSelectedVariable.count > 0) {
                if ([[appDelegate.arrSelectedVariable objectAtIndex:0] isEqualToString:[[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] objectAtIndex:indexPath.row]]) {
                    cell.imgBG.hidden = NO;
                    if ([fromServer isEqualToString:@"1"]) {
                        cell.imgBG.image = [UIImage imageNamed:@"SizeColorSelectedBG"];
                        [Util setPrimaryColorImageView:cell.imgBG];
                    } else {
                        cell.imgBG.image = [UIImage imageNamed:@"SizeColorSelectedBG"];
                    }
                    cell.imgRightTick.hidden = NO;
                } else {
                    cell.imgBG.hidden = YES;
                    cell.imgRightTick.hidden = YES;
                }
            }
        }
        cell.lblTitle.font = Font_Size_Product_Name_Small;
        return cell;
    } else if(collectionView.tag == 111) {
        static NSString *identifier = @"VariationItemCell";
        
        VariationItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VariationItemCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.lblTitle.text = [self.arrData objectAtIndex:indexPath.row];
        
        if (appDelegate.arrSelectedVariable.count > 0) {
            if ([[self.arrData objectAtIndex:indexPath.row] isEqualToString:[appDelegate.arrSelectedVariable objectAtIndex:self.CellNumber]]) {
                if ([fromServer isEqualToString:@"1"]) {
                    cell.imgBG.image = [UIImage imageNamed:@"SizeColorSelectedBG"];
                    [Util setPrimaryColorImageView:cell.imgBG];
                } else {
                    cell.imgBG.image = [UIImage imageNamed:@"SizeColorSelectedBG"];
                }
            } else {
                if ([fromServer isEqualToString:@"1"]) {
                    cell.imgBG.image = [UIImage imageNamed:@"SizeColorSelectedBG"];
                    [Util setPrimaryColorImageView:cell.imgBG];
                } else {
                    cell.imgBG.image = [UIImage imageNamed:@"SizeColorSelectedBG"];
                }
            }
            int available = 0;
            for (int i = 0; i < appDelegate.arrVariations.count; i++) {
                available = 0;
                for (int j = 0; j < appDelegate.arrSelectedVariable.count; j++) {
                    if ([[[appDelegate.arrVariations objectAtIndex:i] valueForKey:@"attributes"] count] <= j) {
                        if (available == j - 1) {
                            available = (int)appDelegate.arrSelectedVariable.count;
                        }
                    } else if ([[appDelegate.arrSelectedVariable objectAtIndex:j] isEqualToString:[[[[appDelegate.arrVariations objectAtIndex:i] valueForKey:@"attributes"] objectAtIndex:j] valueForKey:@"option"]]) {
                        available++;
                    }
                    if (available == appDelegate.arrSelectedVariable.count) {
                        break;
                    }
                }
                if (available == appDelegate.arrSelectedVariable.count) {
                    break;
                }
            }
            
            VariableItemDetailVC *vc = [[VariableItemDetailVC alloc] initWithNibName:@"VariableItemDetailVC" bundle:nil];
            vc.lblProductNotAvailable.hidden = NO;
            
            if (available < appDelegate.arrSelectedVariable.count) {
                //not available
                NSLog(@"Product is not available");
                vc.lblProductNotAvailable.hidden = NO;
                [Util showPositiveMessage:[MCLocalization stringForKey:@"This Combination doesn't exist. Choose another variant."]];
                //                cell.alpha = 0.3;
            } else if(available == appDelegate.arrSelectedVariable.count) {
                //availabel
                NSLog(@"Product is available");
                vc.lblProductNotAvailable.hidden = YES;
                //                cell.alpha = 1.0;
            }
        }
        cell.lblTitle.font = Font_Size_Product_Name_Small;
        return cell;
    } else {
        return nil;
    }
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.colRelatedProducts) {
        [self redirectToProductDetail:[arrRelatedProducts objectAtIndex:indexPath.row]];
    } else if (collectionView.tag == 1) {
        //colColor
        [self ShowPopUp:self.vwColorSizePopup];
        [collectionView reloadData];
    } else if(collectionView.tag == 111) {
        [appDelegate.arrSelectedVariable removeObjectAtIndex:self.CellNumber];
        [appDelegate.arrSelectedVariable insertObject:[self.arrData objectAtIndex:indexPath.row] atIndex:self.CellNumber];
        
        arrSelectedVariationOption = [[NSMutableArray alloc] initWithArray:appDelegate.arrSelectedVariable];
        
        [self.tblVariationData reloadData];
        [self.tblVariationDataInView reloadData];
    }
}

-(void)redirectToProductDetail:(Product*)product {
    [appDelegate setRecentProduct:product];
    if ([product.type1 isEqualToString:@"external"]) {
        NSString *strUrl = @"";
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


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 1) {
        //colColor
        return 10.0;
    } else if(collectionView.tag == 111) {
        return 10.0;
    }
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if(collectionView == self.colRelatedProducts) {
        return UIEdgeInsetsMake(0, 8, 0, 8);
    } else if (collectionView.tag == 1) {
        //colColor
        return UIEdgeInsetsMake(0, 5, 0, 5);
    } else if (collectionView.tag == 111) {
        //colColor
        return UIEdgeInsetsMake(0, 5, 0, 5);
    }
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if(collectionView == self.colRelatedProducts) {
        return CGSizeMake(149 * SCREEN_SIZE.width/375, collectionView.frame.size.height - 4);
    } else if(collectionView.tag == 1) {
        //colColor
        return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    } else if(collectionView.tag == 111) {
        //colColor
        return CGSizeMake(collectionView.frame.size.height, collectionView.frame.size.height);
    } else {
        return CGSizeMake(0, 0);
    }
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        if (arrComments.count > 3) {
            return 3;
        }
        return arrComments.count;
    } else if(tableView.tag == 101 || tableView == self.tblVariationDataInView) {
        //data
        return [product.arrAttributes count];
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        static NSString *simpleTableIdentifier = @"Rate&ReviewCell";
        
        Rate_ReviewCell *cell = (Rate_ReviewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Rate&ReviewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.lblTime.font = Font_Size_Product_Name_Regular;
        cell.lblReview.font = Font_Size_Product_Name;
        cell.lblRate.font = Font_Size_Product_Name_Small;
        cell.btnMore.titleLabel.font = Font_Size_Product_Name_Not_Bold;
        
        cell.lblReview.textColor = FontColorGray;
        [Util setPrimaryColorButtonTitle:cell.btnMore];
        
        cell.lblDescription.text = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"review"];
        [cell.lblDescription sizeToFit];
        
        cell.lblRate.text = [[[arrComments objectAtIndex:indexPath.row] valueForKey:@"rating"] stringValue];
        cell.lblName.text = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"name"];
        [cell.lblName sizeToFit];
        cell.lblReview.text = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"name"];
        
        NSString *strTime = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"date_created_gmt"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *dateFromString = [dateFormatter dateFromString:strTime];
        
        [dateFormatter setDateFormat:@"MMM dd, yyyy"];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        NSString *timestamp = [dateFormatter stringFromDate:dateFromString];
        NSLog(@"%@",timestamp);
        cell.lblTime.text = timestamp;
        [cell.lblTime sizeToFit];
        
        [cell.btnMore setTitle:[MCLocalization stringForKey:@"More >"] forState:UIControlStateNormal];
        
        cell.lblDescription.frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblReview.frame.origin.y + cell.lblReview.frame.size.height + 4, cell.frame.size.width - 46, cell.lblDescription.frame.size.height);
        
        cell.lblName.frame = CGRectMake(cell.lblName.frame.origin.x, cell.lblDescription.frame.origin.y + cell.lblDescription.frame.size.height + 8, cell.lblName.frame.size.width, cell.lblName.frame.size.height);
        
        cell.lblName.hidden = YES;
        cell.lblTime.frame = CGRectMake(cell.lblName.frame.origin.x, cell.lblName.frame.origin.y, cell.lblTime.frame.size.width, cell.lblName.frame.size.height);
        
        cell.btnMore.frame = CGRectMake(cell.btnMore.frame.origin.x, cell.lblName.frame.origin.y + cell.lblName.frame.size.height + 4, cell.btnMore.frame.size.width, cell.btnMore.frame.size.height);
        
        if (indexPath.row == arrComments.count - 1) {
            cell.Devider.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblDescription.font = Font_Size_Product_Name_Regular;
        
        if (appDelegate.isRTL) {
            //RTL
            cell.lblDescription.textAlignment = NSTextAlignmentRight;
            cell.lblName.textAlignment = NSTextAlignmentRight;
            cell.lblTime.textAlignment = NSTextAlignmentRight;
            cell.lblReview.textAlignment = NSTextAlignmentRight;
            
            cell.vwRating.frame = CGRectMake(tableView.frame.size.width - cell.vwRating.frame.size.width - 22, cell.vwRating.frame.origin.y, cell.vwRating.frame.size.width, cell.vwRating.frame.size.height);
            cell.lblReview.frame = CGRectMake(22, cell.lblReview.frame.origin.y, cell.lblReview.frame.size.width, cell.lblReview.frame.size.height);
            cell.lblTime.frame = CGRectMake(tableView.frame.size.width - cell.lblTime.frame.size.width - 22, cell.lblTime.frame.origin.y, cell.lblTime.frame.size.width, cell.lblTime.frame.size.height);
        } else {
            cell.lblReview.frame = CGRectMake(71, cell.lblReview.frame.origin.y, cell.lblReview.frame.size.width, cell.lblReview.frame.size.height);
        }
        return cell;
    } else if(tableView.tag == 101 || tableView == self.tblVariationDataInView) {
        //data
        static NSString *simpleTableIdentifier = @"VariationCell";
        
        VariationCell *cell = (VariationCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VariationCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.delegate=self;
        
        cell.CellNumber = (int)indexPath.row;
        self.CellNumber = (int)indexPath.row;
        
        cell.lblTitle.text = [[[product.arrAttributes objectAtIndex:indexPath.row] valueForKey:@"name"] capitalizedString];
        
        [Util setPrimaryColorLabelText:cell.lblTitle];
        
        cell.arrData = [[NSMutableArray alloc] init];
        cell.arrData = [[[product.arrAttributes objectAtIndex:indexPath.row] valueForKey:@"options"] mutableCopy];
        
        cell.arrNewData = [[NSMutableArray alloc] init];
        if ([[product.arrAttributes objectAtIndex:indexPath.row] valueForKey:@"new_options"]) {
            cell.arrNewData = [[[product.arrAttributes objectAtIndex:indexPath.row] valueForKey:@"new_options"] mutableCopy];
        }
        [cell.colItem reloadData];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.lblTitle.font = Font_Size_Product_Name;
        if (appDelegate.isRTL) {
            //RTL
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
        }
        return cell;
    } else {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1) {
        static NSString *simpleTableIdentifier = @"Rate&ReviewCell";
        
        Rate_ReviewCell *cell = (Rate_ReviewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"Rate&ReviewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.lblDescription.text = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"review"];
        [cell.lblDescription sizeToFit];
        
        return cell.frame.size.height + cell.lblDescription.frame.size.height + 4;
    } else if(tableView.tag == 101) {
        return 130;
    } else if(tableView == self.tblVariationDataInView) {
        return 100;
    } else {
        return 0;
    }
}

#pragma mark - Popup Show and Hide

-(void)ShowPopUp:(UIView*)popup {
    arrPreviousSelection = [[NSMutableArray alloc] init];
    arrPreviousSelection = [appDelegate.arrSelectedVariable mutableCopy];
    arrPreviousImages = [[NSMutableArray alloc] init];
    arrPreviousImages = [arrImages mutableCopy];
    
    self.lblProductNotAvailable.hidden = YES;
    
    self.vwPopupBG.hidden = NO;
    popup.hidden=NO;
    popup.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:0.4 animations:^{
        self.vwPopupBG.alpha = 1.0;
        popup.transform = CGAffineTransformIdentity;
    }];
}

-(void)HidePopUp:(UIView*)popup {
    popup.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        popup.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.vwPopupBG.alpha = 0.0;
    } completion:^(BOOL finished){
        
        popup.hidden = YES;
        self.vwPopupBG.hidden = YES;
    }];
}

#pragma mark - Actionsheet

- (void)onOpenWith:(UIButton *)theButton path:(NSString *)path {
    NSURL *URL = [NSURL fileURLWithPath:path];
    if (URL) { }
}


#pragma mark - Page controller

- (void)updateDots {
    // this only needs to be done one time
    // 7x7 image (@1x)
    self.pageController.currentPageIndicatorTintColor = [Util colorWithHexString:[Util getStringData:kPrimaryColor]];
    self.pageController.pageIndicatorTintColor = [UIColor darkGrayColor];
}

#pragma mark - Hide Bottom bar

-(BOOL)hidesBottomBarWhenPushed {
    return YES;
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - API calls

-(void)getAllReviews {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict = nil;
    
    oneStar = twoStar = threeStar = fourStar = fiveStar = 0;
    arrComments = [[NSMutableArray alloc] init];
    //    SHOW_PROGRESS(@"Please Wait..");
    SHOW_LOADER_ANIMTION();
    [CiyaShopAPISecurity getReviews:productId completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        [self reviewData:dictionary message:message success:success];
    }];
}

- (void) reviewData:(NSDictionary*)dictionary message:(NSString*)message success:(BOOL)success {
    if(success) {
        //no error
        if (dictionary.count>0) {
            NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
            for (int i = 0; i < arrData.count; i++) {
                [arrComments addObject:[arrData objectAtIndex:i]];
                if ([[[[arrData objectAtIndex:i] valueForKey:@"rating"] stringValue] isEqualToString:@"1"]) {
                    oneStar++;
                } else if ([[[[arrData objectAtIndex:i] valueForKey:@"rating"] stringValue] isEqualToString:@"2"]) {
                    twoStar++;
                } else if ([[[[arrData objectAtIndex:i] valueForKey:@"rating"] stringValue] isEqualToString:@"3"]) {
                    threeStar++;
                } else if ([[[[arrData objectAtIndex:i] valueForKey:@"rating"] stringValue] isEqualToString:@"4"]) {
                    fourStar++;
                } else if ([[[[arrData objectAtIndex:i] valueForKey:@"rating"] stringValue] isEqualToString:@"5"]) {
                    fiveStar++;
                }
            }
            [self.tblRateReview reloadData];
            self.vwLast.frame = CGRectMake(self.vwLast.frame.origin.x, self.vwLast.frame.origin.y, self.vwLast.frame.size.width, self.tblRateReview.contentSize.height);
            
            self.vwBorder.frame = CGRectMake(self.vwDetailViewData.frame.origin.x, self.vwDetailViewData.frame.origin.y, self.vwDetailViewData.frame.size.width, self.vwDetailViewData.frame.size.height  + self.vwRateWriteReview.frame.size.height + self.vwLast.frame.size.height + 8);
            [self setBorderForReview];
            [self setSlider];
        } else {
            self.vwLast.frame = CGRectMake(self.vwLast.frame.origin.x, self.vwRateWriteReview.frame.origin.y + self.vwRateWriteReview.frame.size.height, self.vwLast.frame.size.width, 0);
            self.vwBorder.frame = self.vwDetailViewData.frame;
            [self setBorderForReview];
        }
    } else {
        //error
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
    HIDE_PROGRESS;
    [self setDefaultData];
    
    arrColorImage = [[NSMutableArray alloc] init];
    arrVariations = [[NSMutableArray alloc] init];
    page = 1;
    
    [self getVariations];
}

- (void)getVariations {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [dict setValue:@"100" forKey:@"per_page"];
    
    self.colColor.allowsSelection = NO;
    self.btnNumberOfColor.userInteractionEnabled = NO;
    if (page == 1) {
        SHOW_LOADER_ANIMTION();
    }
    [CiyaShopAPISecurity getVariations:dict productid:productId completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        [self variationData:dictionary message:message success:success];
    }];
}

- (void)variationData:(NSDictionary*)dictionary message:(NSString*)message success:(BOOL)success {
    if (success == YES) {
        //no error
        if (dictionary.count > 0) {
            NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
            for (int i = 0; i < arrData.count; i++) {
                [arrVariations addObject:[arrData objectAtIndex:i]];
            }
            if (arrVariations.count > 0 && page == 1) {
                // Facebook Pixel for Product content view
                [Util logViewedContentEvent:product.name contentId:[NSString stringWithFormat:@"%d", product.product_id] currency:appDelegate.strCurrencySymbol valToSum:[[[arrVariations objectAtIndex:0] valueForKey:@"price"] doubleValue]];
            }
            if (arrVariations.count >= 100) {
                page++;
                [self getVariations];
            } else {
                [self.tblVariationData reloadData];
                [self.tblVariationDataInView reloadData];
                [self setFrames];
                HIDE_PROGRESS;
            }
        } else {
            HIDE_PROGRESS;
        }
            [self checkSelectedVariation];
        [self.colColor reloadData];
        self.colColor.allowsSelection = YES;
        self.btnNumberOfColor.userInteractionEnabled = YES;
        [self checkVariationAvailability];
    } else {
        //error
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
        HIDE_PROGRESS;
    }
}

-(void)checkSelectedVariation {
    appDelegate.arrVariations = [[NSMutableArray alloc] initWithArray:arrVariations];
    appDelegate.arrSelectedVariable = [[NSMutableArray alloc] init];
    
    if (arrVariations.count > 0 && product.arrAttributes.count > 0) {
        if ([[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] count] > 0) {
            [appDelegate.arrSelectedVariable addObject:[[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] objectAtIndex:0]];
        }
    }
    if (arrVariations.count > 0 && product.arrAttributes.count > 0) {
        for (int i = 0; i < arrVariations.count; i++) {
            Boolean flag = false;
            NSArray *arrAtrb = [[NSArray alloc] initWithArray:[[arrVariations objectAtIndex:i] valueForKey:@"attributes"]];
            if ([[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] count] > 0) {
                if (arrAtrb.count > 0 && [[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] objectAtIndex:0] == [[arrAtrb objectAtIndex:0] valueForKey:@"option"]) {
                    for (int j = 1; j < arrAtrb.count; j++) {
                        [appDelegate.arrSelectedVariable addObject:[[arrAtrb objectAtIndex:j] valueForKey:@"option"]];
                        flag = true;
                    }
                }
            }
            if (flag) {
                break;
            }
        }
    }
    
    if (arrVariations.count > 0 && product.arrAttributes.count > 0) {


    if (appDelegate.arrSelectedVariable.count != product.arrAttributes.count) {
        for (int i = 0; i < product.arrAttributes.count; i++) {
            Boolean flag = false;
            for (int j = 0; j < [[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] count]; j++) {
                if ([appDelegate.arrSelectedVariable containsObject:[[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] objectAtIndex:j]]) {
                    //contains
                    flag = true;
                    break;
                }
            }
            if (!flag) {
                //not contains value of attribute
                if ([[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] count] > 0 && appDelegate.arrSelectedVariable.count == i) {
                    int pos = 0;
                    for (int k = 0; k < arrVariations.count; k++) {
                        NSArray *arr = [[[arrVariations objectAtIndex:k] valueForKey:@"attributes"] mutableCopy];
                        int count = 0;
                        if (arr.count > appDelegate.arrSelectedVariable.count) {
                            for (int m = 0; m < arr.count; m++) {
                                if ([appDelegate.arrSelectedVariable containsObject:[[arr objectAtIndex:m] valueForKey:@"option"]]) {
                                    count++;
                                }
                                if (count == appDelegate.arrSelectedVariable.count) {
                                    pos = k;
                                    break;
                                }
                            }
                        }
                    }
                    NSArray *arr = [[[arrVariations objectAtIndex:pos] valueForKey:@"attributes"] mutableCopy];
                    NSArray *arrAttr = [[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] mutableCopy];

                    int posNew = 0;
                    for (int k = 0; k < arr.count; k++) {
                        if ([arrAttr containsObject:[[arr objectAtIndex:k] valueForKey:@"option"]]) {
                            posNew = (int)[arrAttr indexOfObject:[[arr objectAtIndex:k] valueForKey:@"option"]];
                            break;
                        }
                    }
                    [appDelegate.arrSelectedVariable insertObject:[[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] objectAtIndex:posNew] atIndex:i];
                }
            }
        }
    }

    }
    if (appDelegate.arrSelectedVariable.count != product.arrAttributes.count) {
        for (int j = 0; j < product.arrAttributes.count; j++) {
            BOOL flag = false;
            NSArray *arr = [[NSArray alloc] initWithArray:[[product.arrAttributes objectAtIndex:j] valueForKey:@"options"]];
            for (int i = 0; i < arr.count; i++) {
                if ([appDelegate.arrSelectedVariable containsObject:[arr objectAtIndex:i]]) {
                    flag = true;
                    break;
                }
            }
            if (!flag && arr.count != 0) {
                [appDelegate.arrSelectedVariable insertObject:[arr objectAtIndex:0] atIndex:j];
            }
        }
    }
    arrSelectedVariationOption = [[NSMutableArray alloc] initWithArray:appDelegate.arrSelectedVariable];
}

-(void)getSelectedVariation {
    appDelegate.arrVariations = [[NSMutableArray alloc] initWithArray:arrVariations];
    appDelegate.arrSelectedVariable = [[NSMutableArray alloc] initWithArray:arrSelectedVariationOption];
}

-(void)getRelatedProduct {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (product.arrRelated_ids > 0 && arrRelatedProducts.count == 0) {
        NSString *joinedComponents = [product.arrRelated_ids componentsJoinedByString:@","];
        [dict setValue:joinedComponents forKey:@"include"];
    } else {
        return;
    }
    [self.actRelatedProduct startAnimating];
    
    [CiyaShopAPISecurity productListing:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        [self.actRelatedProduct stopAnimating];
        if (success)
        {
            //HIDE_PROGRESS;
            if (dictionary.count > 0) {
                if (dictionary.count > 0) {
                    NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                    self->arrRelatedProducts = [[NSMutableArray alloc] init];
                    for (int  i = 0; i < arrData.count; i++) {
                        Product *object = [Util setProductData:[arrData objectAtIndex:i]];
                        [self->arrRelatedProducts addObject:object];
                    }
                    self.vwRelatedProducts.hidden = false;
                    self.vwRelatedTitle.hidden = false;
                    self.colRelatedProducts.hidden = false;
                    [self.colRelatedProducts reloadData];
                }
            }
        } else {
            HIDE_PROGRESS;
            if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, appDelegate.window.rootViewController);
            } else {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
            }
        }
    }];
}

-(void)checkPincode {
    SHOW_LOADER_ANIMTION();
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.txtPincode.text forKey:@"pincode"];
    [dict setValue: [NSString stringWithFormat:@"%d",self.product.product_id] forKey:@"product_id"];

    [CiyaShopAPISecurity checkDeliveryToPincode:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        NSLog(@"%@", dictionary);
        HIDE_PROGRESS;
        if (success) {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"]) {
                //available
                self.lblPincodeAvailabilityText.text = [NSString stringWithFormat:@"%@ %@", appDelegate.pincodeConfigData.availableat_text, self.txtPincode.text];
            } else {
                //not available
                self.lblPincodeAvailabilityText.text = [NSString stringWithFormat:@"%@ %@", appDelegate.pincodeConfigData.cod_not_available_msg, self.txtPincode.text];
            }
        } else {
            if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, appDelegate.window.rootViewController);
            }
            else
            {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
            }
        }
    }];
}
#pragma mark - ClickDelegate Delegate

-(void)shouldReloadTable:(NSMutableArray *)arr {
    //    [self.tblVariationData beginUpdates];
    //    [self.tblVariationData reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
    //    [self.tblVariationData endUpdates];
    //
    //    [self.tblVariationDataInView beginUpdates];
    //    [self.tblVariationDataInView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
    //    [self.tblVariationDataInView endUpdates];
    
    BOOL Check = [self checkVariationAvailability];
    if (!Check) {
        return;
    }
}

-(BOOL)checkVariationAvailability {
    int available = 0;
    int selectedVariation = -1;
    
    BOOL inStock = false;
    for (int i = 0; i < appDelegate.arrVariations.count; i++) {
        available = 0;
        NSMutableArray *arrAttribute = [[NSMutableArray alloc] init];
        for (int k = 0; k < [[[appDelegate.arrVariations objectAtIndex:i] valueForKey:@"attributes"] count]; k++) {
            [arrAttribute addObject:[[[[appDelegate.arrVariations objectAtIndex:i] valueForKey:@"attributes"] objectAtIndex:k] valueForKey:@"option"]];
        }
        for (int j = 0; j < appDelegate.arrSelectedVariable.count; j++) {
            if ([arrAttribute containsObject:[appDelegate.arrSelectedVariable objectAtIndex:j]]) {
                available++;
            }
            if (available == appDelegate.arrSelectedVariable.count) {
                break;
            }
        }
        
        if ([arrAttribute count] < appDelegate.arrSelectedVariable.count) {
            if (available == arrAttribute.count || available > arrAttribute.count) {
                NSString * htmlString = [NSString stringWithFormat:@"%@", [[arrVariations objectAtIndex:i] valueForKey:@"price_html"]];
                [self setPriceLabel:htmlString];
                selectedVariation = i;
                if (product.manageStock) {
                    if([[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue] > 0) {
                        inStock = true;
                    }
                } else {
                    if ([[arrVariations objectAtIndex:i] objectForKey:@"manage_stock"]) {
                        //MANAGE STOCK IS AVAILABLE
                        NSNumber* stockActive = [[arrVariations objectAtIndex:i] valueForKey:@"manage_stock"];
                        if ([stockActive boolValue]) {
                            if([[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue] > 0) {
                                inStock = true;
                            }
                        } else {
                            inStock = true;
                        }
                    } else {
                        //MANAGE STOCK IS NOT AVAILABLE
                        inStock = [[[arrVariations objectAtIndex:i] valueForKey:@"in_stock"] boolValue];
                    }
                }
                available = (int)appDelegate.arrSelectedVariable.count;
                break;
            }
        }
        if (available == appDelegate.arrSelectedVariable.count) {
            NSString * htmlString = [NSString stringWithFormat:@"%@", [[arrVariations objectAtIndex:i] valueForKey:@"price_html"]];
            inStock = [[[arrVariations objectAtIndex:i] valueForKey:@"in_stock"] boolValue];
            selectedVariation = i;
            [self setPriceLabel:htmlString];
            break;
        }
    }
    
    if (available < appDelegate.arrSelectedVariable.count) {
        //not available
        NSLog(@"Product is not available");
        self.btnDone.userInteractionEnabled = NO;
        self.btnDone.alpha = 0.6;
        self.lblProductNotAvailable.hidden = NO;
        [Util showPositiveMessage:[MCLocalization stringForKey:@"This Combination doesn't exist. Choose another variant."]];
        return NO;
    } else if(available == appDelegate.arrSelectedVariable.count) {
        //available
        if (!inStock) {
            //No stock available
            self.lblInStock.text = [MCLocalization stringForKey:@"Out of Stock"];
            self.lblInStock.textColor = [UIColor redColor];
            
            self.btnAddToCart.enabled = NO;
            self.btnBuyNow.enabled = NO;
            
            self.btnAddToCart.alpha = 0.3;
            self.btnBuyNow.alpha = 0.3;
        } else {
            self.lblInStock.text = [MCLocalization stringForKey:@"In Stock"];
            [Util setPrimaryColorLabelText:self.lblInStock];
            
            self.btnAddToCart.enabled = YES;
            self.btnBuyNow.enabled = YES;
            
            self.btnAddToCart.alpha = 1.0;
            self.btnBuyNow.alpha = 1.0;
        }
        
        arrImages = [[NSMutableArray alloc] init];
        if (selectedVariation == -1) {
            for(int i = 0; i < [product.arrImages count]; i++) {
                if (product.arrImages.count > 1) {
                    if (![[[product.arrImages objectAtIndex:i] valueForKey:@"src"] containsString:kPlaceholderText]) {
                        [arrImages addObject:[[product.arrImages objectAtIndex:i] valueForKey:@"src"]];
                    }
                } else {
                    [arrImages addObject:[[product.arrImages objectAtIndex:i] valueForKey:@"src"]];
                }
            }
        } else {
            BOOL imageset = false;
            if ([[[[arrVariations objectAtIndex:selectedVariation] valueForKey:@"image"] valueForKey:@"src"] containsString:kPlaceholderText]) {
                imageset = true;
            } else {
                imageset = false;
                [arrImages addObject:[[[arrVariations objectAtIndex:selectedVariation] valueForKey:@"image"] valueForKey:@"src"]];
            }
            if (imageset) {
                for(int i = 0; i < [product.arrImages count]; i++) {
                    if (product.arrImages.count > 1) {
                        if (![[[product.arrImages objectAtIndex:i] valueForKey:@"src"] containsString:kPlaceholderText]) {
                            [arrImages addObject:[[product.arrImages objectAtIndex:i] valueForKey:@"src"]];
                        }
                    } else {
                        [arrImages addObject:[[product.arrImages objectAtIndex:i] valueForKey:@"src"]];
                    }
                }
            } else {
                if (arrVariations.count > 0 && product.arrAttributes.count > 0) {
                    if ([[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] count] > 0) {
                        if ([appDelegate.arrSelectedVariable containsObject:[[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] objectAtIndex:0]]) {
                            for(int i = 0; i < [product.arrImages count]; i++) {
                                if (![[[product.arrImages objectAtIndex:i] valueForKey:@"src"] containsString:kPlaceholderText]) {
                                    [arrImages addObject:[[product.arrImages objectAtIndex:i] valueForKey:@"src"]];
                                }
                            }
                        }
                    }
                }
            }
            NSMutableDictionary *dictSelectedVariation = [[NSMutableDictionary alloc] init];
            for (int i = 0; i < appDelegate.arrSelectedVariable.count; i++) {
                [dictSelectedVariation setValue:[appDelegate.arrSelectedVariable objectAtIndex:i] forKey:[[product.arrAttributes objectAtIndex:i] valueForKey:@"name"]];
            }
            Boolean flag = [Util checkInCart:product variation:[[[arrVariations objectAtIndex:selectedVariation] valueForKey:@"id"] intValue] attribute:dictSelectedVariation];
            
            if (flag) {
                [self.btnAddToCart setTitle:[MCLocalization stringForKey:@"GO TO CART"] forState:UIControlStateNormal];
            } else {
                [self.btnAddToCart setTitle:[MCLocalization stringForKey:@"ADD TO CART"] forState:UIControlStateNormal];
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setScrollingImages];
        });
        NSLog(@"Product is available");
        self.btnDone.userInteractionEnabled = YES;
        self.btnDone.alpha = 1.0;
        self.lblProductNotAvailable.hidden = YES;
        arrSelectedVariationOption = [[NSMutableArray alloc] initWithArray:appDelegate.arrSelectedVariable];
        return YES;
    }
    return  NO;
}

-(void)setPriceLabel:(NSString*)str {
    self.lblDiscountRate.attributedText = [Util setPriceForItem:str];
    [self.lblDiscountRate sizeToFit];
    if (appDelegate.isRTL) {
        //RTL
        self.lblDiscountRate.frame = CGRectMake(self.view.frame.size.width - self.lblDiscountRate.frame.size.width - 8, self.lblName.frame.origin.y + self.lblName.frame.size.height + 5, self.lblDiscountRate.frame.size.width, self.lblDiscountRate.frame.size.height);
    }
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
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                [arr addObject:[NSString stringWithFormat:@"%d", self->product.product_id]];
                [Util setArray:arr setData:kWishList];
                
                //for animation of Button
                //for zoom in
                [UIView animateWithDuration:0.4f animations:^{
                    [self.imgWishList setImage:[UIImage imageNamed:@"IconInWishList"]];
                    [Util setPrimaryColorImageView:self.imgWishList];
                    self.imgWishList.transform = CGAffineTransformMakeScale(1.3, 1.3);
                } completion:^(BOOL finished){
                    // for zoom out
                    [UIView animateWithDuration:0.4f animations:^{
                        self.imgWishList.transform = CGAffineTransformMakeScale(1, 1);
                    }];
                }];
            } else {
                NSLog(@"Something Went Wrong while adding in Wishlist.");
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                [arr addObject:productID];
                [Util setArray:arr setData:kWishList];
            }
        } else {
            HIDE_PROGRESS;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            [arr addObject:productID];
            
            [Util setArray:arr setData:kWishList];
            
            ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
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
    }];
}

- (void)removeItemFromWishList:(NSString*)productID {
    SHOW_LOADER_ANIMTION();
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
                [self.imgWishList setImage:[UIImage imageNamed:@"IconWishList"]];
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
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                [arr addObject:productID];
                [Util setArray:arr setData:kWishList];
                NSLog(@"Something Went Wrong while adding in Wishlist.");
            }
        } else {
            HIDE_PROGRESS;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            [arr addObject:productID];
            [Util setArray:arr setData:kWishList];
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
    }];
}

#pragma mark - StatusBar Delegate
/*!
 * @discussion This method is used to set Status bar text color
 */
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
