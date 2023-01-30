//
//  ShopDataCell.h
//  QuickClick
//
//  Created by Kaushal PC on 22/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetDataDelegate <NSObject>

- (void)setDataForAllText;

@end

@interface ShopDataCell : UITableViewCell

//@property (strong,nonatomic) IBOutlet UIButton *btnCell;
@property (strong,nonatomic) IBOutlet UIButton *btnStore;
@property (strong,nonatomic) IBOutlet UIButton *btnWishList;
@property (strong,nonatomic) IBOutlet UIButton *btnPlus;
@property (strong,nonatomic) IBOutlet UIButton *btnMinus;
@property (strong,nonatomic) IBOutlet UIButton *btnDelete;

@property (strong,nonatomic) IBOutlet UIImageView *img;
@property (strong,nonatomic) IBOutlet UILabel *lblTitle;
@property (strong,nonatomic) IBOutlet UILabel *lblVariation;

@property (strong,nonatomic) IBOutlet UILabel *lblRate;

@property (strong, nonatomic) IBOutlet UILabel *lblQuantity;
@property (strong, nonatomic) IBOutlet UIView *vwQuatity;
@property (strong, nonatomic) IBOutlet UIButton *btnEdit;
@property (strong, nonatomic) IBOutlet UIView *vwContent;
@property (strong, nonatomic) IBOutlet UIView *vwImage;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *act;

@property (weak, nonatomic) IBOutlet UIView *vwDiscount;

@property int cell;

@property (nonatomic, weak) id <SetDataDelegate> delegate;

@end
