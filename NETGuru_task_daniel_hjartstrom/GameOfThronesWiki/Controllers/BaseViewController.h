//
//  BaseViewController.h
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 01/09/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "Favourites.h"
#import "Favourites+CoreDataProperties.h"

@interface BaseViewController : UIViewController

@property (nonatomic, assign) AppDelegate *app;
@property (strong, nonatomic) NSManagedObjectContext *context; //??? correct with strong?

-(void)addToCore:(NSNumber *)charID;
-(NSMutableArray *)fetchCoreData;
-(void)deleteFromCore:(NSNumber *)charID;

@end
