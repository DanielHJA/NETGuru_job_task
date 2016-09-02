//
//  TableViewCell.h
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 01/09/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"

@protocol addfavoriteDelegate <NSObject>

@optional
-(void)addAndRemoveFromFavourites:(NSNumber *)indexPath andIsFavourite:(NSNumber *)isFavourite;

@end

@interface TableViewCell : UITableViewCell

@property id<addfavoriteDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *abstract;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UIImageView *favouriteImage;

@property (nonatomic) BOOL isFavourite;

- (IBAction)addToFavorites:(UIButton *)sender;

@end
