//
//  Util.h
//  Aglow
//
//  Created by CqlSys iOS Team on 01/02/16.
//  Copyright © 2016 cqlsys. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AddToCartData.h"
#import "Product.h"
#import "HCSStarRatingView.h"
@interface Util : NSObject

#pragma mark
#pragma mark -emailValidation

+(BOOL)ValidateEmailString:(NSString *)str;

#pragma mark - phoneNumberValidation

+(BOOL)validatePhoneString:(NSString*)str;

#pragma mark - pinValidation

+(BOOL)validatePin:(NSString*)str;

#pragma mark
#pragma mark - showAlertview

+ (void)showalert:(NSString *)_msg onView:(UIViewController *)controlr;

#pragma mark
#pragma mark removeNullFromDictionary

+(NSMutableDictionary*)removeNull:(NSMutableDictionary*)dictionary;

#pragma mark
#pragma mark  -encode decode Image BAse64

+ (NSString *)encodeToBase64String:(UIImage *)image;
+ (UIImage *)decodeBase64ToImage:(NSString *)strEncodeData;

#pragma mark

+ (BOOL) checkIfSuccessResponse : (NSDictionary *) responseDict;

#pragma mark 
#pragma mark a
+(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr;
+ (CGFloat)getLabelHeight:(UILabel*)label;
+ (id)cleanJsonToObject:(id)data;

+(UIColor*)colorWithHexString:(NSString*)hex;
+(NSURL *)EncodedURL:(NSString *)strURL;


#pragma mark - get and set data form NSUserDefault

+ (void)setData:(NSString *)value key:(NSString *)key;
+ (void)setArray:(NSMutableArray *)value setData:(NSString *)key;
+ (void)setBoolData:(BOOL)value setBoolData:(NSString *)key;
+ (void)setDictData:(NSMutableDictionary*)value key:(NSString *)key;

+ (NSString*)getStringData:(NSString*)key;
+ (NSMutableArray*)getArrayData:(NSString*)key;
+ (BOOL)getBoolData:(NSString*)key;
+ (NSMutableDictionary*)getDictData:(NSString*)key;


#pragma mark - Toaser in ios

+(void)showPositiveMessage :(NSString*)message;
+(void)showNegativeMessage :(NSString*)message;


#pragma mark - add to cart

+(BOOL)saveCustomObject:(AddToCartData *)object key:(NSString *)key;
+ (AddToCartData *)loadCustomObjectWithKey:(NSData *)encodedObject;


#pragma mark - set color from server

+(void)setRedButton:(UIButton*)view;
+(void)setPrimaryColorLabelText:(UILabel*)lbl;
+(void)setGrayColorLabelText:(UILabel*)lbl;

+(void)setPrimaryColorButtonTitle:(UIButton*)btn;
+(void)setSecondaryColorButtonTitle:(UIButton*)btn;

+(void)setPrimaryColorButtonImageBG:(UIButton*)btn image:(UIImage*)img;
+(void)setPrimaryColorButtonImage:(UIButton*)btn image:(UIImage*)img;
+(void)setSecondaryColorButtonImage:(UIButton*)btn image:(UIImage*)img;
+(void)setHeaderColorButtonImage:(UIButton*)btn image:(UIImage*)img;

+(void)setPrimaryColorActivityIndicator:(UIActivityIndicatorView*)view;

+(void)setPrimaryColorView:(UIView*)view;
+(void)setSecondaryColorView:(UIView*)view;
+(void)setHeaderColorView:(UIView*)view;

+(void)setSecondaryColorButton:(UIButton*)view;
+(void)setPrimaryColorButton:(UIButton*)view;

+(void)setHeaderColorButton:(UIButton*)view;
+(void)setPrimaryColorImageView:(UIImageView*)img;
+(void)setSecondaryColorImageView:(UIImageView*)img;



+(void)setColorImageView:(UIImageView*)img Color:(UIColor *)color;
+(void)setPrimaryColorLabelBackGround:(UILabel*)lbl;

#pragma mark - loader

+(void)ShowLoader;
+(void)hide;



+(void)ShowLoader:(UIViewController *)vc;
+(void)hide:(UIViewController *)vc;




+(NSMutableAttributedString*)setPriceForItem:(NSString*)str;
+(NSAttributedString*)setPriceForItemSmall:(NSString*)str;


+(HCSStarRatingView *)setStarRating:(double)value frame:(CGRect)frame tag:(NSInteger)tag;


+ (NSString *)decodeBase64ToString:(NSString *)strEncodeData;


+ (BOOL)notificationServicesEnabled;

//+(BOOL)checkInCart:(Product*)product variation:(int)variationId;
+(BOOL)checkInCart:(Product*)product variation:(int)variationId attribute:(NSDictionary*)dictAttributes;


#pragma mark - Set Product Model

+ (NSData *)encodeProductData:(Product*)object;
+ (Product *)decodeProductData:(NSData *)encodedObject;
+ (Product *)setProductData:(NSDictionary*)dict;

#pragma mark - Facebook Pixel Event

+ (void)logSearchedEvent :(NSString*)contentType
            searchString :(NSString*)searchString
                 success :(BOOL)success;

+ (void)logViewedContentEvent :(NSString*)contentType
                    contentId :(NSString*)contentId
                     currency :(NSString*)currency
                     valToSum :(double)price;

+ (void)logAddedToCartEvent :(NSString*)contentId
                contentType :(NSString*)contentType
                   currency :(NSString*)currency
                   valToSum :(double)price;

+ (void)logAddedToWishlistEvent :(NSString*)contentId
                    contentType :(NSString*)contentType
                       currency :(NSString*)currency
                       valToSum :(double)price;

+ (void)logPurchasedEvent :(int)numItems
              contentType :(NSString*)contentType
                contentId :(NSString*)contentId
                 currency :(NSString*)currency
                 valToSum :(double)price;

+ (void)logInitiatedCheckoutEvent :(NSString*)contentId
                      contentType :(NSString*)contentType
                         numItems :(int)numItems
             paymentInfoAvailable :(BOOL)paymentInfoAvailable
                         currency :(NSString*)currency
                         valToSum :(double)totalPrice;

+ (void)logAbandoned_CartEvent:(NSString *)contentId
                   contentType:(NSString *)contentType
                      numItems:(NSInteger)numItems
                      currency:(NSString *)currency
                         price:(double)price;

#pragma mark - Check AbandonedCart

+(void)checkForAbandonedCart;

#pragma mark - Deep link data
+(void)generateDeepLink:(Product*)product desc:(NSString*)description viewController:(UIViewController*)viewController;
+(void)shareURL:(NSString*)urlShare productid:(int)productid viewController:(UIViewController*)viewController;

#pragma mark - Play video
+(void)PlayVideo:(NSString*)url viewController:(UIViewController*)viewController;

#pragma mark - Show Variation detail
+(void)showVariationPage:(UIViewController*)view product:(Product*)product;

#pragma mark - Set Triange Label
+(void)setTriangleLable:(UIView*)vwDiscount product:(Product*)product;

#pragma mark - productListing
+(Product*)setProductDataListing:(NSDictionary*)dict;

@end
