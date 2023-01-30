//
//  AppDelegate.m
//  QuickClick
//
//  Created by Umesh on 4/14/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "AppDelegate.h"
#import "MyRewardVC.h"
#import "MyOrderVC.h"
#import "LocationHelper.h"

#import <OneSignal/OneSignal.h>

@import Firebase;
@import GoogleSignIn;

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
@interface AppDelegate ()<UITabBarControllerDelegate, UNUserNotificationCenterDelegate, UIApplicationDelegate, GIDSignInDelegate>

@end

@implementation AppDelegate{
    AssistiveTouch *touch;
}
@synthesize firstViewController;
@synthesize secondViewController;
@synthesize thirdViewController;
@synthesize baseTabBarController;
@synthesize forthViewController;
@synthesize fifthViewController;
@synthesize loggedIn;

@synthesize window;

#pragma mark - Life Cycle Methods

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    /**
    set this isVariationInView parameter to true, if you want to show variation selection on page else make it false, if you want to set the variation selection in popup.
     **/
    self.isVariationInView = true;
    
    //On Signal setup
    [OneSignal initWithLaunchOptions:launchOptions
                               appId:@"One_Signal_key"
            handleNotificationAction:nil
                            settings:@{kOSSettingsKeyAutoPrompt: @false}];
    
    OneSignal.inFocusDisplayType = OSNotificationDisplayTypeNotification;
    
    // Recommend moving the below line to prompt for push after informing the user about
    // how your app will use them.
    [OneSignal promptForPushNotificationsWithUserResponse:^(BOOL accepted) {
        NSLog(@"User accepted notifications: %d", accepted);
    }];

    // Facebook Pixel For Deep Linking
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
        [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL* url, NSError* error) {
            if (error) {
                NSLog(@"Received error while fetching deferred app link %@", error);
            }
            if (url) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            }
        }];
    }
    
    if (IS_OTP_ENABLE) {
        appDelegate.isOTPEnabled = true;
    } else {
        appDelegate.isOTPEnabled = false;
    }
    
    if (IS_SHIMMER_LOADER) {
        self.isShimmerLoader = true;
    } else {
        self.isShimmerLoader = false;
    }
    [self setDataForCiyashopOauth];

    self.strCurrencySymbolPosition = [[NSString alloc] init];
    [[LocationHelper sharedInstance] updateLocation];
        
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
    
    //Firebase configuration
    [FIRApp configure];
    [GIDSignIn sharedInstance].clientID = [FIRApp defaultApp].options.clientID;
    [GIDSignIn sharedInstance].delegate = self;

    self.AppUrl=[[NSString alloc]init];
    self.LoaderImages = [[NSMutableArray alloc] init];
    NSString *strTemp=[[NSString alloc] init];
    
    for (int i = 1; i <= 32; i++) {
        strTemp = [NSString stringWithFormat:@"Layer %d.png",i];
        [self.LoaderImages addObject:[UIImage imageNamed:strTemp]];
    }
    
    if ([Util getBoolData:kLogin]) {
        self.loggedIn = kLoggedIn;
    } else {
        self.loggedIn = kLoggedOut;
        [Util setBoolData:NO setBoolData:kLogin];
        [Util setBoolData:NO setBoolData:kFromFBorGoogle];
        [FBSDKAccessToken setCurrentAccessToken:nil];
        [[GIDSignIn sharedInstance] signOut];
    }
    
    [NSThread sleepForTimeInterval:1.0];
    
    [self selectDefaultLanguage];
    [self createTabBar];
    [self.window makeKeyAndVisible];
    
    [self showBadge];
    [self registerForRemoteNotifications];
    
    if (SCREEN_SCALE==2.0) {
        if (SCREEN_SIZE.width>320) {
            //NavigationTitle
            self.FontSizeNavigationTitle=16;
            
            //Most Popular Product
            self.FontSizeProductName=11;
            self.FontSizePrice=14;
            self.FontSizePriceSale=15;
            self.FontSizePriceSaleYes=17;
            
            //DealOfTheDay
            self.FontSizeProductNameSmall=12;
            self.FontSizePriceSaleSmall=11;
            self.FontSizePriceSaleYesSmall=13;
            
            //Title of Section
            self.FontSizeProductTitle=14;
            self.FontSizeBigTitle=30;
        } else {
            //NavigationTitle
            self.FontSizeNavigationTitle=14;
            
            //Most Popular Product
            self.FontSizeProductName=9;
            self.FontSizePrice=13;
            self.FontSizePriceSale=14;
            self.FontSizePriceSaleYes=16;
            
            //DealOfTheDay
            self.FontSizeProductNameSmall=10;
            self.FontSizePriceSaleSmall=9;
            self.FontSizePriceSaleYesSmall=11;
            
            //Title of Section
            self.FontSizeProductTitle=12;
            self.FontSizeBigTitle=27;
        }
    } else {
        //NavigationTitle
        self.FontSizeNavigationTitle=18;
        
        //Most Popular Product
        self.FontSizeProductName=12;
        self.FontSizePrice=15;
        self.FontSizePriceSale=16;
        self.FontSizePriceSaleYes=18;
        
        //DealOfTheDay
        self.FontSizeProductNameSmall=14;
        self.FontSizePriceSaleSmall=12;
        self.FontSizePriceSaleYesSmall=14;
        
        //Title of Section
        self.FontSizeProductTitle=16;
        self.FontSizeBigTitle=33;
    }
    
    NSDictionary *activityDic = [launchOptions objectForKey:UIApplicationLaunchOptionsUserActivityDictionaryKey];
    if (activityDic) {
        if(self.window.rootViewController) {
            NSUserActivity *userActivity = [activityDic valueForKey:@"UIApplicationLaunchOptionsUserActivityKey"];
            [self.window.rootViewController restoreUserActivityState:userActivity];
        }
    }
    
    touch = [[AssistiveTouch alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width - 56, SCREEN_SIZE.height - 56 - baseTabBarController.tabBar.frame.size.height, 56, 56)];
    [touch addTarget:self action:@selector(touchonButton) forControlEvents:UIControlEventTouchUpInside];
    [touch setImage:[UIImage imageNamed:@"iconWhatsappContactUs"] forState:UIControlStateNormal];
    
    [touch setBackgroundColor:UIColor.whiteColor];
    
    touch.layer.cornerRadius = 8;
    touch.layer.masksToBounds = true;
    touch.layer.shadowRadius  = 1.5f;
    touch.layer.shadowColor = [UIColor blackColor].CGColor;
    touch.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    touch.layer.shadowOpacity = 0.9f;
    touch.layer.masksToBounds = NO;
    
    touch.hidden = true;
    touch.alpha = 0.0;
    [self.window addSubview:touch];
    [self.window bringSubviewToFront:touch];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh object:self];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Set Language data

