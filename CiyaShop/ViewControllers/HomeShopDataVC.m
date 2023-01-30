//
//  HomeShopDataVC.m
//  QuickClick
//
//  Created by Kaushal PC on 22/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "HomeShopDataVC.h"
#import "VariableItemDetailVC.h"
#import "ShopDataCell.h"
#import "ItemDetailVC.h"
#import "ShopDataGridCell.h"
#import "SearchVC.h"
#import "FilterVC.h"
#import "GroupItemDetailVC.h"
#import "FilterCategoryVC.h"

@import ListPlaceholder;

#define LIMIT(__VALUE__, __MIN__, __MAX__) MAX(__MIN__, MIN(__MAX__, __VALUE__))

@interface HomeShopDataVC () <UITableViewDelegate, UICollectionViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate, FilterDelegate, CategoryDelgate>

@property (weak, nonatomic) IBOutlet UIButton *btnListGrid;
@property (weak, nonatomic) IBOutlet UITableView *tblData;
@property (weak, nonatomic) IBOutlet UICollectionView *colData;

@property (strong,nonatomic) IBOutlet UIView *vwHeader;
@property (weak, nonatomic) IBOutlet UIView *vwtable;
@property (strong,nonatomic) IBOutlet UIView *vwNoItemToShow;
@property (weak, nonatomic) IBOutlet UIView *vwPopupBGSortBy;
@property (weak, nonatomic) IBOutlet UIView *vwPopupSortBy;
@property (weak, nonatomic) IBOutlet UIView *vwBG;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerSortBy;

@property (nonatomic) CGRect originalFrame;

@property (weak, nonatomic) IBOutlet UILabel *lblSortBy;
@property (weak, nonatomic) IBOutlet UILabel *lblFilter;
@property (weak, nonatomic) IBOutlet UILabel *lblSortByPopup;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;
@property (weak, nonatomic) IBOutlet UIButton *btnContinueShopping;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;

@property (weak, nonatomic) IBOutlet UIButton *btnSortBy;
@property (weak, nonatomic) IBOutlet UIButton *btnFilter;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *actLoading;

@property (strong, nonatomic) IBOutlet UILabel *lblNoItemAvailable;
@property (strong, nonatomic) IBOutlet UILabel *lblNoItemAvailableDesc;

