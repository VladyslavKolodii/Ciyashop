//
//  AddToCartData.m
//  QuickClick
//
//  Created by Kaushal PC on 27/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "AddToCartData.h"

@implementation AddToCartData

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Encode And Decode data for NSUserDefault

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeDouble:self.rating forKey:@"rating"];
    [encoder encodeObject:self.imgUrl forKey:@"imgUrl"];
    [encoder encodeObject:self.html_Price forKey:@"htmlPrice"];
    [encoder encodeInt:self.productId forKey:@"productId"];
    [encoder encodeInt:self.variation_id forKey:@"variationId"];
    [encoder encodeInt:self.quantity forKey:@"quantity"];
    [encoder encodeDouble:self.price forKey:@"price"];
    [encoder encodeObject:self.arrVariation forKey:@"arrVariation"];
    [encoder encodeBool:self.isSoldIndividually forKey:@"isSoldIndividually"];

    [encoder encodeBool:self.manageStock forKey:@"manageStock"];
    [encoder encodeInt:self.stockQuantity forKey:@"stockQuantity"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.rating = [decoder decodeDoubleForKey:@"rating"];
        self.imgUrl = [decoder decodeObjectForKey:@"imgUrl"];
        self.html_Price = [decoder decodeObjectForKey:@"htmlPrice"];
        self.productId = [decoder decodeIntForKey:@"productId"];
        self.variation_id = [decoder decodeIntForKey:@"variationId"];
        self.quantity = [decoder decodeIntForKey:@"quantity"];
        self.price = [decoder decodeDoubleForKey:@"price"];
        self.arrVariation = [decoder decodeObjectForKey:@"arrVariation"];
        self.isSoldIndividually = [decoder decodeBoolForKey:@"isSoldIndividually"];
        
        self.manageStock = [decoder decodeBoolForKey:@"manageStock"];
        self.stockQuantity = [decoder decodeIntForKey:@"stockQuantity"];
    }
    return self;
}


@end
