//
//  AppDelegate.h
//  QuickClick
//
//  Created by Umesh on 4/14/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SearchVC.h"
#import "MyCartVC.h"
#import "HomeVC.h"
#import "AccountVC.h"
#import "WishListVC.h"
#import <UserNotifications/UserNotifications.h>
#import "Product.h"
#import "PincodeData.h"

@protocol GoogleSignUpDelegate <NSObject>

-(void)googleSignUp;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *nav;
@property NSString *strComeForm;

@property (nonatomic) int  FontSizeProductNameSmall;
@property (nonatomic) int  FontSizeProductName;
@property (nonatomic) int  FontSizePrice;
@property (nonatomic) int  FontSizePriceSale;
@property (nonatomic) int  FontSizePriceSaleYes;
@property (nonatomic) int  FontSizePriceSaleSmall;
@property (nonatomic) int  FontSizePriceSaleYesSmall;
@property (nonatomic) int  FontSizeProductTitle;
@property (nonatomic) int  FontSizeNavigationTitle;
@property (nonatomic) int  FontSizeBigTitle;

//these  view controllers (screens) for adding to tabs.
@property (strong, nonatomic) SearchVC *firstViewController;
@property (strong, nonatomic) MyCartVC *secondViewController;
@property (strong, nonatomic) HomeVC *thirdViewController;
@property (strong, nonatomic) AccountVC *forthViewController;
@property (strong, nonatomic) WishListVC *fifthViewController;

@property (strong, nonatomic) NSDictionary *postParameter;

//this will be the tab bar-controller
@property (strong, nonatomic) UITabBarController *baseTabBarController;

@property (strong, nonatomic) NSString *loggedIn;
@property (strong, nonatomic) NSString *language;
@property (strong, nonatomic) NSString *AppUrl;
-(void) createTabBar;
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController;

-(void)Notification:(UIViewController*)ViewC;
-(void)Search:(UIViewController*)ViewC;
-(BOOL)checkWishListData;
-(void)showBadge;
-(void)setRecentProduct:(Product*)product;
-(void)setWishList:(NSMutableArray*)arrData;
-(void)registerForToken;
-(void)selectDefaultLanguage;

-(void)setDataForCiyashopOauth;

-(NSMutableArray*)getRecentArray;

- (void)setRTLView;

-(void)showWhatsAppFloatingButton;

//-(void)checkForWishlistInDict:(NSDictionary*)dictionary;

@property BOOL from; // 1 then from Home else from other
@property BOOL isFromBuyNow; // 1 then from Home else from other
@property BOOL isGetScroll; // true then got data else donot get data

@property NSMutableArray *arrCategory, *arrMainCategory, *arrBanner;
@property NSMutableArray *arrSelectedVariable;
@property NSMutableArray *arrSelectedSimple;
@property NSMutableArray *arrVariations, *arrMostPopularProducts, *arrRecentlyAddedProducts, *arrSelectedProduct, *arrDealOfTheDay, *arrHomeCatagoryData, *arrFromWebView;
@property NSMutableArray *arrReasonToBuyWithUs;
@property NSMutableArray *arrCurrency;
@property NSMutableArray *arrWpmlLanguages;

@property NSMutableArray *arrCheckoutOptions;
@property NSMutableArray *arrTopRatedData;
@property NSMutableArray *arrSelectedProductData;

@property NSMutableDictionary *dictCustData;
@property NSMutableDictionary *dictSocialData;

@property (strong, nonatomic) NSMutableArray *LoaderImages;

@property NSString *vc;
@property NSString *strDeviceToken;
@property NSString *strGotoVC;
@property NSString *strReasonsToBuy;
@property NSString *strCurrencySymbol;
@property NSString *strCurrencySymbolPosition;
@property NSString *strThousandSeparatore;
@property NSString *strDecimalSeparatore;

@property NSString *strContactUsPhoneNumber;
@property NSString *strContactUsEmail;
@property NSString *strContactUsAddress;
@property NSString *strWhatsAppNumber;

@property int decimal;

@property (nonatomic)BOOL isWishList;
@property (nonatomic)BOOL flgAccount;
@property (nonatomic)BOOL isRTL;
@property (nonatomic)BOOL isLanguageChange;
@property (nonatomic)BOOL fromMore;
@property (nonatomic)BOOL isSliderScreen;
@property (nonatomic)BOOL isLoginScreen;
@property (nonatomic)BOOL isVariationInView;
@property (nonatomic)BOOL isCatalogMode;
@property (nonatomic)BOOL isShimmerLoader;


@property (strong, nonatomic) id<GoogleSignUpDelegate> delegateGoogle;

//set currency value for app
@property BOOL currency;
@property BOOL isCurrencySet;
@property BOOL isOrderTrackingActive;
@property BOOL isMyRewardPointsActive;
@property BOOL isGuestCheckoutActive;
@property BOOL isWpmlActive;
@property BOOL isPincodeCheckActive;
@property BOOL isRefresh;
@property BOOL isAcctChanged;
@property BOOL isFeatureEnabled;
@property BOOL isWhatsAppFloatingEnabled;
@property BOOL isYithVideoEnabled;
@property BOOL isCartButtonEnabled;
@property BOOL isReviewLoginEnabled;
@property BOOL isReviewEnabled;
@property BOOL isAlreadyInCart;
@property BOOL isOTPEnabled;

@property BOOL fromItemDetail;

//product data for deep link
@property NSString *productID;

@property NSString *amountPayable;

@property (nonatomic) PincodeData *pincodeConfigData;

@end
