//
//  APICallHelper.m
//  CiyaShop
//
//  Created by Kaushal Parmar on 11/06/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import "APICallHelper.h"

@implementation APICallHelper

#pragma mark - Create instance of file

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

#pragma mark - Verify Pincode

- (void)checkDeliveryToPincode:(NSString*)pincode completionBlock:(DictionaryResponse)completionBlock {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:pincode forKey:@"pincode"];

    [CiyaShopAPISecurity checkDeliveryToPincode:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        NSLog(@"%@", dictionary);
        if (success)
        {
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"]) {
                //available
                NSString *str = [NSString stringWithFormat:@"%@ %@", [MCLocalization stringForKey:@"Product is available to deliver at"], pincode];
                ALERTVIEW(str, appDelegate.window.rootViewController);
            } else {
                //not available
                NSString *str = [NSString stringWithFormat:@"%@ %@", [MCLocalization stringForKey:@"Product is not available to deliver at"], pincode];
                ALERTVIEW(str, appDelegate.window.rootViewController);
            }
        }
        else
        {
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

@end
