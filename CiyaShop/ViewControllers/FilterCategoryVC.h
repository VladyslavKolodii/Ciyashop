//
//  FilterCategoryVC.h
//  QuickClick
//
//  Created by Kaushal PC on 22/08/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryDelgate <NSObject>

-(void)setCategory:(NSString*)id;

@end

@interface FilterCategoryVC : UIViewController

@property (strong, nonatomic) id<CategoryDelgate> delegate;

@end
