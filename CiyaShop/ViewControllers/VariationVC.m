//
//  VariationVC.m
//  CiyaShop
//
//  Created by Apple on 25/01/19.
//  Copyright © 2019 Potenza. All rights reserved.
//

#import "VariationVC.h"
#import "VariationCell.h"
#import "VariationItemCell.h"

@interface VariationVC () <ClickDelegate>

@property (weak, nonatomic) IBOutlet UIView *vwContent;
@property (weak, nonatomic) IBOutlet UITableView *tblVariationData;
@property (weak, nonatomic) IBOutlet UILabel *lblProductNotAvailable;

@property (weak, nonatomic) IBOutlet UIButton *btnCancel;
@property (weak, nonatomic) IBOutlet UIButton *btnDone;

@property int CellNumber;
@property NSMutableArray *arrData;

@end

@implementation VariationVC {
    int page;
    NSMutableArray *arrVariations, *arrSelectedVariationOption;
    NSString *strImageUrl;
}
@synthesize product;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    page = 1;
    NSMutableArray *arrTemp = [[NSMutableArray alloc] init];
    for (int i = 0; i < product.arrAttributes.count; i++) {
        NSNumber* flag = [[product.arrAttributes objectAtIndex:i] valueForKey:@"variation"];
        if ([flag boolValue]) {
            [arrTemp addObject:[product.arrAttributes objectAtIndex:i]];
        }
    }
    self.product.arrAttributes = arrTemp;
    
    appDelegate.arrVariations = [[NSMutableArray alloc] init];
    appDelegate.arrSelectedVariable = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [product.arrAttributes count]; i++)
    {
        if ([[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] count] > 0)
        {
            [appDelegate.arrSelectedVariable addObject:[[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] objectAtIndex:0]];
        }
    }
    
    if (appDelegate.isRTL) {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceRightToLeft];
    } else {
        [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
    }
    
    self.vwContent.layer.cornerRadius = 0.5;
    self.vwContent.layer.shadowColor = UIColor.blackColor.CGColor;
    self.vwContent.layer.shadowOffset = CGSizeMake(0, 1); //Here your control your spread
    self.vwContent.layer.shadowOpacity = 0.5;
    self.vwContent.layer.shadowRadius = 5.0; //Here your control your blur

    [Util setPrimaryColorButtonTitle:self.btnCancel];
    [Util setSecondaryColorButton:self.btnDone];
    
    [self.btnCancel setTitle:[MCLocalization stringForKey:@"Cancel"] forState:UIControlStateNormal];
    [self.btnDone setTitle:[MCLocalization stringForKey:@"Done"] forState:UIControlStateNormal];

    arrVariations = [[NSMutableArray alloc] init];
    [self getVariations];
    
    self.lblProductNotAvailable.text = [MCLocalization stringForKey:@"This Combination doesn't exist. Choose another variant."];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:true];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.tblVariationData reloadData];
}

#pragma mark - Button Clicks

