//
//  Util.m
//  Aglow
//
//  Created by CqlSys iOS Team on 01/02/16.
//  Copyright © 2016 cqlsys. All rights reserved.
//

#import "Util.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "LoaderVC.h"
@import Firebase;


@implementation Util


#pragma mark - check notificaton is enabled or not

+(void)generateDeepLink:(Product*)product desc:(NSString*)description viewController:(UIViewController*)viewController {
    SHOW_LOADER_ANIMTION();
    NSString *longUrl = [NSString stringWithFormat:@"%@#%d", product.permalink, product.product_id];
    
    NSURL *link = [NSURL URLWithString:longUrl];
    NSString *dynamicLinksDomain = DEEP_LINK_DOMAIN;
    FIRDynamicLinkComponents *components = [FIRDynamicLinkComponents componentsWithLink:link domainURIPrefix:dynamicLinksDomain];

    
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    components.iOSParameters = [[FIRDynamicLinkIOSParameters alloc]
                                initWithBundleID:bundleIdentifier];
    components.iOSParameters.appStoreID = APPLE_APP_STORE_ID;
    components.iOSParameters.minimumAppVersion = APPLE_APP_VERSION;
    
    components.androidParameters = [[FIRDynamicLinkAndroidParameters alloc]
                                    initWithPackageName:ANDROID_PACKAGE_NAME];
    components.androidParameters.minimumVersion = [PLAYSTORE_MINIMUM_VERSION intValue];
    
    FIRDynamicLinkSocialMetaTagParameters *socialParams = [FIRDynamicLinkSocialMetaTagParameters parameters];
    socialParams.title = product.name;
    socialParams.descriptionText = description;
    socialParams.imageURL = [NSURL URLWithString:[[product.arrImages objectAtIndex:0] valueForKey:@"src"]];
    components.socialMetaTagParameters = socialParams;
    
    NSLog(@"The long URL is: %@", components.url);
    [components shortenWithCompletion:^(NSURL * _Nullable shortURL,
                                        NSArray<NSString *> * _Nullable warnings,
                                        NSError * _Nullable error) {
        HIDE_PROGRESS;
        if (error || shortURL == nil) { return; }
        NSLog(@"error : %@", error);
        NSLog(@"Short URL: %@", shortURL.absoluteString);
        // [START_EXCLUDE]
        
        NSString *url = shortURL.absoluteString;
        [self shareURL:url productid:product.product_id viewController:viewController];
    }];
}

+(void)shareURL:(NSString*)urlShare productid:(int)productid viewController:(UIViewController*)viewController {
    
    NSString *url = [NSString stringWithFormat:@"%@#%d", urlShare, productid];
    NSArray *activityItems = @[url];
    UIActivityViewController *activityViewControntroller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityViewControntroller.excludedActivityTypes = @[];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        activityViewControntroller.popoverPresentationController.sourceView = viewController.view;
        activityViewControntroller.popoverPresentationController.sourceRect = CGRectMake(viewController.view.bounds.size.width/2, viewController.view.bounds.size.height/4, 0, 0);
    }
    [viewController presentViewController:activityViewControntroller animated:true completion:nil];
}

+ (BOOL)notificationServicesEnabled {
    BOOL isEnabled = NO;
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(currentUserNotificationSettings)]){
        UIUserNotificationSettings *notificationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        
        if (!notificationSettings || (notificationSettings.types == UIUserNotificationTypeNone)) {
            isEnabled = NO;
        } else {
            isEnabled = YES;
        }
    } else {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if (types & UIRemoteNotificationTypeAlert) {
            isEnabled = YES;
        } else{
            isEnabled = NO;
        }
    }
    return isEnabled;
}

#pragma mark
#pragma mark -emailValidation

+(BOOL)ValidateEmailString:(NSString *)str
{
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:str];
}

#pragma mark - phoneNumberValidation

+(BOOL)validatePhoneString:(NSString*)str {
    NSString *mobileNumberPattern = @"[789][0-9]{9}";
   // NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$";
    NSPredicate *mobileNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberPattern];
    
    return [mobileNumberPred evaluateWithObject:str];
}

#pragma mark - pinValidation

+(BOOL)validatePin:(NSString*)str {
    NSString *pinNumberPattern = @"^(\d)(?!\1+$)\d{5}$";
    NSPredicate *pinNumberPred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pinNumberPattern];

    return [pinNumberPred evaluateWithObject:str];
}

#pragma mark
#pragma mark - showAlertview

+ (void)showalert:(NSString *)_msg onView:(UIViewController *)controlr
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:appNAME
                                          message:_msg
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   
                               }];
    
    [alertController addAction:okAction];
    
    [controlr presentViewController:alertController animated:YES completion:nil];
}

#pragma mark
#pragma mark removeNullFromDictionary

+(NSMutableDictionary*)removeNull:(NSMutableDictionary*)dictionary{
    
    NSMutableDictionary *tempDict = [[NSMutableDictionary alloc] init];
    
    tempDict = [dictionary mutableCopy];
    
    //--remove null values from dictioanry
    for(NSString* key in [[dictionary allKeys] mutableCopy]) {
        
        if([dictionary[key] isKindOfClass:[NSNull class]] || dictionary[key] ==(id)[NSNull null])
        {
            [tempDict setValue:@"" forKey:key];
        }
    }
    return tempDict;
}

#pragma mark
#pragma mark  -encode decode Image BAse64

+ (NSString *)encodeToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:strEncodeData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

