//
//  Product.h
//  CiyaShop
//
//  Created by Kaushal PC on 28/05/18.
//  Copyright © 2018 Potenza. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlogData : NSObject

@property (strong,nonatomic) NSString *desc;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *image_url_large;
@property (strong,nonatomic) NSString *image_url_medium;
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *link;
@property (strong,nonatomic) NSArray *arrCategory;

@property (nonatomic) int blog_id;

- (id)init;

@end
