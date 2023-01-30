//
//  ShopNowCell.h
//  QuickClick
//
//  Created by Umesh on 4/22/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetCategoryDelegate <NSObject>

-(void)setCategoryData:(NSIndexPath*)indexPath;

@end

@interface ShopNowCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (weak,nonatomic) IBOutlet UIImageView *imgBG;
@property (weak,nonatomic) IBOutlet UILabel *lblShop;
@property (weak,nonatomic) IBOutlet UIView *vwShopDetail;
@property (weak,nonatomic) IBOutlet UIButton *btnShopNow;

@property (weak,nonatomic) IBOutlet UIActivityIndicatorView *act;

@property (strong, nonatomic) IBOutlet UICollectionView *colShopNowCategory;

@property (weak,nonatomic) id<SetCategoryDelegate> delegate;

@end