+ (NSString *)decodeBase64ToString:(NSString *)strEncodeData
{
    NSString *returnStr = nil;
    
    if( strEncodeData )
    {
        returnStr = [ strEncodeData stringByReplacingOccurrencesOfString:@"&Amp;" withString: @"&"];
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x27;" withString:@"'"];
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x39;" withString:@"'"];
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x92;" withString:@"'"];
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&#x96;" withString:@"'"];
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
        returnStr = [ returnStr stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        returnStr = [ [ NSString alloc ] initWithString:returnStr];
    }
    return returnStr;
}


#pragma mark

+ (BOOL) checkIfSuccessResponse : (NSDictionary *) responseDict {
    
    int i = [[responseDict objectForKey:@"success"] intValue];
    
    if (i == 1)
    {
        return true;
    }
    else
    {
        return false;
    }
}

+(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    
    double latitude = 0, longitude = 0;
    
    NSString *esc_addr = [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *esc_addr = [addressStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];

    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
    if (result) {
        NSScanner *scanner = [NSScanner scannerWithString:result];
        if ([scanner scanUpToString:@"\"lat\" :" intoString:nil] && [scanner scanString:@"\"lat\" :" intoString:nil]) {
            [scanner scanDouble:&latitude];
            if ([scanner scanUpToString:@"\"lng\" :" intoString:nil] && [scanner scanString:@"\"lng\" :" intoString:nil]) {
                [scanner scanDouble:&longitude];
            }
        }
    }
    CLLocationCoordinate2D center;
    center.latitude = latitude;
    center.longitude = longitude;
    return center;
}

+ (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, 20000.0f);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}


+ (id)cleanJsonToObject:(id)data
{
    NSError* error;
    if (data == (id)[NSNull null])
    {
        return [[NSObject alloc] init];
    }
    id jsonObject;
    
    if ([data isKindOfClass:[NSData class]])
    {
        jsonObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    }
    else
    {
        jsonObject = data;
    }
    
    if ([jsonObject isKindOfClass:[NSArray class]])
    {
        NSMutableArray *array = [jsonObject mutableCopy];
        for (int i = (int)array.count - 1; i >= 0; i--)
        {
            id a = array[i];
            if (a == (id)[NSNull null])
            {
                [array removeObjectAtIndex:i];
            }
            else
            {
                array[i] = [self cleanJsonToObject:a];
            }
        }
        return array;
    }
    else if ([jsonObject isKindOfClass:[NSDictionary class]])
    {
        NSMutableDictionary *dictionary = [jsonObject mutableCopy];
        for(NSString *key in [dictionary allKeys])
        {
            id d = dictionary[key];
            if (d == (id)[NSNull null])
            {
                dictionary[key] = @"";
            }
            else
            {
                dictionary[key] = [self cleanJsonToObject:d];
            }
        }
        return dictionary;
    }
    else
    {
        return jsonObject;
    }
}

+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *str = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];

    NSString *cString = [[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(NSURL *)EncodedURL:(NSString *)strURL
{
    return [NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
}


#pragma mark - set value in NSUserDefault

+ (void)setData:(NSString *)value key:(NSString *)key
{
    if(!(value == [NSNull null]))
    {
        [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)setArray:(NSMutableArray *)value setData:(NSString *)key
{
    NSMutableArray *archiveArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < value.count; i++)
    {
        NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:[value objectAtIndex:i]];
        [archiveArray addObject:personEncodedObject];
    }

    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    [currentDefaults setObject:archiveArray forKey:key];
}

+ (void)setBoolData:(BOOL)value setBoolData:(NSString *)key
{
    [[NSUserDefaults standardUserDefaults] setBool:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setDictData:(NSMutableDictionary*)value key:(NSString *)key
{
    NSData *personEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:value];
    
    NSUserDefaults *currentDefaults = [NSUserDefaults standardUserDefaults];
    [currentDefaults setObject:personEncodedObject forKey:key];
}

#pragma mark - get value from NSUserDefault

+ (NSString*)getStringData:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

+ (BOOL)getBoolData:(NSString*)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (NSMutableArray*)getArrayData:(NSString*)key
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[[NSUserDefaults standardUserDefaults] objectForKey:key] mutableCopy]];
    NSMutableArray *archiveArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < arr.count; i++)
    {
        [archiveArray addObject:[NSKeyedUnarchiver unarchiveObjectWithData:[arr objectAtIndex:i]]];
    }
    
    return archiveArray;
}

+ (NSMutableDictionary*)getDictData:(NSString*)key;
{
    NSData *dictionaryData = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    NSDictionary *dictionary = [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
    return [dictionary mutableCopy];
}

#pragma mark - toaser in ios

//TODO: Toaser Code

+(void)showPositiveMessage :(NSString*)message
{
    [self showAlertWithBackgroundColor:[self colorWithHexString:[self getStringData:kPrimaryColor]] textColor:[UIColor whiteColor] message:message];
}

+(void)showNegativeMessage :(NSString*)message
{
    [self showAlertWithBackgroundColor:[UIColor redColor] textColor:[UIColor whiteColor] message:message];
}

+(void)showAlertWithBackgroundColor:(UIColor*)backgroundColor textColor:(UIColor*)textColor message:(NSString*)String
{
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = String;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:13];
    label.adjustsFontSizeToFitWidth = true;
    [label sizeToFit];
    label.numberOfLines = 4;
    label.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    label.layer.shadowOffset = CGSizeMake(4, 3);
    label.layer.shadowOpacity = 0.3;
    label.frame = CGRectMake(320, statusBarSize.height + 57, appDelegate.window.frame.size.width, 44);
    label.alpha = 1;
    label.backgroundColor = backgroundColor;
    label.textColor = textColor;
    
    [appDelegate.window addSubview:label];
    
    CGRect basketTopFrame  = label.frame;
    basketTopFrame.origin.x = 0;
    
    [UIView animateWithDuration:2.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.1 options:UIViewAnimationOptionCurveEaseOut animations: ^(void){
        label.frame = basketTopFrame;
    } completion:^(BOOL finished){
        [label removeFromSuperview];
    }];
}

#pragma mark - product model data setup

+ (NSData *)encodeProductData:(Product*)object {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    return encodedObject;
}