-(IBAction)btnDoneClick:(id)sender {
    
    BOOL flag1 = [self checkVariationAvailability];
    if (!flag1) {
        return;
    }
    int variationId = 0;
    int stockQuantity = 0;
    double price = 0;
    int inStock = 0;
    int manageStock = false;
    
    NSString *strHtmlPrice = [[NSString alloc] init];
    
    NSMutableDictionary *dictSelectedVariation = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < appDelegate.arrSelectedVariable.count; i++) {
        [dictSelectedVariation setValue:[appDelegate.arrSelectedVariable objectAtIndex:i] forKey:[[product.arrAttributes objectAtIndex:i] valueForKey:@"name"]];
    }
    
    for (int i = 0; i < arrVariations.count; i++) {
        NSArray *arrAtrb = [[NSArray alloc] initWithArray:[[arrVariations objectAtIndex:i] valueForKey:@"attributes"]];
        
        int flag = 0;
        
        for (int j = 0; j < arrAtrb.count; j++) {
            if ([appDelegate.arrSelectedVariable containsObject:[[arrAtrb objectAtIndex:j] valueForKey:@"option"]]) {
                //contains object
                if (arrAtrb.count < product.arrAttributes.count) {
                    flag++;
                    //less attribute in variation
                    if (flag == arrAtrb.count) {
                        flag = (int)product.arrAttributes.count;
                        break;
                    }
                } else {
                    //all variation
                    flag++;
                }
                if (flag == product.arrAttributes.count) {
                    //selected variation
                    break;
                }
            } else {
                //object is not in array
            }
        }
        if (flag == product.arrAttributes.count) {
            variationId = [[[arrVariations objectAtIndex:i] valueForKey:@"id"] intValue];
            inStock = [[[arrVariations objectAtIndex:i] valueForKey:@"in_stock"] intValue];
            
            if (product.manageStock) {
                manageStock = product.manageStock;
                stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
            } else {
                if ([[arrVariations objectAtIndex:i] objectForKey:@"manage_stock"]) {
                    //MANAGE STOCK IS AVAILABLE
                    NSNumber* stockActive = [[arrVariations objectAtIndex:i] valueForKey:@"manage_stock"];
                    if ([stockActive boolValue]) {
                        manageStock = [stockActive boolValue];
                        stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
                    } else {
                        manageStock = false;
                        stockQuantity = 0;
                    }
                } else {
                    //MANAGE STOCK IS NOT AVAILABLE
                    manageStock = product.manageStock;
                    stockQuantity = 0;
                }
            }
            
            strHtmlPrice = [[arrVariations objectAtIndex:i] valueForKey:@"price_html"];
            price = [[[arrVariations objectAtIndex:i] valueForKey:@"price"] doubleValue];
            
            break;
        } else if (arrAtrb.count == 0) {
            variationId = [[[arrVariations objectAtIndex:i] valueForKey:@"id"] intValue];
            inStock = [[[arrVariations objectAtIndex:i] valueForKey:@"in_stock"] intValue];
            
            if (product.manageStock) {
                manageStock = product.manageStock;
                stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
            } else {
                if ([[arrVariations objectAtIndex:i] objectForKey:@"manage_stock"]) {
                    //MANAGE STOCK IS AVAILABLE
                    NSNumber* stockActive = [[arrVariations objectAtIndex:i] valueForKey:@"manage_stock"];
                    if ([stockActive boolValue]) {
                        manageStock = [stockActive boolValue];
                        stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
                    } else {
                        manageStock = false;
                        stockQuantity = 0;
                    }
                } else {
                    //MANAGE STOCK IS NOT AVAILABLE
                    manageStock = product.manageStock;
                    stockQuantity = 0;
                }
            }
            strHtmlPrice = [[arrVariations objectAtIndex:i] valueForKey:@"price_html"];
            price = [[[arrVariations objectAtIndex:i] valueForKey:@"price"] doubleValue];
            
            break;
        }
    }
    if (inStock == 0) {
        //No stock available
        return;
    }
    AddToCartData *object = [[AddToCartData alloc] init];
    object.name = product.name;
    object.rating = product.average_rating;
    object.imgUrl = strImageUrl;
    object.html_Price = strHtmlPrice;
    object.productId = product.product_id;
    object.variation_id = variationId;
    object.quantity = 1;
    object.price = price;
    object.arrVariation = dictSelectedVariation;
    object.isSoldIndividually = (BOOL)product.sold_individually;
    object.manageStock = manageStock;
    object.stockQuantity = stockQuantity;
    
    BOOL flag = [Util saveCustomObject:object key:kMyCart];
    if (flag) {
        // Facebook Pixel for Add To cart
        [Util logAddedToCartEvent:[NSString stringWithFormat:@"%d", product.product_id] contentType:product.name currency:appDelegate.strCurrencySymbol valToSum:price];
        [Util showPositiveMessage:[MCLocalization stringForKey:@"Item Added to Your Cart Successfully"]];
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //Run UI Updates
            [self dismissViewControllerAnimated:true completion:^{
                [appDelegate showBadge];
            }];
        });
    } else if (appDelegate.isAlreadyInCart) {
        appDelegate.isAlreadyInCart = false;
        [self dismissViewControllerAnimated:true completion:^{
            appDelegate.baseTabBarController.selectedIndex = 2;
        }];
    }
}

-(IBAction)btnCancelClick:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        //Run UI Updates
        [self dismissViewControllerAnimated:true completion:nil];
    });
}