-(void)selectDefaultLanguage
{
    NSDictionary * languageURLPairs =
    @{
      @"en-US":[[NSBundle mainBundle] URLForResource:@"English.json" withExtension:nil],
      @"ru-RU":[[NSBundle mainBundle] URLForResource:@"Russian.json" withExtension:nil],
      @"ar":[[NSBundle mainBundle] URLForResource:@"Arabic.json" withExtension:nil],
      @"fr-FR":[[NSBundle mainBundle] URLForResource:@"French.json" withExtension:nil],
      @"de-DE":[[NSBundle mainBundle] URLForResource:@"German.json" withExtension:nil],
      @"ja":[[NSBundle mainBundle] URLForResource:@"Japanese.json" withExtension:nil],
      @"pt-PT":[[NSBundle mainBundle] URLForResource:@"Portuguese.json" withExtension:nil],
      @"es-ES":[[NSBundle mainBundle] URLForResource:@"Spanish.json" withExtension:nil],
      @"sv-SE":[[NSBundle mainBundle] URLForResource:@"Swedish.json" withExtension:nil]
      };
    
    if ([self.language length] == 0) {
        self.language = @"en-US";
    }
    [MCLocalization loadFromLanguageURLPairs:languageURLPairs defaultLanguage:@"en-US"];
    [MCLocalization sharedInstance].noKeyPlaceholder = @"[No '{key}' in '{language}']";
}