+ (Product *)decodeProductData:(NSData *)encodedObject
{
    Product *cls=[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return cls;
}

+(Product*)setProductDataListing:(NSDictionary*)dict {
    
    Product *object = [[Product alloc] init];
    object.additional_Info = [dict valueForKey:@"addition_info_html"];
    object.arrAttributes = [dict valueForKey:@"attributes"];
        object.average_rating = [[dict valueForKey:@"average_rating"] doubleValue];
    
    object.date_created_gmt = [dict valueForKey:@"date_created_gmt"];
    object.desc = [dict valueForKey:@"description"];
    object.arrGrouped_products = [dict valueForKey:@"grouped_products"];
    object.product_id = [[dict valueForKey:@"id"] intValue];
    object.arrImages = [dict valueForKey:@"images"];
    object.in_stock = [[dict valueForKey:@"in_stock"] intValue];
    NSString *str = [dict valueForKey:@"name"];
    if ( str.length== 0)
    {
        object.name = [dict valueForKey:@"title"];
    }
    else
    {
        object.name = [dict valueForKey:@"name"];
    }
    
    object.permalink = [dict valueForKey:@"permalink"];
    if (![[dict valueForKey:@"price"] isKindOfClass:[NSDictionary class]]) {
        object.price = [[dict valueForKey:@"price"] doubleValue];
    }
    object.price_html = [dict valueForKey:@"price_html"];
    object.reviews_allowed = [[dict valueForKey:@"reviews_allowed"] intValue];
    object.rewards_message = [dict valueForKey:@"rewards_message"];
    object.sale_price = [dict valueForKey:@"sale_price"];
    object.regular_price = [dict valueForKey:@"regular_price"];
    object.dict_seller_info = [dict valueForKey:@"seller_info"];
    object.short_description = [dict valueForKey:@"short_description"];
    object.sold_individually = [[dict valueForKey:@"sold_individually"] intValue];
    object.on_sale = [[dict valueForKey:@"on_sale"] intValue];

    //    if ([[dict valueForKey:@"type"] respondsToSelector:@selector(stringValue)]) {
    //        object.type1 = [[dict objectForKey:@"type"] stringValue];
    //    }
    //    else {
    //        object.type1 = [NSString stringWithString:[dict valueForKey:@"type"]];
    //    }
    
    
    object.type1 = [NSString stringWithFormat:@"%@", [dict valueForKey:@"type"]];
    
    
    
    object.arrVariations =[dict valueForKey:@"variations"];
    object.external_url = [dict valueForKey:@"external_url"];
    object.arrRelated_ids = [dict valueForKey:@"related_ids"];
    object.date_on_sale_to = [dict valueForKey:@"date_on_sale_to"];
    
    NSNumber* stockActive = [dict valueForKey:@"manage_stock"];
    object.manageStock = [stockActive boolValue] ? YES : NO;
    
    if (object.manageStock) {
        if ([dict objectForKey:@"stock_quantity"]) {
            if(!([dict objectForKey:@"stock_quantity"] == [NSNull null])) {
                object.stockQuantity = [[dict valueForKey:@"stock_quantity"] intValue];
            } else {
                NSLog(@"Nil");
            }
        } else {
            object.stockQuantity = 0;
        }
    }
    
    if(appDelegate.isYithVideoEnabled) {
        if ([dict objectForKey:@"featured_video"]) {
            object.dict_featured_video = [dict valueForKey:@"featured_video"];
        }
    }
    return object;
}


+(Product*)setProductData:(NSDictionary*)dict {
    
    Product *object = [[Product alloc] init];
    object.additional_Info = [dict valueForKey:@"addition_info_html"];
    object.arrAttributes = [dict valueForKey:@"attributes"];
//    object.average_rating = [[dict valueForKey:@"average_rating"] doubleValue];
    object.average_rating = [[dict valueForKey:@"rating"] doubleValue];

    object.date_created_gmt = [dict valueForKey:@"date_created_gmt"];
    object.desc = [dict valueForKey:@"description"];
    object.arrGrouped_products = [dict valueForKey:@"grouped_products"];
    object.product_id = [[dict valueForKey:@"id"] intValue];
    object.arrImages = [dict valueForKey:@"images"];
    object.in_stock = [[dict valueForKey:@"in_stock"] intValue];
    NSString *str = [dict valueForKey:@"name"];
    if ( str.length== 0)
    {
        object.name = [dict valueForKey:@"title"];
    }
    else
    {
        object.name = [dict valueForKey:@"name"];
    }
    
    object.permalink = [dict valueForKey:@"permalink"];
    if (![[dict valueForKey:@"price"] isKindOfClass:[NSDictionary class]]) {
        object.price = [[dict valueForKey:@"price"] doubleValue];
    }
    object.price_html = [dict valueForKey:@"price_html"];
    object.reviews_allowed = [[dict valueForKey:@"reviews_allowed"] intValue];
    object.rewards_message = [dict valueForKey:@"rewards_message"];
    object.sale_price = [dict valueForKey:@"sale_price"];
    object.regular_price = [dict valueForKey:@"regular_price"];
    object.dict_seller_info = [dict valueForKey:@"seller_info"];
    object.short_description = [dict valueForKey:@"short_description"];
    object.sold_individually = [[dict valueForKey:@"sold_individually"] intValue];
    object.type1 = [NSString stringWithFormat:@"%@", [dict valueForKey:@"type"]];
    object.arrVariations =[dict valueForKey:@"variations"];
    object.external_url = [dict valueForKey:@"external_url"];
    object.arrRelated_ids = [dict valueForKey:@"related_ids"];
    object.date_on_sale_to = [dict valueForKey:@"date_on_sale_to"];
    object.on_sale = [[dict valueForKey:@"on_sale"] intValue];
    
    NSNumber* stockActive = [dict valueForKey:@"manage_stock"];
    object.manageStock = [stockActive boolValue] ? YES : NO;

    if (object.manageStock) {
        if ([dict objectForKey:@"stock_quantity"]) {
            if(!([dict objectForKey:@"stock_quantity"] == [NSNull null])) {
                object.stockQuantity = [[dict valueForKey:@"stock_quantity"] intValue];
            } else {
                NSLog(@"Nil");
            }
        } else {
            object.stockQuantity = 0;
        }
    }
    
    if(appDelegate.isYithVideoEnabled) {
        if ([dict objectForKey:@"featured_video"]) {
            object.dict_featured_video = [dict valueForKey:@"featured_video"];
        }
    }
    return object;
}

#pragma mark - Add To Cart Data

+ (BOOL)saveCustomObject:(AddToCartData *)object key:(NSString *)key
{
    NSMutableArray *arrMyCart = [[NSMutableArray alloc]initWithArray:[[self getArrayData:kMyCart] mutableCopy]];
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    AddToCartData *obj1 = [self loadCustomObjectWithKey:encodedObject];
    
    if (obj1.manageStock){
        if (obj1.stockQuantity == 0) {
            return NO;
        }
    }
    if (appDelegate.isFromBuyNow) {
        NSMutableArray *arrBuyNow = [[NSMutableArray alloc]initWithArray:[[self getArrayData:key] mutableCopy]];
        [arrBuyNow addObject:encodedObject];
        [self setArray:arrBuyNow setData:key];
    } else {
        int count = 0;
        for (int i = 0; i < arrMyCart.count; i++) {
            AddToCartData *obj;
            if([[arrMyCart objectAtIndex:i] isKindOfClass:[NSData class]]) {
                obj = [Util loadCustomObjectWithKey:[arrMyCart objectAtIndex:i]];
            } else {
                obj = [arrMyCart objectAtIndex:i];
            }

            if (obj.productId == obj1.productId && obj.variation_id == obj1.variation_id) {
                if (obj1.arrVariation != nil) {
                    if (![obj.arrVariation isEqualToDictionary:obj1.arrVariation]) {
                        count++;
                    } else {
                        appDelegate.isAlreadyInCart = true;
                    }
                } else if (obj1.variation_id == 0) {
                    //already there
//                    return YES;
                }
            } else {
                count++;
            }
        }
        
        if (count == arrMyCart.count) {
            [arrMyCart addObject:encodedObject];
            [self setArray:arrMyCart setData:key];
            return YES;
        } else {
            return NO;
        }
    }
    return YES;
}

+ (AddToCartData *)loadCustomObjectWithKey:(NSData *)encodedObject {
    AddToCartData *cls=[NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return cls;
}

#pragma mark - loader methods

+(void)ShowLoader:(UIViewController *)vc {
    LoaderVC *VC=[[LoaderVC alloc] initWithNibName:@"LoaderVC" bundle:nil];
    VC.view.frame=appDelegate.window.rootViewController.view.frame;
    VC.view.tag=123456789;
    VC.view.frame = vc.view.frame;
    [vc.view addSubview:VC.view];
    [vc.view bringSubviewToFront:VC.view];
}

+ (void)hide:(UIViewController *)vc {
    for (UIView *subview in vc.view.subviews) {
        if (subview.tag==123456789) {
            [subview removeFromSuperview];
        }
    }
}

+ (void)ShowLoader {
    LoaderVC *VC = [[LoaderVC alloc] initWithNibName:@"LoaderVC" bundle:nil];
    VC.view.frame=appDelegate.window.rootViewController.view.frame;
    VC.view.tag=123456789;
    [appDelegate.window.rootViewController.view addSubview:VC.view];
    [appDelegate.window.rootViewController.view bringSubviewToFront:VC.view];
}

+ (void)hide {
    for (UIView *subview in appDelegate.window.rootViewController.view.subviews) {
        if (subview.tag==123456789) {
            [subview removeFromSuperview];
        }
    }
}


+(NSMutableAttributedString*)setPriceForItem:(NSString*)str {
    NSString *strAtt = str;
    
    str = [str stringByReplacingOccurrencesOfString:@"<ins>" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</ins>" withString:@""];
    NSString * htmlString = str;
    
    
  NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:kCFStringEncodingUTF8] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    if ([attrStr.string containsString:@"–"]) {
        [attrStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(0, attrStr.length)];
        [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes range:NSMakeRange(0, attrStr.length)];
    } else if ([attrStr.string containsString:@" "]) {
        NSRange r1 = [strAtt rangeOfString:@"<ins>"];
        NSRange r2 = [strAtt rangeOfString:@"</ins>"];
        NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
        NSString *sub1 = [strAtt substringWithRange:rSub];
        NSRange r11 = [strAtt rangeOfString:@"<del>"];
        NSRange r21 = [strAtt rangeOfString:@"</del>"];
        NSRange rSub1 = NSMakeRange(r11.location + r11.length, r21.location - r11.location - r11.length);
        NSString *sub2 = [strAtt substringWithRange:rSub1];

//        NSMutableAttributedString * attrStr1 = [[NSMutableAttributedString alloc] initWithData:[sub1 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
//        NSMutableAttributedString * attrStr2 = [[NSMutableAttributedString alloc] initWithData:[sub2 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

        
        NSMutableAttributedString * attrStr1 = [[NSMutableAttributedString alloc] initWithData:[sub1 dataUsingEncoding:kCFStringEncodingUTF8] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        
        NSMutableAttributedString * attrStr2 = [[NSMutableAttributedString alloc] initWithData:[sub2 dataUsingEncoding:kCFStringEncodingUTF8] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];

        
        
        
        
        
        
        NSString *str11 = [attrStr1.string stringByReplacingOccurrencesOfString:appDelegate.strCurrencySymbol withString:@""];
        NSString *str1 = [str11 stringByReplacingOccurrencesOfString:@"," withString:@""];

        NSString *str22 = [attrStr2.string stringByReplacingOccurrencesOfString:appDelegate.strCurrencySymbol withString:@""];
        NSString *str2 = [str22 stringByReplacingOccurrencesOfString:@"," withString:@""];

        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i.", 1]];

        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length-1)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(string.length-1,1)];

        attrStr = [[NSMutableAttributedString alloc] init];

        if ([str1 doubleValue] > [str2 doubleValue]) {
            [attrStr1 addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0, attrStr1.length)];
            [attrStr1 addAttribute:NSFontAttributeName value:Font_Size_Price_Sale range:NSMakeRange(0, attrStr1.length)];
            [attrStr1 addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, attrStr1.length)];

            [attrStr2 addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(0, attrStr2.length)];

            [attrStr2 addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes range:NSMakeRange(0, attrStr2.length)];

            [attrStr appendAttributedString:attrStr1];
            [attrStr appendAttributedString:string];
            [attrStr appendAttributedString:attrStr2];
        } else {
            [attrStr1 addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(0, attrStr1.length)];
            [attrStr1 addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes range:NSMakeRange(0, attrStr1.length)];

            [attrStr2 addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0, attrStr2.length)];

            [attrStr2 addAttribute:NSFontAttributeName value:Font_Size_Price_Sale range:NSMakeRange(0, attrStr2.length)];
            [attrStr2 addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, attrStr2.length)];
            [attrStr appendAttributedString:attrStr2];
            [attrStr appendAttributedString:string];
            [attrStr appendAttributedString:attrStr1];
        }
    } else {
        [attrStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(0, attrStr.length)];
        [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes range:NSMakeRange(0, attrStr.length)];
    }
    return attrStr;
}

