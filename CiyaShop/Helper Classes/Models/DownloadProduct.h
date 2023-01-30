//
//  DownloadProduct.h
//  CiyaShop
//
//  Created by Kaushal Parmar on 07/05/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DownloadProduct : NSObject

@property (nonatomic)int order_id;
@property (nonatomic)int downloads_remaining;

@property (strong,nonatomic) NSString *download_url;
@property (strong,nonatomic) NSString *product_name;
@property (strong,nonatomic) NSString *download_name;
@property (strong,nonatomic) NSString *access_expires;

- (id)init;

@end

NS_ASSUME_NONNULL_END