#pragma mark - Set WhatsApp Floating Button

-(void)showWhatsAppFloatingButton {
    if (self.isWhatsAppFloatingEnabled && ![self.strWhatsAppNumber isEqualToString:@""]) {
        touch.hidden = false;
        [UIView animateWithDuration:0.5 animations:^{
            self->touch.alpha = 1.0;
        }];
    } else {
        [UIView animateWithDuration:0.5 animations:^{
            self->touch.alpha = 0.0;
        } completion:^(BOOL finished) {
            self->touch.hidden = true;
        }];
    }
}

-(void) touchonButton {
    NSLog(@"Clicked Whatsapp Floating Button");
    NSLog(@"Whatsapp");
    
    if ([self.strWhatsAppNumber isEqualToString:@""]) {
        return;
    }
    NSString *whatsappUrl1 = self.strWhatsAppNumber;
    if (![whatsappUrl1 containsString:@"+"]) {
        whatsappUrl1 = [NSString stringWithFormat:@"%@%@", MOBILE_COUNTRY_CODE, whatsappUrl1];
    }
    if ([whatsappUrl1 isEqualToString:@""]) {
        return;
    }
    NSString *whatsappUrl2 = @"&text=";
    NSString *whatsappUrl3 = appURL;
    whatsappUrl3 =    (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef) whatsappUrl3, NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    
    NSString *formattedString = [NSString stringWithFormat:@"whatsapp://send?phone=%@%@%@", whatsappUrl1, whatsappUrl2, whatsappUrl3];
    NSLog(@"%@", formattedString);
    
    NSURL *whatsappURL = [NSURL URLWithString: formattedString];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL]) {
        [[UIApplication sharedApplication] openURL:whatsappURL options:@{} completionHandler:nil];
    } else if (whatsappURL == nil) {
        ALERTVIEW([MCLocalization stringForKey:@"Invalid Contact Number"], appDelegate.window.rootViewController);
    } else {
        ALERTVIEW([MCLocalization stringForKey:@"WhatsApp is not installed on your device."], appDelegate.window.rootViewController);
    }
}

#pragma mark - Set Authentication Data

