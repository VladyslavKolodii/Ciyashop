//
//  FilterVC.h
//  QuickClick
//
//  Created by Kaushal PC on 23/05/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NMRangeSlider.h"

@protocol FilterDelegate <NSObject>

-(void)applyFilter:(NSMutableArray*)arr minPrice:(double)minPrice maxPrice:(double)maxPrice rating:(NSMutableArray*)rating;

@end

@interface FilterVC : UIViewController

@property int categoryId;

@property (strong, nonatomic) id<FilterDelegate> delegate;

@property BOOL fromAppliedFilter;
@property (strong, nonatomic) NSMutableArray *arrSelectedAttributefromFilter, *arrSelectedValuesfromFilter, *arrSelectedRatingValues;

@property double sliderMinValuefromFilter, sliderMaxValuefromFilter;

@end
