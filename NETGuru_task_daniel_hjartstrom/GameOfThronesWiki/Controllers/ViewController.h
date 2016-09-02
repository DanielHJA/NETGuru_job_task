//
//  ViewController.h
//  GameOfThronesWiki
//
//  Created by Daniel Hjärtström on 31/08/16.
//  Copyright © 2016 Daniel Hjärtström. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailsViewController.h"
#import "Character.h"
#import "TableViewCell.h"
#import "BaseViewController.h"

@interface ViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, addfavoriteDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSIndexPath *indexPath;

@end