-(void)setDataForCiyashopOauth {
    NSMutableDictionary *dictoAuthParams = [[NSMutableDictionary alloc] init];
    
    [dictoAuthParams setValue:appURL forKey:@"appURL"];
    [dictoAuthParams setValue:PATH forKey:@"PATH"];
    [dictoAuthParams setValue:OTHER_API_PATH forKey:@"OTHER_API_PATH"];
    
    [dictoAuthParams setValue:OAUTH_CUSTOMER_KEY forKey:@"OAUTH_CUSTOMER_KEY"];
    [dictoAuthParams setValue:OAUTH_CUSTOMER_SERCET forKey:@"OAUTH_CUSTOMER_SERCET"];
    
    [dictoAuthParams setValue:OAUTH_CONSUMER_KEY_PLUGIN forKey:@"OAUTH_CONSUMER_KEY_PLUGIN"];
    [dictoAuthParams setValue:OAUTH_CONSUMER_SECRET_PLUGIN forKey:@"OAUTH_CONSUMER_SECRET_PLUGIN"];
    
    [dictoAuthParams setValue:OAUTH_TOKEN_PLUGIN forKey:@"OAUTH_TOKEN_PLUGIN"];
    [dictoAuthParams setValue:OAUTH_TOKEN_SECRET_PLUGIN forKey:@"OAUTH_TOKEN_SECRET_PLUGIN"];
    
    [dictoAuthParams setValue:OAUTH_TOKEN_PLUGIN forKey:@"OAUTH_TOKEN_PLUGIN"];
    [dictoAuthParams setValue:OAUTH_TOKEN_SECRET_PLUGIN forKey:@"OAUTH_TOKEN_SECRET_PLUGIN"];
    
    if ([Util getBoolData:kCurrency]) {
        [dictoAuthParams setValue:[NSNumber numberWithBool:[Util getBoolData:kCurrency]] forKey:@"currency"];
        if ([Util getStringData:kCurrencyText] != nil && ![[Util getStringData:kCurrencyText] isEqualToString:@""]) {
            [dictoAuthParams setValue:[NSNumber numberWithBool:[Util getBoolData:kCurrency]] forKey:@"currency"];
            [dictoAuthParams setValue:[Util getStringData:kCurrencyText] forKey:@"currency_value"];
        } else {
            [dictoAuthParams setValue:[NSNumber numberWithBool:false] forKey:@"currency"];
            [dictoAuthParams setValue:@"" forKey:@"currency_value"];
        }
    } else {
        [dictoAuthParams setValue:[NSNumber numberWithBool:false] forKey:@"currency"];
        [dictoAuthParams setValue:@"" forKey:@"currency_value"];
    }
    
    if ([Util getBoolData:kLanguage]) {
        [dictoAuthParams setValue:[NSNumber numberWithBool:[Util getBoolData:kLanguage]] forKey:@"language"];
        if ([Util getStringData:kLanguageText] != nil && ![[Util getStringData:kLanguageText] isEqualToString:@""]) {
            [dictoAuthParams setValue:[NSNumber numberWithBool:[Util getBoolData:kLanguage]] forKey:@"language"];
            [dictoAuthParams setValue:[Util getStringData:kLanguageText] forKey:@"language_value"];
        } else {
            [dictoAuthParams setValue:[NSNumber numberWithBool:false] forKey:@"language"];
            [dictoAuthParams setValue:@"" forKey:@"language_value"];
        }
    } else {
        [dictoAuthParams setValue:[NSNumber numberWithBool:false] forKey:@"language"];
        [dictoAuthParams setValue:@"" forKey:@"language_value"];
    }
    [CiyaShopAPISecurity setOauthData:dictoAuthParams];
}

#pragma mark - Set RTL view

