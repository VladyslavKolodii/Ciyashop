//
//  Product.m
//  CiyaShop
//
//  Created by Kaushal PC on 28/05/18.
//  Copyright © 2018 Potenza. All rights reserved.
//

#import "Product.h"

@implementation Product

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Encode And Decode data for NSUserDefault

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.arrAttributes forKey:@"arrAttributes"];
    [encoder encodeObject:self.date_created_gmt forKey:@"date_created_gmt"];
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.arrGrouped_products forKey:@"arrGrouped_products"];
    [encoder encodeObject:self.arrImages forKey:@"arrImages"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.permalink forKey:@"permalink"];
    [encoder encodeObject:self.price_html forKey:@"price_html"];
    [encoder encodeObject:self.arrRelated_ids forKey:@"arrRelated_ids"];
    [encoder encodeObject:self.rewards_message forKey:@"rewards_message"];
    [encoder encodeObject:self.sale_price forKey:@"sale_price"];
    [encoder encodeObject:self.regular_price forKey:@"regular_price"];
    [encoder encodeObject:self.dict_seller_info forKey:@"dict_seller_info"];
    [encoder encodeObject:self.dict_featured_video forKey:@"dict_featured_video"];
    [encoder encodeObject:self.short_description forKey:@"short_description"];
    [encoder encodeObject:self.type1 forKey:@"type"];
    [encoder encodeObject:self.arrVariations forKey:@"arrVariations"];
    [encoder encodeObject:self.external_url forKey:@"external_url"];
    [encoder encodeObject:self.additional_Info forKey:@"additional_Info"];
    [encoder encodeObject:self.date_on_sale_to forKey:@"date_on_sale_to"];

    [encoder encodeInt:self.product_id forKey:@"product_id"];
    [encoder encodeInt:self.sold_individually forKey:@"sold_individually"];
    [encoder encodeInt:self.reviews_allowed forKey:@"reviews_allowed"];
    [encoder encodeInt:self.in_stock forKey:@"in_stock"];
    
    
    [encoder encodeDouble:self.average_rating forKey:@"average_rating"];
    [encoder encodeDouble:self.price forKey:@"price"];

    [encoder encodeBool:self.manageStock forKey:@"manageStock"];
    [encoder encodeInt:self.stockQuantity forKey:@"stockQuantity"];

    NSLog(@"%@",encoder);
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        
        self.arrAttributes=  [decoder decodeObjectForKey:@"arrAttributes"] ;
        self.date_created_gmt=  [decoder decodeObjectForKey:@"date_created_gmt"] ;
        self.desc= [decoder decodeObjectForKey:@"desc"];
        self.arrGrouped_products= [decoder decodeObjectForKey:@"arrGrouped_products"];
        self.arrImages=  [decoder decodeObjectForKey:@"arrImages"];
        self.name= [decoder decodeObjectForKey:@"name"] ;
        self.permalink=  [decoder decodeObjectForKey:@"permalink"] ;
        self.price_html= [decoder decodeObjectForKey:@"price_html"] ;
        self.arrRelated_ids=  [decoder decodeObjectForKey:@"arrRelated_ids"] ;
        self.rewards_message=   [decoder decodeObjectForKey:@"rewards_message"] ;
        self.sale_price=   [decoder decodeObjectForKey:@"sale_price"];
        self.regular_price=   [decoder decodeObjectForKey:@"regular_price"];
        self.dict_seller_info=  [decoder decodeObjectForKey:@"dict_seller_info"];
        self.dict_featured_video=  [decoder decodeObjectForKey:@"dict_featured_video"];
        self.short_description= [decoder decodeObjectForKey:@"short_description"] ;
        self.type1= [decoder decodeObjectForKey:@"type"] ;
        self.arrVariations= [decoder decodeObjectForKey:@"arrVariations"] ;
        self.external_url=  [decoder decodeObjectForKey:@"external_url"] ;
        self.additional_Info=  [decoder decodeObjectForKey:@"additional_Info"];
        self.date_on_sale_to=   [decoder decodeObjectForKey:@"date_on_sale_to"];

        self.sold_individually=[decoder decodeIntForKey:@"sold_individually"];
        self.reviews_allowed=  [decoder decodeIntForKey:@"reviews_allowed"];
        self.in_stock=   [decoder decodeIntForKey:@"in_stock"];
        self.product_id=    [decoder decodeIntForKey:@"product_id"];

        self.price=[decoder decodeDoubleForKey:@"price"];
        self.average_rating=[decoder decodeDoubleForKey:@"average_rating"];
        
        self.manageStock=[decoder decodeBoolForKey:@"manageStock"];
        self.stockQuantity = [decoder decodeIntForKey:@"stockQuantity"];
    }
    NSLog(@"%@",decoder);

    return self;
}

@end
