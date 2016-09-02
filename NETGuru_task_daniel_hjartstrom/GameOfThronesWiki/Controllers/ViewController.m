//
//  ViewController.m
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 31/08/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *characterArray;
@property (strong, nonatomic) NSMutableArray *favouritesArray;
@property (strong, nonatomic) NSMutableArray *filteredArray;
@property (strong, nonatomic) NSMutableSet *expandedCells;
@property (nonatomic) BOOL isFiltering;

@end

@implementation ViewController

static NSString *const API_URL = @"https://gameofthrones.wikia.com/api/v1/Articles/Top?expand=1&category=characters&limit=75";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFiltering = NO;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        
        self.favouritesArray = [[NSMutableArray alloc] initWithArray:[self fetchCoreData]];
        
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_group_async(group, queue, ^{
        
        self.expandedCells = [[NSMutableSet alloc ]init];
        self.characterArray = [[NSMutableArray alloc] init];
        
        [self applyGestureRecognizers];
        
        NSURL *fetchURL = [NSURL URLWithString:[NSString stringWithFormat:API_URL]];
        
        NSURLSession *session = [NSURLSession sharedSession];
        
        NSURLSessionTask *task = [session dataTaskWithURL:fetchURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary *results = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            for (NSObject *character in results[@"items"]) {
                
                NSString *url = [character valueForKey:@"url"];
                NSNumber *charID = [character valueForKey:@"id"];
                NSString *title = [character valueForKey:@"title"];
                NSString *abstract = [character valueForKey:@"abstract"];
                NSString *thumbnail = [character valueForKey:@"thumbnail"];
                BOOL isFavourite = NO;
                
                if ([self.favouritesArray containsObject:charID]) {
                    isFavourite = YES;
                }
                
                UIImage *thumbnailImage = [UIImage imageWithData:[NSData dataWithContentsOfURL: [NSURL URLWithString:thumbnail]]];
                
                Character *character = [[Character alloc] initWithID:charID andTitle:title andURL:url andAbstract:abstract andThumbnail:thumbnailImage andIsExpanded:NO andIsfavourite:isFavourite];
                
                [self.characterArray addObject:character];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
                    
                });
            }
        }];
        
        [task resume];
        dispatch_group_leave(group);
    });
}

-(void)applyGestureRecognizers {
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(didPressLong:)];
    longPress.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tapPress = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap:)];
    tapPress.numberOfTapsRequired = 1;
    tapPress.numberOfTouchesRequired = 1;
    [self.tableView addGestureRecognizer: tapPress];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.isFiltering) {
        
        return self.filteredArray.count;
        
    } else {
        
        return self.characterArray.count;
        
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = (TableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    Character *character;
    
    if (self.isFiltering) {
        
        character = self.filteredArray[indexPath.row];
        
    } else {
        
        character = self.characterArray[indexPath.row];
        
    }
    
    cell.delegate = self;
    cell.title.text = character.title;
    cell.addButton.tag = indexPath.row;
    cell.abstract.text = character.abstract;
    cell.thumbnail.image = character.thumbnail;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *imageString;
    
    if (character.isExpanded) {
        imageString = @"arrow_down";
    } else {
        imageString = @"arrow_right";
    }
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageString]];
    
    if (character.isFavourite) {
        
        [cell.addButton setTitle:@"Remove from favourites" forState:UIControlStateNormal];
        cell.favouriteImage.image = [UIImage imageNamed:@"star_yellow"];
        cell.isFavourite = YES;
        
    } else {
        
        [cell.addButton setTitle:@"Add to favourites" forState:UIControlStateNormal];
        cell.favouriteImage.image = [UIImage imageNamed:@"star_clear"];
        cell.isFavourite = NO;
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Use of UIAutomaticdimension makes it difficult to hide the button. Works, but looks ugly.
    
    if([self.expandedCells containsObject:indexPath]){
        
        return 160;
        
    } else {
        
        return 75;
        
    }
}

-(NSIndexPath *)returnIndexPathFromSender:(id)sender{
    
    CGPoint point = [sender locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    self.indexPath = indexPath;
    
    return indexPath;
}

-(void)didSingleTap:(UITapGestureRecognizer *)sender {
    
    NSIndexPath *indexPath = [self returnIndexPathFromSender:sender];
    
    if (indexPath != nil) {
        
        Character *character;
        
        if (self.isFiltering) {
            
            character = self.filteredArray[indexPath.row];
            
        } else {
            
            character = self.characterArray[indexPath.row];
            
        }
        
        if (!character.isExpanded) {
            [self performSegueWithIdentifier:@"DetailSegue" sender:nil];
        }
    }
}

-(void)didPressLong:(UILongPressGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        
        NSIndexPath *indexPath = [self returnIndexPathFromSender:sender];
        TableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        
        Character *character;
        
        if (self.isFiltering) {
            
            character = self.filteredArray[indexPath.row];
            
        } else {
            
            character = self.characterArray[indexPath.row];
            
        }
        
        if([self.expandedCells containsObject:indexPath]){
            
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_right"]];
            [self.expandedCells removeObject:indexPath];
            cell.abstract.numberOfLines = 2;
            character.isExpanded = NO;
            
        } else {
            
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
            [self.expandedCells addObject:indexPath];
            cell.abstract.numberOfLines = 0;
            character.isExpanded = YES;
        }
        
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier  isEqual: @"DetailSegue"]) {
        
        DetailsViewController *vc = [segue destinationViewController];
        
        Character *character;
        
        if (self.isFiltering) {
            
            character = self.filteredArray[self.indexPath.row];
            
        } else {
            
            character = self.characterArray[self.indexPath.row];
            
        }
        
        vc.selectedCharacter = character;
        
    }
}

-(void)addAndRemoveFromFavourites:(NSNumber *)index andIsFavourite:(NSNumber *)isFavourite {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow: [index integerValue] inSection:0];
    
    Character *character;
    
    if (self.isFiltering) {
        
        character = self.filteredArray[indexPath.row];
        
    } else {
        
        character = self.characterArray[indexPath.row];
        
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        
        // If user presses Remove from favourites
        if ([isFavourite isEqual:[NSNumber numberWithBool:YES]]) {
            
            character.isFavourite = NO;
            character.isExpanded = NO;
            [self.expandedCells removeObject:indexPath];
            [self deleteFromCore:character.charID];
            
            if (self.isFiltering) {
                [self.filteredArray removeObjectAtIndex:indexPath.row];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                });
            }
            
        } else {
            
            // If user presses Add to favourites
            character.isFavourite = YES;
            character.isExpanded = NO;
            [self.expandedCells removeObject:indexPath];
            [self addToCore:character.charID];
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!self.isFiltering) {
                
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        });
    });
}

- (IBAction)filterFavourites:(UIBarButtonItem *)sender {
    
    if (self.isFiltering) {
        
        self.isFiltering = NO;
        sender.title = @"Favourites";
        
    } else {
        
        self.isFiltering = YES;
        sender.title = @"Show all";
    }
    
    self.filteredArray = [[NSMutableArray alloc] init];
    
    for (Character *object in self.characterArray) {
        
        if (object.isFavourite) {
            
            [self.filteredArray addObject:object];
            
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
