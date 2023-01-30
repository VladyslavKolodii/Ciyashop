//
//  AddToCartData.h
//  QuickClick
//
//  Created by Kaushal PC on 27/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddToCartData : NSObject

@property (strong, nonatomic) NSString *name;
@property double rating;
@property (strong, nonatomic) NSString *imgUrl;
@property (strong, nonatomic) NSString *html_Price;
@property int productId;
@property int variation_id;
@property int quantity;
@property double price;
@property BOOL isSoldIndividually;

@property (strong, nonatomic) NSMutableDictionary *arrVariation;


@property (nonatomic)int manageStock;
@property (nonatomic)int stockQuantity;

- (id)init;

@end