+(NSAttributedString*)setPriceForItemSmall:(NSString*)str
{
    NSString *strAtt = str;

    str = [str stringByReplacingOccurrencesOfString:@"<ins>"
                                         withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"</ins>"
                                         withString:@""];

    NSString * htmlString = str;
    
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    if ([attrStr.string containsString:@"–"])
    {
        [attrStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(0, attrStr.length)];
        [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes_Small range:NSMakeRange(0, attrStr.length)];
    }
    else if ([attrStr.string containsString:@" "])
    {
//        NSUInteger location = [attrStr.string rangeOfString:@" "].location + 1;
//
//        NSArray *arrSecond = [attrStr.string componentsSeparatedByString:@" "];
//        NSString *str11 = [[arrSecond objectAtIndex:0] stringByReplacingOccurrencesOfString:appDelegate.strCurrencySymbol withString:@""];
//        NSString *str1 = [str11 stringByReplacingOccurrencesOfString:@"," withString:@""];
//        NSString *str22 = [[arrSecond objectAtIndex:1] stringByReplacingOccurrencesOfString:appDelegate.strCurrencySymbol withString:@""];
//        NSString *str2 = [str22 stringByReplacingOccurrencesOfString:@"," withString:@""];
//
//        if ([str1 doubleValue] > [str2 doubleValue]) {
//            [attrStr addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0, location)];
//            [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Small range:NSMakeRange(0, location)];
//
//            [attrStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(location, attrStr.length - location)];
//
//            [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes_Small range:NSMakeRange(location, attrStr.length - location)];
//        } else {
//            [attrStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(0, location)];
//            [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes_Small range:NSMakeRange(0, location)];
//
//            [attrStr addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(location, attrStr.length - location)];
//
//            [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Small range:NSMakeRange(location, attrStr.length - location)];
//        }
        NSRange r1 = [strAtt rangeOfString:@"<ins>"];
        NSRange r2 = [strAtt rangeOfString:@"</ins>"];
        NSRange rSub = NSMakeRange(r1.location + r1.length, r2.location - r1.location - r1.length);
        NSString *sub1 = [strAtt substringWithRange:rSub];
        
        NSRange r11 = [strAtt rangeOfString:@"<del>"];
        NSRange r21 = [strAtt rangeOfString:@"</del>"];
        NSRange rSub1 = NSMakeRange(r11.location + r11.length, r21.location - r11.location - r11.length);
        NSString *sub2 = [strAtt substringWithRange:rSub1];
        
        NSMutableAttributedString * attrStr1 = [[NSMutableAttributedString alloc] initWithData:[sub1 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        NSMutableAttributedString * attrStr2 = [[NSMutableAttributedString alloc] initWithData:[sub2 dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        
        //        NSUInteger location = [attrStr.string rangeOfString:@" "].location + 1;
        //
        //        NSArray *arrSecond = [attrStr.string componentsSeparatedByString:@" "];
        //        NSString *str11 = [[arrSecond objectAtIndex:0] stringByReplacingOccurrencesOfString:appDelegate.strCurrencySymbol withString:@""];
        //        NSString *str1 = [str11 stringByReplacingOccurrencesOfString:@"," withString:@""];
        //        NSString *str22 = [[arrSecond objectAtIndex:1] stringByReplacingOccurrencesOfString:appDelegate.strCurrencySymbol withString:@""];
        //        NSString *str2 = [str22 stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSString *str11 = [attrStr1.string stringByReplacingOccurrencesOfString:appDelegate.strCurrencySymbol withString:@""];
        NSString *str1 = [str11 stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSString *str22 = [attrStr2.string stringByReplacingOccurrencesOfString:appDelegate.strCurrencySymbol withString:@""];
        NSString *str2 = [str22 stringByReplacingOccurrencesOfString:@"," withString:@""];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%i.", 1]];
        
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length-1)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor clearColor] range:NSMakeRange(string.length-1,1)];
        
        attrStr = [[NSMutableAttributedString alloc] init];

        if ([str1 doubleValue] > [str2 doubleValue])
        {
            //            [attrStr addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0, location)];
            //            [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale range:NSMakeRange(0, location)];
            //
            //            [attrStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(location, attrStr.length - location)];
            //
            //            [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes range:NSMakeRange(location, attrStr.length - location)];
            [attrStr1 addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0, attrStr1.length)];
            [attrStr1 addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Small range:NSMakeRange(0, attrStr1.length)];
            [attrStr1 addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, attrStr1.length)];

            [attrStr2 addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(0, attrStr2.length)];
            
            [attrStr2 addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes_Small range:NSMakeRange(0, attrStr2.length)];
            
            [attrStr appendAttributedString:attrStr1];
            [attrStr appendAttributedString:string];
            [attrStr appendAttributedString:attrStr2];
        }
        else
        {
            //            [attrStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(0, location)];
            //            [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes range:NSMakeRange(0, location)];
            //
            //            [attrStr addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(location, attrStr.length - location)];
            //
            //            [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale range:NSMakeRange(location, attrStr.length - location)];
            [attrStr1 addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(0, attrStr1.length)];
            [attrStr1 addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes_Small range:NSMakeRange(0, attrStr1.length)];
            
            [attrStr2 addAttribute:NSForegroundColorAttributeName value:FontColorGray range:NSMakeRange(0, attrStr2.length)];
            
            [attrStr2 addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Small range:NSMakeRange(0, attrStr2.length)];
            [attrStr2 addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, attrStr2.length)];
            [attrStr appendAttributedString:attrStr2];
            [attrStr appendAttributedString:string];
            [attrStr appendAttributedString:attrStr1];
        }
    }
    else
    {
        [attrStr addAttribute:NSForegroundColorAttributeName value:[self colorWithHexString:[self getStringData:kPrimaryColor]] range:NSMakeRange(0, attrStr.length)];
        [attrStr addAttribute:NSFontAttributeName value:Font_Size_Price_Sale_Yes_Small range:NSMakeRange(0, attrStr.length)];
    }
    return attrStr;
}


