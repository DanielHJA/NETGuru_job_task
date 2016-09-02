//
//  BaseViewController.m
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 01/09/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.app = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.context = [self.app managedObjectContext];
    
}

-(void)addToCore:(NSNumber *)charID {
    
    NSError *error;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Favourites"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"favouriteID == %@", charID]];
    
    NSUInteger count = [self.context countForFetchRequest:fetchRequest error:&error];
    
    if (count < 1) {
        
        Favourites *favouritesModel = [NSEntityDescription insertNewObjectForEntityForName:@"Favourites" inManagedObjectContext:self.context];
        [favouritesModel setFavouriteID:charID];
        [self.context save:&error];
        
    } else {
        
        NSLog(@"%@", error.localizedDescription);
        
    }
}

-(NSMutableArray *)fetchCoreData {
    
    NSError *error;
    
    NSMutableArray *characterIDArray = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Favourites"];
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[self.context executeFetchRequest:fetchRequest error:&error]];
    
    if (error == nil && results.count > 0) {
        
        for (Favourites *object in results) {
            
            [characterIDArray addObject:object.favouriteID];
        }
        
        return characterIDArray;
        
    } else {
        
        NSLog(@"%@", error.localizedDescription);
        
    }
    
    return nil;
}

-(void)deleteFromCore:(NSNumber *)charID {
    
    NSError *error;
    
    NSFetchRequest *fetchrequest = [[NSFetchRequest alloc] initWithEntityName:@"Favourites"];
    [fetchrequest setPredicate:[NSPredicate predicateWithFormat:@"favouriteID == %@", charID]];
    
    NSMutableArray *results = [[NSMutableArray alloc] initWithArray:[self.context executeFetchRequest:fetchrequest error:&error]];
    
    if (!error && results.count > 0) {
        
        for (Favourites *object in results) {
            
            [self.context deleteObject:object];
            
        }
        
    } else {
        
        NSLog(@"%@",error.localizedDescription);
        
    }
    
    [self.context save:&error];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
