//
//  TableViewCell.m
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 01/09/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)addToFavorites:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(addAndRemoveFromFavourites:andIsFavourite:)]) {
        
        [self.delegate performSelector:@selector(addAndRemoveFromFavourites:andIsFavourite:) withObject:[NSNumber numberWithInteger:sender.tag] withObject:[NSNumber numberWithBool:self.isFavourite]];
    }
}

@end
