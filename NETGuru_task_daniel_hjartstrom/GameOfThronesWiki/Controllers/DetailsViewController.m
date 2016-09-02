//
//  DetailsViewController.m
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 31/08/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

#import "DetailsViewController.h"

@interface DetailsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UIImageView *favouriteImage;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.selectedCharacter.title;
    self.textView.text = self.selectedCharacter.abstract;
    self.imageView.image = self.selectedCharacter.thumbnail;
    
    if (self.selectedCharacter.isFavourite) {
        
        self.favouriteImage.image = [UIImage imageNamed:@"star_yellow"];
    }
}

- (IBAction)redirectToWikiArticle:(UIBarButtonItem *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://sv.gameofthrones.wikia.com/%@", self.selectedCharacter.url]]];}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
