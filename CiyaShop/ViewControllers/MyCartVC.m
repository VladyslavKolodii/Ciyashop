//
//  MyCartVC.m
//  QuickClick
//
//  Created by APPLE on 21/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "MyCartVC.h"
#import "ShopDataCell.h"
#import "GroupItemDetailVC.h"
#import "VariableItemDetailVC.h"
#import "ItemDetailVC.h"
#import "ThankYouVC.h"
#import "SigninVC.h"

@import Firebase;
@import GoogleSignIn;

@interface MyCartVC ()<UIGestureRecognizerDelegate, UITableViewDelegate, SetDataDelegate, ThankYouDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrl;
@property (strong, nonatomic) IBOutlet UITableView *tblItems;

@property (strong, nonatomic) IBOutlet UIView *vwHeader;
@property (strong, nonatomic) IBOutlet UIView *vwPriceDetail;
@property (strong, nonatomic) IBOutlet UIView *vwTotal;
@property (strong, nonatomic) IBOutlet UIView *vwNoAnyProduct;
@property (strong, nonatomic) IBOutlet UIView *vwPriceDetailData;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceDetail;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblDelivery;
@property (strong, nonatomic) IBOutlet UILabel *lblAmountPayable;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceValue;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceDelivery;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceTotal;
@property (strong, nonatomic) IBOutlet UILabel *lblPriceTotalFinal;
@property (strong, nonatomic) IBOutlet UILabel *lblNumberofItem;

@property (strong, nonatomic) IBOutlet UIButton *btnPriceDetail;
@property (strong, nonatomic) IBOutlet UIButton *btnContinue;
@property (strong, nonatomic) IBOutlet UIButton *btnContinueShopping;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UILabel *lblNoIteminCart;
@property (strong, nonatomic) IBOutlet UILabel *lblNoIteminCartDesc;

@property (strong, nonatomic) IBOutlet UIView *vwAllData;
@property (strong, nonatomic) IBOutlet UIView *vwContent;

@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;

@end

@implementation MyCartVC
{
    int selectedCell;
    NSMutableArray *arrMyCart;
    NSString *strSize, *strColor,*strCheckOutUrl,*strThankYouUrl;
    int productID;
    UIView *vw;
    NSMutableArray *arrMyCartDynamic,*arrKey;
    BOOL isFromLogin;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.navigationController.navigationBarHidden = YES;
    [self.tblItems registerNib:[UINib nibWithNibName:@"ShopDataCell" bundle:nil] forCellReuseIdentifier:@"ShopDataCell"];
    selectedCell = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localize) name:MCLocalizationLanguageDidChangeNotification object:nil];
    self.btnContinue.layer.cornerRadius = 3;
    self.btnContinue.layer.masksToBounds = true;
}

-(void) viewWillAppear:(BOOL)animated3
{
    [super viewWillAppear:YES];
    [self viewDidLayoutSubviews];
    
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

    //    [self GetCartProduct];
    
    
    [Util setHeaderColorView:vw];
    [Util setSecondaryColorButtonImage:self.btnContinueShopping image:[UIImage imageNamed:@"MyRewardsButtonBG"]];
    [Util setSecondaryColorImageView:self.imgArrow];
    if (appDelegate.isFromBuyNow)
    {
        arrMyCart = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kBuyNow] mutableCopy]];
    }
    else
    {
        arrMyCart = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
    }
    if (arrMyCart.count > 0)
    {
        [self setPriceinLabels];
        [self.tblItems reloadData];
        self.vwNoAnyProduct.hidden = YES;
        self.scrl.hidden = NO;
    }
    else
    {
        self.vwNoAnyProduct.hidden = NO;
        self.scrl.hidden = YES;
    }
    [self.tblItems reloadData];
    
    if (isFromLogin)
    {
        isFromLogin = false;
        if ([Util getBoolData:kLogin])
        {
            [self AddToCartData];
        }
    }
    
    [self localize];
    //    [self AddToCartDataLoad];
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.vwAllData.frame = CGRectMake(0, statusBarSize.height, self.vwAllData.frame.size.width, SCREEN_SIZE.height - statusBarSize.height - self.tabBarController.tabBar.frame.size.height);
    vw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, statusBarSize.width, statusBarSize.height)];
    [Util setHeaderColorView:vw];
    [self.view addSubview:vw];
    
    [self.lblPrice sizeToFit];
    self.lblNumberofItem.frame = CGRectMake(self.lblPrice.frame.origin.x + self.lblPrice.frame.size.width + 8, self.lblPrice.frame.origin.y, self.lblNumberofItem.frame.size.width, self.lblNumberofItem.frame.size.height);
    
    [self.lblPriceTotalFinal sizeToFit];
    self.btnPriceDetail.frame = CGRectMake(self.lblPriceTotalFinal.frame.origin.x + self.lblPriceTotalFinal.frame.size.width + 8, self.btnPriceDetail.frame.origin.y, self.btnPriceDetail.frame.size.width, self.btnPriceDetail.frame.size.height);
    
    self.vwPriceDetailData.layer.shadowColor = [UIColor blackColor].CGColor;
    self.vwPriceDetailData.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    self.vwPriceDetailData.layer.shadowRadius = 1.0f;
    self.vwPriceDetailData.layer.shadowOpacity = 0.5f;
    self.vwPriceDetailData.layer.masksToBounds = NO;
    self.vwPriceDetailData.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.vwPriceDetailData.bounds cornerRadius:self.vwPriceDetailData.layer.cornerRadius].CGPath;
    
    self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.vwTotal.frame.origin.y + self.vwTotal.frame.size.height);
    
    [self localize];
}

