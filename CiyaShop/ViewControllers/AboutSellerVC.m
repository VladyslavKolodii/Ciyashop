//
//  AbouSellerVC.m
//  CiyaShop
//
//  Created by Kaushal PC on 03/11/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "AboutSellerVC.h"
#import "ShopDataGridCell.h"
#import "GroupItemDetailVC.h"
#import "VariableItemDetailVC.h"
#import "ItemDetailVC.h"
#import "HomeShopDataVC.h"
#import "SallerReviewCell.h"
#import "ContactSellerVC.h"
#import "AllReviewsVC.h"

#define SPACE 10.0f

@interface AboutSellerVC ()


// UILabel's
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDesc;
@property (strong, nonatomic) IBOutlet UILabel *lblOtherProductsFromVendor;
@property (strong, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet UILabel *lblAbout;
@property (strong, nonatomic) IBOutlet UILabel *lblReviews;

// UIImageView's
@property (strong, nonatomic) IBOutlet UIImageView *imgBanner;
@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;

// UIView's
@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwRating;
@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIView *vwContent;
@property (strong, nonatomic) IBOutlet UIView *vwOtherContent;
@property (strong, nonatomic) IBOutlet UIView *vwReviews;
@property (strong, nonatomic) IBOutlet UIView *vwFooter;

// UICollectionView's
@property (strong, nonatomic) IBOutlet UICollectionView *colProducts;
@property (strong, nonatomic) IBOutlet UITableView *tblReview;

// UIButton's
@property (weak, nonatomic) IBOutlet UIButton *btnContactSeller;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIButton *btnViewAll;
@end

@implementation AboutSellerVC
{
    NSMutableArray *arrProductData, *arrComments;
    NSMutableDictionary *dictSellerDetail;
    int page;
    BOOL flgchk, flag_once;
    BOOL apiCallRunning,dataArrived;
    NSMutableArray *arrWishList;
    
    int selectedIndex;
    NSString *selectedProductId;
    NSArray *arrselect;
    NSArray *arrUnselect;
    NSMutableArray *arrGroupedProduct;

;


}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imgBanner.frame=CGRectMake(0,0,self.view.frame.size.width, 170);

    //Intialization and Assignment
    arrProductData = [[NSMutableArray alloc] init];
    page = 1;
    flag_once = YES;
    
    selectedIndex = -1;

    
    self.vwAllData.hidden = YES;
    
    [Util setSecondaryColorButton:self.btnViewAll];
    
    //Value Assignment
    self.lblTitle.text = self.strTitle;
    NSString * htmlString = self.strDesc;
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    self.lblDesc.attributedText = attrStr;
    
    
    //CollectionviewSetup
    self.colProducts.showsHorizontalScrollIndicator=NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.colProducts setCollectionViewLayout:flowLayout];
    [self.colProducts registerNib:[UINib nibWithNibName:@"ShopDataGridCell" bundle:nil] forCellWithReuseIdentifier:@"ShopDataGridCell"];
    
    
    // webservice Call
    [self GetSellerData];
    
    //Notification center Registration
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //Localization Setup
    [self localize];
    
    // Status bar Setup
    
    if (@available(iOS 13, *))
    {
        UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
        statusBar.backgroundColor = [self averageColor:self.imgBanner.image];
        [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
    }
    else
    {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            statusBar.backgroundColor = [self averageColor:self.imgBanner.image];
        }
    }

    
    arrWishList = [[NSMutableArray alloc] init];
    
    [arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];

}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    // FrameSetup
    self.vwAllData.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
    
    if(appDelegate.isRTL){
        self.btnViewAll.frame = CGRectMake(8, self.btnViewAll.frame.origin.y, self.btnViewAll.frame.size.width, self.btnViewAll.frame.size.height);
    }
    
    self.btnBack.frame = CGRectMake(0, statusBarSize.height, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
}

#pragma mark - Adjust all Frames as per Content
/*!
 * @discussion Setting up a Frame of the page
 */
