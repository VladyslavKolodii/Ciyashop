//
//  ShopDataCell.m
//  QuickClick
//
//  Created by Kaushal PC on 22/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "ShopDataCell.h"

@implementation ShopDataCell
@synthesize delegate;

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

-(IBAction)btnQuantityMinusClick:(id)sender
{
    int quantity = [self.lblQuantity.text intValue];
    if(quantity>1)
    {
        quantity--;
        self.lblQuantity.text = [NSString stringWithFormat:@"%d",quantity];
    }
    [self updateCartQuantity:quantity];
}

-(IBAction)btnQuantityPlusClick:(id)sender
{
    int quantity = [self.lblQuantity.text intValue];
    
    NSMutableArray *arrMyCart;
    if (appDelegate.isFromBuyNow)
    {
        arrMyCart = [[NSMutableArray alloc]initWithArray:[[Util getArrayData:kBuyNow] mutableCopy]];
    }
    else
    {
        arrMyCart = [[NSMutableArray alloc]initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
    }
    
    AddToCartData *obj1;
    if([[arrMyCart objectAtIndex:self.cell] isKindOfClass:[NSData class]])
    {
        obj1 = [Util loadCustomObjectWithKey:[arrMyCart objectAtIndex:self.cell]];
    }
    else
    {
        obj1 = [arrMyCart objectAtIndex:self.cell];
    }

    if (obj1.manageStock)
    {
        if (obj1.stockQuantity == quantity)
        {
            NSString *str = [NSString stringWithFormat:@"%@ %d %@", [MCLocalization stringForKey:@"Only"], obj1.stockQuantity, [MCLocalization stringForKey:@"quantity is available."]];
            ALERTVIEW(str, appDelegate.window.rootViewController);
            return;
        }
    }
    quantity++;
    self.lblQuantity.text = [NSString stringWithFormat:@"%d",quantity];
    [self updateCartQuantity:quantity];
}

-(void)updateCartQuantity:(int)quantity
{
    if (appDelegate.isFromBuyNow)
    {
        NSMutableArray *arrMyCart = [[NSMutableArray alloc]initWithArray:[[Util getArrayData:kBuyNow] mutableCopy]];
        
        AddToCartData *obj1;
        if([[arrMyCart objectAtIndex:self.cell] isKindOfClass:[NSData class]])
        {
            obj1 = [Util loadCustomObjectWithKey:[arrMyCart objectAtIndex:self.cell]];
        }
        else
        {
            obj1 = [arrMyCart objectAtIndex:self.cell];
        }

        obj1.quantity = quantity;
        
        NSData *encodedObject1 = [NSKeyedArchiver archivedDataWithRootObject:obj1];
        
        [arrMyCart removeObjectAtIndex:self.cell];
        [arrMyCart insertObject:encodedObject1 atIndex:self.cell];
        
        [Util setArray:arrMyCart setData:kBuyNow];
        
        if ( delegate )
        {
            [delegate setDataForAllText];
        }
    }
    else
    {
        NSMutableArray *arrMyCart = [[NSMutableArray alloc]initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
        
        AddToCartData *obj1;
        if([[arrMyCart objectAtIndex:self.cell] isKindOfClass:[NSData class]])
        {
            obj1 = [Util loadCustomObjectWithKey:[arrMyCart objectAtIndex:self.cell]];
        }
        else
        {
            obj1 = [arrMyCart objectAtIndex:self.cell];
        }

        obj1.quantity = quantity;
        
        NSData *encodedObject1 = [NSKeyedArchiver archivedDataWithRootObject:obj1];
        
        [arrMyCart removeObjectAtIndex:self.cell];
        [arrMyCart insertObject:encodedObject1 atIndex:self.cell];
        
        [Util setArray:arrMyCart setData:kMyCart];
        
        if ( delegate )
        {
            [delegate setDataForAllText];
        }
    }
}

@end
