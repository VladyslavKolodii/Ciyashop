//
//  VariationCell.h
//  QuickClick
//
//  Created by Kaushal PC on 13/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SimpleItemCell : UITableViewCell

@property int CellNumber;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UICollectionView *colItem;
@property (strong, nonatomic) NSMutableArray *arrData;

@end