-(void)setFrames
{
    float size = 0;
    if(flag_once)
    {
        flag_once = NO;
        self.imgProfilePic.frame = CGRectMake((SCREEN_SIZE.width/2) - (60*SCREEN_SIZE.width/375), (self.imgBanner.frame.size.height+self.imgBanner.frame.origin.y) - (60*SCREEN_SIZE.width/375), 120*SCREEN_SIZE.width/375, 120*SCREEN_SIZE.width/375);
        
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width/2;
        self.imgProfilePic.layer.masksToBounds = true;
        [self.imgProfilePic.layer setBorderColor: [[UIColor whiteColor] CGColor]];
        [self.imgProfilePic.layer setBorderWidth: 3.0];
        
        
        self.lblTitle.frame = CGRectMake(8, self.imgProfilePic.frame.origin.y + self.imgProfilePic.frame.size.height + SPACE *SCREEN_SIZE.width/375, self.view.frame.size.width - 16*SCREEN_SIZE.width/375, self.lblDesc.frame.size.height);
        self.vwRating.frame = CGRectMake((self.view.frame.size.width/2) - (self.vwRating.frame.size.width/2), self.lblTitle.frame.origin.y + self.lblTitle.frame.size.height + SPACE*SCREEN_SIZE.width/375, self.vwRating.frame.size.width, self.vwRating.frame.size.height);
        
        if (self.lblDesc.text.length > 0)
        {
            [self.lblDesc sizeToFit];
            self.lblDesc.frame = CGRectMake(8, self.vwRating.frame.origin.y + self.vwRating.frame.size.height + SPACE*SCREEN_SIZE.width/375, self.view.frame.size.width - 16, self.lblDesc.frame.size.height);
            size = SPACE*SCREEN_SIZE.width/375;
        }
        else
        {
            self.lblDesc.frame = CGRectMake(8, self.vwRating.frame.origin.y + self.vwRating.frame.size.height + SPACE*SCREEN_SIZE.width/375, self.view.frame.size.width, 0);
            size = 0;
        }
        
        if (self.lblAbout.text.length > 0)
        {
            [self.lblAbout sizeToFit];
            self.lblAbout.frame = CGRectMake(8, self.lblDesc.frame.origin.y + self.lblDesc.frame.size.height + size, self.view.frame.size.width - 16, self.lblAbout.frame.size.height);
            [self.lblAbout sizeToFit];
            size = SPACE*SCREEN_SIZE.width/375;
        }
        else
        {
            self.lblAbout.frame = CGRectMake(8, self.lblDesc.frame.origin.y + self.lblDesc.frame.size.height + size, self.view.frame.size.width - 16, 0);
            size = 0;
        }
        if (self.btnContactSeller.isHidden) {
            self.btnContactSeller.frame = CGRectMake((SCREEN_SIZE.width/2) - (60*SCREEN_SIZE.width/375), self.lblAbout.frame.origin.y + self.lblAbout.frame.size.height + size, 120*SCREEN_SIZE.width/375, 0);
        }
        else
        {
                    self.btnContactSeller.frame = CGRectMake((SCREEN_SIZE.width/2) - (60*SCREEN_SIZE.width/375), self.lblAbout.frame.origin.y + self.lblAbout.frame.size.height + size, 120*SCREEN_SIZE.width/375, 35*SCREEN_SIZE.width/375);
        }

        
    }
    
    
    if (arrProductData.count > 0)
    {
        self.vwOtherContent.frame = CGRectMake(0,15*SCREEN_SIZE.width/375, self.view.frame.size.width, 60*SCREEN_SIZE.width/375);
        
        if (appDelegate.isRTL)
        {
            self.lblOtherProductsFromVendor.textAlignment = NSTextAlignmentRight;
        }
        else
        {
            self.lblOtherProductsFromVendor.textAlignment = NSTextAlignmentLeft;
        }
        self.lblOtherProductsFromVendor.frame = CGRectMake(8, self.lblOtherProductsFromVendor.frame.origin.y, SCREEN_SIZE.width - 16, self.lblOtherProductsFromVendor.frame.size.height);
        
        self.colProducts.frame = CGRectMake(0, self.vwOtherContent.frame.origin.y + self.vwOtherContent.frame.size.height - 10*SCREEN_SIZE.width/375, self.view.frame.size.width, (SCREEN_SIZE.width*276/375)*ceil(arrProductData.count/2.0)+(6*arrProductData.count-1));
        self.vwFooter.frame = CGRectMake(0, self.vwFooter.frame.origin.y, self.vwFooter.frame.size.width, self.colProducts.frame.origin.y + self.colProducts.frame.size.height);
    }
    else
    {
        self.vwOtherContent.frame = CGRectMake(0, self.btnContactSeller.frame.origin.y + self.btnContactSeller.frame.size.height + 0, SCREEN_SIZE.width, 0);
        self.colProducts.frame = CGRectMake(0, self.vwOtherContent.frame.origin.y, self.view.frame.size.width, 0);
    }

    self.imgBanner.frame=CGRectMake(0,0,self.view.frame.size.width, 170);

    
    if (arrComments.count > 0)
    {
        //Comments are available
        self.vwReviews.frame = CGRectMake(0, self.btnContactSeller.frame.origin.y + self.btnContactSeller.frame.size.height + SCREEN_SIZE.width/375*SCREEN_SIZE.width/375, self.view.frame.size.width, 60*SCREEN_SIZE.width/375);
        self.lblReviews.frame = CGRectMake(8, self.lblReviews.frame.origin.y, self.view.frame.size.width - 16, self.lblReviews.frame.size.height);
        self.vwContent.frame = CGRectMake(0, 0, self.view.frame.size.width, self.vwReviews.frame.origin.y + self.vwReviews.frame.size.height);
    }
    else
    {
        //Comments are not available
        self.vwReviews.frame = CGRectMake(0, self.btnContactSeller.frame.origin.y + self.btnContactSeller.frame.size.height, self.view.frame.size.width, 0);
        self.vwReviews.hidden = YES;
        self.vwContent.frame = CGRectMake(0, 0, self.view.frame.size.width, self.vwReviews.frame.origin.y + self.vwReviews.frame.size.height + SPACE*SCREEN_SIZE.width/375);
    }
    
    [self.tblReview setTableHeaderView:self.vwContent];
    [self.tblReview setTableFooterView:self.vwFooter];
}

