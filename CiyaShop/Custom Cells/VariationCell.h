//
//  VariationCell.h
//  QuickClick
//
//  Created by Kaushal PC on 13/07/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClickDelegate <NSObject>
@optional
- (void)shouldReloadTable:(NSMutableArray*)arr;
@end

@interface VariationCell : UITableViewCell<UICollectionViewDataSource, UICollectionViewDelegate>

@property int CellNumber;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblProductNotAvailable;
@property (strong, nonatomic) IBOutlet UICollectionView *colItem;
@property (strong, nonatomic) NSMutableArray *arrData;
@property (strong, nonatomic) NSMutableArray *arrNewData;

@property(nonatomic, assign) id <ClickDelegate> delegate;

@end
