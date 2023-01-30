//
//  VariationItemCell.h
//  QuickClick
//
//  Created by Kaushal PC on 13/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VariationItemCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgBG;
@property (strong, nonatomic) IBOutlet UIImageView *imgBG2;
@property (strong, nonatomic) IBOutlet UIImageView *imgRight;

@property (weak, nonatomic) IBOutlet UIView *vwVariationText;
@property (weak, nonatomic) IBOutlet UILabel *lblVariationBG;
@property (weak, nonatomic) IBOutlet UILabel *lblVariationText;

@property (weak, nonatomic) IBOutlet UIView *vwVariationColor;
@property (weak, nonatomic) IBOutlet UIImageView *imgVariationColor;

@property (weak, nonatomic) IBOutlet UIView *vwVariationImage;
@property (weak, nonatomic) IBOutlet UIImageView *imgVariationImage;

@end