+(HCSStarRatingView *)setStarRating:(double)value frame:(CGRect)frame tag:(NSInteger)tag
{
    HCSStarRatingView *starRatingView = [[HCSStarRatingView alloc] initWithFrame:frame];
    starRatingView.maximumValue = 5;
    starRatingView.minimumValue = 0;
    starRatingView.value = value;
    starRatingView.allowsHalfStars = YES;
    starRatingView.accurateHalfStars = YES;
    
//    starRatingView.tintColor = [Util colorWithHexString:[Util getStringData:kPrimaryColor]];
    
    starRatingView.backgroundColor = [UIColor clearColor];
    starRatingView.tintColor = [Util colorWithHexString:@"ffcc00"];
    
//    starRatingView.emptyStarImage = [UIImage imageNamed:@"StarNonFillBlack"];
//    starRatingView.halfStarImage = [UIImage imageNamed:@"StarHalfFilledBlack"]; // optional
//    starRatingView.filledStarImage = [UIImage imageNamed:@"StarFilledBlack"];
    
    starRatingView.userInteractionEnabled = NO;
    starRatingView.tag = tag;
    return starRatingView;
}

#pragma mark - set color from server
+(void)setPrimaryColorLabelBackGround:(UILabel*)lbl
{
    lbl.backgroundColor = [self colorWithHexString:[self getStringData:kPrimaryColor]];
}