- (void)setRTLView {
    if (self.isRTL) {
        if(([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) &&
           [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9, 0, 0}]) {
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
            [[UITabBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
        }
    } else {
        if(([[NSProcessInfo processInfo] respondsToSelector:@selector(isOperatingSystemAtLeastVersion:)]) &&
           [[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9, 0, 0}]) {
            [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
            [[UITabBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
        }
    }
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (UIWindow *window in windows) {
        for (UIView *view in window.subviews) {
            [view removeFromSuperview];
            [window addSubview:view];
        }
    }
}

#pragma mark - Push Notification

- (void)registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center setDelegate:self];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[UIApplication sharedApplication] registerForRemoteNotifications];
                });
            }
        }];
    } else {
        // Code for old versions
        // [appDelegate SetData:@"00" value:kdeviceToken];
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)settings {
    NSLog(@"Registering device for push notifications..."); // iOS 8
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token {
    NSLog(@"Registration successful, bundle identifier: %@, mode: %@, device token: %@",
          [NSBundle.mainBundle bundleIdentifier], [self modeString], token);
    
    NSString *token1 = [[token description] stringByTrimmingCharactersInSet: [NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token1 = [token1 stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"content---%@", token1);
    
    self.strDeviceToken = token1;

    if (![token1 isEqualToString:[Util getStringData:kDeviceToken]]) {
        [self registerForToken];
    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Failed to register: %@", error);
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)notification completionHandler:(void(^)())completionHandler {
    NSLog(@"Received push notification: %@, identifier: %@", notification, identifier); // iOS 8
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)notification {
    NSLog(@"Received push notification: %@", notification); // iOS 7 and earlier
}


//Called to let your app know which action was selected by the user for a given notification.
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse*)response withCompletionHandler:(void(^)(void))completionHandler {
    NSLog(@"User Info : %@", response.notification.request.content.userInfo);
    if ([[[[response.notification.request.content.userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"not_code"] intValue] == 1) {
        //My Rewards
        UITabBarController *tabb = (UITabBarController *)self.window.rootViewController;
        tabb.selectedIndex = 3;
        self.strGotoVC=@"myrewards";
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh object:self];
    } else if ([[[[response.notification.request.content.userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"not_code"] intValue] == 2) {
        //My Order
        UITabBarController *tabb = (UITabBarController *)self.window.rootViewController;
        tabb.selectedIndex = 3;
        self.strGotoVC=@"myorders";
        [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh object:self];
    }
}

-(void)userNotificationCenter:(UNUserNotificationCenter*)center willPresentNotification:(UNNotification*)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    NSLog(@"User Info : %@", notification.request.content.userInfo);
    if ([[[[notification.request.content.userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"not_code"] intValue]  == 1) {
        //My Rewards
        if ([self.vc isEqualToString:@"MyRewardVC"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh object:self];
        } else {
            completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
        }
    } else if ([[[[notification.request.content.userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"not_code"] intValue] == 2) {
        //My Order
        if ([self.vc isEqualToString:@"MyOrderVC"]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kRefresh object:self];
        } else {
            completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
        }
    } else if ([[[[notification.request.content.userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"not_code"] intValue] == 3) {
         completionHandler(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge);
    }
}

- (NSString *)modeString {
#if DEBUG
    return @"Development (sandbox)";
#else
    return @"Production";
#endif
}

#pragma mark - Register for PushNotification

-(void)registerForToken {
    SHOW_LOADER_ANIMTION_1(self.window.rootViewController);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"userid"];
    [dict setValue:self.strDeviceToken forKey:@"device_token"];
    [dict setValue:@"1" forKey:@"device_type"];
    
    [CiyaShopAPISecurity addNotification:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        NSLog(@"%@",dictionary);
        HIDE_PROGRESS_1(self.window.rootViewController);

        if (success) {
            HIDE_PROGRESS_1(self.window.rootViewController);
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"]) {
                //done
                [Util setData:self.strDeviceToken key:kDeviceToken];
            }
        }
    }];
}

#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
    */
}

- (void)dealloc {
   // [window release];
   // [super dealloc];
}

#pragma mark - UITabBar Delegate

-(void) createTabBar {
    if (self.isRTL) {
        [[UITabBar appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    }
    baseTabBarController = [[UITabBarController alloc]init];
    UIImage *bgImage = [UIImage imageNamed:@"FooterBg"];
    baseTabBarController.tabBar.backgroundImage=bgImage;
    
    baseTabBarController.tabBar.tintColor = [Util colorWithHexString:[Util getStringData:kPrimaryColor]];
    if ([[UITabBar appearance] respondsToSelector:@selector(setUnselectedItemTintColor:)]) {
        baseTabBarController.tabBar.unselectedItemTintColor = [UIColor darkGrayColor];
    }
    baseTabBarController.delegate = self;
    
    // initialize first screen
    firstViewController = [[SearchVC alloc] initWithNibName:@"SearchVC" bundle:nil];
    UINavigationController *offersView = [[UINavigationController alloc]initWithRootViewController:firstViewController];
    firstViewController.title = [MCLocalization stringForKey:@"Search"];
    firstViewController.navigationController.navigationBar.hidden = YES;
    
    // initialize second screen
    secondViewController = [[MyCartVC alloc] initWithNibName:@"MyCartVC" bundle:nil];
    secondViewController.title = [MCLocalization stringForKey:@"My Cart"];
    UINavigationController *myCartView = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    
    // initialize third screen
    thirdViewController = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
    thirdViewController.title = [MCLocalization stringForKey:@"Home"];
    UINavigationController *homeView = [[UINavigationController alloc] initWithRootViewController:thirdViewController];
    
    // initialize fourth screen
    forthViewController = [[AccountVC alloc] initWithNibName:@"AccountVC" bundle:nil];
    forthViewController.title = [MCLocalization stringForKey:@"Account"];
    UINavigationController *accountView = [[UINavigationController alloc] initWithRootViewController:forthViewController];
    
    // initialize fifth screen
    fifthViewController = [[WishListVC alloc] initWithNibName:@"WishListVC" bundle:nil];
    fifthViewController.title = [MCLocalization stringForKey:@"Wishlist"];
    UINavigationController *wishlistview = [[UINavigationController alloc] initWithRootViewController:fifthViewController];
    
    //add both views in array
    NSArray *controllers = [NSArray arrayWithObjects:homeView,offersView,myCartView,accountView,wishlistview,nil];
    
    //add array to tab bar
    baseTabBarController.viewControllers = controllers; 
    
    //add tab bar to window
    //[self.view addSubview:baseTabBarController];
    
    UITabBarItem *item1 = baseTabBarController.tabBar.items[0];
    UITabBarItem *item2 = baseTabBarController.tabBar.items[1];
    UITabBarItem *item3 = baseTabBarController.tabBar.items[2];
    UITabBarItem *item4 = baseTabBarController.tabBar.items[3];
    UITabBarItem *item5 = baseTabBarController.tabBar.items[4];
    
    item1.image=[UIImage imageNamed:@"FooterUnselected1"];
    item2.image=[UIImage imageNamed:@"FooterUnselected2"];
    item3.image=[UIImage imageNamed:@"FooterUnselected3"];
    item4.image=[UIImage imageNamed:@"FooterUnselected4"];
    item5.image=[UIImage imageNamed:@"FooterUnselected5"];
    
    item1.tag=1;
    item2.tag=2;
    item3.tag=3;
    item4.tag=4;
    item5.tag=5;
    
    self.window.rootViewController = baseTabBarController;
    [self.window makeKeyAndVisible];
}

-(void)showBadge {
    if ([[[Util getArrayData:kMyCart] mutableCopy] count] > 0) {
        UIViewController *selectedVC = [baseTabBarController.viewControllers objectAtIndex:baseTabBarController.selectedIndex];
        int selectedItemTag = (int)selectedVC.tabBarItem.tag;
        if (selectedItemTag != 3 && !self.isCatalogMode) {
            UITabBarItem *item3 = baseTabBarController.tabBar.items[2];
            item3.badgeColor = [Util colorWithHexString:[Util getStringData:kPrimaryColor]];
            item3.badgeValue = [NSString stringWithFormat:@"%ld",[[[Util getArrayData:kMyCart] mutableCopy] count]];
        }
    }
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    tabBarController.tabBar.selectedItem.badgeValue=nil;
    [self showBadge];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    // Call Abandoned Cart Method For Facebook Pixel
    [Util checkForAbandonedCart];
    
    NSArray *tabViewControllers = tabBarController.viewControllers;
    UIView * fromView = tabBarController.selectedViewController.view;
    UIView * toView = viewController.view;
    if (fromView == toView) {
        int tabitem = (int)tabBarController.selectedIndex;
        [[tabBarController.viewControllers objectAtIndex:tabitem] popToRootViewControllerAnimated:YES];
        return false;
    }
    if (self.isAcctChanged && [viewController.title isEqualToString:[MCLocalization stringForKey:@"Account"]]) {
        tabBarController.selectedIndex = 3;
        return true;
    }
    NSUInteger fromIndex = [tabViewControllers indexOfObject:tabBarController.selectedViewController];
    NSUInteger toIndex = [tabViewControllers indexOfObject:viewController];
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.4
                       options: toIndex > fromIndex ? UIViewAnimationOptionTransitionFlipFromLeft : UIViewAnimationOptionTransitionFlipFromRight
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = toIndex;
                        }
                    }];
    appDelegate.isFromBuyNow = NO;
    [Util setArray:nil setData:kBuyNow];
    return true;
}

#pragma mark - Redirect to search and notification

-(void)Notification:(UIViewController*)ViewC {
    NoticationVC *vc = [[NoticationVC alloc] initWithNibName:@"NoticationVC" bundle:nil];
    [ViewC.navigationController pushViewController:vc animated:YES];
}

-(void)Search:(UIViewController*)ViewC {
    SearchVC *vc = [[SearchVC alloc] initWithNibName:@"SearchVC" bundle:nil];
    if (self.fromMore) {
        self.fromMore = NO;
        vc.fromMore = YES;
    }
    vc.fromViewController = YES;
    [ViewC.navigationController pushViewController:vc animated:YES];
}

#pragma mark - check wishlist data

-(BOOL)checkWishListData {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
    if (arr.count > 0) {
        return YES;
    } else {
        return NO;
    }
    return NO;
}

#pragma mark - Google signIn Delegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    if (user == nil) {
        return;
    }
    NSString *userId = user.userID;                  // For client-side use only!
//    NSString *idToken = user.authentication.idToken; // Safe to send to the server
//    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    BOOL hashImage = user.profile.hasImage;
    
    NSURL *imageURL = [[NSURL alloc] init];
    CGSize thumbSize=CGSizeMake(500, 500);
    if (hashImage) {
        NSUInteger dimension = round(thumbSize.width * [[UIScreen mainScreen] scale]);
        imageURL = [user.profile imageURLWithDimension:dimension];
        NSLog(@"image url=%@",imageURL);
    }
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:email forKey:@"email"];
    [dict setValue:userId forKey:@"id"];
    [dict setValue:@"" forKey:@"gender"];
    [dict setValue:@"" forKey:@"dob"];
    [dict setValue:givenName forKey:@"first_name"];
    [dict setValue:familyName forKey:@"last_name"];
    [dict setValue:imageURL forKey:@"imageurl"];
    
    [Util setDictData:dict key:kGoogleData];
    if (self.delegateGoogle) {
        [self.delegateGoogle googleSignUp];
    }
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma mark - Set Recently Viewed Products

-(NSMutableArray*)getRecentArray {
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    NSData *dataRepresentingSavedArray = [currentDefaults objectForKey:kRecentItem];
    NSMutableArray *objectArray = nil;
    if(![dataRepresentingSavedArray isKindOfClass:[NSArray class]]) {
        if (dataRepresentingSavedArray != nil) {
            NSArray *savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataRepresentingSavedArray];
            if (savedArray != nil)
                objectArray = [[NSMutableArray alloc] initWithArray:savedArray];
            else
                objectArray = [[NSMutableArray alloc] init];
        }
    }
    return objectArray;
}

-(void)setRecentProduct:(Product*)product {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[self getRecentArray] mutableCopy]];
    int index = -1;
    for (int i = 0; i < arr.count; i++) {
        Product *object = [arr objectAtIndex:i];
        if (product.product_id == object.product_id) {
            index = i;
            break;
        }
    }
    if (index != -1) {
        [arr removeObjectAtIndex:index];
    }
    if (arr.count == 5) {
        [arr removeObjectAtIndex:4];
    }
    [arr insertObject:product atIndex:0];
    NSData *dataRepresentingSavedArrayData=[NSKeyedArchiver archivedDataWithRootObject:arr];
    [[NSUserDefaults standardUserDefaults] setObject:dataRepresentingSavedArrayData forKey:kRecentItem];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
}

