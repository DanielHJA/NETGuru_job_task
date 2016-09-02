//
//  Character.h
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 31/08/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface Character : NSObject

@property (nonatomic) NSNumber *charID;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString *abstract;
@property (nonatomic) UIImage *thumbnail;
@property (nonatomic) BOOL isExpanded;
@property (nonatomic) BOOL isFavourite;

-(id)initWithID:(NSNumber *)charID andTitle:(NSString *)title andURL:(NSString *)url andAbstract:(NSString *)abstract andThumbnail:(UIImage *)thumbnail andIsExpanded:(BOOL)isExpanded andIsfavourite:(BOOL)isFavourite;

@end