-(void)setTableframe {
    self.tblItems.frame = CGRectMake(self.tblItems.frame.origin.x, self.tblItems.frame.origin.y, self.tblItems.frame.size.width, self.tblItems.contentSize.height);
    [UIView animateWithDuration:0.4 animations:^{
        self.vwContent.frame = CGRectMake(self.vwContent.frame.origin.x, self.tblItems.frame.origin.y + self.tblItems.frame.size.height + 18*SCREEN_SIZE.width/375, self.vwContent.frame.size.width, self.vwContent.frame.size.height);
        
        self.scrl.contentSize = CGSizeMake(SCREEN_SIZE.width, self.vwContent.frame.origin.y + self.vwContent.frame.size.height);
    }];
}

-(NSString *)stringByFormattingString:(NSNumber *)string
{
    //        NSString *formatString = [NSString stringWithFormat:@"%%.%ldf", (long)precision];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:appDelegate.strThousandSeparatore];
    [numberFormatter setGroupingSize:3];
    //        [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    //    NSLog(@"%@",[NSLocale localeWithLocaleIdentifier:@"pt_BR"]);
    //    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"DE"]];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:appDelegate.strDecimalSeparatore];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:appDelegate.decimal];
    numberFormatter.minimumFractionDigits=appDelegate.decimal;
    //        [numberFormatter setAlwaysShowsDecimalSeparator:YES];
    NSString *theString = [numberFormatter stringFromNumber:string];
    return theString;
}