-(void)setRecentProductArray:(Product*)product {
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[self getRecentArray]];
    [arr insertObject:product atIndex:0];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:arr];
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    [currentDefaults setObject:data forKey:kRecentItem];
}

- (BOOL)saveCustomObject:(Product *)object {
    NSMutableArray *arrRecentItem = [[NSMutableArray alloc]initWithArray:[[self getRecentArray] mutableCopy]];
    int index = -1;
    for (int i = 0; i < arrRecentItem.count; i++) {
        Product *object1;
        if([[arrRecentItem objectAtIndex:i] isKindOfClass:[NSData class]]) {
            object1 = [Util decodeProductData:[arrRecentItem objectAtIndex:i]];
        } else {
            object1 = [arrRecentItem objectAtIndex:i];
        }
        if (object.product_id == object1.product_id) {
            index = i;
            break;
        }
    }
    if (index != -1) {
        [arrRecentItem removeObjectAtIndex:index];
    }
    if (arrRecentItem.count == 5) {
        [arrRecentItem removeObjectAtIndex:4];
    }
    [Util setArray:arrRecentItem setData:kRecentItem];
    return YES;
}

#pragma mark - Set WishList data

-(void)setWishList:(NSMutableArray*)arrData {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < arrData.count; i++) {
        [arr addObject:[[arrData objectAtIndex:i] valueForKey:@"prod_id"]];
    }
    [Util setArray:arr setData:kWishList];
}

