//
//  Character.m
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 31/08/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

#import "Character.h"

@implementation Character

-(id)initWithID:(NSNumber *)charID andTitle:(NSString *)title andURL:(NSString *)url andAbstract:(NSString *)abstract andThumbnail:(UIImage *)thumbnail andIsExpanded:(BOOL)isExpanded andIsfavourite:(BOOL)isFavourite {
    
    self = [super init];
    
    if (self) {
        
        self.charID = charID;
        self.title = title;
        self.url = url;
        self.abstract = abstract;
        self.thumbnail = thumbnail;
        self.isExpanded = isExpanded;
        self.isFavourite = isFavourite;
    }
    
    return self;
    
}

@end