#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [product.arrAttributes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //data
    static NSString *simpleTableIdentifier = @"VariationCell";
    VariationCell *cell = (VariationCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"VariationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.delegate = self;
    
    cell.CellNumber = (int)indexPath.row;
    self.CellNumber = (int)indexPath.row;
    
    cell.lblTitle.text = [[[product.arrAttributes objectAtIndex:indexPath.row] valueForKey:@"name"] capitalizedString];
    
    [Util setPrimaryColorLabelText:cell.lblTitle];
    
    cell.arrData = [[NSMutableArray alloc] init];
    cell.arrData = [[[product.arrAttributes objectAtIndex:indexPath.row] valueForKey:@"options"] mutableCopy];
    
    cell.arrNewData = [[NSMutableArray alloc] init];
    if ([[product.arrAttributes objectAtIndex:indexPath.row] valueForKey:@"new_options"]) {
        cell.arrNewData = [[[product.arrAttributes objectAtIndex:indexPath.row] valueForKey:@"new_options"] mutableCopy];
    }
    [cell.colItem reloadData];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblTitle.font = Font_Size_Product_Name;
    
    if (appDelegate.isRTL) {
        //RTL
        cell.lblTitle.textAlignment = NSTextAlignmentRight;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath { }

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 130;
}

#pragma mark - ClickDelegate Delegate

-(void)shouldReloadTable:(NSMutableArray *)arr {
    BOOL Check = [self checkVariationAvailability];
    [self checkInCartData];
    if (!Check) {
        return;
    }
}

#pragma mark - Api call

- (void)getVariations {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:[NSString stringWithFormat:@"%d", page] forKey:@"page"];
    [dict setValue:@"100" forKey:@"per_page"];

    if (page == 1) {
        SHOW_LOADER_ANIMTION_1(self);
    }
    [CiyaShopAPISecurity getVariations:dict productid:product.product_id completionBlock:^(BOOL success, NSString *message, NSDictionary *dictionary) {
        
        [self variationData:dictionary message:message success:success];
    }];
}

- (void)variationData:(NSDictionary*)dictionary message:(NSString*)message success:(BOOL)success {
    if (success == YES) {
        //no error
        if (dictionary.count>0) {
            NSArray *arrData = [[NSArray alloc] initWithArray:(NSArray*)dictionary];
            
            for (int i = 0; i < arrData.count; i++) {
                [arrVariations addObject:[arrData objectAtIndex:i]];
            }
            
            if (arrVariations.count > 0 && page == 1) {
                // Facebook Pixel for Product content view
                [Util logViewedContentEvent:product.name contentId:[NSString stringWithFormat:@"%d", product.product_id] currency:appDelegate.strCurrencySymbol valToSum:[[[arrVariations objectAtIndex:0] valueForKey:@"price"] doubleValue]];
            }
            
            if (arrVariations.count >= 100) {
                page++;
                [self getVariations];
            } else {
                [self.tblVariationData reloadData];
                HIDE_PROGRESS_1(self);
            }
        } else {
            HIDE_PROGRESS_1(self);
        }
        
        [self checkSelectedVariation];
        [self checkVariationAvailability];
        [self checkInCartData];
    } else {
        //error
        if ([dictionary isKindOfClass:[NSDictionary class]] && [dictionary objectForKey:@"message"]) {
            NSData *stringData = [[dictionary valueForKey:@"message"] dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *options = @{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType};
            NSAttributedString *decodedString;
            decodedString = [[NSAttributedString alloc] initWithData:stringData
                                                             options:options
                                                  documentAttributes:NULL
                                                               error:NULL];
            ALERTVIEW(decodedString.string, self);
        } else {
            ALERTVIEW([MCLocalization stringForKey:@"Something Went Wrong"], self);
        }
        HIDE_PROGRESS_1(self);
    }
    
    if (arrVariations.count == 0) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //Run UI Updates
            HIDE_PROGRESS_1(self);
            [self dismissViewControllerAnimated:true completion:nil];
        });
    }
}