#pragma mark - Localize Language

/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    self.lblOtherProductsFromVendor.text = [MCLocalization stringForKey:@"Other Products from this Vendor"];
    self.lblReviews.text = [MCLocalization stringForKey:@"Reviews for this Vendor"];
    
    [self.btnContactSeller setTitle:[MCLocalization stringForKey:@"Contact Seller"] forState:UIControlStateNormal];
    
    [self.btnViewAll setTitle:[MCLocalization stringForKey:@"View All"] forState:UIControlStateNormal];
    self.btnViewAll.layer.cornerRadius = 3;
    self.btnViewAll.layer.masksToBounds = true;
    self.btnViewAll.titleLabel.font = Font_Size_Product_Name_Not_Bold;
    
    [Util setHeaderColorView:self.vwHeader];
    
    [Util setPrimaryColorLabelText:self.lblTitle];
    
    self.lblTitle.font=Font_Size_Navigation_Title;
    self.lblDesc.font = Font_Size_Product_Name_Medium;
    self.lblRating.font = Font_Size_Product_Name_Medium;
    
    [Util setSecondaryColorButton:self.btnContactSeller];
    
    self.btnContactSeller.titleLabel.font = Font_Size_Product_Name;
    
    self.btnContactSeller.layer.cornerRadius = 3;
    self.btnContactSeller.layer.masksToBounds = true;
    
    self.lblAbout.textAlignment = NSTextAlignmentCenter;
    self.lblDesc.textAlignment = NSTextAlignmentCenter;
    self.lblRating.textAlignment = NSTextAlignmentCenter;
    if (appDelegate.isRTL)
    {
        //RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        
        self.lblOtherProductsFromVendor.textAlignment = NSTextAlignmentRight;
        self.lblReviews.textAlignment = NSTextAlignmentRight;
    }
    else
    {
        //NonRTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        
        self.lblOtherProductsFromVendor.textAlignment = NSTextAlignmentLeft;
        self.lblReviews.textAlignment = NSTextAlignmentLeft;
    }
}

