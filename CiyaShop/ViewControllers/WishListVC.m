//
//  WishListVC.m
//  QuickClick
//
//  Created by APPLE on 21/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "WishListVC.h"
#import "ShopDataCell.h"
#import "ItemDetailVC.h"
#import "GroupItemDetailVC.h"
#import "VariableItemDetailVC.h"

@import ListPlaceholder;
@interface WishListVC ()

@property (weak, nonatomic) IBOutlet UITableView *tblData;

@property (strong,nonatomic) IBOutlet UIView *vwLoader;
@property (strong,nonatomic) IBOutlet UIView *vwLoader1;
@property (strong,nonatomic) IBOutlet UIView *vwLoader2;
@property (strong,nonatomic) IBOutlet UIView *vwLoader3;
@property (strong,nonatomic) IBOutlet UIView *vwLoader4;
@property (strong,nonatomic) IBOutlet UIView *vwLoader5;
@property (weak, nonatomic) IBOutlet UIView *vwLoader6;

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UIView *vwNoWishList;
@property (strong, nonatomic) IBOutlet UIView *vwAllData;


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblWishListIsEmpty;
@property (weak, nonatomic) IBOutlet UILabel *lblWishListIsEmptyDesc;

@property (weak, nonatomic) IBOutlet UIButton *btnContinueShopping;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UIImageView *imgArrow;


@end