-(void)checkSelectedVariation {
    appDelegate.arrVariations = [[NSMutableArray alloc] initWithArray:arrVariations];
    appDelegate.arrSelectedVariable = [[NSMutableArray alloc] init];
    
    if (arrVariations.count > 0 && product.arrAttributes.count > 0) {
        if ([[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] count] > 0) {
            [appDelegate.arrSelectedVariable addObject:[[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] objectAtIndex:0]];
        }
    }
    
    if (arrVariations.count > 0 && product.arrAttributes.count > 0) {
        for (int i = 0; i < arrVariations.count; i++) {
            Boolean flag = false;
            NSArray *arrAtrb = [[NSArray alloc] initWithArray:[[arrVariations objectAtIndex:i] valueForKey:@"attributes"]];
            if (product.arrAttributes.count > 0) {
                if ([[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] count] > 0) {
                    if (arrAtrb.count > 0 && [[[product.arrAttributes objectAtIndex:0] valueForKey:@"options"] objectAtIndex:0] == [[arrAtrb objectAtIndex:0] valueForKey:@"option"]) {
                        for (int j = 1; j < arrAtrb.count; j++) {
                            [appDelegate.arrSelectedVariable addObject:[[arrAtrb objectAtIndex:j] valueForKey:@"option"]];
                            flag = true;
                        }
                    }
                }
            }
            if (flag) {
                break;
            }
        }
    }
    
    if (appDelegate.arrSelectedVariable.count != product.arrAttributes.count) {
        for (int i = 0; i < product.arrAttributes.count; i++) {
            Boolean flag = false;
            for (int j = 0; j < [[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] count]; j++) {
                if ([appDelegate.arrSelectedVariable containsObject:[[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] objectAtIndex:j]]) {
                    //contains
                    flag = true;
                    break;
                }
            }
            if (!flag) {
                //not contains value of attribute
                if ([[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] count] > 0 && appDelegate.arrSelectedVariable.count == i) {
                    int pos = 0;
                    for (int k = 0; k < arrVariations.count; k++) {
                        NSArray *arr = [[[arrVariations objectAtIndex:k] valueForKey:@"attributes"] mutableCopy];
                        int count = 0;
                        if (arr.count > appDelegate.arrSelectedVariable.count) {
                            for (int m = 0; m < arr.count; m++) {
                                if ([appDelegate.arrSelectedVariable containsObject:[[arr objectAtIndex:m] valueForKey:@"option"]]) {
                                    count++;
                                }
                                if (count == appDelegate.arrSelectedVariable.count) {
                                    pos = k;
                                    break;
                                }
                            }
                        }
                    }
                    
                    if (arrVariations.count > 0 && product.arrAttributes.count > 0) {
                        NSArray *arr = [[[arrVariations objectAtIndex:pos] valueForKey:@"attributes"] mutableCopy];
                        NSArray *arrAttr = [[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] mutableCopy];
                        
                        int posNew = 0;
                        for (int k = 0; k < arr.count; k++) {
                            if ([arrAttr containsObject:[[arr objectAtIndex:k] valueForKey:@"option"]]) {
                                posNew = (int)[arrAttr indexOfObject:[[arr objectAtIndex:k] valueForKey:@"option"]];
                                break;
                            }
                        }
                        [appDelegate.arrSelectedVariable insertObject:[[[product.arrAttributes objectAtIndex:i] valueForKey:@"options"] objectAtIndex:posNew] atIndex:i];
                    }
                }
            }
        }
    }
    
    if (appDelegate.arrSelectedVariable.count != product.arrAttributes.count) {
        for (int j = 0; j < product.arrAttributes.count; j++) {
            BOOL flag = false;
            NSArray *arr = [[NSArray alloc] initWithArray:[[product.arrAttributes objectAtIndex:j] valueForKey:@"options"]];
            for (int i = 0; i < arr.count; i++) {
                if ([appDelegate.arrSelectedVariable containsObject:[arr objectAtIndex:i]]) {
                    flag = true;
                    break;
                }
            }
            if (!flag && arr.count != 0) {
                [appDelegate.arrSelectedVariable insertObject:[arr objectAtIndex:0] atIndex:j];
            }
        }
    }
    arrSelectedVariationOption = [[NSMutableArray alloc] initWithArray:appDelegate.arrSelectedVariable];
}

