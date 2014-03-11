//
//  BaseGridViewController.m
//  photomovie
//
//  Created by Evgeny Rusanov on 28.06.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import "BaseGridViewController.h"

@interface BaseGridViewController ()
-(void)handleSearch:(NSString*)searchString;
@end

@implementation BaseGridViewController
{
    NSMutableArray *searchResult;
    UISearchDisplayController *searchController;
    NSOperationQueue *searchQueue;
    
    GridView *gridView;
}

@synthesize gridView;

@synthesize itemsCount = _gridItemsCount;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        _gridItemsCount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 
                                                                           0,
                                                                           self.view.bounds.size.width,
                                                                           44)];
    searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:searchBar];
    
    searchController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar
                                                                                    contentsController:self];
    searchController.delegate = self;
    searchController.searchResultsDataSource = self;
    searchController.searchResultsDelegate = self;
    
    searchQueue = [[NSOperationQueue alloc] init];
    searchQueue.maxConcurrentOperationCount = 1;
    
    gridView = [[GridView alloc] initWithFrame:CGRectMake(0,
                                                          searchBar.frame.size.height,
                                                          self.view.bounds.size.width,
                                                          self.view.bounds.size.height - searchBar.frame.size.height)];
    gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    gridView.delegate = self;
    gridView.dataSource = self;
    [self.view addSubview:gridView];
    
    self.view.backgroundColor = [UIColor clearColor];                
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

-(void)reloadData
{
    [gridView reloadData];
    
    if (searchController.searchBar.text.length)
        [self handleSearch:searchController.searchBar.text];
}

#pragma mark - Overload

-(GridViewCell*)gridCellMaker:(NSInteger)index fromList:(NSArray*)list
{
    return nil;
}

-(NSArray*)itemsList
{
    return [NSArray array];
}

-(NSArray*)searchItems:(NSString*)searchString
{
    return [NSArray array];
}

-(UITableViewCell*)searchCellFor:(NSIndexPath*)indexPath from:(NSArray*)items inTable:(UITableView*)tableView
{
    return nil;
}

-(void)itemSelected:(NSInteger)index fromList:(NSArray*)items
{
    
}

#pragma mark - TableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchResult.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self searchCellFor:indexPath from:searchResult inTable:tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self itemSelected:indexPath.row fromList:searchResult];
}

#pragma mark - SearchDelegate

-(void)handleSearch:(NSString*)searchString
{
    __weak BaseGridViewController *pself = self;
    __weak NSMutableArray* psearchResult = searchResult;
    
    [searchQueue addOperationWithBlock:^{
        NSArray *result = [pself searchItems:searchString];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [psearchResult removeAllObjects];
            [psearchResult addObjectsFromArray:result];
            [searchController.searchResultsTableView reloadData];
        }];
    }];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self handleSearch:searchString];
    return NO;
}

-(void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    searchResult = [NSMutableArray array];
}

#pragma mark - GridView

-(NSInteger)numberOfCellsInGrid:(GridView *)gridView
{
    return self.itemsCount;
}

-(GridViewCell*)gridView:(GridView *)gridView cellForIndex:(NSInteger)index
{
    return [self gridCellMaker:index fromList:[self itemsList]];
}

-(void)gridView:(GridView *)gridView didSelectCellAtIndex:(NSInteger)index
{
    [self itemSelected:index fromList:[self itemsList]];
}

#pragma mark - Properties

-(void)setGridItemsCount:(int)gridItemsCount
{
    _gridItemsCount = gridItemsCount;
    [self.gridView reloadData];
}

@end
