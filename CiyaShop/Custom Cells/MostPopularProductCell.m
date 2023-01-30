//
//  MostPopularProductCell.m
//  QuickClick
//
//  Created by APPLE on 24/04/17.
//  Copyright © 2017 Potenza. All rights reserved.
//

#import "MostPopularProductCell.h"

#import "ItemDetailVC.h"
#import "GroupItemDetailVC.h"
#import "VariableItemDetailVC.h"

@implementation MostPopularProductCell
{
    NSMutableArray *arrGroupedProduct;
    NSArray *arrselect;
    NSArray *arrUnselect;
    NSMutableArray *arrWishList;
    int selectedIndex;
    NSString *selectedProductId;
}
@synthesize arrMostPopularProducts,delegate;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.colProducts.showsHorizontalScrollIndicator=NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.colProducts setCollectionViewLayout:flowLayout];

    [self.colProducts registerNib:[UINib nibWithNibName:@"ShopDataGridCell" bundle:nil] forCellWithReuseIdentifier:@"ShopDataGridCell"];
    arrWishList = [[NSMutableArray alloc] init];
    
    [arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
    selectedIndex = -1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isCustomSection) {
        return self.arrMostPopularProducts.count;
    }
    if (arrMostPopularProducts.count > 4)
    {
        return 4;
    }
    else
    {
        return arrMostPopularProducts.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *identifier = @"ShopDataGridCell";
    
    ShopDataGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ShopDataGridCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Product *object = [Util setProductData:[self.arrMostPopularProducts objectAtIndex:indexPath.row]];

    
    if (appDelegate.isCatalogMode) {
        cell.btnAddToCart.hidden = true;
    } else {
        if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode)
        {
            cell.btnAddToCart.hidden = false;
            [Util setSecondaryColorButton:cell.btnAddToCart];
            
            [cell.btnAddToCart setTitle:[MCLocalization stringForKey:@"ADD TO CART"] forState:UIControlStateNormal];
            NSLog(@"%@",object.type1);
            
            if ([object.type1 isEqualToString:@"simple"])
            {
                if ([Util checkInCart:object variation:0 attribute:nil])
                {
                    [cell.btnAddToCart setTitle:[MCLocalization stringForKey:@"GO TO CART"] forState:UIControlStateNormal];
                }
                else
                {
                    [cell.btnAddToCart setTitle:[MCLocalization stringForKey:@"ADD TO CART"] forState:UIControlStateNormal];
                }
            }
            if (object.in_stock == 1) {
                [Util setSecondaryColorButton:cell.btnAddToCart];
                cell.btnAddToCart.userInteractionEnabled = true;
                cell.btnAddToCart.alpha = 1.0;
                cell.alpha = 1.0;
            } else {
                [Util setRedButton:cell.btnAddToCart];
                cell.btnAddToCart.userInteractionEnabled = false;
                cell.btnAddToCart.alpha = 0.5;
                [cell.btnAddToCart setTitle:[MCLocalization stringForKey:@"Out of Stock"] forState:UIControlStateNormal];
            }
            
            if (object.price == 0)
            {
                cell.btnAddToCart.hidden = true;
            }
            else
            {
                cell.btnAddToCart.hidden = false;
            }
        }
        else
        {
            cell.btnAddToCart.hidden = true;
        }
    }
    Boolean set11 = [arrWishList containsObject:[NSString stringWithFormat:@"%d",object.product_id]];
    
    //image change for wish list
    if (set11)
    {
        [Util setPrimaryColorButtonImageBG:cell.btnWishList image:[UIImage imageNamed:@"IconInWishList"]];
    }
    else
    {
        [cell.btnWishList setImage:[UIImage imageNamed:@"IconWishList"] forState:UIControlStateNormal];
    }
    
    cell.btnWishList.tag = indexPath.row;
    cell.btnStore.tag = indexPath.row;
    cell.btnAddToCart.tag = indexPath.row;
    
    [cell.btnStore addTarget:self action:@selector(btnStoreClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAddToCart addTarget:self action:@selector(btnAddToCartClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnWishList addTarget:self action:@selector(btnWishListClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.lblTitle.textColor = FontColorGray;
    cell.lblTitle.text = object.name;
    cell.lblTitle.font=Font_Size_Product_Name_Small;
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^()
//    {
//            dispatch_async(dispatch_get_main_queue(), ^()
//            {
                [cell.act startAnimating];
                [Util setPrimaryColorActivityIndicator:cell.act];
            if (![[[self->arrMostPopularProducts objectAtIndex:indexPath.row] valueForKey:@"image"] isEqualToString:@"0"])
            {
                        [cell.imgProduct sd_setImageWithURL:[Util EncodedURL:[[self->arrMostPopularProducts objectAtIndex:indexPath.row] valueForKey:@"image"]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
                         {
                                    cell.imgProduct.image = image;
                                    [cell.act stopAnimating];
                        }];
                
            } else {
                        cell.imgProduct.image = [UIImage imageNamed:@"CategoryNoImage"];
            }
//            });
//    });
    
        dispatch_async(dispatch_get_main_queue(), ^()
        {
                NSString * htmlString = object.price_html;
                cell.lblRate.attributedText = [Util setPriceForItem:htmlString];
                [cell.lblRate setTextAlignment:NSTextAlignmentCenter];
        });

    
    if (arrselect.count > 0)
    {
        NSIndexPath *indexPath1 = [arrselect objectAtIndex:0];
        if (indexPath.row == indexPath1.row)
        {
            cell.btnWishList.userInteractionEnabled = NO;
            
            [UIView animateWithDuration:0.4f animations:^{
                
                cell.btnWishList.transform = CGAffineTransformMakeScale(1.5, 1.5);
            } completion:^(BOOL finished) {
                
                [Util setPrimaryColorButtonImageBG:cell.btnWishList image:[UIImage imageNamed:@"IconInWishList"]];
                
                // for zoom out
                [UIView animateWithDuration:0.4f animations:^{
                    cell.btnWishList.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    cell.btnWishList.userInteractionEnabled = YES;
                }];
            }];
            arrselect = [[NSArray alloc] init];
        }
    }
    if (arrUnselect.count>0)
    {
        NSIndexPath *indexPath1 = [arrUnselect objectAtIndex:0];
        if (indexPath.row == indexPath1.row)
        {
            [cell.btnWishList setImage:[UIImage imageNamed:@"IconWishList"] forState:UIControlStateNormal];
            arrUnselect = [[NSArray alloc] init];
        }
    }
    
    
    BOOL flg = false;
    for (UIView *subview in cell.vwRating.subviews)
    {
        if (subview.tag>=1000)
        {
            flg = YES;
            HCSStarRatingView *starRatingView=(HCSStarRatingView *)subview;
            starRatingView.value = object.average_rating;
            starRatingView.frame = CGRectMake(0, 0, cell.vwRating.frame.size.width, cell.vwRating.frame.size.height);
            break;
        }
    }
    
    if (!flg)
    {
        [cell.vwRating addSubview:[Util setStarRating:object.average_rating frame:CGRectMake(0, 0, cell.vwRating.frame.size.width, 12) tag:1000+indexPath.row]];
    }
    
    cell.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    cell.layer.shadowRadius = 1.0f;
    cell.layer.shadowOpacity = 0.5f;
    cell.layer.masksToBounds = NO;
    cell.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:cell.bounds cornerRadius:cell.contentView.layer.cornerRadius].CGPath;
    

    
    
    

    
    if (appDelegate.isWishList)
    {
        cell.btnWishList.hidden = NO;
    }
    else
    {
        cell.btnWishList.hidden = YES;
    }
    [Util setTriangleLable:cell.vwDiscount product:object];
    
    if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
        cell.heightAddToCart.constant = 30;
    } else {
        cell.heightAddToCart.constant = 0;
    }
    return cell;



}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
        Product *object = [Util setProductData:[self.arrMostPopularProducts objectAtIndex:indexPath.row]];
        if (self->delegate)
        {
            [self->delegate RedirectToMostPopularProduct:object];
        }
    } else {
        [self getSingleProduct:[[arrMostPopularProducts objectAtIndex:indexPath.row] valueForKey:@"id"]];
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
//    return CGSizeMake((collectionView.frame.size.width/2), SCREEN_SIZE.width*276/375);
    
//    if (self.isCustomSection) {
//        if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode) {
//            return CGSizeMake((collectionView.frame.size.width/2), self.arrMostPopularProducts.count * (286*SCREEN_SIZE.width/375));
//        } else {
//            return CGSizeMake((collectionView.frame.size.width/2), self.arrMostPopularProducts.count * (256*SCREEN_SIZE.width/375));
//        }
//    } else {
        if (appDelegate.isCartButtonEnabled && !appDelegate.isCatalogMode)
        {
            return CGSizeMake((collectionView.frame.size.width/2), (SCREEN_SIZE.width*286/375));
        }
        else
        {
            return CGSizeMake((collectionView.frame.size.width/2), (SCREEN_SIZE.width*286/375) - (SCREEN_SIZE.width*30/375));
        }
//    }
}

#pragma mark - API calls 

-(void)getSingleProduct:(NSString*)productId
{
    SHOW_LOADER_ANIMTION();

    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:productId forKey:@"include"];
    
    [CiyaShopAPISecurity productListing:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success)
        {
            HIDE_PROGRESS;
            if (dictionary.count > 0)
            {
                if (dictionary.count > 0)
                {
                    NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                    Product *object = [Util setProductDataListing:[arrData objectAtIndex:0]];
                    if (self->delegate)
                    {
                        [self->delegate RedirectToMostPopularProduct:object];
                    }
                }
            }
        }
        else
        {
            HIDE_PROGRESS;
            if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
                ALERTVIEW(decodedString.string, appDelegate.window.rootViewController);
            }
            else
            {
                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
            }
        }
    }];
}

