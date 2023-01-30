//
//  MostPopularProductCell.h
//  QuickClick
//
//  Created by APPLE on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopDataGridCell.h"

@protocol RedirectToMostPopularProductDelegate <NSObject>

-(void)RedirectToMostPopularProduct:(Product*)dict;

@end

@interface MostPopularProductCell : UITableViewCell <UICollectionViewDelegate,UICollectionViewDataSource>

@property(strong,nonatomic) IBOutlet UIView *vwTop;

@property(strong,nonatomic) IBOutlet UICollectionView *colProducts;
@property(strong,nonatomic) IBOutlet UIButton *btnViewAll;

@property(strong,nonatomic) IBOutlet UILabel *lblTitle;

@property ( strong, nonatomic) NSMutableArray *arrMostPopularProducts;
@property ( strong, nonatomic) NSMutableArray *arrProducts;

@property (strong, nonatomic) id<RedirectToMostPopularProductDelegate> delegate;

@property BOOL isCustomSection;

@end
