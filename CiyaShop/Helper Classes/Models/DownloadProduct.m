//
//  DownloadProduct.m
//  CiyaShop
//
//  Created by Kaushal Parmar on 07/05/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import "DownloadProduct.h"

@implementation DownloadProduct

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Encode And Decode data for NSUserDefault

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeInt:self.order_id forKey:@"order_id"];
    [encoder encodeInt:self.downloads_remaining forKey:@"downloads_remaining"];

    [encoder encodeObject:self.download_url forKey:@"download_url"];
    [encoder encodeObject:self.product_name forKey:@"product_name"];
    [encoder encodeObject:self.download_name forKey:@"download_name"];
    [encoder encodeObject:self.access_expires forKey:@"access_expires"];
    
    NSLog(@"%@",encoder);
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.order_id=[decoder decodeIntForKey:@"order_id"];
        self.downloads_remaining=  [decoder decodeIntForKey:@"downloads_remaining"];

        self.download_url=  [decoder decodeObjectForKey:@"download_url"] ;
        self.product_name=  [decoder decodeObjectForKey:@"product_name"] ;
        self.download_name= [decoder decodeObjectForKey:@"download_name"];
        self.access_expires= [decoder decodeObjectForKey:@"access_expires"];
    }
    NSLog(@"%@",decoder);
    
    return self;
}

@end