-(void)btnStoreClicked:(UIButton *)sender
{
    [self btnAddToCartClicked:sender];
}
-(void)btnWishListClicked:(UIButton *)sender
{
    selectedIndex = (int)sender.tag;
    
    Product *object = [Util setProductData:[self.arrMostPopularProducts objectAtIndex:selectedIndex]];
    Boolean set1 = NO;
    for (int i=0; i<arrWishList.count; i++)
    {
        if ([[arrWishList objectAtIndex:i] integerValue] == object.product_id)
        {
            set1 = YES;
            [arrWishList removeObjectAtIndex:i];
            break;
        }
    }
    
    if (set1==NO)
    {
        // Facebook Pixel for Add to Wishlist
        
        [Util logAddedToWishlistEvent:[NSString stringWithFormat:@"%d",object.product_id]  contentType:object.name currency:appDelegate.strCurrencySymbol valToSum:object.price];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        arrselect = [[NSArray alloc] initWithObjects:indexPath, nil];
        
        Product *object = [Util setProductData:[self.arrMostPopularProducts objectAtIndex:sender.tag]];

//        Product *object = [self.arrMostPopularProducts objectAtIndex:indexPath.row];

        if ([Util getBoolData:kLogin])
        {
            selectedProductId = [NSString stringWithFormat:@"%d",object.product_id];
            [self addItemToWishList:selectedProductId];
        }
        else
        {
            NSString *message = [MCLocalization stringForKey:@"Item Added to your Wish List."];
            [Util showPositiveMessage:message];
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
        [arr addObject:[NSString stringWithFormat:@"%d",object.product_id]];
        
        [Util setArray:arr setData:kWishList];
        [arrWishList addObject:[NSString stringWithFormat:@"%d",object.product_id]];
        
        NSLog(@"%@",[Util getArrayData:kWishList]);
        
        

            [self.colProducts reloadData];
    }
    else
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        
        Product *object = [Util setProductData:[self.arrMostPopularProducts objectAtIndex:sender.tag]];

        [arrWishList removeObject:[NSString stringWithFormat:@"%d",object.product_id]];
        
        arrUnselect = [[NSArray alloc] initWithObjects:indexPath, nil];
        
        if ([Util getBoolData:kLogin])
        {
            selectedProductId = [NSString stringWithFormat:@"%d",object.product_id];
            [self removeItemFromWishList:selectedProductId];
        }
        else
        {
            NSString *message = [MCLocalization stringForKey:@"Item Removed From your Wish List."];
            [Util showPositiveMessage:message];
        }
        
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
        
        [arr removeObject:[NSString stringWithFormat:@"%d",object.product_id]];
        
        [Util setArray:arr setData:kWishList];
        NSLog(@"%@",[Util getArrayData:kWishList]);
        
            [self.colProducts reloadData];
    }
}


