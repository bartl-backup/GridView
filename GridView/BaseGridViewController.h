//
//  BaseGridViewController.h
//  photomovie
//
//  Created by Evgeny Rusanov on 28.06.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GridView.h"

@interface BaseGridViewController : UIViewController
                                        <UITableViewDataSource,
                                        UITableViewDelegate, 
                                        UISearchDisplayDelegate,
                                        GridViewDelegate,
                                        GridViewDataSource
                                        >

@property (nonatomic, readonly) GridView *gridView;

@property (nonatomic) int itemsCount;

-(GridViewCell*)gridCellMaker:(int)index fromList:(NSArray*)list;
-(UITableViewCell*)searchCellFor:(NSIndexPath*)indexPath from:(NSArray*)items inTable:(UITableView*)tableView;

-(NSArray*)itemsList;
-(NSArray*)searchItems:(NSString*)searchString;

-(void)itemSelected:(int)index fromList:(NSArray*)items;

-(void)reloadData;

@end