#pragma mark - ScrollView Delegate
/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)scrollViewDidScroll:(UIScrollView*)scrollView{
    if(scrollView!=nil){
        CGFloat y = -scrollView.contentOffset.y;
        NSLog(@"%f",y);

        if (y > 0) {
            if (@available(iOS 11.0, *))
            {
                self.imgBanner.frame = CGRectMake(0-y, -y, SCREEN_SIZE.width+2*y, (170)+y);
            }
            else
            {
                self.imgBanner.frame = CGRectMake(0-y, -y, SCREEN_SIZE.width+2*y, (170)+y);
                self.imgBanner.center = CGPointMake(self.view.center.x, self.imgBanner.center.y);
            }
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.imgBanner.frame=CGRectMake(0,0,self.view.frame.size.width, 170);

}


#pragma mark - Button Clicked

/*!
 * @discussion To go previous page
 * @param sender For indentifying sender
 */
-(IBAction)btnViewAllClicked:(id)sender
{
    AllReviewsVC *vc = [[AllReviewsVC alloc] initWithNibName:@"AllReviewsVC" bundle:nil];
    vc.arrComments = arrComments;
    vc.strTitle = self.strTitle;
    [self.navigationController pushViewController:vc animated:YES];
}
/*!
 * @discussion Will Take you to seller Contact page
 * @param sender For indentifying sender
 */
-(IBAction)btnBackClicked:(id)sender
{
    
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
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnContactSellerClicked:(id)sender
{
    if (dictSellerDetail.count > 0)
    {
        ContactSellerVC *vc = [[ContactSellerVC alloc] initWithNibName:@"ContactSellerVC" bundle:nil];
        vc.strSellerID = [dictSellerDetail valueForKey:@"seller_id"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
-(void)btnWishListClicked:(UIButton *)sender
{
    selectedIndex = (int)sender.tag;
    
    Product *object = [arrProductData objectAtIndex:selectedIndex];
    Boolean set1 = NO;
    for (int i=0; i<arrWishList.count; i++)
    {
        if ([[arrWishList objectAtIndex:i] integerValue] == object.product_id)
        {
            set1 = YES;
            [arrWishList removeObjectAtIndex:i];
            break;
        }
    }
    
    if (set1==NO)
    {
        // Facebook Pixel for Add to Wishlist
        
        [Util logAddedToWishlistEvent:[NSString stringWithFormat:@"%d",object.product_id]  contentType:object.name currency:appDelegate.strCurrencySymbol valToSum:object.price];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        arrselect = [[NSArray alloc] initWithObjects:indexPath, nil];
        
        Product *object = [arrProductData objectAtIndex:indexPath.row];
        
        if ([Util getBoolData:kLogin])
        {
            selectedProductId = [NSString stringWithFormat:@"%d",object.product_id];
            [self addItemToWishList:selectedProductId];
        }
        else
        {
            NSString *message = [MCLocalization stringForKey:@"Item Added to your Wish List."];
            [Util showPositiveMessage:message];
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
        [arr addObject:[NSString stringWithFormat:@"%d",object.product_id]];
        
        [Util setArray:arr setData:kWishList];
        [arrWishList addObject:[NSString stringWithFormat:@"%d",object.product_id]];
        
        NSLog(@"%@",[Util getArrayData:kWishList]);
        
        
            [self.colProducts reloadData];
    }
    else
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        Product *object = [arrProductData objectAtIndex:indexPath.row];
        
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
        

            [self.colProducts reloadData];
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
    
    Product *object = [arrProductData objectAtIndex:sender.tag];
    
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
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //Run UI Updates
        [self.colProducts reloadData];

    });
}

-(void)btnStoreClicked:(UIButton *)sender
{
    [self btnAddToCartClicked:sender];
}

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

- (void)removeItemFromWishList:(NSString*)productID
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    [dict setValue:productID forKey:@"product_id"];
    [CiyaShopAPISecurity removeItemFromWishList:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success)
        {
            HIDE_PROGRESS;
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                NSString *message = [MCLocalization stringForKey:@"Item Removed From your Wish List."];
                
                NSLog(@"Item Removed From wishlist successfully!");
                [Util showPositiveMessage:message];
            }
            else
            {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                [arr addObject:productID];
                
                [Util setArray:arr setData:kWishList];
                
                self->arrWishList = [[NSMutableArray alloc] init];
                [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                
                NSLog(@"Something Went Wrong while adding in Wishlist.");
            }
            
            //[self.tblData reloadData];
            //[self.colData reloadData];
            
            if([[dictionary valueForKey:@"sync_list"] isKindOfClass:[NSArray class]])
            {
                //Is array
                NSMutableArray *arrData = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"sync_list"]];
                [appDelegate setWishList:arrData];
            }
            else if([dictionary isKindOfClass:[NSDictionary class]])
            {
                //is dictionary
                NSMutableArray *arrData = [[NSMutableArray alloc] init];
                [appDelegate setWishList:arrData];
            }
            
        }
        else
        {
            HIDE_PROGRESS;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            [arr addObject:productID];
            
            [Util setArray:arr setData:kWishList];
            
            self->arrWishList = [[NSMutableArray alloc] init];
            [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            
            [self.colProducts reloadData];
        }
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                //                                   dispatch_async(dispatch_get_main_queue(), ^{
                [self.colProducts reloadData];
                //[self.actLoading stopAnimating];
                //                                   });
            });
        });
    }];
}

- (void)addItemToWishList:(NSString*)productID
{
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
            
            //[self.tblData reloadData];
            //[self.colData reloadData];
            
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
        if([[dictionary valueForKey:@"sync_list"] isKindOfClass:[NSArray class]])
        {
            //Is array
            NSMutableArray *arrData = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"sync_list"]];
            [appDelegate setWishList:arrData];
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            //is dictionary
            NSMutableArray *arrData = [[NSMutableArray alloc] init];
            [appDelegate setWishList:arrData];
        }
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                //                                   dispatch_async(dispatch_get_main_queue(), ^{
                [self.colProducts reloadData];
            });
        });
    }];
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