-(void)btnAddToCartClicked:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:[MCLocalization stringForKey:@"GO TO CART"]])
    {
        if(appDelegate.window.rootViewController.tabBarController.selectedIndex == 2)
        {
            [appDelegate.window.rootViewController.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            appDelegate.baseTabBarController.selectedIndex = 2;
        }
        return;
    }
    
//    Product *object = [self.arrProducts objectAtIndex:sender.tag];
    Product *object = [Util setProductData:[self.arrMostPopularProducts objectAtIndex:sender.tag]];

    if ([object.type1 isEqualToString:@"external"])
    {
        //external product
        NSString *strUrl = object.external_url;
        NSURL *_url = [Util EncodedURL:strUrl];
        [[UIApplication sharedApplication] openURL:_url options:@{} completionHandler:nil];
    }
    else if ([object.type1 isEqualToString:@"grouped"])
    {
        //Group product
        arrGroupedProduct = [[NSMutableArray alloc] init];
        [self GetGroupedProductDetail:object];
    }
    else if ([object.type1 isEqualToString:@"variable"])
    {
        //Variable product
        [Util showVariationPage:appDelegate.window.rootViewController product:object];
    }
    else
    {
        //Simple product
        [self AddToCart:object];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        //Run UI Updates
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        [indexPaths addObject:index];
        [self.colProducts reloadItemsAtIndexPaths: indexPaths];
    });
}

