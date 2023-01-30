//
//  ShopDataGridCell.h
//  QuickClick
//
//  Created by Kaushal PC on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBShimmeringView.h>

@interface ShopDataGridCell : UICollectionViewCell

@property (strong,nonatomic) IBOutlet UIButton *btnAddToCart;
@property (strong,nonatomic) IBOutlet UIButton *btnStore;
@property (strong,nonatomic) IBOutlet UIButton *btnWishList;
@property (strong,nonatomic) IBOutlet UIImageView *imgProduct;
@property (strong,nonatomic) IBOutlet UILabel *lblTitle;
//@property (strong,nonatomic) IBOutlet UILabel *lblSizeColor;
@property (strong,nonatomic) IBOutlet UILabel *lblRate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *act;

@property (strong,nonatomic) IBOutlet UIView *vwRating;

@property (weak, nonatomic) IBOutlet UIView *vwDiscount;

@property (weak, nonatomic) IBOutlet UILabel *lblTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightTimer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightAddToCart;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightRating;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightImage;

@property (weak, nonatomic) IBOutlet FBShimmeringView *vwLoader;
@property Product *product;

@property int mins, hours, seconds;
@property NSTimer *timer;

-(void)startTimer:(NSString*)dateString;

@end
