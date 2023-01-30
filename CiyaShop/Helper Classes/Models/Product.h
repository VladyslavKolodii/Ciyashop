//
//  Product.h
//  CiyaShop
//
//  Created by Kaushal PC on 28/05/18.
//  Copyright © 2018 Potenza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject



@property (strong,nonatomic)    NSString *date_created_gmt;
@property (strong,nonatomic)    NSString *desc;
@property (strong,nonatomic)    NSString *name;
@property (strong,nonatomic)    NSString *permalink;
@property (strong,nonatomic)    NSString *price_html;
@property (strong,nonatomic)    NSString *rewards_message;
@property (strong,nonatomic)    NSString *sale_price;
@property (strong,nonatomic)    NSString *regular_price;
@property (strong,nonatomic)    NSString *short_description;
@property (strong,nonatomic)    NSString *type1;
@property (strong,nonatomic)    NSString *external_url;
@property (strong,nonatomic)    NSString *additional_Info;
@property (strong,nonatomic)    NSString *date_on_sale_to;
@property (nonatomic)    int on_sale;



@property (strong,nonatomic)    NSMutableArray *arrVariations;
@property (strong,nonatomic)    NSMutableArray *arrRelated_ids;
@property (strong,nonatomic)    NSMutableArray *arrImages;
@property (strong,nonatomic)    NSMutableArray *arrGrouped_products;
@property (strong,nonatomic)    NSMutableArray *arrAttributes;

@property (strong,nonatomic)    NSMutableDictionary *dict_seller_info;
@property (strong,nonatomic)    NSMutableDictionary *dict_featured_video;

@property (nonatomic)int sold_individually;
@property (nonatomic)int reviews_allowed;
@property (nonatomic)int product_id;
@property (nonatomic)int in_stock;

@property (nonatomic)double average_rating;
@property (nonatomic)double price;

@property (nonatomic)int manageStock;
@property (nonatomic)int stockQuantity;

- (id)init;

@end