@property (weak, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIImageView *imgHeaderImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;

@property (weak, nonatomic) IBOutlet UIView *vwFilterData;
@property (weak, nonatomic) IBOutlet UIView *vwNoFilterData;

@end

@implementation HomeShopDataVC
{
    int set1, noProductFound;
    int selectedIndex, selectedSortBy;
    NSString *selectedProductId;
    Boolean cellSelected;
    NSMutableArray *arrWishList;
    
    NSArray *arrselect,*arrPickerData;
    NSArray *arrUnselect;
    Boolean firstLoad;
    Boolean GrigList; // if YES then list else NO then grid
    NSInteger prevOffset;
    
//    NSMutableArray *arrImgURL, *arrProductName, *arrPrice, *arrRating;
    int page, productCount;
    NSMutableArray *arrProductData, *arrFilter, *arrRating;
    NSString *strMinPrice, *strMaxPrice;
    BOOL fromFilter;
    BOOL apiCallRunning;
    UIView *vw;
    NSMutableArray *arrGroupedProduct;
}
@synthesize CategoryID, fromCategory, fromViewAll, fromSearch, fromDealofTheDay, strSearchString;

- (void)viewDidLoad
{
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
    
    cellSelected=NO;
    selectedIndex = -1;
    
    firstLoad = YES;

    
    arrProductData = [[NSMutableArray alloc] init];
    if (appDelegate.isCatalogMode) {
        Product *product = [[Product alloc] init];
        [arrProductData addObject:product];
        [arrProductData addObject:product];
        [arrProductData addObject:product];
        [arrProductData addObject:product];
        [arrProductData addObject:product];
        [arrProductData addObject:product];
    }
    
    arrPickerData = [[NSArray alloc] initWithObjects:@"Newest First", @"Rating", @"Popularity", @"Price -- Low to High", @"Price -- High to Low", nil];
    
    [self.colData registerNib:[UINib nibWithNibName:@"ShopDataGridCell" bundle:nil] forCellWithReuseIdentifier:@"ShopDataGridCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.colData setCollectionViewLayout:flowLayout];
    self.colData.hidden = NO;
    self.tblData.hidden = YES;
    GrigList = YES;
    [self.btnListGrid setImage:[UIImage imageNamed:@"IconList"] forState:UIControlStateNormal];
    
    self.pickerSortBy.dataSource = self;
    self.pickerSortBy.delegate = self;
    
    [self.pickerSortBy reloadAllComponents];
    
    UIGestureRecognizer *singleTap = [[UIGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapAction:)];
    [self.vwPopupBGSortBy addGestureRecognizer:singleTap];
    
    self.originalFrame = self.tabBarController.tabBar.frame;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    page = 1;
    
    [self.pickerSortBy selectRow:0 inComponent:0 animated:YES];
    
    if (fromViewAll)
    {
        [self.pickerSortBy selectRow:2 inComponent:0 animated:YES];
    }
    else if (self.fromTopRatedProducts)
    {
        [self.pickerSortBy selectRow:1 inComponent:0 animated:YES];
    }
    [self loadProducts];
    set1 = 0;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [Util setHeaderColorView:vw];
    
    if (@available(iOS 13, *))
    {
        UIView *statusBar = [[UIView alloc]initWithFrame:[UIApplication sharedApplication].keyWindow.windowScene.statusBarManager.statusBarFrame] ;
        [Util setHeaderColorView:statusBar];
        [statusBar setHidden:NO];

        [[UIApplication sharedApplication].keyWindow addSubview:statusBar];
    }
    else
    {
        UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
        [statusBar setHidden:NO];
        if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
            [Util setHeaderColorView:statusBar];
        }
    }

    

    if (GrigList)
    {
        [self.btnListGrid setImage:[UIImage imageNamed:@"IconList"] forState:UIControlStateNormal];
        self.colData.hidden = NO;
        self.tblData.hidden = YES;
        GrigList = YES;
    }
    else
    {
        [self.btnListGrid setImage:[UIImage imageNamed:@"IconGrid"] forState:UIControlStateNormal];
        self.colData.hidden = YES;
        self.tblData.hidden = NO;
        GrigList = NO;
    }
    
    if (set1 == 0)
    {
        self.vwBG.frame = CGRectMake(0, 0, SCREEN_SIZE.width, SCREEN_SIZE.height);
        
        set1 = 1;
    }
    [self localize];
    
    arrWishList = [[NSMutableArray alloc] init];
    
    [arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
    
    
    [self.tblData reloadData];
    [self.colData reloadData];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwPopupSortBy.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, self.vwPopupSortBy.frame.size.height);
    [self.colData reloadData];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Localize Language

- (void)localize
{
    [self.btnContinueShopping setTitle:[MCLocalization stringForKey:@"CONTINUE SHOPPING"] forState:UIControlStateNormal];
    
    [Util setSecondaryColorButtonTitle:self.btnContinueShopping];
    [Util setSecondaryColorButtonImage:self.btnContinueShopping image:[UIImage imageNamed:@"MyRewardsButtonBG"]];
    [Util setSecondaryColorImageView:self.imgArrow];

    [Util setHeaderColorView:self.vwHeader];
    self.lblFilter.textColor = FilterColor;
    self.lblSortBy.textColor = FilterColor;
    
    
    self.lblSortBy.text = [MCLocalization stringForKey:@"Sort By"];
    self.lblFilter.text = [MCLocalization stringForKey:@"Filter"];
    
    self.lblNoItemAvailable.text = [MCLocalization stringForKey:@"No Product Found"];
    self.lblNoItemAvailableDesc.text = [MCLocalization stringForKey:@"Browse some Other Item"];
    
    self.lblSortByPopup.text = [MCLocalization stringForKey:@"Sort By"];
    
    [self.btnCancel setTitle:[MCLocalization stringForKey:@"Cancel"]  forState:UIControlStateNormal];
    [self.btnDone setTitle:[MCLocalization stringForKey:@"Done"] forState:UIControlStateNormal];
    
    arrPickerData = [[NSArray alloc] initWithObjects: [MCLocalization stringForKey:@"Newest First"], [MCLocalization stringForKey:@"Rating"], [MCLocalization stringForKey:@"Popularity"], [MCLocalization stringForKey:@"Price -- Low to High"], [MCLocalization stringForKey:@"Price -- High to Low"], nil];
    
    [_pickerSortBy reloadAllComponents];
    
    NSLog(@"--- %@", [MCLocalization stringForKey:@"non-existing-key"]);
    
    
    //set Font
    self.lblFilter.font = Font_Size_Product_Name_Not_Bold;
    self.lblSortBy.font = Font_Size_Product_Name_Not_Bold;
    self.btnDone.titleLabel.font = Font_Size_Title;
    self.btnCancel.titleLabel.font = Font_Size_Title;
    self.lblSortByPopup.font = Font_Size_Title;
    
    self.lblSortBy.textAlignment = NSTextAlignmentLeft;
    self.lblFilter.textAlignment = NSTextAlignmentLeft;

    if (appDelegate.isRTL) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
    }
}


#pragma mark - UITapGestureRecognizer Handler

- (void)singleTapAction:(UIGestureRecognizer *)singleTap
{
    [self popSortByView];
}

-(void)popSortByView
{
    [UIView animateWithDuration:0.5 animations:^{
        
        self.vwPopupBGSortBy.alpha = 0.0;
        self.vwPopupSortBy.frame = CGRectMake(0, SCREEN_SIZE.height, SCREEN_SIZE.width, self.vwPopupSortBy.frame.size.height);
    }completion:^(BOOL finished) {
        
        self.vwPopupBGSortBy.hidden = YES;
    }];
}

#pragma mark - Scrollview Delegate
//method to manage tab bar show and hide

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

#pragma mark - Button Clicks

-(IBAction)btnContinueShoppingClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnFilterClicked:(id)sender
{
    if(fromCategory)
    {
        if (fromFilter)
        {
            FilterVC *vc = [[FilterVC alloc] initWithNibName:@"FilterVC" bundle:nil];
            vc.categoryId = CategoryID;
            vc.fromAppliedFilter = YES;
            
            vc.arrSelectedValuesfromFilter = [[NSMutableArray alloc]initWithArray:[arrFilter mutableCopy]];
            vc.arrSelectedRatingValues = [[NSMutableArray alloc]initWithArray:[arrRating mutableCopy]];
            
            vc.sliderMaxValuefromFilter = [strMaxPrice doubleValue];
            vc.sliderMinValuefromFilter = [strMinPrice doubleValue];
            
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            FilterVC *vc = [[FilterVC alloc] initWithNibName:@"FilterVC" bundle:nil];
            vc.categoryId = CategoryID;
            vc.delegate = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else
    {
        FilterCategoryVC *vc = [[FilterCategoryVC alloc] initWithNibName:@"FilterCategoryVC" bundle:nil];
        vc.delegate =self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(IBAction)btnBackClicked:(id)sender
{
    self.tabBarController.tabBar.frame = self.originalFrame;
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnListORGridClicked:(id)sender
{
    if (GrigList)
    {
        [self.btnListGrid setImage:[UIImage imageNamed:@"IconGrid"] forState:UIControlStateNormal];
        self.colData.hidden = YES;
        self.tblData.hidden = NO;
        GrigList = NO;
    }
    else
    {
        [self.btnListGrid setImage:[UIImage imageNamed:@"IconList"] forState:UIControlStateNormal];
        self.colData.hidden = NO;
        self.tblData.hidden = YES;
        GrigList = YES;
    }
    [self.tblData reloadData];
    [self.colData reloadData];
}

-(IBAction)btnSortByClicked:(id)sender
{
    CGPoint offset = self.colData.contentOffset;
    [self.colData setContentOffset:offset animated:NO];
    CGPoint offset1 = self.tblData.contentOffset;
    [self.tblData setContentOffset:offset1 animated:NO];
    
    selectedSortBy = (int)[self.pickerSortBy selectedRowInComponent:0];
    
    UITabBar *tb = self.tabBarController.tabBar;
    [UIView animateWithDuration:0.4 animations:^{
        tb.frame = CGRectMake(tb.frame.origin.x, SCREEN_SIZE.height + 100, tb.frame.size.width, tb.frame.size.height); 
    }];
    
    self.vwPopupBGSortBy.alpha = 0.0;
    self.vwPopupBGSortBy.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.vwPopupBGSortBy.alpha = 0.75;
        self.vwPopupSortBy.frame =CGRectMake(0, SCREEN_SIZE.height - self.vwPopupSortBy.frame.size.height - statusBarSize.height, self.vwPopupSortBy.frame.size.width, self.vwPopupSortBy.frame.size.height);
    }];
}

-(IBAction)btnPopupSortbyDoneClicked:(id)sender
{
    [self initializeData];
    
    [self popSortByView];
    
    UITabBar *tb = self.tabBarController.tabBar;
    [UIView animateWithDuration:0.4 animations:^{
        tb.frame = self.originalFrame;
    }];
}

-(IBAction)btnPopupSortbyCancelClicked:(id)sender
{
    [self.pickerSortBy selectRow:selectedSortBy inComponent:0 animated:YES];
    
    [self popSortByView];
    UITabBar *tb = self.tabBarController.tabBar;
    [UIView animateWithDuration:0.4 animations:^{
        tb.frame = self.originalFrame;
    }];
}


-(IBAction)btnNotificationClicked:(id)sender
{
    [appDelegate Notification:self];
}

-(IBAction)btnSearchClicked:(id)sender
{
    [appDelegate Search:self];
}



#pragma mark - Cell clicks
-(void)btnStoreClicked:(UIButton *)sender
{
    [self btnAddToCartClicked:sender];
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
        [self.colData reloadData];
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
        
        
        if (GrigList)
        {
            [self.colData reloadData];
        }
        else if (GrigList == NO)
        {
            [self.tblData reloadData];
        }
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
        
        if (GrigList)
        {
            [self.colData reloadData];
        }
        else if (GrigList == NO)
        {
            [self.tblData reloadData];
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
    return arrProductData.count;
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
    
    Product *object = [arrProductData objectAtIndex:indexPath.row];
    
    if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode)
    {
        cell.btnStore.hidden = false;
//        [Util setPrimaryColorButton:cell.btnStore];
        
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
            cell.btnStore.alpha = 1.0;
        }
        else
        {
            cell.btnStore.userInteractionEnabled = false;
            cell.btnStore.alpha = 0.4;
        }
        if (object.in_stock == 1)
        {
            cell.btnStore.userInteractionEnabled = true;
            cell.alpha = 1.0;
        }
        else
        {
            cell.btnStore.userInteractionEnabled = false;
//            cell.alpha = 0.4;
        }
    }
    else
    {
        cell.btnStore.hidden = true;
    }

    Boolean set = [arrWishList containsObject:[NSString stringWithFormat:@"%d",object.product_id]];
    //    for (int i = 0; i < arrWishList.count; i++)
    //    {
    //        if ([[arrWishList objectAtIndex:i] integerValue] == object.product_id)
    //        {
    //            set = YES;
    //        }
    //    }

    //image change for wish list
    if (set==YES)
    {
        [Util setPrimaryColorButtonImageBG:cell.btnWishList image:[UIImage imageNamed:@"IconInWishList"]];
    }
    else
    {
        [cell.btnWishList setImage:[UIImage imageNamed:@"IconWishList"] forState:UIControlStateNormal];
    }
    
    
    cell.btnWishList.tag = indexPath.row;
    cell.btnStore.tag = indexPath.row;
    cell.lblTitle.textColor = FontColorGray;
    cell.lblTitle.text = object.name;
    cell.lblTitle.font=Font_Size_Product_Name_Not_Bold;
    
    [cell.act startAnimating];
    [Util setPrimaryColorActivityIndicator:cell.act];
    
    if (object.arrImages.count > 0)
    {
        [cell.img sd_setImageWithURL:[Util EncodedURL:[[object.arrImages objectAtIndex:0] valueForKey:@"src"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
            cell.img.image=image;
            [cell.act stopAnimating];
        }];
    }

    NSString * htmlString = object.price_html;
    cell.lblRate.attributedText = [Util setPriceForItem:htmlString];
    
    cell.btnStore.tag = indexPath.row;
    if (appDelegate.isCatalogMode) {
        cell.btnStore.hidden = true;
    } else {
        if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
            [cell.btnStore addTarget:self action: @selector(btnStoreClicked:) forControlEvents:UIControlEventTouchUpInside];
            cell.btnStore.hidden = false;
        } else {
            cell.btnStore.hidden = true;
        }
    }
    
    [cell.btnWishList addTarget:self action: @selector(btnWishListClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    if (arrselect.count > 0)
    {
        NSIndexPath *indexPath1 = [arrselect objectAtIndex:0];
        if (indexPath.row == indexPath1.row)
        {
            
            cell.btnWishList.userInteractionEnabled = NO;
            [UIView animateWithDuration:0.4f animations:^{
                
                cell.btnWishList.transform = CGAffineTransformMakeScale(1.5, 1.5);
            } completion:^(BOOL finished){
                
                [Util setPrimaryColorButtonImageBG:cell.btnWishList image:[UIImage imageNamed:@"IconInWishList"]];

                // for zoom out
                [UIView animateWithDuration:0.4f animations:^{
                    
                    cell.btnWishList.transform = CGAffineTransformMakeScale(1, 1);
                }completion:^(BOOL finished){
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
    for (UIView *subview in cell.subviews)
    {
        if (subview.tag>=1000)
        {
            HCSStarRatingView *starRatingView=(HCSStarRatingView *)subview;
            starRatingView.value = object.average_rating;
            if (appDelegate.isRTL)
            {
                cell.lblRate.frame = CGRectMake(cell.frame.size.width - cell.lblRate.frame.size.width - 99*SCREEN_SIZE.width/375, cell.lblRate.frame.origin.y, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                subview.frame = CGRectMake(cell.lblRate.frame.size.width + cell.lblRate.frame.origin.x- subview.frame.size.width, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8,  (cell.frame.size.width/2.3)/2, appDelegate.FontSizeProductName);
                [starRatingView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                cell.btnWishList.frame = CGRectMake(3, cell.btnWishList.frame.origin.y, cell.btnWishList.frame.size.width, cell.btnWishList.frame.size.height);
            }
            else
            {
                //nonRTL
                subview.frame = CGRectMake(cell.lblRate.frame.origin.x, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8, (cell.frame.size.width/2.3)/2, appDelegate.FontSizeProductName);
                [starRatingView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                cell.lblRate.frame = CGRectMake(cell.lblRate.frame.origin.x, subview.frame.origin.y + subview.frame.size.height + 8, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
            }
            flg=YES;
        }
    }
    
    if (!flg)
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                HCSStarRatingView *starRatingView;
                if (appDelegate.isRTL)
                {
                    //RTL
                    NSLog(@"path : %f",SCREEN_SIZE.width - 60 - 99*SCREEN_SIZE.width/375);
                    cell.lblRate.frame = CGRectMake(cell.frame.size.width - cell.lblRate.frame.size.width - 99*SCREEN_SIZE.width/375, cell.lblRate.frame.origin.y, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                    starRatingView = [Util setStarRating:object.average_rating frame:CGRectMake(cell.lblRate.frame.size.width + cell.lblRate.frame.origin.x- (cell.frame.size.width/2.3)/2, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8, (cell.frame.size.width/2.3)/2,appDelegate.FontSizeProductName) tag:1000+indexPath.row];
                    cell.btnWishList.frame = CGRectMake(3, cell.btnWishList.frame.origin.y, cell.btnWishList.frame.size.width, cell.btnWishList.frame.size.height);
                    [starRatingView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                }
                else
                {
                    //nonRTL
                    starRatingView = [Util setStarRating:object.average_rating frame:CGRectMake(cell.lblRate.frame.origin.x, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8, (cell.frame.size.width/2.1)/2,appDelegate.FontSizeProductName) tag:1000+indexPath.row];
                    [starRatingView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                }
                [cell addSubview:starRatingView];
                if (appDelegate.isRTL)
                {
                    //RTL
                    cell.lblRate.frame = CGRectMake(cell.frame.size.width - cell.lblRate.frame.size.width - 99*SCREEN_SIZE.width/375, cell.lblRate.frame.origin.y, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                    
                    cell.lblRate.textAlignment = NSTextAlignmentRight;
                }
                else
                {
                    //NonRTL
                    cell.lblRate.frame = CGRectMake(cell.lblRate.frame.origin.x, starRatingView.frame.origin.y + starRatingView.frame.size.height + 8, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                    cell.lblRate.textAlignment = NSTextAlignmentLeft;
                }
                
            });
        });
    }
    
    if (!apiCallRunning)
    {
        if (noProductFound != 1)
        {
            if (productCount == 10)
            {
                if (indexPath.row == arrProductData.count - 4)
                {
                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
                        //Background Thread
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self loadProducts];
                            self->apiCallRunning = YES;
                        });
                    });
                }
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
    
    if (appDelegate.isRTL)
    {
        
        cell.lblTitle.textAlignment = NSTextAlignmentRight;
        cell.lblRate.textAlignment = NSTextAlignmentRight;
//        cell.btnWishList.frame = CGRectMake(3, cell.btnWishList.frame.origin.y, cell.btnWishList.frame.size.width, cell.btnWishList.frame.size.height);
    }
    else
    {
        cell.lblTitle.textAlignment = NSTextAlignmentLeft;
        cell.lblRate.textAlignment = NSTextAlignmentLeft;
    }
    [Util setTriangleLable:cell.vwDiscount product:object];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (page != 1) {
        
        [appDelegate setRecentProduct:[arrProductData objectAtIndex:indexPath.row]];
        
        Product *object = [arrProductData objectAtIndex:indexPath.row];
        
        if ([object.type1 isEqualToString:@"external"])
        {
            //External Products
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
            //Simple Products
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

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrProductData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
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
    
//    if (!apiCallRunning)
//    {
//        if (noProductFound != 1)
//        {
//            if (productCount == 10)
//            {
//                if (indexPath.row == arrProductData.count - 4)
//                {
//                    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
//                        //Background Thread
//                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                            [self loadProducts];
//                            apiCallRunning = YES;
//                        });
//                    });
//                }
//            }
//        }
//    }
    
    
    
    if (!apiCallRunning && noProductFound != 1 && productCount == 10 && indexPath.row == arrProductData.count - 4)
    {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
            //Background Thread
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self loadProducts];
                self->apiCallRunning = YES;
            });
        });
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
    return 6.0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(6, 6, 6, 6);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
        return CGSizeMake((collectionView.frame.size.width/2)-10, (SCREEN_SIZE.width*276/375));
    } else {
        return CGSizeMake((collectionView.frame.size.width/2)-10, (SCREEN_SIZE.width*276/375) - (SCREEN_SIZE.width*30/375));
    }
}

#pragma mark - PickerVIew Delegate

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [arrPickerData objectAtIndex:row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    return attString;
}

// The number of columns of data
- (long)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (long)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (int)arrPickerData.count;
}

// The data to return for the row and component (column) that's being passed in
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [arrPickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        tView.font=Font_Size_Navigation_Title;
    }
    tView.textAlignment=NSTextAlignmentCenter;
    // Fill the label text here
    tView.text=[arrPickerData objectAtIndex:row];
    return tView;
}


#pragma mark - to hide bottom bar

-(BOOL)hidesBottomBarWhenPushed
{
    return NO;
}

#pragma mark - API calls

- (void)loadProducts
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    
    if (page == 1) {
//        if(appDelegate.isShimmerLoader){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.colData showLoader];
//                [self.tblData showLoader];
//            });
//        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                SHOW_LOADER_ANIMTION();
            });
//        }
        
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.actLoading.activityIndicatorViewStyle=UIActivityIndicatorViewStyleWhiteLarge;
            
            [Util setPrimaryColorActivityIndicator:self.actLoading];
            
            [self.actLoading startAnimating];
            self.actLoading.frame = CGRectMake(self.actLoading.frame.origin.x, self.vwAllData.frame.size.height - self.actLoading.frame.size.height - 15, self.actLoading.frame.size.width, self.actLoading.frame.size.height);
        });
    }
    if (fromSearch)
    {
        [dict setValue:strSearchString forKey:@"search"];
        [dict setValue:[NSString stringWithFormat:@"%d", CategoryID] forKey:@"category"];
    }
    if (fromCategory)
    {
        [dict setValue:[NSString stringWithFormat:@"%d", CategoryID] forKey:@"category"];
    }
    if (fromFilter)
    {
        [dict setValue:arrFilter forKey:@"attribute"];
        
        if (![strMaxPrice isEqualToString:@"0"]) {
            [dict setValue:strMaxPrice forKey:@"max_price"];
        }
        if (![strMinPrice isEqualToString:@"0"]) {
            [dict setValue:strMinPrice forKey:@"min_price"];
        }
        if (arrRating.count > 0)
        {
            NSString *rating = [arrRating componentsJoinedByString:@","];
            [dict setValue:rating forKey:@"rating_filter"];
        }
    }
    
    if ([self.pickerSortBy selectedRowInComponent:0] == 0)
    {
        //Newest First
    }
    else if ([self.pickerSortBy selectedRowInComponent:0] == 1)
    {
        //Rating
        [dict setValue:@"rating" forKey:@"order_by"];
    }
    else if ([self.pickerSortBy selectedRowInComponent:0] == 2)
    {
        //Popularity
        [dict setValue:@"popularity" forKey:@"order_by"];
    }
    else if ([self.pickerSortBy selectedRowInComponent:0] == 3)
    {
        //Price -- Low to High
        [dict setValue:@"price" forKey:@"order_by"];
    }
    else if ([self.pickerSortBy selectedRowInComponent:0] == 4)
    {
        //Price -- High to Low
        [dict setValue:@"price-desc" forKey:@"order_by"];
    }
    if (self.SaleProducts)
    {
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"on_sale"];
    }
    if (fromDealofTheDay)
    {
        NSString *str = [[NSString alloc] init];
        
        for (int i = 0; i < appDelegate.arrDealOfTheDay.count; i++)
        {
            if (i == 0)
            {
                str = [NSString stringWithFormat:@"%@", [[appDelegate.arrDealOfTheDay objectAtIndex:i] valueForKey:@"id"]];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@,%@", str, [[appDelegate.arrDealOfTheDay objectAtIndex:i] valueForKey:@"id"]];
            }
        }
        [dict setValue:str forKey:@"include"];
    }
    
    if (self.strSellerId.length>0)
    {
        [dict setObject:self.strSellerId forKey:@"seller_id"];
    }
    
    if (self.fromFeaturedProducts)
    {
        [dict setValue:[NSNumber numberWithBool:self.fromFeaturedProducts] forKey:@"featured"];
    }
    NSLog(@" dict is :: %@", dict);
    
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^()
    //                   {
    self->apiCallRunning = YES;
    [CiyaShopAPISecurity productListing:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        
        self->apiCallRunning = NO;
        
        if (self->page == 1) {
            self->arrProductData = [[NSMutableArray alloc]init];
        }
        if(success==YES)
        {
            //no error
            if (dictionary.count>0)
            {
                if([dictionary isKindOfClass:[NSArray class]])
                {
                    //Is array
                    NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                    
                    self->productCount = (int)arrData.count;
                    
                    for (int i = 0; i < arrData.count; i++)
                    {
                        Product *object = [Util setProductDataListing:[arrData objectAtIndex:i]];
                        [self->arrProductData addObject:object];
                    }
                    self->page++;
                }
                else if([dictionary isKindOfClass:[NSDictionary class]])
                {
                    //is dictionary
                    if([[dictionary valueForKey:@"message"] isEqualToString:@"No product found"])
                    {
                        self->noProductFound = 1;
                    }
                }
            }
        }
        else
        {
            //error
            self->noProductFound = 1;
        }
        
        if (self->arrProductData.count == 0)
        {
            self.colData.hidden = YES;
            self.tblData.hidden = YES;
            self.vwNoFilterData.hidden = NO;
            self.vwFilterData.hidden = YES;
            self.vwNoItemToShow.hidden = NO;
            [self.btnFilter setUserInteractionEnabled:false];
            [self.btnSortBy setUserInteractionEnabled:false];
            [self.btnListGrid setUserInteractionEnabled:false];
        }
        else
        {
            self.colData.hidden = NO;
            self.tblData.hidden = NO;
            
            self.vwNoFilterData.hidden = YES;
            self.vwFilterData.hidden = NO;
            self.vwNoItemToShow.hidden = YES;
            [self.btnFilter setUserInteractionEnabled:true];
            [self.btnSortBy setUserInteractionEnabled:true];
            [self.btnListGrid setUserInteractionEnabled:true];
        }
        [self.colData hideLoader];
        [self.tblData hideLoader];
        HIDE_PROGRESS;

        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                //                                   dispatch_async(dispatch_get_main_queue(), ^{
                [self.colData reloadData];
                [self.tblData reloadData];
                [self.actLoading stopAnimating];
                //                                       HIDE_PROGRESS;
                //                                   });
            });
        });
    }];
    //                   });
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
                [self.colData reloadData];
                [self.tblData reloadData];
                //[self.actLoading stopAnimating];
                //                                   });
            });
        });
    }];
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
            
            [self.tblData reloadData];
            [self.colData reloadData];
        }
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                //                                   dispatch_async(dispatch_get_main_queue(), ^{
                [self.colData reloadData];
                [self.tblData reloadData];
                //[self.actLoading stopAnimating];
                //                                   });
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


-(void)initializeData
{
    page = 1;
    arrProductData = [[NSMutableArray alloc] init];
    
    [self.colData reloadData];
    [self.tblData reloadData];
    
    [self loadProducts];
}

#pragma mark - Filter Delegate

-(void)applyFilter:(NSMutableArray *)arr minPrice:(double)minPrice maxPrice:(double)maxPrice rating:(NSMutableArray *)rating
{
    fromFilter = YES;
    arrFilter = [[NSMutableArray alloc] initWithArray:[arr mutableCopy]];
    arrRating = [[NSMutableArray alloc] initWithArray:[rating mutableCopy]];
    if (minPrice == 0)
    {
        strMinPrice = @"0";
    }
    else
    {
        strMinPrice = [NSString stringWithFormat:@"%.2f", minPrice];
    }
    if (minPrice == 0)
    {
        strMaxPrice = @"0";
    }
    else
    {
        strMaxPrice = [NSString stringWithFormat:@"%.2f", maxPrice];
    }
    [self initializeData];
}

#pragma mark - Category Delegate

-(void)setCategory:(NSString *)ids
{
    fromCategory = YES;
    CategoryID = [ids intValue];
    
    [self initializeData];
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
