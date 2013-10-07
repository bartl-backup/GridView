//
//  GridView.h
//  photomovie
//
//  Created by Evgeny Rusanov on 26.06.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GridViewCell.h"

@class GridView;

@protocol GridViewDataSource <NSObject>
-(int)numberOfCellsInGrid:(GridView*)gridView;
-(GridViewCell*)gridView:(GridView*)gridView cellForIndex:(int)index;
@end

@protocol GridViewDelegate <NSObject>
@optional
-(void)gridView:(GridView*)gridView didSelectCellAtIndex:(int)index;
-(void)gridView:(GridView *)gridView didDoubleTapCellAtIndex:(int)index;
@end

@interface GridView : UIView
@property (nonatomic) float cellMargin;

@property (nonatomic) CGSize cellSize;

@property (nonatomic, weak) id<GridViewDataSource> dataSource;
@property (nonatomic, weak) id<GridViewDelegate>   delegate;

-(void)reloadData;

@end