-(void)setPriceinLabels
{
    double Price = 0;
    
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
        Price = Price + (object.price * object.quantity);
        
    }
    
    if ([appDelegate.strCurrencySymbolPosition isEqualToString:@"left"])
    {
        self.lblPriceValue.text = [NSString stringWithFormat:@"%@%@", appDelegate.strCurrencySymbol,[self stringByFormattingString:[NSNumber numberWithDouble:Price]]];
        self.lblPriceTotal.text = [NSString stringWithFormat:@"%@%@", appDelegate.strCurrencySymbol, [self stringByFormattingString:[NSNumber numberWithDouble:Price]]];
        self.lblPriceTotalFinal.text = [NSString stringWithFormat:@"%@%@", appDelegate.strCurrencySymbol, [self stringByFormattingString:[NSNumber numberWithDouble:Price]]];
        self.lblPriceDelivery.text = [NSString stringWithFormat:@"%@", appDelegate.strCurrencySymbol];
    }
    else if ([appDelegate.strCurrencySymbolPosition isEqualToString:@"left_space"])
    {
        self.lblPriceValue.text = [NSString stringWithFormat:@"%@ %@", appDelegate.strCurrencySymbol, [self stringByFormattingString:[NSNumber numberWithDouble:Price]]];
        self.lblPriceTotal.text = [NSString stringWithFormat:@"%@ %@", appDelegate.strCurrencySymbol, [self stringByFormattingString:[NSNumber numberWithDouble:Price]]];
        self.lblPriceTotalFinal.text = [NSString stringWithFormat:@"%@ %@", appDelegate.strCurrencySymbol, [self stringByFormattingString:[NSNumber numberWithDouble:Price]]];
        self.lblPriceDelivery.text = [NSString stringWithFormat:@"%@ ", appDelegate.strCurrencySymbol];
    }
    else if ([appDelegate.strCurrencySymbolPosition isEqualToString:@"right"]) {
        self.lblPriceValue.text = [NSString stringWithFormat:@"%@%@", [self stringByFormattingString:[NSNumber numberWithDouble:Price]],appDelegate.strCurrencySymbol ];
        self.lblPriceTotal.text = [NSString stringWithFormat:@"%@%@",[self stringByFormattingString:[NSNumber numberWithDouble:Price]], appDelegate.strCurrencySymbol];
        self.lblPriceTotalFinal.text = [NSString stringWithFormat:@"%@%@", [self stringByFormattingString:[NSNumber numberWithDouble:Price]], appDelegate.strCurrencySymbol];
        self.lblPriceDelivery.text = [NSString stringWithFormat:@"%@", appDelegate.strCurrencySymbol];
    }
    else if ([appDelegate.strCurrencySymbolPosition isEqualToString:@"right_space"]) {
        self.lblPriceValue.text = [NSString stringWithFormat:@"%@ %@", [self stringByFormattingString:[NSNumber numberWithDouble:Price]],appDelegate.strCurrencySymbol ];
        self.lblPriceTotal.text = [NSString stringWithFormat:@"%@ %@", [self stringByFormattingString:[NSNumber numberWithDouble:Price]], appDelegate.strCurrencySymbol];
        self.lblPriceTotalFinal.text = [NSString stringWithFormat:@"%@ %@", [self stringByFormattingString:[NSNumber numberWithDouble:Price]], appDelegate.strCurrencySymbol];
        self.lblPriceDelivery.text = [NSString stringWithFormat:@" %@", appDelegate.strCurrencySymbol];
    }
    
    
    
    
    [self.lblPriceTotalFinal sizeToFit];
    
    self.lblNumberofItem.text = [NSString stringWithFormat:@"(%d %@)",(int)arrMyCart.count, [MCLocalization stringForKey:@"items"]];
    [self.lblNumberofItem sizeToFit];
    
    if (appDelegate.isRTL)
    {
        self.lblNumberofItem.frame = CGRectMake(self.lblPrice.frame.origin.x - self.lblNumberofItem.frame.size.width - 8, self.lblPrice.frame.origin.y, self.lblNumberofItem.frame.size.width, self.lblNumberofItem.frame.size.height);
        self.lblPriceTotalFinal.frame = CGRectMake(SCREEN_SIZE.width -  self.lblPriceTotalFinal.frame.size.width - 20*SCREEN_SIZE.width/375, self.lblPriceTotalFinal.frame.origin.y, self.lblPriceTotalFinal.frame.size.width, self.lblPriceTotalFinal.frame.size.height);
    }
    else
    {
        self.lblNumberofItem.frame = CGRectMake(self.lblPrice.frame.origin.x + self.lblPrice.frame.size.width + 8, self.lblPrice.frame.origin.y, self.lblNumberofItem.frame.size.width, self.lblNumberofItem.frame.size.height);
        self.lblPriceTotalFinal.frame = CGRectMake(20*SCREEN_SIZE.width/375, self.lblPriceTotalFinal.frame.origin.y, self.lblPriceTotalFinal.frame.size.width, self.lblPriceTotalFinal.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Localize Language

- (void)localize
{
    [Util setPrimaryColorView:self.vwTotal];
    self.lblTitle.textColor = OtherTitleColor;
    [Util setHeaderColorView:self.vwHeader];
    
    self.lblNoIteminCart.text = [MCLocalization stringForKey:@"Cart is Empty"];
    self.lblNoIteminCartDesc.text = [MCLocalization stringForKey:@"Simply browse and add item to cart."];
    [self.btnContinueShopping setTitle:[MCLocalization stringForKey:@"CONTINUE SHOPPING"] forState:UIControlStateNormal];
    
    [Util setSecondaryColorButtonTitle:self.btnContinueShopping];
    
    self.lblTitle.text = [MCLocalization stringForKey:@"CART"];
    self.lblPriceDetail.text = [MCLocalization stringForKey:@"Price Details:"];
    self.lblPrice.text = [MCLocalization stringForKey:@"Price"];
    self.lblDelivery.text = [MCLocalization stringForKey:@"Delivery"];
    self.lblAmountPayable.text = [MCLocalization stringForKey:@"Amount Payable"];
    
    [self.btnPriceDetail setTitle:[MCLocalization stringForKey:@"View price details"] forState:UIControlStateNormal];
    [self.btnContinue setTitle:[MCLocalization stringForKey:@"CONTINUE"] forState:UIControlStateNormal];
    
    //    [Util setHeaderColorButton:self.btnContinue];
    
    strSize = [MCLocalization stringForKey:@"Size:"];
    strColor = [MCLocalization stringForKey:@"Color:"];
    
    [self.lblPrice sizeToFit];
    [self.lblNumberofItem sizeToFit];
    [self.lblPriceTotalFinal sizeToFit];
    [self.lblAmountPayable sizeToFit];
    
    if (appDelegate.isRTL)
    {
        //RTL
        [self.tblItems setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        self.lblPriceDetail.textAlignment = NSTextAlignmentRight;
        
        self.lblPrice.frame = CGRectMake(self.vwPriceDetailData.frame.size.width - self.lblPrice.frame.size.width - 38*SCREEN_SIZE.width/375, self.lblPrice.frame.origin.y, self.lblPrice.frame.size.width, self.lblPrice.frame.size.height);
        
        self.lblNumberofItem.frame = CGRectMake(self.lblPrice.frame.origin.x - self.lblNumberofItem.frame.size.width - 8, self.lblPrice.frame.origin.y, self.lblNumberofItem.frame.size.width, self.lblNumberofItem.frame.size.height);
        self.lblNumberofItem.textAlignment = NSTextAlignmentRight;
        
        self.lblPriceValue.frame = CGRectMake(38*SCREEN_SIZE.width/375, self.lblPriceValue.frame.origin.y, self.lblPriceValue.frame.size.width, self.lblPriceValue.frame.size.height);
        self.lblPriceValue.textAlignment = NSTextAlignmentLeft;
        
        
        self.lblAmountPayable.frame = CGRectMake(self.vwPriceDetailData.frame.size.width - self.lblAmountPayable.frame.size.width - 38*SCREEN_SIZE.width/375, self.lblAmountPayable.frame.origin.y, self.lblAmountPayable.frame.size.width, self.lblAmountPayable.frame.size.height);
        
        self.lblPriceTotal.frame = CGRectMake(38*SCREEN_SIZE.width/375, self.lblPriceTotal.frame.origin.y, self.lblPriceTotal.frame.size.width, self.lblPriceTotal.frame.size.height);
        self.lblPriceTotal.textAlignment = NSTextAlignmentLeft;
        
        self.btnBack.frame = CGRectMake(SCREEN_SIZE.width - self.btnBack.frame.size.width, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(M_PI);
        
        self.btnContinue.frame = CGRectMake(20*SCREEN_SIZE.width/375, self.btnContinue.frame.origin.y, self.btnContinue.frame.size.width, self.btnContinue.frame.size.height);
        self.lblPriceTotalFinal.frame = CGRectMake(SCREEN_SIZE.width -  self.lblPriceTotalFinal.frame.size.width - 20*SCREEN_SIZE.width/375, self.lblPriceTotalFinal.frame.origin.y, self.lblPriceTotalFinal.frame.size.width, self.lblPriceTotalFinal.frame.size.height);
    }
    else
    {
        //No RTL
        [self.tblItems setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        self.lblPriceDetail.textAlignment = NSTextAlignmentLeft;
        
        self.lblPrice.frame = CGRectMake(38*SCREEN_SIZE.width/375, self.lblPrice.frame.origin.y, self.lblPrice.frame.size.width, self.lblPrice.frame.size.height);
        
        
        self.lblNumberofItem.frame = CGRectMake(self.lblPrice.frame.origin.x + self.lblNumberofItem.frame.size.width + 8, self.lblPrice.frame.origin.y, self.lblNumberofItem.frame.size.width, self.lblNumberofItem.frame.size.height);
        self.lblNumberofItem.textAlignment = NSTextAlignmentLeft;
        
        self.lblPriceValue.frame = CGRectMake(self.vwPriceDetailData.frame.size.width - self.lblPriceValue.frame.size.width - 38*SCREEN_SIZE.width/375, self.lblPriceValue.frame.origin.y, self.lblPriceValue.frame.size.width, self.lblPriceValue.frame.size.height);
        self.lblPriceValue.textAlignment = NSTextAlignmentRight;
        
        self.lblAmountPayable.frame = CGRectMake(38*SCREEN_SIZE.width/375, self.lblAmountPayable.frame.origin.y, self.lblAmountPayable.frame.size.width, self.lblAmountPayable.frame.size.height);
        
        self.lblPriceTotal.frame = CGRectMake(self.vwPriceDetailData.frame.size.width - self.lblPriceTotal.frame.size.width - 38*SCREEN_SIZE.width/375, self.lblPriceTotal.frame.origin.y, self.lblPriceTotal.frame.size.width, self.lblPriceTotal.frame.size.height);
        self.lblPriceTotal.textAlignment = NSTextAlignmentRight;
        
        self.btnBack.frame = CGRectMake(0, self.btnBack.frame.origin.y, self.btnBack.frame.size.width, self.btnBack.frame.size.height);
        self.btnBack.transform = CGAffineTransformMakeRotation(0);
        
        self.btnContinue.frame = CGRectMake(SCREEN_SIZE.width -  self.btnContinue.frame.size.width - 20*SCREEN_SIZE.width/375, self.btnContinue.frame.origin.y, self.btnContinue.frame.size.width, self.btnContinue.frame.size.height);
        self.lblPriceTotalFinal.frame = CGRectMake(20*SCREEN_SIZE.width/375, self.lblPriceTotalFinal.frame.origin.y, self.lblPriceTotalFinal.frame.size.width, self.lblPriceTotalFinal.frame.size.height);
    }
    [self.tblItems reloadData];
    [self setTableframe];
}

#pragma mark - Scrollview Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (selectedCell!=-1)
    {
        self.tblItems.scrollEnabled = NO;
        selectedCell = -1;
        [self.tblItems reloadData];
        self.tblItems.scrollEnabled = YES;
        return;
    }
    self.tblItems.scrollEnabled = YES;
}


#pragma mark - Button Clicks
-(IBAction)btnContinueShoppingClicked:(id)sender
{
    self.tabBarController.selectedIndex = 0;
    [[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
}

-(IBAction)btnContinueClicked:(id)sender
{
    if (appDelegate.isGuestCheckoutActive)
    {
        [self AddToCartData];
    }
    else
    {
        if ([Util getBoolData:kLogin])
        {
            [self AddToCartData];
        }
        else
        {
            isFromLogin = true;
            [self redirectToLogin];
        }
    }
}

-(void)redirectToLogin
{
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [[GIDSignIn sharedInstance] signOut];
    
    SigninVC *vc=[[SigninVC alloc] initWithNibName:@"SigninVC" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    navigationController.modalPresentationStyle=UIModalPresentationFullScreen;
    [self presentViewController:navigationController animated:YES completion:nil];
}


-(IBAction)btnBackClicked:(id)sender
{
    appDelegate.isFromBuyNow = false;
    if (self.tabBarController.selectedIndex != 0) {
        self.tabBarController.selectedIndex = 0;
        [[self.tabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
    }
    //    [[appDelegate.baseTabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
    //    appDelegate.baseTabBarController.selectedIndex = 0;
    [appDelegate showBadge];
}

-(IBAction)btnClearCartClicked:(id)sender
{
    //    [self clearCart];
}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 1)
    {
        return arrMyCart.count;
    }
    else if (tableView.tag == 3)
    {
        return arrMyCartDynamic.count;
    }
    else
    {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1)
    {
        static NSString *simpleTableIdentifier = @"ShopDataCell";
        
        ShopDataCell *cell = (ShopDataCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopDataCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        cell.cell = (int)indexPath.row;
        cell.delegate = self;
        
        cell.btnDelete.hidden = NO;
        [cell.btnDelete addTarget:self action:@selector(deleteTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        AddToCartData *object;
        if([[arrMyCart objectAtIndex:indexPath.row] isKindOfClass:[NSData class]])
        {
            object = [Util loadCustomObjectWithKey:[arrMyCart objectAtIndex:indexPath.row]];
        }
        else
        {
            object = [arrMyCart objectAtIndex:indexPath.row];
        }
        
        if (object.isSoldIndividually)
        {
            cell.btnPlus.userInteractionEnabled = NO;
            cell.btnMinus.userInteractionEnabled = NO;
        }
        else
        {
            cell.btnPlus.userInteractionEnabled = YES;
            cell.btnMinus.userInteractionEnabled = YES;
        }
        
        cell.lblTitle.text = object.name;
        cell.lblTitle.textColor = FontColorGray;
        cell.lblTitle.font=Font_Size_Product_Name_Not_Bold;
        
        if(object.variation_id == 0)
        {
            cell.lblVariation.hidden = YES;
        }
        else
        {
            cell.lblVariation.hidden = NO;
            NSArray *keys=[object.arrVariation allKeys];
            NSString *str;
            for (int i = 0; i < keys.count; i++)
            {
                if (i == 0)
                {
                    str = [NSString stringWithFormat:@"%@ : %@", [[keys objectAtIndex:i] capitalizedString], [[object.arrVariation valueForKey:[keys objectAtIndex:i]]capitalizedString]];
                }
                else
                {
                    str = [NSString stringWithFormat:@"%@, %@ : %@",str, [[keys objectAtIndex:i] capitalizedString], [[object.arrVariation valueForKey:[keys objectAtIndex:i]]capitalizedString]];
                }
            }
            cell.lblVariation.text = str;
            cell.lblVariation.textColor = FontColorGray;
            cell.lblVariation.font=Font_Size_Product_Name_Not_Bold;
        }
        
        if (object.imgUrl != NULL)
        {
            [cell.act startAnimating];
            [Util setPrimaryColorActivityIndicator:cell.act];
            
            [cell.img sd_setImageWithURL:[Util EncodedURL:object.imgUrl] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                [cell.act stopAnimating];
                cell.img.image=image;
            }];
        }
        
        NSString * htmlString = object.html_Price;
        cell.lblRate.attributedText = [Util setPriceForItem:htmlString];
        
        cell.lblQuantity.text = [NSString stringWithFormat:@"%d", object.quantity];
        [Util setPrimaryColorLabelText:cell.lblQuantity];
        
        cell.btnStore.hidden=YES;
        cell.btnWishList.hidden=YES;
        cell.vwQuatity.hidden=NO;
        cell.btnEdit.tag = object.productId;
        
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (appDelegate.isRTL)
        {
            //RTL
            cell.vwImage.frame = CGRectMake(cell.frame.size.width - cell.vwImage.frame.size.width - 6*SCREEN_SIZE.width/375, cell.vwImage.frame.origin.y, cell.vwImage.frame.size.width, cell.vwImage.frame.size.height);
            
            //            cell.vwQuatity.frame = CGRectMake(18*SCREEN_SIZE.width/375, cell.vwQuatity.frame.origin.y, cell.vwQuatity.frame.size.width, cell.vwQuatity.frame.size.height);
            
            cell.lblTitle.frame = CGRectMake(cell.frame.size.width - cell.lblTitle.frame.size.width - 99*SCREEN_SIZE.width/375, cell.lblTitle.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
            
            cell.lblTitle.textAlignment = NSTextAlignmentRight;
            cell.lblRate.textAlignment = NSTextAlignmentRight;
            cell.lblVariation.textAlignment = NSTextAlignmentRight;
        }
        else
        {
            cell.vwImage.frame = CGRectMake(6*SCREEN_SIZE.width/375, cell.vwImage.frame.origin.y, cell.vwImage.frame.size.width, cell.vwImage.frame.size.height);
            
            //            cell.vwQuatity.frame = CGRectMake(cell.frame.size.width - cell.vwQuatity.frame.size.width - 18*SCREEN_SIZE.width/375, cell.vwQuatity.frame.origin.y, cell.vwQuatity.frame.size.width, cell.vwQuatity.frame.size.height);
            
            cell.lblTitle.frame = CGRectMake(cell.vwImage.frame.origin.x + cell.vwImage.frame.size.width + 8, cell.lblTitle.frame.origin.y, cell.lblTitle.frame.size.width, cell.lblTitle.frame.size.height);
            
            cell.lblTitle.textAlignment = NSTextAlignmentLeft;
            cell.lblRate.textAlignment = NSTextAlignmentLeft;
            cell.lblVariation.textAlignment = NSTextAlignmentLeft;
        }
        
        
        BOOL flg = false;
        for (UIView *subview in cell.subviews)
        {
            if (subview.tag>=1000)
            {
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
                    //Background Thread
                    dispatch_async(dispatch_get_main_queue(), ^(void){
                        //Run UI Updates
                        
                        if (appDelegate.isRTL)
                        {
                            //RTL
                            subview.frame = CGRectMake(cell.lblRate.frame.size.width + cell.lblRate.frame.origin.x- ((cell.frame.size.width/2.3)/2), cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8,  (cell.frame.size.width/2.3)/2, appDelegate.FontSizeProductName);
                            [subview setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                            cell.lblRate.frame = CGRectMake(cell.frame.size.width - cell.lblRate.frame.size.width - 99*SCREEN_SIZE.width/375, cell.lblRate.frame.origin.y, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                        }
                        else
                        {
                            //nonRTL
                            subview.frame = CGRectMake(cell.lblTitle.frame.origin.x, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8, (cell.frame.size.width/2.3)/2, appDelegate.FontSizeProductName);
                            [subview setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                            cell.lblRate.frame = CGRectMake(cell.lblTitle.frame.origin.x, subview.frame.origin.y + subview.frame.size.height + 8, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                        }
                    });
                });
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
                        cell.lblRate.frame = CGRectMake(cell.frame.size.width - cell.lblRate.frame.size.width - 99*SCREEN_SIZE.width/375, cell.lblRate.frame.origin.y, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                        
                        cell.lblVariation.frame = CGRectMake(cell.frame.size.width - cell.lblVariation.frame.size.width - 99*SCREEN_SIZE.width/375, cell.lblRate.frame.origin.y + cell.lblRate.frame.size.height, cell.lblVariation.frame.size.width, cell.lblVariation.frame.size.height);
                        
                        cell.lblRate.textAlignment = NSTextAlignmentRight;
                        cell.lblVariation.textAlignment = NSTextAlignmentRight;
                    }
                    else
                    {
                        //NonRTL
                        cell.lblRate.frame = CGRectMake(cell.lblTitle.frame.origin.x, cell.lblRate.frame.origin.y, cell.lblRate.frame.size.width, cell.lblRate.frame.size.height);
                        
                        cell.lblVariation.frame = CGRectMake(cell.lblTitle.frame.origin.x, cell.lblRate.frame.origin.y + cell.lblRate.frame.size.height, cell.lblVariation.frame.size.width, cell.lblVariation.frame.size.height);
                        
                        cell.lblRate.textAlignment = NSTextAlignmentLeft;
                        cell.lblVariation.textAlignment = NSTextAlignmentLeft;
                    }
                    if (appDelegate.isRTL)
                    {
                        //RTL
                        NSLog(@"path : %f",SCREEN_SIZE.width - 60 - 99*SCREEN_SIZE.width/375);
                        starRatingView = [Util setStarRating:object.rating frame:CGRectMake(cell.lblRate.frame.size.width + cell.lblRate.frame.origin.x- ((cell.frame.size.width/2.3)/2), cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8, (cell.frame.size.width/2.3)/2,appDelegate.FontSizeProductName) tag:1000+indexPath.row];
                        [starRatingView setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
                    }
                    else
                    {
                        //nonRTL
                        starRatingView=[Util setStarRating:object.rating frame:CGRectMake(cell.lblRate.frame.origin.x, cell.lblTitle.frame.origin.y + cell.lblTitle.frame.size.height+8, (cell.frame.size.width/2.1)/2,appDelegate.FontSizeProductName) tag:1000+indexPath.row];
                        [starRatingView setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
                    }
                    [cell addSubview:starRatingView];
                    
                });
            });
            
        }
        //        [Util setTriangleLable:cell.vwDiscount product:object];
        
        return cell;
    }
    
    else if(tableView.tag == 3)
    {
        static NSString *simpleTableIdentifier = @"ShopDataCell";
        ShopDataCell *cell = (ShopDataCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if(cell == nil)
        {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopDataCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        NSLog(@"Product name %@",[[arrMyCartDynamic valueForKey:[arrKey objectAtIndex:indexPath.row]] valueForKey:@"product_name"]);
        NSLog(@"QTY %@",[[arrMyCartDynamic valueForKey:[arrKey objectAtIndex:indexPath.row]] valueForKey:@"quantity"]);
        
        cell.lblTitle.text = [NSString stringWithFormat:@"%@",[[arrMyCartDynamic valueForKey:[arrKey objectAtIndex:indexPath.row]] valueForKey:@"product_name"]];
        cell.lblRate.text = [NSString stringWithFormat:@"%@",[[arrMyCartDynamic valueForKey:[arrKey objectAtIndex:indexPath.row]] valueForKey:@"quantity"]];
        
        return cell;
    }
    else
    {
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        AddToCartData *object;
        
        if([[arrMyCart objectAtIndex:indexPath.row] isKindOfClass:[NSData class]])
        {
            object = [Util loadCustomObjectWithKey:[arrMyCart objectAtIndex:indexPath.row]];
        }
        else
        {
            object = [arrMyCart objectAtIndex:indexPath.row];
        }
        
        productID = (int)object.productId;
        [self getSingleProductDetail:productID];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1 || tableView.tag == 3)
    {
        return 120;
    }
    else
    {
        return 0;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        if (selectedCell == -1)
        {
            return NO;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1)
    {
        if (selectedCell!=-1)
        {
            selectedCell = - 1;
            [self.tblItems reloadData];
        }
        
        UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"          " handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
            
            [self DeleteItemFromMyCart:indexPath];
            NSLog(@"Delete clicked");
        }];
        
        deleteAction.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"iconDelete"]];
        return @[deleteAction];
    }
    else
    {
        return nil;
    }
}

- (void)DeleteItemFromMyCart:(NSIndexPath*)indexPath
{
    NSMutableArray *arr;
    if (appDelegate.isFromBuyNow)
    {
        arr = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kBuyNow] mutableCopy]];
        [arr removeObjectAtIndex:indexPath.row];
        [Util setArray:arr setData:kBuyNow];
    }
    else
    {
        arr = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
        [arr removeObjectAtIndex:indexPath.row];
        [Util setArray:arr setData:kMyCart];
    }
    
    
    if (appDelegate.isFromBuyNow)
    {
        arrMyCart = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kBuyNow] mutableCopy]];
    }
    else
    {
        arrMyCart = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
    }
    
    //    appDelegate.isFromBuyNow = NO;
    
    NSArray *deletedIndexPaths = [[NSArray alloc]initWithObjects:indexPath,nil];
    
    [self.tblItems beginUpdates];
    [self.tblItems deleteRowsAtIndexPaths:deletedIndexPaths withRowAnimation:UITableViewRowAnimationRight];
    [self.tblItems endUpdates];
    [self setPriceinLabels];
    [self performSelector:@selector(showContinueShopping) withObject:nil afterDelay:0.5];
    
    //    [self AddToCartDataLoad];
}

-(void)showContinueShopping
{
    [appDelegate showBadge];
    if (arrMyCart.count > 0)
    {
        [self setTableframe];
        [self setPriceinLabels];
        self.vwNoAnyProduct.hidden = YES;
        self.scrl.hidden = NO;
    }
    else
    {
        self.vwNoAnyProduct.hidden = NO;
        self.scrl.hidden = YES;
        self.vwNoAnyProduct.frame = CGRectMake(SCREEN_SIZE.width, self.vwNoAnyProduct.frame.origin.y, SCREEN_SIZE.width, self.vwNoAnyProduct.frame.size.height);
        [UIView animateWithDuration:0.4 animations:^{
            
            self.vwNoAnyProduct.frame = CGRectMake(0, self.vwNoAnyProduct.frame.origin.y, SCREEN_SIZE.width, self.vwNoAnyProduct.frame.size.height);
        }];
    }
}

#pragma mark - Handle method for Cell Editing

-(void)deleteTapped:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblItems];
    NSIndexPath *indexPath = [self.tblItems indexPathForRowAtPoint:buttonPosition];
    [self DeleteItemFromMyCart:indexPath];
}

-(void)EditTapped:(UIButton*)btn
{
    productID = (int)btn.tag;
    [self getSingleProductDetail:productID];
}

-(void)tappedOnTable:(UITapGestureRecognizer*)tap
{
    //do you Tap stuff here.
    selectedCell = -1;
    [self.tblItems reloadData];
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)gestureRecognizer
{
    if (selectedCell != -1)
    {
        selectedCell = -1;
        [self.tblItems reloadData];
        return;
    }
    //do you right swipe stuff here. Something usually using theindexPath that you get that way
    CGPoint location = [gestureRecognizer locationInView:self.tblItems];
    NSIndexPath *indexPath = [self.tblItems indexPathForRowAtPoint:location];
    
    selectedCell = (int)indexPath.row;
    [self.tblItems reloadData];
}

#pragma mark - API Calls

-(void)AddToCartData
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableArray *arrCartData = [[NSMutableArray alloc] init];
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
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        [dict setValue:[NSString stringWithFormat:@"%d", object.productId] forKey:@"product_id"];
        [dict setValue:[NSString stringWithFormat:@"%d", object.quantity] forKey:@"quantity"];
        [dict setValue:[NSString stringWithFormat:@"%d", object.variation_id] forKey:@"variation_id"];
        if (object.arrVariation == nil || object.arrVariation.count == 0)
        {
            [dict setValue:@"" forKey:@"variation"];
        }
        else
        {
            [dict setValue:object.arrVariation forKey:@"variation"];
        }
        [arrCartData addObject:dict];
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:arrCartData forKey:@"cart_items"];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    
    [CiyaShopAPISecurity addToCart:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                // Facebook Pixel for Product Initial Checkout
                NSMutableArray *arrInitialCheckout = [[NSMutableArray alloc] init];
                if (appDelegate.isFromBuyNow) {
                    //For Buy Now code
                    arrInitialCheckout = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kBuyNow] mutableCopy]];
                }
                else
                {
                    //For My Cart code
                    arrInitialCheckout = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
                }
                
                for (int i = 0; i < arrInitialCheckout.count; i++)
                {
                    AddToCartData * initialCheckout;
                    if([[arrInitialCheckout objectAtIndex:i] isKindOfClass:[NSData class]])
                    {
                        initialCheckout = [Util loadCustomObjectWithKey:[self->arrMyCart objectAtIndex:i]];
                    }
                    else
                    {
                        initialCheckout = [self->arrMyCart objectAtIndex:i];
                    }
                    // Code for Pixel
                    [Util logInitiatedCheckoutEvent:[NSString stringWithFormat:@"%d", initialCheckout.productId] contentType:initialCheckout.name numItems:initialCheckout.quantity paymentInfoAvailable:NO currency:appDelegate.strCurrencySymbol valToSum:initialCheckout.price];
                }
                
                // Store Current Time and Date in NSUserDefault For Facebook Pixel Abandoned Cart Event
                
                NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
                
                NSString *valueToSave = [dateFormatter stringFromDate:[NSDate date]];
                [Util setData:valueToSave key:kFbAbandonedCartTime];
                
                [Util setArray:arrInitialCheckout setData:kFbAbandonedCartObject];
                
                HIDE_PROGRESS;
                WebViewVC *vc = [[WebViewVC alloc] initWithNibName:@"WebViewVC" bundle:nil];
                vc.dictCart = dict;
                NSString *url = [dictionary valueForKey:@"checkout_url"];
                if ([Util getBoolData:kCurrency])
                {
                    url = [NSString stringWithFormat:@"%@%@", url, [Util getStringData:kCurrencyText]];
                }
                
                vc.url = url;
                if ([dictionary objectForKey:@"thankyou"])
                {
                    if(!([dictionary valueForKey:@"thankyou"] == [NSNull null]))
                    {
                        vc.urlThankYou = [dictionary valueForKey:@"thankyou"];
                    }
                }
                
                if ([dictionary objectForKey:@"thankyou_endpoint"])
                {
                    if(!([dictionary valueForKey:@"thankyou_endpoint"] == [NSNull null]))
                    {
                        vc.urlThankYouEndPoint = [dictionary valueForKey:@"thankyou_endpoint"];
                    }
                }
                vc.delegate = self;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                HIDE_PROGRESS;
                NSLog(@"Something Went Wrong.");
            }
        }
        else
        {
            HIDE_PROGRESS;
        }
        HIDE_PROGRESS;
    }];
}