- (void)AddToCart:(Product*)product
{
    // Facebook Pixel for Add To cart
    [Util logAddedToCartEvent:[NSString stringWithFormat:@"%d", product.product_id] contentType:product.name currency:appDelegate.strCurrencySymbol valToSum:product.price];
    
    //Old Logic
    AddToCartData *object = [[AddToCartData alloc] init];
    object.name = product.name;
    object.rating = product.average_rating;
    if ([product.arrImages count] > 0)
    {
        object.imgUrl = [[product.arrImages objectAtIndex:0] valueForKey:@"src"];
    }
    else
    {
        object.imgUrl = @"";
    }
    object.html_Price = product.price_html;
    object.productId = product.product_id;
    object.variation_id = 0;
    object.quantity = 1;
    
    object.price = product.price;
    
    object.arrVariation = nil;
    object.isSoldIndividually = (BOOL)product.sold_individually;
    
    object.manageStock = (BOOL)product.manageStock;
    object.stockQuantity = product.stockQuantity;
    
    BOOL flag = [Util saveCustomObject:object key:kMyCart];
    if (flag)
    {
        [Util showPositiveMessage:[MCLocalization stringForKey:@"Item Added to Your Cart Successfully"]];
    }
    else
    {
        //        NSString *str = [MCLocalization stringForKey:@"Out of Stock"];
        //        ALERTVIEW(str, appDelegate.window.rootViewController);
    }
    [appDelegate showBadge];
}

