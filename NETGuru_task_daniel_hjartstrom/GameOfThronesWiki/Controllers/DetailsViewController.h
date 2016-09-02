//
//  DetailsViewController.h
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 31/08/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"
#import "BaseViewController.h"

@interface DetailsViewController : BaseViewController

@property (nonatomic, strong) Character *selectedCharacter;

@end