+(void)setPrimaryColorLabelText:(UILabel*)lbl
{
    lbl.textColor = [self colorWithHexString:[self getStringData:kPrimaryColor]];
}

+(void)setPrimaryColorButtonTitle:(UIButton*)btn
{
    NSLog(@"%@",[Util getStringData:kPrimaryColor]);
    
    [btn setTitleColor:[Util colorWithHexString:[Util getStringData:kPrimaryColor]] forState:UIControlStateNormal];
}

+(void)setSecondaryColorButtonTitle:(UIButton*)btn
{
    [btn setTitleColor:[Util colorWithHexString:[Util getStringData:kSecondaryColor]] forState:UIControlStateNormal];
}

+(void)setPrimaryColorActivityIndicator:(UIActivityIndicatorView*)view
{
    [view setColor:[self colorWithHexString:[self getStringData:kPrimaryColor]]];
}

+(void)setPrimaryColorView:(UIView*)view
{
    view.backgroundColor = [self colorWithHexString:[self getStringData:kPrimaryColor]];
}

+(void)setSecondaryColorView:(UIView*)view
{
    view.backgroundColor = [self colorWithHexString:[self getStringData:kSecondaryColor]];
}

+(void)setHeaderColorView:(UIView*)view
{
    view.backgroundColor = [self colorWithHexString:[self getStringData:kHeaderColor]];
}

+(void)setGrayColorLabelText:(UILabel*)lbl
{
    lbl.textColor = UIColor.grayColor;
}

#pragma mark - Color to button
+(void)setSecondaryColorButton:(UIButton*)view
{
    view.backgroundColor = [self colorWithHexString:[self getStringData:kSecondaryColor]];
}

+(void)setRedButton:(UIButton*)view
{
//    view.backgroundColor = [UIColor grayColor];
    view.backgroundColor = [Util colorWithHexString:@"808080"];
}

+(void)setPrimaryColorButton:(UIButton*)view
{
    view.backgroundColor = [self colorWithHexString:[self getStringData:kPrimaryColor]];
}

+(void)setHeaderColorButton:(UIButton*)view
{
    view.backgroundColor = [self colorWithHexString:[self getStringData:kHeaderColor]];
}