- (void)addItemToWishList:(NSString*)productID
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    [dict setValue:productID forKey:@"product_id"];
    
    [CiyaShopAPISecurity addItemtoWishList:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success) {
            HIDE_PROGRESS;
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"]) {
                NSString *message = [MCLocalization stringForKey:@"Item Added to your Wish List."];
                
                NSLog(@"Product Added to wishlist successfully!");
                [Util showPositiveMessage:message];
            } else {
                NSLog(@"Something Went Wrong while adding in Wishlist.");
                
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                [arr addObject:productID];
                
                [Util setArray:arr setData:kWishList];
                
                self->arrWishList = [[NSMutableArray alloc] init];
                [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            }
        } else {
            HIDE_PROGRESS;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            [arr addObject:productID];
            
            [Util setArray:arr setData:kWishList];
            
            self->arrWishList = [[NSMutableArray alloc] init];
            [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            
            //[self.tblData reloadData];
            //[self.colData reloadData];
            
            if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                
                NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                NSAttributedString *decodedString;
                decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                 options:options
                                                      documentAttributes:NULL
                                                                   error:NULL];
//                ALERTVIEW(decodedString.string, self);
            }
            else
            {
//                ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
            }
        }
        if([[dictionary valueForKey:@"sync_list"] isKindOfClass:[NSArray class]])
        {
            //Is array
            NSMutableArray *arrData = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"sync_list"]];
            [appDelegate setWishList:arrData];
        }
        else if([dictionary isKindOfClass:[NSDictionary class]])
        {
            //is dictionary
            NSMutableArray *arrData = [[NSMutableArray alloc] init];
            [appDelegate setWishList:arrData];
        }
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                //                                   dispatch_async(dispatch_get_main_queue(), ^{
                [self.colProducts reloadData];
                //[self.actLoading stopAnimating];
                //                                   });
            });
        });
    }];
}

- (void)removeItemFromWishList:(NSString*)productID
{
    SHOW_LOADER_ANIMTION();
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[Util getStringData:kUserID] forKey:@"user_id"];
    [dict setValue:productID forKey:@"product_id"];
    [CiyaShopAPISecurity removeItemFromWishList:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        NSLog(@"%@", dictionary);
        if (success)
        {
            HIDE_PROGRESS;
            if ([[dictionary valueForKey:@"status"] isEqualToString:@"success"])
            {
                NSString *message = [MCLocalization stringForKey:@"Item Removed From your Wish List."];
                
                NSLog(@"Item Removed From wishlist successfully!");
                [Util showPositiveMessage:message];
            }
            else
            {
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                [arr addObject:productID];
                
                [Util setArray:arr setData:kWishList];
                
                self->arrWishList = [[NSMutableArray alloc] init];
                [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
                
                NSLog(@"Something Went Wrong while adding in Wishlist.");
            }
            
            //[self.tblData reloadData];
            //[self.colData reloadData];
            
            if([[dictionary valueForKey:@"sync_list"] isKindOfClass:[NSArray class]])
            {
                //Is array
                NSMutableArray *arrData = [[NSMutableArray alloc] initWithArray:[dictionary valueForKey:@"sync_list"]];
                [appDelegate setWishList:arrData];
            }
            else if([dictionary isKindOfClass:[NSDictionary class]])
            {
                //is dictionary
                NSMutableArray *arrData = [[NSMutableArray alloc] init];
                [appDelegate setWishList:arrData];
            }
            
        }
        else
        {
            HIDE_PROGRESS;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            [arr addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            [arr addObject:productID];
            
            [Util setArray:arr setData:kWishList];
            
            self->arrWishList = [[NSMutableArray alloc] init];
            [self->arrWishList addObjectsFromArray:[[Util getArrayData:kWishList] mutableCopy]];
            
            [self.colProducts reloadData];
        }
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                //                                   dispatch_async(dispatch_get_main_queue(), ^{
                [self.colProducts reloadData];
                //[self.actLoading stopAnimating];
                //                                   });
            });
        });
    }];
}