#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arrProductData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *identifier = @"ShopDataGridCell";
//
//    ShopDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//
//    if(cell == nil)
//    {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopDataGridCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
//
//    cell.btnWishList.hidden = YES;
//
//    cell.lblTitle.text = [[arrProductData objectAtIndex:indexPath.row] valueForKey:@"name"];
//    cell.lblTitle.textColor = FontColorGray;
//    cell.lblTitle.font=Font_Size_Product_Name_Small;
//
//    if ([[[arrProductData objectAtIndex:indexPath.row] valueForKey:@"images"] count] > 0)
//    {
//        [cell.act startAnimating];
//        [Util setPrimaryColorActivityIndicator:cell.act];
//        [cell.imgProduct sd_setImageWithURL:[Util EncodedURL:[[[[arrProductData objectAtIndex:indexPath.row] valueForKey:@"images"] objectAtIndex:0] valueForKey:@"src"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
//            cell.imgProduct.image = image;
//            [cell.act stopAnimating];
//        }];
//    }
//
//    NSString * htmlString = [[arrProductData objectAtIndex:indexPath.row] valueForKey:@"price_html"];
//    cell.lblRate.attributedText = [Util setPriceForItemSmall:htmlString];
//    [cell.lblRate setTextAlignment:NSTextAlignmentCenter];
//
//    //shadow to cell
//    cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
//    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
//    cell.layer.shadowRadius = 1.0f;
//    cell.layer.shadowOpacity = 0.5f;
//    cell.layer.masksToBounds = NO;
//    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
//
//    if (!apiCallRunning)
//    {
//        if ((page - 1)*10 == arrProductData.count)
//        {
//            if (indexPath.row == arrProductData.count - 4)
//            {
//                [self GetSellerData];
//                apiCallRunning = YES;
//            }
//        }
//    }
//    return cell;
    
    static NSString *identifier = @"ShopDataGridCell";
    
    ShopDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopDataGridCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Product *object = [arrProductData objectAtIndex:indexPath.row];
    
    if (appDelegate.isCatalogMode) {
        cell.btnAddToCart.hidden = true;
    } else {
        if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode)
        {
            cell.btnAddToCart.hidden = false;
            [Util setSecondaryColorButton:cell.btnAddToCart];
            
            [cell.btnAddToCart setTitle:[MCLocalization stringForKey:@"ADD TO CART"] forState:UIControlStateNormal];
            
            if ([object.type1 isEqualToString:@"simple"])
            {
//                //external product
//            }
//            else if ([object.type isEqualToString:@"grouped"])
//            {
//                //Group product
//            }
//            else if ([object.type isEqualToString:@"variable"])
//            {
//                //Variable product
//            }
//            else
//            {
                //Simple product
                if ([Util checkInCart:object variation:0 attribute:nil])
                {
                    [cell.btnAddToCart setTitle:[MCLocalization stringForKey:@"GO TO CART"] forState:UIControlStateNormal];
                }
                else
                {
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
            
            if (object.price == 0)
            {
                cell.btnAddToCart.hidden = true;
            }
            else
            {
                cell.btnAddToCart.hidden = false;
            }
        }
        else
        {
            cell.btnAddToCart.hidden = true;
        }
    }
    
    Boolean set11 = [arrWishList containsObject:[NSString stringWithFormat:@"%d",object.product_id]];
    
    //image change for wish list
    if (set11)
    {
        [Util setPrimaryColorButtonImageBG:cell.btnWishList image:[UIImage imageNamed:@"IconInWishList"]];
    }
    else
    {
        [cell.btnWishList setImage:[UIImage imageNamed:@"IconWishList"] forState:UIControlStateNormal];
    }
    
    cell.btnWishList.tag = indexPath.row;
    cell.btnStore.tag = indexPath.row;
    cell.btnAddToCart.tag = indexPath.row;
    
    [cell.btnStore addTarget:self action:@selector(btnStoreClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAddToCart addTarget:self action:@selector(btnAddToCartClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnWishList addTarget:self action:@selector(btnWishListClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lblTitle.textColor = FontColorGray;
    cell.lblTitle.text = object.name;
    cell.lblTitle.font=Font_Size_Product_Name_Small;
    
    [cell.act startAnimating];
    [Util setPrimaryColorActivityIndicator:cell.act];
    
    if (object.arrImages.count > 0)
    {
        [cell.imgProduct sd_setImageWithURL:[Util EncodedURL:[[object.arrImages objectAtIndex:0] valueForKey:@"src"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            [cell.act stopAnimating];
            cell.imgProduct.image=image;
        }];
    }
    
    NSString * htmlString = object.price_html;
    cell.lblRate.attributedText = [Util setPriceForItem:htmlString];
    
    [cell.lblRate setTextAlignment:NSTextAlignmentCenter];
    
    if (arrselect.count > 0)
    {
        NSIndexPath *indexPath1 = [arrselect objectAtIndex:0];
        if (indexPath.row == indexPath1.row)
        {
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
    if (arrUnselect.count>0)
    {
        NSIndexPath *indexPath1 = [arrUnselect objectAtIndex:0];
        if (indexPath.row == indexPath1.row)
        {
            [cell.btnWishList setImage:[UIImage imageNamed:@"IconWishList"] forState:UIControlStateNormal];
            arrUnselect = [[NSArray alloc] init];
        }
    }
    
    
    BOOL flg = false;
    for (UIView *subview in cell.vwRating.subviews)
    {
        if (subview.tag>=1000)
        {
            flg = YES;
            HCSStarRatingView *starRatingView=(HCSStarRatingView *)subview;
            starRatingView.value = object.average_rating;
            starRatingView.frame = CGRectMake(0, 0, cell.vwRating.frame.size.width, cell.vwRating.frame.size.height);
            break;
        }
    }
    //    cell.lblTitle.frame = CGRectMake(cell.lblTitle.frame.origin.x, cell.imgProduct.frame.size.height + 5, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
    
    
    if (!flg)
    {
        [cell.vwRating addSubview:[Util setStarRating:object.average_rating frame:CGRectMake(0, 0, cell.vwRating.frame.size.width, 12) tag:1000+indexPath.row]];
    }
    
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    

//    if (!apiCallRunning && noProductFound != 1 && productCount == 10 && indexPath.row == arrProductData.count - 4)
//    {
//        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
//            //Background Thread
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [self loadProducts];
//                self->apiCallRunning = YES;
//            });
//        });
//    }

        if (!apiCallRunning)
        {
            if ((page - 1)*10 == arrProductData.count)
            {
                if (indexPath.row == arrProductData.count - 4)
                {
                    [self GetSellerData];
                    apiCallRunning = YES;
                }
            }
        }
    
    
    if (appDelegate.isWishList)
    {
        cell.btnWishList.hidden = NO;
    }
    else
    {
        cell.btnWishList.hidden = YES;
    }
    [Util setTriangleLable:cell.vwDiscount product:object];
    
    if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
        cell.heightAddToCart.constant = 30;
    } else {
        cell.heightAddToCart.constant = 0;
    }
    return cell;

    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [dictSellerDetail setValue:[NSNumber numberWithBool:YES] forKey:@"is_seller"];
//    [[arrProductData objectAtIndex:indexPath.row] setValue:dictSellerDetail forKey:@"seller_info"];
//    if ([[[arrProductData objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"external"])
//    {
//        NSString *strUrl = [[arrProductData objectAtIndex:indexPath.row] valueForKey:@"external_url"];
//        NSURL *_url = [Util EncodedURL:strUrl];
//        
//        [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
////        [[UIApplication sharedApplication] openURL:_url];
//    }
//    else if ([[[arrProductData objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"grouped"])
//    {
//        //GroupItemDetailVC
//        GroupItemDetailVC *vc = [[GroupItemDetailVC alloc] initWithNibName:@"GroupItemDetailVC" bundle:nil];
//        vc.product = [Util setProductData:[arrProductData objectAtIndex:indexPath.row]];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else if ([[[arrProductData objectAtIndex:indexPath.row] valueForKey:@"type"] isEqualToString:@"variable"])
//    {
//        //VariableItemDetailVC
//        VariableItemDetailVC *vc = [[VariableItemDetailVC alloc] initWithNibName:@"VariableItemDetailVC" bundle:nil];
//        vc.product = [Util setProductData:[arrProductData objectAtIndex:indexPath.row]];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
//    else
//    {
//        ItemDetailVC *vc = [[ItemDetailVC alloc] initWithNibName:@"ItemDetailVC" bundle:nil];
//        vc.product = [Util setProductData:[arrProductData objectAtIndex:indexPath.row]];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
    
    if (page != 1) {
        [appDelegate setRecentProduct:[arrProductData objectAtIndex:indexPath.row]];
        
        Product *object = [arrProductData objectAtIndex:indexPath.row];
        
        if ([object.type1 isEqualToString:@"external"])
        {
            NSString *strUrl = object.external_url;
            NSURL *_url = [Util EncodedURL:strUrl];
            [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
            //        [[UIApplication sharedApplication] openURL:_url];
        }
        else if ([object.type1 isEqualToString:@"grouped"])
        {
            //GroupItemDetailVC
            GroupItemDetailVC *vc = [[GroupItemDetailVC alloc] initWithNibName:@"GroupItemDetailVC" bundle:nil];
            vc.product = object;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if ([object.type1 isEqualToString:@"variable"])
        {
            //VariableItemDetailVC
            VariableItemDetailVC *vc = [[VariableItemDetailVC alloc] initWithNibName:@"VariableItemDetailVC" bundle:nil];
            vc.product = object;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            ItemDetailVC *vc = [[ItemDetailVC alloc] initWithNibName:@"ItemDetailVC" bundle:nil];
            vc.product = [arrProductData objectAtIndex:indexPath.row];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 6.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(6, 6, 6, 6);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionView.frame.size.width/2)-10, SCREEN_SIZE.width*276/375);
}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(arrComments.count > 3)
    {
        return 3;
    }
    else
    {
        return arrComments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SallerReviewCell";
    
    SallerReviewCell *cell = (SallerReviewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SallerReviewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    if (indexPath.row==0)
    {
        cell.lblBorder.hidden=NO;
    }
    else
    {
        cell.lblBorder.hidden=YES;
    }
    
    cell.lblBorder.backgroundColor=LineSeperator;
    
    
    cell.lblTime.font = Font_Size_Product_Name_Regular;
    cell.lblReview.font = Font_Size_Product_Name;
    cell.lblRate.font = Font_Size_Product_Name_Small;
    cell.btnMore.titleLabel.font = Font_Size_Product_Name_Not_Bold;
    
    cell.lblReview.textColor = FontColorGray;
    
    [Util setPrimaryColorButtonTitle:cell.btnMore];
    cell.lblDescription.text = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"comment_content"];
    [cell.lblDescription sizeToFit];
    
    cell.lblRate.text = [[[arrComments objectAtIndex:indexPath.row] valueForKey:@"rating"] stringValue];
    cell.lblName.text = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"comment_author"];
    [cell.lblName sizeToFit];
    cell.lblReview.text = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"comment_author"];
    
    
    NSString *strTime = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"comment_date"];
    cell.lblTime.text = strTime;
    [cell.lblTime sizeToFit];
    
    [cell.btnMore setTitle:[MCLocalization stringForKey:@"More >"] forState:UIControlStateNormal];
    
    cell.lblDescription.frame = CGRectMake(cell.lblDescription.frame.origin.x, cell.lblReview.frame.origin.y + cell.lblReview.frame.size.height + 4, cell.frame.size.width - 46, cell.lblDescription.frame.size.height);
    
    cell.lblName.frame = CGRectMake(cell.lblName.frame.origin.x, cell.lblDescription.frame.origin.y + cell.lblDescription.frame.size.height + 8, cell.lblName.frame.size.width, cell.lblName.frame.size.height);
    
    cell.lblName.hidden = YES;
    cell.lblTime.frame = CGRectMake(cell.lblName.frame.origin.x, cell.lblName.frame.origin.y, cell.lblTime.frame.size.width, cell.lblName.frame.size.height);
    
    cell.btnMore.frame = CGRectMake(cell.btnMore.frame.origin.x, cell.lblName.frame.origin.y + cell.lblName.frame.size.height + 4, cell.btnMore.frame.size.width, cell.btnMore.frame.size.height);
    
    if (indexPath.row == arrComments.count - 1)
    {
        cell.Devider.hidden = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblDescription.font = Font_Size_Product_Name_Regular;
    
    if (appDelegate.isRTL)
    {
        //RTL
        cell.lblDescription.textAlignment = NSTextAlignmentRight;
        cell.lblName.textAlignment = NSTextAlignmentRight;
        cell.lblTime.textAlignment = NSTextAlignmentRight;
        cell.lblReview.textAlignment = NSTextAlignmentRight;
        
        cell.vwRating.frame = CGRectMake(tableView.frame.size.width - cell.vwRating.frame.size.width - 22, cell.vwRating.frame.origin.y, cell.vwRating.frame.size.width, cell.vwRating.frame.size.height);
        cell.lblReview.frame = CGRectMake(22, cell.lblReview.frame.origin.y, cell.lblReview.frame.size.width, cell.lblReview.frame.size.height);
        cell.lblTime.frame = CGRectMake(tableView.frame.size.width - cell.lblTime.frame.size.width - 22, cell.lblTime.frame.origin.y, cell.lblTime.frame.size.width, cell.lblTime.frame.size.height);
    }
    else
    {
        cell.lblReview.frame = CGRectMake(71, cell.lblReview.frame.origin.y, cell.lblReview.frame.size.width, cell.lblReview.frame.size.height);
        cell.lblDescription.textAlignment = NSTextAlignmentLeft;
        cell.lblName.textAlignment = NSTextAlignmentLeft;
        cell.lblTime.textAlignment = NSTextAlignmentLeft;
        cell.lblReview.textAlignment = NSTextAlignmentLeft;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SallerReviewCell";
    
    SallerReviewCell *cell = (SallerReviewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SallerReviewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblDescription.text = [[arrComments objectAtIndex:indexPath.row] valueForKey:@"comment_content"];
    [cell.lblDescription sizeToFit];
    
    return 56 + cell.lblDescription.frame.size.height + 4;
}

#pragma mark - Hide Bottom bar and status bar

-(BOOL)hidesBottomBarWhenPushed
{
    return YES;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark - get avg color from image
/*!
 * @discussion To set avg color to background of image
 */
- (UIColor *)averageColor:(UIImage*)img
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char rgba[4];
    CGContextRef context = CGBitmapContextCreate(rgba, 1, 1, 8, 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    
    CGImageRef cgImage = [img CGImage];
    CGContextDrawImage(context, CGRectMake(0, 0, 1, 1), cgImage);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
    if(rgba[3] > 0) {
        CGFloat alpha = ((CGFloat)rgba[3])/255.0;
        CGFloat multiplier = alpha/255.0;
        return [UIColor colorWithRed:((CGFloat)rgba[0])*multiplier
                               green:((CGFloat)rgba[1])*multiplier
                                blue:((CGFloat)rgba[2])*multiplier
                               alpha:alpha];
    }
    else {
        return [UIColor colorWithRed:((CGFloat)rgba[0])/255.0
                               green:((CGFloat)rgba[1])/255.0
                                blue:((CGFloat)rgba[2])/255.0
                               alpha:((CGFloat)rgba[3])/255.0];
    }
}

#pragma mark - API calls
/*!
 * @discussion Webservice call for Getting Seller information
 */
- (void)GetSellerData
{
    if (page == 1)
    {
        SHOW_LOADER_ANIMTION();
        self.vwContent.hidden = YES;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:self.strSellerID forKey:@"seller_id"];
    [dict setValue:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    
    NSLog(@" dict is :: %@", dict);
    
    apiCallRunning = YES;
    [CiyaShopAPISecurity getSellerDetail:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
                
        self->apiCallRunning = NO;
        NSLog(@"%@", dictionary);
        
        if(success==YES)
        {
            //no error
            if (dictionary.count > 0)
            {
                NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)[dictionary valueForKey:@"products"]];
                
                for (int i = 0; i < arrData.count; i++)
                {
                    Product *object = [Util setProductData:[arrData objectAtIndex:i]];
                    [self->arrProductData addObject:object];
                }

                
                BOOL isContactSeller = [[[dictionary valueForKey:@"seller_info"] valueForKey:@"contact_seller"] boolValue];
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
                                
                if ([[[dictionary valueForKey:@"seller_info"] valueForKey:@"seller_rating"] valueForKey:@"rating"] != nil)
                {
                    self.lblRating.text = [NSString stringWithFormat:@"%@",[[[dictionary valueForKey:@"seller_info"] valueForKey:@"seller_rating"] valueForKey:@"rating"]];
                }
                else
                {
                    self.lblRating.text = @"0";
                }
                
                NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[[[dictionary valueForKey:@"seller_info"] valueForKey:@"store_description"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                
                self.lblAbout.text = attrStr.string;
                
                self->arrComments = [[NSMutableArray alloc] initWithArray:[[[dictionary valueForKey:@"seller_info"] valueForKey:@"review_list"] mutableCopy]];
                self->dictSellerDetail = [[NSMutableDictionary alloc] initWithDictionary:[dictionary valueForKey:@"seller_info"]];
                
                self.lblTitle.text = [[dictionary valueForKey:@"seller_info"]valueForKey:@"store_name"];
                NSMutableAttributedString * attrStr1 = [[NSMutableAttributedString alloc] initWithData:[[[dictionary valueForKey:@"seller_info"]valueForKey:@"seller_address"] dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
                self.lblDesc.attributedText = attrStr1;
                self.lblDesc.textAlignment = NSTextAlignmentCenter;
                
                
                [self.imgBanner sd_setImageWithURL:[Util EncodedURL:[[dictionary valueForKey:@"seller_info"]valueForKey:@"banner_url"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    self.imgBanner.image = image;
                    
                    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
                    img.image = image;
                    [self.view addSubview:img];
                    
                    NSLog(@"Image loaded");
                    if (!self->dataArrived) {
                        
                        
                        
                        if (@available(iOS 13, *))
                        {
                            UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
                            statusBar.backgroundColor = [self averageColor:image];
                            [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
                        }
                        else
                        {
                            UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
                            if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
                                statusBar.backgroundColor = [self averageColor:image];
                            }
                        }

                        
                        self->dataArrived = YES;
                    }
                }];
                
                NSLog(@"%@",[Util EncodedURL:[[dictionary valueForKey:@"seller_info"]valueForKey:@"avatar"]]);
                [self.imgProfilePic sd_setImageWithURL:[Util EncodedURL:[[dictionary valueForKey:@"seller_info"]valueForKey:@"avatar"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    self.imgProfilePic.image = image;
                    [self.imgProfilePic setBackgroundColor:[self averageColor:self.imgProfilePic.image]];
                }];
                self->page++;
            }
        }
        HIDE_PROGRESS;
        
        self.vwContent.hidden = NO;
        [self localize];
        self->flag_once = YES;
        [self setFrames];
        [self.colProducts reloadData];
        [self.tblReview reloadData];
        
        self.vwAllData.hidden = NO;
    }];
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
