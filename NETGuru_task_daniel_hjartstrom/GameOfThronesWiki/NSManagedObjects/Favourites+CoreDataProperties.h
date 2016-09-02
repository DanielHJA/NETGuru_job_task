//
//  Favourites+CoreDataProperties.h
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 01/09/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Favourites.h"

NS_ASSUME_NONNULL_BEGIN

@interface Favourites (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *favouriteID;

@end

NS_ASSUME_NONNULL_END