-(BOOL)checkVariationAvailability {
    int available = 0;
    int selectedVariation = -1;
    
    BOOL inStock = false;
    for (int i = 0; i < appDelegate.arrVariations.count; i++) {
        available = 0;
        NSMutableArray *arrAttribute = [[NSMutableArray alloc] init];
        
        for (int k = 0; k < [[[appDelegate.arrVariations objectAtIndex:i] valueForKey:@"attributes"] count]; k++) {
            [arrAttribute addObject:[[[[appDelegate.arrVariations objectAtIndex:i] valueForKey:@"attributes"] objectAtIndex:k] valueForKey:@"option"]];
        }
        for (int j = 0; j < appDelegate.arrSelectedVariable.count; j++) {
            if ([arrAttribute containsObject:[appDelegate.arrSelectedVariable objectAtIndex:j]]) {
                available++;
            }
            if (available == appDelegate.arrSelectedVariable.count) {
                break;
            }
        }
        
        if ([arrAttribute count] < appDelegate.arrSelectedVariable.count) {
            if (available == arrAttribute.count || available > arrAttribute.count) {
                selectedVariation = i;
                
                if (product.manageStock) {
                    if([[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue] > 0) {
                        inStock = true;
                    }
                } else {
                    if ([[arrVariations objectAtIndex:i] objectForKey:@"manage_stock"]) {
                        //MANAGE STOCK IS AVAILABLE
                        NSNumber* stockActive = [[arrVariations objectAtIndex:i] valueForKey:@"manage_stock"];
                        if ([stockActive boolValue]) {
                            if([[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue] > 0) {
                                inStock = true;
                            }
                        } else {
                            inStock = true;
                        }
                    } else {
                        //MANAGE STOCK IS NOT AVAILABLE
                        inStock = [[[arrVariations objectAtIndex:i] valueForKey:@"in_stock"] boolValue];
                    }
                }
                available = (int)appDelegate.arrSelectedVariable.count;
                break;
            }
        }
        if (available == appDelegate.arrSelectedVariable.count) {
            inStock = [[[arrVariations objectAtIndex:i] valueForKey:@"in_stock"] boolValue];
            selectedVariation = i;
            break;
        }
    }
    
    if (available < appDelegate.arrSelectedVariable.count) {
        //not available
        NSLog(@"Product is not available");
        self.btnDone.userInteractionEnabled = NO;
        self.btnDone.alpha = 0.6;
        self.lblProductNotAvailable.hidden = NO;
        return NO;
    } else if(available == appDelegate.arrSelectedVariable.count) {
        //available
        if (selectedVariation == -1) {
            if ([product.arrImages count] > 0) {
                strImageUrl = [[product.arrImages objectAtIndex:0] valueForKey:@"src"];
            } else {
                strImageUrl = @"";
            }
        } else {
            if ([[[[arrVariations objectAtIndex:selectedVariation] valueForKey:@"image"] valueForKey:@"src"] containsString:kPlaceholderText]) {
                if ([product.arrImages count] > 0) {
                    strImageUrl = [[product.arrImages objectAtIndex:0] valueForKey:@"src"];
                } else {
                    strImageUrl = @"";
                }
            } else {
                strImageUrl = [[[arrVariations objectAtIndex:selectedVariation] valueForKey:@"image"] valueForKey:@"src"];
            }
        }
        NSLog(@"Product is available");
        self.btnDone.userInteractionEnabled = YES;
        self.btnDone.alpha = 1.0;
        self.lblProductNotAvailable.hidden = YES;
        arrSelectedVariationOption = [[NSMutableArray alloc] initWithArray:appDelegate.arrSelectedVariable];
        return YES;
    }
    return  NO;
}

#pragma mark - Check the item is in cart

-(void)checkInCartData {
    BOOL flag1 = [self checkVariationAvailability];
    if (!flag1) {
//        [Util showPositiveMessage:@"Select variation"];
        return;
    }
    int variationId = 0;
    int stockQuantity = 0;
    double price = 0;
    int inStock = 0;
    int manageStock = false;
    NSString *strHtmlPrice = [[NSString alloc] init];
    NSMutableDictionary *dictSelectedVariation = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < appDelegate.arrSelectedVariable.count; i++) {
        [dictSelectedVariation setValue:[appDelegate.arrSelectedVariable objectAtIndex:i] forKey:[[product.arrAttributes objectAtIndex:i] valueForKey:@"name"]];
    }
    for (int i = 0; i < arrVariations.count; i++) {
        NSArray *arrAtrb = [[NSArray alloc] initWithArray:[[arrVariations objectAtIndex:i] valueForKey:@"attributes"]];
        int flag = 0;
        for (int j = 0; j < arrAtrb.count; j++) {
            if ([appDelegate.arrSelectedVariable containsObject:[[arrAtrb objectAtIndex:j] valueForKey:@"option"]])
            {
                //contains object
                if (arrAtrb.count < product.arrAttributes.count) {
                    flag++;
                    //less attribute in variation
                    if (flag == arrAtrb.count) {
                        flag = (int)product.arrAttributes.count;
                        break;
                    }
                } else {
                    //all variation
                    flag++;
                }
                if (flag == product.arrAttributes.count) {
                    //selected variation
                    break;
                }
            } else {
                //object is not in array
            }
        }
        if (flag == product.arrAttributes.count) {
            variationId = [[[arrVariations objectAtIndex:i] valueForKey:@"id"] intValue];
            inStock = [[[arrVariations objectAtIndex:i] valueForKey:@"in_stock"] intValue];
            if (product.manageStock) {
                manageStock = product.manageStock;
                stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
            } else {
                if ([[arrVariations objectAtIndex:i] objectForKey:@"manage_stock"]) {
                    //MANAGE STOCK IS AVAILABLE
                    NSNumber* stockActive = [[arrVariations objectAtIndex:i] valueForKey:@"manage_stock"];
                    if ([stockActive boolValue]) {
                        manageStock = [stockActive boolValue];
                        stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
                    } else {
                        manageStock = false;
                        stockQuantity = 0;
                    }
                } else {
                    //MANAGE STOCK IS NOT AVAILABLE
                    manageStock = product.manageStock;
                    stockQuantity = 0;
                }
            }
            strHtmlPrice = [[arrVariations objectAtIndex:i] valueForKey:@"price_html"];
            price = [[[arrVariations objectAtIndex:i] valueForKey:@"price"] doubleValue];
            break;
        } else if (arrAtrb.count == 0) {
            variationId = [[[arrVariations objectAtIndex:i] valueForKey:@"id"] intValue];
            inStock = [[[arrVariations objectAtIndex:i] valueForKey:@"in_stock"] intValue];
            
            if (product.manageStock) {
                manageStock = product.manageStock;
                stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
            } else {
                if ([[arrVariations objectAtIndex:i] objectForKey:@"manage_stock"]) {
                    //MANAGE STOCK IS AVAILABLE
                    NSNumber* stockActive = [[arrVariations objectAtIndex:i] valueForKey:@"manage_stock"];
                    if ([stockActive boolValue]) {
                        manageStock = [stockActive boolValue];
                        stockQuantity = [[[arrVariations objectAtIndex:i] valueForKey:@"stock_quantity"] intValue];
                    } else {
                        manageStock = false;
                        stockQuantity = 0;
                    }
                } else {
                    //MANAGE STOCK IS NOT AVAILABLE
                    manageStock = product.manageStock;
                    stockQuantity = 0;
                }
            }
            strHtmlPrice = [[arrVariations objectAtIndex:i] valueForKey:@"price_html"];
            price = [[[arrVariations objectAtIndex:i] valueForKey:@"price"] doubleValue];
            break;
        }
    }
    if (inStock == 0) {
        //No stock available
        return;
    }
    AddToCartData *object = [[AddToCartData alloc] init];
    object.name = product.name;
    object.rating = product.average_rating;
    object.imgUrl = strImageUrl;
    object.html_Price = strHtmlPrice;
    object.productId = product.product_id;
    object.variation_id = variationId;
    object.quantity = 1;
    object.price = price;
    object.arrVariation = dictSelectedVariation;
    object.isSoldIndividually = (BOOL)product.sold_individually;
    object.manageStock = manageStock;
    object.stockQuantity = stockQuantity;
    
    BOOL flag = [self checkInCart:object key:kMyCart];
    if (flag) {
        [self.btnDone setTitle:[MCLocalization stringForKey:@"Go to Cart"] forState:UIControlStateNormal];
    } else {
        [self.btnDone setTitle:[MCLocalization stringForKey:@"Done"] forState:UIControlStateNormal];
    }
}

- (BOOL)checkInCart:(AddToCartData *)object key:(NSString *)key {
    NSMutableArray *arrMyCart = [[NSMutableArray alloc]initWithArray:[[Util getArrayData:kMyCart] mutableCopy]];
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    AddToCartData *obj1 = [Util loadCustomObjectWithKey:encodedObject];
    
    if (obj1.manageStock) {
        if (obj1.stockQuantity == 0) {
            return NO;
        }
    }
    for (int i = 0; i < arrMyCart.count; i++) {
        AddToCartData *obj;
        if([[arrMyCart objectAtIndex:i] isKindOfClass:[NSData class]]) {
            obj = [Util loadCustomObjectWithKey:[arrMyCart objectAtIndex:i]];
        } else {
            obj = [arrMyCart objectAtIndex:i];
        }
        
        if (obj.productId == obj1.productId && obj.variation_id == obj1.variation_id) {
            if (obj1.arrVariation != nil) {
                if ([obj.arrVariation isEqualToDictionary:obj1.arrVariation]) {
                    return true;
                }
            }
        }
    }
    return NO;
}

@end