@implementation WishListVC
{
    NSMutableArray *arrWishList;
    NSString *strSize, *strColor;
    int page;
    NSIndexPath *selectedIndex;
    BOOL apiCallRunning;
    UIView *vw;
    NSMutableArray *arrGroupedProduct;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
    [self.tblData reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [Util setHeaderColorView:vw];

    
    self.navigationController.navigationBarHidden = YES;
    [self localize];
    page = 1;
    arrWishList = [[NSMutableArray alloc] init];
    self.tblData.tableFooterView=[UIView new];
    [self.tblData reloadData];
    if (appDelegate.isWishList)
    {
        [self checkWishList];
    }
    else
    {
        self.vwNoWishList.hidden = NO;
        self.tblData.hidden = YES;
    }
}

-(void)checkWishList
{
    if ([appDelegate checkWishListData])
    {
        page = 1;
        [self loadWishListProducts];
        self.vwNoWishList.hidden = YES;
        self.tblData.hidden = NO;
    }
    else
    {
        self.vwNoWishList.hidden = NO;
        self.tblData.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideTable
{
    if (arrWishList.count == 0)
    {
        self.tblData.hidden = YES;
        self.vwNoWishList.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            self.vwNoWishList.frame = CGRectMake(0, 42, SCREEN_SIZE.width, self.vwNoWishList.frame.size.height);
        }];
    }
}

#pragma mark - Localize Language

/*!
 * @discussion This method is Localize the App (Change Language)
 */
- (void)localize
{
    [Util setHeaderColorView:self.vwHeader];
    self.lblTitle.textColor = OtherTitleColor;
    self.lblTitle.font = Font_Size_Navigation_Title;

    self.lblTitle.text = [MCLocalization stringForKey:@"Wishlist"];
    
    [Util setSecondaryColorButtonImage:self.btnContinueShopping image:[UIImage imageNamed:@"MyRewardsButtonBG"]];
    
    [Util setSecondaryColorImageView:self.imgArrow];


    strSize = [MCLocalization stringForKey:@"Size:"];
    strColor = [MCLocalization stringForKey:@"Color:"];
    
    self.lblWishListIsEmptyDesc.text = [MCLocalization stringForKey:@"Simply browse and add item to wishList"];
    
//    self.lblWishListIsEmpty.text = [MCLocalization stringForKey:@"Wish list is Empty..!!"];
    self.lblWishListIsEmpty.text = [MCLocalization stringForKey:@"No product Available"];
    [self.btnContinueShopping setTitle:[MCLocalization stringForKey:@"CONTINUE SHOPPING"] forState:UIControlStateNormal];
    [Util setSecondaryColorButtonTitle:self.btnContinueShopping];

    if(appDelegate.isRTL) {
        //set up RTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];

        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        
    } else {
        //set up nonRTL
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }

    [self.tblData reloadData];
}

#pragma mark - Button IBAction Methods
/*!
 * @discussion will Take you to Previous page
 * @param sender For indentifying sender
 */
-(IBAction)btnBackClicked:(id)sender
{
    if (self.tabBarController.selectedIndex != 0) {
        self.tabBarController.selectedIndex = 0;
        [[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
    }
}
/*!
 * @discussion To continue Shoping
 * @param sender For indentifying sender
 */
-(IBAction)btnContinueShoppingClicked:(id)sender
{
    self.tabBarController.selectedIndex = 0;
    [[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
}
/*!
 * @discussion It will take you to Notification
 * @param sender For indentifying sender
 */ 
-(IBAction)btnNotificationClicked:(id)sender
{
    [appDelegate Notification:self];
}
/*!
 * @discussion It will take you to Search
 * @param sender For indentifying sender
 */
-(IBAction)btnSearchClicked:(id)sender
{
    [appDelegate Search:self];
}
/*!
 * @discussion It will take you to Product Detail
 * @param sender For indentifying sender
 */
-(void)btnStoreClicked:(UIButton *)sender
{
    Product *object = [arrWishList objectAtIndex:sender.tag];
    
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
        [self.tblData reloadData];
    });
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

/*!
 * @discussion It will remove product from Wishlist
 * @param sender For indentifying sender
 */
-(void)btnWishListClicked:(UIButton *)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblData];
    NSIndexPath *indexPath = [self.tblData indexPathForRowAtPoint:buttonPosition];
    selectedIndex = indexPath;
    if ([Util getBoolData:kLogin])
    {
        [self removeItemFromWishList:selectedIndex];
    }
    else
    {
        NSLog(@"%@",arrWishList);
        if (arrWishList.count > 0)
        {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            int j = -1;
            Product *object = [arrWishList objectAtIndex:indexPath.row];
            
            for (int i = 0; i < [arr count]; i++)
            {
                if ([[arr objectAtIndex:i] integerValue] == object.product_id)
                {
                    j = i;
                    break;
                }
            }
            if(j!=-1){
                [arr removeObjectAtIndex:j];
                [Util setArray:arr setData:kWishList];
                [arrWishList removeObjectAtIndex:indexPath.row];
                NSArray *deletedIndexPaths = [[NSArray alloc]initWithObjects:indexPath,nil];
                [self.tblData beginUpdates];
                [self.tblData deleteRowsAtIndexPaths:deletedIndexPaths withRowAnimation:UITableViewRowAnimationRight];
                [self.tblData endUpdates];
                NSString *message = [MCLocalization stringForKey:@"Item Removed From your Wish List."];
                [Util showPositiveMessage:message];
                [self performSelector:@selector(hideTable) withObject:nil afterDelay:0.99];
            }
        }
        else
        {
            [self.tblData endUpdates];
        }
    }
}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrWishList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"ShopDataCell";
    ShopDataCell *cell = (ShopDataCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopDataCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.btnEdit.hidden = YES;
    [Util setPrimaryColorLabelText:cell.lblRate];
    
    if (arrWishList.count > 0)
    {
        Product *object = [arrWishList objectAtIndex:indexPath.row];
        
        cell.lblTitle.font = Font_Size_Product_Name_Not_Bold;
        cell.lblTitle.textColor = FontColorGray;
        if (arrWishList.count != 0)
        {
            cell.lblTitle.text = object.name;
            NSString * htmlString = object.price_html;
            if ([object.arrImages count] > 0)
            {
                [cell.act startAnimating];
                [Util setPrimaryColorActivityIndicator:cell.act];
                
                [cell.img sd_setImageWithURL:[Util EncodedURL:[[object.arrImages objectAtIndex:0] valueForKey:@"src"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    cell.img.image = image;
                    [cell.act stopAnimating];
                }];
            }
            cell.lblRate.attributedText = [Util setPriceForItem:htmlString];
        }
        
        
        [Util setPrimaryColorButtonImageBG:cell.btnWishList image:[UIImage imageNamed:@"IconInWishList"]];
        
        cell.btnWishList.tag = indexPath.row;
        [cell.btnWishList addTarget:self action:@selector(btnWishListClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (appDelegate.isCatalogMode) {
            cell.btnStore.hidden = true;
        } else {
            if (appDelegate.isCartButtonEnabled) {
                [cell.btnStore addTarget:self action: @selector(btnStoreClicked:) forControlEvents:UIControlEventTouchUpInside];
                cell.btnStore.hidden = false;
            } else {
                cell.btnStore.hidden = true;
            }
        }
        
        if (!apiCallRunning) {
            if ((page - 1)*10 == arrWishList.count)
            {
                if (indexPath.row == arrWishList.count - 4)
                {
                    [self loadWishListProducts];
                    apiCallRunning = YES;
                }
            }
        }
        if (appDelegate.isRTL)
        {
            //        //RTL
            cell.vwImage.frame = CGRectMake(cell.frame.size.width - cell.vwImage.frame.size.width - 6*SCREEN_SIZE.width/375, cell.vwImage.frame.origin.y, cell.vwImage.frame.size.width, cell.vwImage.frame.size.height);
            cell.vwQuatity.frame = CGRectMake(18*SCREEN_SIZE.width/375, cell.vwQuatity.frame.origin.y, cell.vwQuatity.frame.size.width, cell.vwQuatity.frame.size.height);
            cell.lblTitle.frame = CGRectMake(cell.frame.size.width - cell.lblTitle.frame.size.width - cell.vwImage.frame.size.width - 15, cell.lblTitle.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            cell.lblRate.textAlignment = NSTextAlignmentRight;
            cell.btnStore.frame = CGRectMake(40, cell.btnStore.frame.origin.y, cell.btnStore.frame.size.width, cell.btnStore.frame.size.height);
            cell.btnWishList.frame = CGRectMake(3, cell.btnWishList.frame.origin.y, cell.btnWishList.frame.size.width, cell.btnWishList.frame.size.height);
            //        cell.lblRate.textAlignment = NSTextAlignmentRight;
        }
        else
        {
            cell.vwImage.frame = CGRectMake(6*SCREEN_SIZE.width/375, cell.vwImage.frame.origin.y, cell.vwImage.frame.size.width, cell.vwImage.frame.size.height);
            cell.vwQuatity.frame = CGRectMake(cell.frame.size.width - cell.vwQuatity.frame.size.width - 18*SCREEN_SIZE.width/375, cell.vwQuatity.frame.origin.y, cell.vwQuatity.frame.size.width, cell.vwQuatity.frame.size.height);
            cell.lblTitle.frame = CGRectMake(cell.vwImage.frame.origin.x + cell.vwImage.frame.size.width + 8, cell.lblTitle.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
            cell.btnStore.frame = CGRectMake(cell.frame.size.width - cell.btnStore.frame.size.width - 40, cell.btnStore.frame.origin.y, cell.btnStore.frame.size.width, cell.btnStore.frame.size.height);
            cell.btnWishList.frame = CGRectMake(cell.frame.size.width - cell.btnWishList.frame.size.width - 3, cell.btnWishList.frame.origin.y, cell.btnWishList.frame.size.width, cell.btnWishList.frame.size.height);
            cell.lblRate.textAlignment = NSTextAlignmentLeft;
            cell.lblTitle.textAlignment = NSTextAlignmentLeft;
        }
        BOOL flg = false;
        for (UIView *subview in cell.subviews)
        {
            if (subview.tag >= 1000)
            {
                flg=YES;
                if (appDelegate.isRTL)
                {
                    //RTL
                    subview.frame = CGRectMake(cell.lblRate.frame.size.width + cell.lblRate.frame.origin.x- subview.frame.size.width, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8,  (cell.frame.size.width/2.3)/2, appDelegate.FontSizeProductName);
                    
                    cell.lblRate.frame = CGRectMake(cell.frame.size.width - cell.lblRate.frame.size.width - 99*SCREEN_SIZE.width/375, cell.lblRate.frame.origin.y, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                    [subview setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                }
                else
                {
                    //nonRTL
                    subview.frame = CGRectMake(cell.lblRate.frame.origin.x, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8, (cell.frame.size.width/2.3)/2, appDelegate.FontSizeProductName);
                    
                    cell.lblRate.frame = CGRectMake(cell.lblTitle.frame.origin.x, subview.frame.origin.y + subview.frame.size.height + 8, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                    [subview setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                    
                }
            }
        }
        
        if (!flg)
        {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                //Background Thread
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Run UI Updates
                    
                    if (appDelegate.isRTL)
                    {
                        //RTL
                        cell.lblRate.frame = CGRectMake(cell.frame.size.width - cell.lblRate.frame.size.width - 99*SCREEN_SIZE.width/375, cell.lblRate.frame.origin.y, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                        
                        cell.lblRate.textAlignment = NSTextAlignmentRight;
                    }
                    else
                    {
                        //NonRTL
                        cell.lblRate.frame = CGRectMake(cell.lblTitle.frame.origin.x, cell.lblRate.frame.origin.y, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                        cell.lblRate.textAlignment = NSTextAlignmentLeft;
                    }
                    HCSStarRatingView *starRatingView;
                    if (appDelegate.isRTL)
                    {
                        //RTL
                        NSLog(@"path : %f",SCREEN_SIZE.width - 60 - 99*SCREEN_SIZE.width/375);
                        starRatingView = [Util setStarRating:object.average_rating frame:CGRectMake(cell.lblRate.frame.size.width + cell.lblRate.frame.origin.x- (cell.frame.size.width/2.3)/2, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8, (cell.frame.size.width/2.3)/2,appDelegate.FontSizeProductName) tag:1000+indexPath.row];
                        [starRatingView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                    }
                    else
                    {
                        //nonRTL
                        starRatingView = [Util setStarRating:object.average_rating frame:CGRectMake(cell.lblRate.frame.origin.x, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8, (cell.frame.size.width/2.1)/2,appDelegate.FontSizeProductName) tag:1000+indexPath.row];
                        [starRatingView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                    }
                    [cell addSubview:starRatingView];
                    
                });
            });
        }
        if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode)
        {
            cell.btnStore.hidden = false;
//            [Util setPrimaryColorButton:cell.btnStore];
            
            if ([object.type1 isEqualToString:@"external"])
            {
                //external product
            }
            else if ([object.type1 isEqualToString:@"grouped"])
            {
                //Group product
            }
            else if ([object.type1 isEqualToString:@"variable"])
            {
                //Variable product
            }
            else
            {
                //Simple product
                if ([Util checkInCart:object variation:0 attribute:nil])
                {
                    [Util setPrimaryColorButtonImageBG:cell.btnStore image:[UIImage imageNamed:@"IconCart"]];
                }
                else
                {
                    [cell.btnStore setImage:[UIImage imageNamed:@"IconCart"] forState:UIControlStateNormal];
                }
            }
            if (object.in_stock == 1)
            {
                cell.btnStore.userInteractionEnabled = true;
                cell.alpha = 1.0;
            }
            else
            {
                cell.btnStore.userInteractionEnabled = false;
//                cell.alpha = 0.4;
            }
        }
        else
        {
            cell.btnStore.hidden = true;
        }
        [Util setTriangleLable:cell.vwDiscount product:object];
        if (appDelegate.isRTL) {
            //set rtl view
            cell.vwDiscount.frame = CGRectMake(cell.frame.size.width - cell.vwDiscount.frame.size.width, 0, cell.vwDiscount.frame.size.width, cell.vwDiscount.frame.size.height);
        } else {
            //set non rtl view
            cell.vwDiscount.frame = CGRectMake(0, 0, cell.vwDiscount.frame.size.width, cell.vwDiscount.frame.size.height);
        }

    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (arrWishList.count > 0)
    {
        Product *object = [arrWishList objectAtIndex:indexPath.row];
        
        [appDelegate setRecentProduct:object];
        
        if ([object.type1 isEqualToString:@"external"])
        {
            //Enternal products
            NSString *strUrl = object.external_url;
            NSURL *_url = [Util EncodedURL:strUrl];
            [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
            //            [[UIApplication sharedApplication] openURL:_url];
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
            //ItemDetailVC
            ItemDetailVC *vc = [[ItemDetailVC alloc] initWithNibName:@"ItemDetailVC" bundle:nil];
            vc.product = object;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

#pragma mark - API calls
/*!
 * @discussion Webservice call for Loding Wishlist Products
 */
- (void)loadWishListProducts
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObjectsFromArray:[Util getArrayData:kWishList]];
    NSString *str = [[NSString alloc] init];
    for (int i = 0; i < arr.count; i++)
    {
        if (i == 0)
        {
            str = [NSString stringWithFormat:@"%@", [arr objectAtIndex:i]];
        }
        else
        {
            str = [NSString stringWithFormat:@"%@,%@", str, [arr objectAtIndex:i]];
        }
    }
    [dict setValue:str forKey:@"include"];
    if (page == 1) {
        if (appDelegate.isShimmerLoader){
            [self.vwLoader1 showLoader];
            [self.vwLoader2 showLoader];
            [self.vwLoader3 showLoader];
            [self.vwLoader4 showLoader];
            [self.vwLoader5 showLoader];
            [self.vwLoader6 showLoader];
            self.vwLoader.hidden = false;
        } else {
            SHOW_LOADER_ANIMTION();
        }
       
    }
    apiCallRunning = YES;
    [CiyaShopAPISecurity productListing:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        if (appDelegate.isShimmerLoader){
            self.vwLoader.hidden = true;
            [self.vwLoader1 hideLoader];
            [self.vwLoader2 hideLoader];
            [self.vwLoader3 hideLoader];
            [self.vwLoader4 hideLoader];
            [self.vwLoader5 hideLoader];
            [self.vwLoader6 hideLoader];
        } else {
            HIDE_PROGRESS;
        }
        if (self->page == 1) {
            self->arrWishList = [[NSMutableArray alloc] init];
        }
        self->apiCallRunning = NO;
        if (success==YES)
        {
            //no error
            if (dictionary.count>0)
            {
                if([dictionary isKindOfClass:[NSArray class]])
                {
                    //Is array
                    NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                    for (int i = 0; i < arrData.count; i++)
                    {
                        Product *object = [Util setProductData:[arrData objectAtIndex:i]];
                        
                        [self->arrWishList addObject:object];
                    }
                    self->page++;
                    [self.tblData reloadData];
                }
            }
        }
        if (self->arrWishList.count == 0) {
            [self checkWishList];
        }
    }];
}
/*!
 * @discussion Webservice call for Removing Product from WishList
 */
- (void)removeItemFromWishList:(NSIndexPath*)indexpath
{
//    SHOW_LOADER_ANIMTION();
    SHOW_LOADER_ANIMTION();
    Product *object = [arrWishList objectAtIndex:indexpath.row];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    [dict setValue:[NSString stringWithFormat:@"%d", object.product_id] forKey:@"product_id"];
    [CiyaShopAPISecurity removeItemFromWishList:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        HIDE_PROGRESS;
        if (success) {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                NSString *message = [MCLocalization stringForKey:@"Item Removed From your Wish List."];
                NSLog(@"Item Removed From wishlist successfully!");
                [Util showPositiveMessage:message];
                [self->arrWishList removeObjectAtIndex:indexpath.row];
                if([[dictionary valueForKey:@"sync_list"] isKindOfClass:[NSArray class]])
                {
                    //Is array
                    NSMutableArray *arrData = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"sync_list"]];
                    [appDelegate setWishList:arrData];
                }
                else if([[dictionary valueForKey:@"sync_list"] isKindOfClass:[NSDictionary class]])
                {
                    //is dictionary
                    NSMutableArray *arrData = [[NSMutableArray alloc] init];
                    [appDelegate setWishList:arrData];
                }
            }
            else
            {
                NSString *message = [MCLocalization stringForKey:@"Item isnot Removed From your Wish List."];
                NSLog(@"Item is not Removed From wishlist!");
                [Util showNegativeMessage:message];
            }
        }
        else
        {
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            [Util setArray:arr setData:kWishList];
            self->arrWishList = [[NSMutableArray alloc] init];
            [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            [self.tblData reloadData];
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
//        if ([[Util getArrayData:kWishList] count] > 0)
//        {
////            self->page = 1;
////            self->arrWishList = [[NSMutableArray alloc] init];
////            [self loadWishListProducts];
//        }
//        else
//        {
//            self->arrWishList = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kWishList] mutableCopy]];
        [self.tblData reloadData];
        [self hideTable];
//        }
    }];
}

-(void)GetGroupedProductDetail:(Product*)product
{
    if (appDelegate.isShimmerLoader) {
        [self.vwLoader1 showLoader];
        [self.vwLoader2 showLoader];
        [self.vwLoader3 showLoader];
        [self.vwLoader4 showLoader];
        [self.vwLoader5 showLoader];
        [self.vwLoader6 showLoader];
        self.vwLoader.hidden = false;
    } else {
        SHOW_LOADER_ANIMTION();
    }
//    SHOW_LOADER_ANIMTION();
    if (product.arrGrouped_products.count == 0)
    {
        
    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        NSString *str = [product.arrGrouped_products componentsJoinedByString:@","];
//        NSString *str = [[NSString alloc] init];
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
            HIDE_PROGRESS;
            [appDelegate showBadge];
        }];
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