#pragma mark - Firebase Deep-Linking

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<NSString *, id> *)options {
    BOOL deepLink =  [self application:app
                               openURL:url
                     sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                            annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    BOOL google = [[GIDSignIn sharedInstance]
                   handleURL:url
                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    BOOL fb = [[FBSDKApplicationDelegate sharedInstance]
               application:app
               openURL:url
               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    return deepLink | google | fb;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    NSString *str = [appURL stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"www." withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"/" withString:@""];

    if ([url.absoluteString containsString:DEEP_LINK_DOMAIN] || [url.absoluteString containsString:str]) {
        FIRDynamicLink *dynamicLink = [[FIRDynamicLinks dynamicLinks] dynamicLinkFromCustomSchemeURL:url];
        
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        if (state == UIApplicationStateBackground || state == UIApplicationStateInactive || state == UIApplicationStateActive) {
            //app is open.
        } else {
            //app is not open
        }
        if (dynamicLink) {
            if (dynamicLink.url) {
                [self handleDynamicLink:dynamicLink];
            }
        }
        [self showDeeplinkAlert:[NSString stringWithFormat:@"OpenURL:\n%@", url]];
        return  NO;
    }
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

-(void)handleDynamicLink:(FIRDynamicLink *) dynamicLink {
    [self showDeeplinkAlert:dynamicLink.url.absoluteString];
}

-(void)showDeeplinkAlert:(NSString *) dynamicLinkURl {
    NSLog(@"URl is %@",dynamicLinkURl);
    NSString *encodedLink = dynamicLinkURl;
    NSString *decodedUrl = [encodedLink stringByRemovingPercentEncoding];
    NSLog (@"%@", decodedUrl);
    NSArray *items = [decodedUrl componentsSeparatedByString:@"#"];
    NSLog(@"Id is: %@", items);
    NSString *productId = [items objectAtIndex:items.count - 1];
    self.productID = productId;
    
    NSLog(@"Id is: %@", _productID);
    
    [[appDelegate.baseTabBarController.viewControllers objectAtIndex:0] popToRootViewControllerAnimated:YES];
    self.baseTabBarController.selectedIndex = 0;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DeepLinkData object:self];
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(nonnull NSUserActivity *)userActivity
 restorationHandler:
#if defined(__IPHONE_12_0) && (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_12_0)
(nonnull void (^)(NSArray<id<UIUserActivityRestoring>> *_Nullable))restorationHandler {
#else
    (nonnull void (^)(NSArray *_Nullable))restorationHandler {
#endif  // __IPHONE_12_0
        BOOL handled = [[FIRDynamicLinks dynamicLinks] handleUniversalLink:userActivity.webpageURL
                                                                completion:^(FIRDynamicLink * _Nullable dynamicLink,
                                                                             NSError * _Nullable error) {
                                                                    NSLog(@"Your deep link is: %@", dynamicLink);
                                                                    [self handleDynamicLink:dynamicLink];
                                                                }];
        if (!handled) {
            NSString *message = [NSString stringWithFormat:@"ContinueUserActivity webPageUrl: \n %@", userActivity.webpageURL];
            [self showDeeplinkAlert:message];
        }
        return handled;
    }
    
@end
