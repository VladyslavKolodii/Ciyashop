//
//  HomeShopDataVC.h
//  QuickClick
//
//  Created by Kaushal PC on 22/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeShopDataVC : UIViewController

@property BOOL fromCategory;
@property BOOL fromViewAll;
@property BOOL fromDealofTheDay;
@property BOOL fromSearch;
@property BOOL fromTopRatedProducts;
@property BOOL fromFeaturedProducts;
@property BOOL SaleProducts;

@property NSString *strSearchString;
@property NSString *strSellerId;
@property NSString *strProductIds;

@property int CategoryID;

@end