+(void)setPrimaryColorImageView:(UIImageView*)img
{
    img.image = [img.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [img setTintColor:[self colorWithHexString:[self getStringData:kPrimaryColor]]];
}

+(void)setColorImageView:(UIImageView*)img Color:(UIColor *)Color
{
    img.image = [img.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [img setTintColor:Color];
}

+(void)setSecondaryColorImageView:(UIImageView*)img
{
    img.image = [img.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [img setTintColor:[self colorWithHexString:[self getStringData:kSecondaryColor]]];
}

+(void)setPrimaryColorButtonImage:(UIButton*)btn image:(UIImage*)img
{
    [btn setBackgroundImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    btn.tintColor = [self colorWithHexString:[self getStringData:kPrimaryColor]];
}

+(void)setPrimaryColorButtonImageBG:(UIButton*)btn image:(UIImage*)img
{
    [btn setImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    btn.tintColor = [self colorWithHexString:[self getStringData:kPrimaryColor]];
}

+(void)setSecondaryColorButtonImage:(UIButton*)btn image:(UIImage*)img
{
    [btn setBackgroundImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    btn.tintColor = [self colorWithHexString:[self getStringData:kSecondaryColor]];
}

+(void)setHeaderColorButtonImage:(UIButton*)btn image:(UIImage*)img
{
    [btn setBackgroundImage:[img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    btn.tintColor = [self colorWithHexString:[self getStringData:kHeaderColor]];
}

+(BOOL)checkInCart:(Product*)product variation:(int)variationId attribute:(NSDictionary*)dictAttributes {
    
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
    object.variation_id = variationId;
    object.quantity = 1;
    object.price = product.price;
    object.arrVariation = nil;
    object.isSoldIndividually = (BOOL)product.sold_individually;
    
    object.manageStock = (BOOL)product.manageStock;
    object.stockQuantity = product.stockQuantity;

    NSMutableArray *arrMyCart = [[NSMutableArray alloc]initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    AddToCartData *obj1 = [Util loadCustomObjectWithKey:encodedObject];
    
    for (int i = 0; i < arrMyCart.count; i++)
    {
        AddToCartData *obj;
        if([[arrMyCart objectAtIndex:i] isKindOfClass:[NSData class]])
        {
            obj = [Util loadCustomObjectWithKey:[arrMyCart objectAtIndex:i]];
        }
        else
        {
            obj = [arrMyCart objectAtIndex:i];
        }
        
        if (obj.productId == obj1.productId && obj.variation_id == obj1.variation_id)
        {
            if (obj1.variation_id == 0) {
                return YES;
            } else if ([dictAttributes isEqualToDictionary:obj.arrVariation]) {
                return YES;
            }
        }
    }
    return NO;
}

#pragma mark - Facebook Pixel Event

//Product Search Event

+ (void)logSearchedEvent :(NSString*)contentType
            searchString :(NSString*)searchString
                 success :(BOOL)success {
    
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     contentType, FBSDKAppEventParameterNameContentType,
     searchString, FBSDKAppEventParameterNameSearchString,
     [NSNumber numberWithInt:success ? 1 : 0], FBSDKAppEventParameterNameSuccess,
     nil];
    
    [FBSDKAppEvents logEvent: FBSDKAppEventNameSearched
                  parameters: params];
    [FBSDKAppEvents logEvent:@"Search Event Log"];
}

//Product View content Event

+ (void)logViewedContentEvent :(NSString*)contentType
                    contentId :(NSString*)contentId
                     currency :(NSString*)currency
                     valToSum :(double)price {
    
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     contentType, FBSDKAppEventParameterNameContentType,
     contentId, FBSDKAppEventParameterNameContentID,
     currency, FBSDKAppEventParameterNameCurrency,
     nil];
    
    [FBSDKAppEvents logEvent: FBSDKAppEventNameViewedContent
                  valueToSum: price
                  parameters: params];
    
    [FBSDKAppEvents logEvent:@"Product View Content"];
}

//Product Add to cart Event

+ (void)logAddedToCartEvent :(NSString*)contentId
                contentType :(NSString*)contentType
                   currency :(NSString*)currency
                   valToSum :(double)price {
    
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     contentId, FBSDKAppEventParameterNameContentID,
     contentType, FBSDKAppEventParameterNameContentType,
     currency, FBSDKAppEventParameterNameCurrency,
     nil];
    
    [FBSDKAppEvents logEvent: FBSDKAppEventNameAddedToCart
                  valueToSum: price
                  parameters: params];
}

//Product Wishlist Event

+ (void)logAddedToWishlistEvent :(NSString*)contentId
                    contentType :(NSString*)contentType
                       currency :(NSString*)currency
                       valToSum :(double)price {
    
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     contentId, FBSDKAppEventParameterNameContentID,
     contentType, FBSDKAppEventParameterNameContentType,
     currency, FBSDKAppEventParameterNameCurrency,
     nil];
    
    [FBSDKAppEvents logEvent: FBSDKAppEventNameAddedToWishlist
                  valueToSum: price
                  parameters: params];
}

// Product Purchase Event

+ (void)logPurchasedEvent :(int)numItems
              contentType :(NSString*)contentType
                contentId :(NSString*)contentId
                 currency :(NSString*)currency
                 valToSum :(double)price {
    
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     [NSNumber numberWithInt:numItems], FBSDKAppEventParameterNameNumItems,
     contentType, FBSDKAppEventParameterNameContentType,
     contentId, FBSDKAppEventParameterNameContentID,
     currency, FBSDKAppEventParameterNameCurrency,
     nil];
    
    [FBSDKAppEvents logPurchase:price
                       currency: currency
                     parameters: params];
}

// Product Initial Checkout Event

+ (void)logInitiatedCheckoutEvent :(NSString*)contentId
                      contentType :(NSString*)contentType
                         numItems :(int)numItems
             paymentInfoAvailable :(BOOL)paymentInfoAvailable
                         currency :(NSString*)currency
                         valToSum :(double)totalPrice {
    
    NSDictionary *params =
    [[NSDictionary alloc] initWithObjectsAndKeys:
     contentId, FBSDKAppEventParameterNameContentID,
     contentType, FBSDKAppEventParameterNameContentType,
     [NSNumber numberWithInt:numItems], FBSDKAppEventParameterNameNumItems,
     [NSNumber numberWithInt:paymentInfoAvailable ? 1 : 0], FBSDKAppEventParameterNamePaymentInfoAvailable,
     currency, FBSDKAppEventParameterNameCurrency,
     nil];
    
    [FBSDKAppEvents logEvent: FBSDKAppEventNameInitiatedCheckout
                  valueToSum: totalPrice
                  parameters: params];
}

// Abandoned_cart Event

+ (void)logAbandoned_CartEvent:(NSString *)contentId
                   contentType:(NSString *)contentType
                      numItems:(NSInteger)numItems
                      currency:(NSString *)currency
                         price:(double)price {
    NSDictionary *params =
    @{
      @"contentId" : contentId,
      @"contentType" : contentType,
      @"numItems" : @(numItems),
      @"currency" : currency,
      @"price" : [NSNumber numberWithDouble:price]
      };
    [FBSDKAppEvents
     logEvent:@"Abandoned_Cart"
     parameters:params];
}

#pragma mark - Check AbandonedCart

+(void)checkForAbandonedCart
{
    if ([appDelegate.strCurrencySymbol isEqualToString:@""] || appDelegate.strCurrencySymbol == nil)
    {
        return;
    }
    if (![[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:kFbAbandonedCartTime]) {
        [self setArray:nil setData:kFbAbandonedCartObject];
        [self setData:@"" key:kFbAbandonedCartTime];
        return;
    }
    if ([Util getStringData:kFbAbandonedCartTime] != nil && ![[Util getStringData:kFbAbandonedCartTime] isEqualToString:@""])
    {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *currentTime = [dateFormatter dateFromString:[dateFormatter stringFromDate:[NSDate date]]];
        NSDate *storeTime = [dateFormatter dateFromString:[Util getStringData:kFbAbandonedCartTime]];
        
        NSTimeInterval timeDifference = [currentTime timeIntervalSinceDate:storeTime];
        
        double minutes = timeDifference / 60;
        double hours = minutes / 60;
        double seconds = timeDifference;
        double days = minutes / 1440;
        
        
        Boolean time = false;
        
        if (days >= 1 || hours >= 0.5) {
            time = true;
        } else {
            if (minutes >= 30) {
                time = true;
                NSLog(@" days = %.0f,hours = %.2f, minutes = %.0f,seconds = %.0f", days, hours, minutes, seconds);
            }
        }
        if (time)
        {
            if ([self getArrayData:kFbAbandonedCartObject] != nil && [[self getArrayData:kFbAbandonedCartObject] count] > 0)
            {
                //evaluate array and make fb pixel api calls
                NSMutableArray *arrCart = [[NSMutableArray alloc] initWithArray:[self getArrayData:kFbAbandonedCartObject]];
                for (int  i = 0; i < arrCart.count; i++)
                {
                    //pixel api calls
                    AddToCartData * initialCheckout;
                    if([[arrCart objectAtIndex:i] isKindOfClass:[NSData class]])
                    {
                        initialCheckout = [Util loadCustomObjectWithKey:[arrCart objectAtIndex:i]];
                    }
                    else
                    {
                        initialCheckout = [arrCart objectAtIndex:i];
                    }
                    // Facebook Pixel for Abandoned Cart
                    [self logAbandoned_CartEvent:[NSString stringWithFormat:@"%d", initialCheckout.productId] contentType:initialCheckout.name numItems:initialCheckout.quantity currency:appDelegate.strCurrencySymbol price:initialCheckout.price];
                }
            }
            //Remove data for time and Abandoned Cart Array
            [self setArray:nil setData:kFbAbandonedCartObject];
            [self setData:@"" key:kFbAbandonedCartTime];
        }
    }
    else
    {
        //Remove data for time and Abandoned Cart Array
        [self setArray:nil setData:kFbAbandonedCartObject];
        [self setData:@"" key:kFbAbandonedCartTime];
    }
    
}

#pragma mark - Play video

+(void)PlayVideo:(NSString*)url viewController:(UIViewController*)viewController
{
    VideoVC *vc = [[VideoVC alloc] initWithNibName:@"VideoVC" bundle:nil];
    vc.url = url;
    [viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Show Variation detail

+(void)showVariationPage:(UIViewController*)view product:(Product*)product {
    
    appDelegate.arrSelectedVariable = [[NSMutableArray alloc] init];
    appDelegate.arrVariations = [[NSMutableArray alloc] init];
    
    VariationVC *vc = [[VariationVC alloc] initWithNibName:@"VariationVC" bundle:nil];
    vc.product = product;
    
    view.definesPresentationContext = YES; //self is presenting view controller
    vc.view.backgroundColor = [UIColor clearColor];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;

//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
//    [navigationController setNavigationBarHidden:true];
    [view presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Set Triange Label

+(void)setTriangleLable:(UIView*)vwDiscount product:(Product*)product {

    if ((product.sale_price == (id)[NSNull null]) || [product.sale_price isEqualToString:@""] || product.on_sale == 0 ) {
        for (UIView *i in vwDiscount.subviews) {
            if(i.tag == 999999){
                [i removeFromSuperview];
            }
        }
        return;
    }
    BOOL found = false;
    for (UIView *i in vwDiscount.subviews){
        if(i.tag == 999999) {
            [i removeFromSuperview];
            found = false;
            break;
        } else {
            found = true;
        }
    }
    if (!found) {
        float disc = [product.regular_price floatValue] - [product.sale_price floatValue];
        float discount = disc * 100 / [product.regular_price floatValue];
        if (appDelegate.isRTL) {
            TriLabelViewRTL *lblDiscount = [[TriLabelViewRTL alloc] initWithFrame:CGRectMake(vwDiscount.frame.size.width - vwDiscount.frame.size.width, 0, vwDiscount.frame.size.width, vwDiscount.frame.size.width)];
            if (fmod(discount, 1.0) == 0.0) {
                lblDiscount.labelText = [NSString stringWithFormat:@"%d %%", (int)discount];
            } else {
                lblDiscount.labelText = [NSString stringWithFormat:@"%.2f %%", discount];
            }
            lblDiscount.viewColor = [Util colorWithHexString:[Util getStringData:kPrimaryColor]];
            lblDiscount.labelFont = Font_Size_Price_Sale_Small;
            lblDiscount.textColor = [UIColor whiteColor];
            lblDiscount.lengthPercentage = 100;
            lblDiscount.tag = 999999;
            [vwDiscount addSubview:lblDiscount];
        } else {
            TriLabelView *lblDiscount = [[TriLabelView alloc] initWithFrame:CGRectMake(0, 0, vwDiscount.frame.size.width, vwDiscount.frame.size.width)];
            if (fmod(discount, 1.0) == 0.0) {
                lblDiscount.labelText = [NSString stringWithFormat:@"%d %%", (int)discount];
            } else {
                lblDiscount.labelText = [NSString stringWithFormat:@"%.2f %%", discount];
            }
            lblDiscount.viewColor = [Util colorWithHexString:[Util getStringData:kPrimaryColor]];
            lblDiscount.labelFont = Font_Size_Price_Sale_Small;
            lblDiscount.textColor = [UIColor whiteColor];
            lblDiscount.lengthPercentage = 100;
            lblDiscount.tag = 999999;
            [vwDiscount addSubview:lblDiscount];
        }
    }
}
@end