-(void)getSingleProductDetail:(int)productId
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%d",productId] forKey:@"include"];
    
    [CiyaShopAPISecurity productListing:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        
        if(success)
        {
            //no error
            if (dictionary.count>0)
            {
                if([dictionary isKindOfClass:[NSArray class]])
                {
                    //Is array
                    self->selectedCell = -1;
                    [self.tblItems reloadData];
                    
                    NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                    Product *object = [Util setProductData:[arrData objectAtIndex:0]];
                    if ([[[arrData objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"grouped"])
                    {
                        //GroupItemDetailVC
                        GroupItemDetailVC *vc = [[GroupItemDetailVC alloc] initWithNibName:@"GroupItemDetailVC" bundle:nil];
                        vc.product = object;
                        //                        vc.arrProductData = [[arrData objectAtIndex:0] mutableCopy];
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else if ([[[arrData objectAtIndex:0] valueForKey:@"type"] isEqualToString:@"variable"])
                    {
                        //VariableItemDetailVC
                        VariableItemDetailVC *vc = [[VariableItemDetailVC alloc] initWithNibName:@"VariableItemDetailVC" bundle:nil];
                        vc.product = object;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    else
                    {
                        ItemDetailVC *vc = [[ItemDetailVC alloc] initWithNibName:@"ItemDetailVC" bundle:nil];
                        vc.product = object;
                        [self.navigationController pushViewController:vc animated:YES];
                    }
                    HIDE_PROGRESS;
                }
                else if([dictionary isKindOfClass:[NSDictionary class]])
                {
                    //is dictionary
                    NSLog(@"Something Went Wrong");
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
                    HIDE_PROGRESS;
                }
            }
            else
            {
                NSLog(@"Something Went Wrong");
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
                HIDE_PROGRESS;
            }
        }
        else
        {
            //error
            NSLog(@"Something Went Wrong");
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
            HIDE_PROGRESS;
        }
    }];
}

-(void)setThankYouPage:(BOOL)set
{
    if (set)
    {
        ThankYouVC *vc = [[ThankYouVC alloc] initWithNibName:@"ThankYouVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)clearAllCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}



#pragma mark - SetData Delegate

-(void)setDataForAllText
{
    if (appDelegate.isFromBuyNow)
    {
        arrMyCart = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kBuyNow] mutableCopy]];
    }
    else
    {
        arrMyCart = [[NSMutableArray alloc] initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
    }
    [self setPriceinLabels];
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