-(void)GetGroupedProductDetail:(Product*)product
{
    SHOW_LOADER_ANIMTION();
    if (product.arrGrouped_products.count == 0)
    {
        
    }
    else
    {
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        
        //        NSString *str = [[NSString alloc] init];
        NSString *str = [product.arrGrouped_products componentsJoinedByString:@","];
        //        for (int i = 0; i < product.arrGrouped_products.count; i++)
        //        {
        //            if (i == 0)
        //            {
        //                str = [NSString stringWithFormat:@"%@",[product.arrGrouped_products objectAtIndex:i]];
        //            }
        //            else
        //            {
        //                str = [NSString stringWithFormat:@"%@,%@",str,[product.arrGrouped_products objectAtIndex:i]];
        //            }
        //        }
        [dict setValue:str forKey:@"include"];
        
        [CiyaShopAPISecurity productListing:dict completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
            
            NSLog(@"%@",dictionary);
            if (success)
            {
                if (dictionary.count>0)
                {
                    NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
                    
                    for (int i = 0; i < arrData.count; i++)
                    {
                        [self->arrGroupedProduct addObject:[arrData objectAtIndex:i]];
                    }
                    [Util logAddedToCartEvent:[NSString stringWithFormat:@"%d", product.product_id] contentType:product.name currency:appDelegate.strCurrencySymbol valToSum:product.price];
                    
                    BOOL saveData = NO;
                    BOOL alreadyincart = NO;
                    int count = 0;
                    for (int i = 0; i < self->arrGroupedProduct.count; i++)
                    {
                        if ([[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"variable"] || [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"grouped"]  || [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"external"])
                        {
                            
                        }
                        else
                        {
                            AddToCartData *object = [[AddToCartData alloc] init];
                            object.name = [[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"name"];
                            object.rating = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"average_rating"] doubleValue];
                            if ([[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"images"] count] > 0)
                            {
                                object.imgUrl = [[[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"images"] objectAtIndex:0] valueForKey:@"src"];
                            }
                            else
                            {
                                object.imgUrl = @"";
                            }
                            object.html_Price = [[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"price_html"];
                            object.productId = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"id"] intValue];
                            object.variation_id = 0;
                            object.quantity = 1;
                            
                            object.price = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"price"] doubleValue];
                            
                            object.arrVariation = nil;
                            object.isSoldIndividually = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"sold_individually"] boolValue];
                            
                            object.manageStock = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"manage_stock"] boolValue];
                            if (object.manageStock) {
                                object.stockQuantity = [[[self->arrGroupedProduct objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
                            }
                            
                            BOOL flag = [Util saveCustomObject:object key:kMyCart];
                            
                            if (flag)
                            {
                                saveData = YES;
                                count ++;
                                NSLog(@"Product Added");
                            }
                            else
                            {
                                alreadyincart = true;
                                NSLog(@"Already in cart");
                            }
                        }
                    }
                    if (count > 0)
                    {
                        [Util showPositiveMessage:[MCLocalization stringForKey:@"Item Added to Your Cart Successfully"]];
                    }
                }
                else
                {
                    HIDE_PROGRESS;
                    if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"])
                    {
                        NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                        
                        NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                        NSAttributedString *decodedString;
                        decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                         options:options
                                                              documentAttributes:NULL
                                                                           error:NULL];
                        ALERTVIEW(decodedString.string, appDelegate.window.rootViewController);
                    }
                    else
                    {
                        ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
                    }
                }
            }
            else
            {
                HIDE_PROGRESS;
                if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
                    NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
                    
                    NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
                    NSAttributedString *decodedString;
                    decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                                     options:options
                                                          documentAttributes:NULL
                                                                       error:NULL];
                    ALERTVIEW(decodedString.string, appDelegate.window.rootViewController);
                }
                else
                {
                    ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], appDelegate.window.rootViewController);
                }
            }
            HIDE_PROGRESS;
            [appDelegate showBadge];
        }];
    }
}

@end
