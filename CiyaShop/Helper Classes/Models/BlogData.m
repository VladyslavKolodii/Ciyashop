//
//  Product.m
//  CiyaShop
//
//  Created by Kaushal PC on 28/05/18.
//  Copyright © 2018 Potenza. All rights reserved.
//

#import "BlogData.h"

@implementation BlogData

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}

#pragma mark - Encode And Decode data for NSUserDefault

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.desc forKey:@"desc"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.image_url_large forKey:@"image_url_large"];
    [encoder encodeObject:self.image_url_medium forKey:@"image_url_medium"];
    [encoder encodeObject:self.date forKey:@"date"];
    [encoder encodeObject:self.link forKey:@"link"];
    
    [encoder encodeObject:self.arrCategory forKey:@"arrCategory"];

    [encoder encodeInt:self.blog_id forKey:@"blog_id"];
    
    NSLog(@"%@",encoder);
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if((self = [super init])) {
        //decode properties, other class vars
        
        self.desc= [decoder decodeObjectForKey:@"desc"];
        self.title=  [decoder decodeObjectForKey:@"title"] ;
        self.image_url_large =  [decoder decodeObjectForKey:@"image_url_large"] ;
        self.image_url_medium =  [decoder decodeObjectForKey:@"image_url_medium"] ;
        self.date= [decoder decodeObjectForKey:@"date"];
        self.link=  [decoder decodeObjectForKey:@"link"];
        
        self.arrCategory=  [decoder decodeObjectForKey:@"arrCategory"];

        self.blog_id=    [decoder decodeIntForKey:@"blog_id"];
    }
    NSLog(@"%@",decoder);

    return self;
}

@end
