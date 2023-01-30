//
//  APICallHelper.h
//  CiyaShop
//
//  Created by Kaushal Parmar on 11/06/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CompletionBlock) (BOOL responseObject);
typedef void (^DictionaryResponse) (BOOL success, NSString *message, NSDictionary *dictionary);

@interface APICallHelper : NSObject

#pragma mark - Create instance of file

+ (instancetype)sharedInstance;

#pragma mark - Verify Pincode

- (void)checkDeliveryToPincode:(NSString*)pincode completionBlock:(DictionaryResponse)completionBlock;

@end

NS_ASSUME_NONNULL_END
