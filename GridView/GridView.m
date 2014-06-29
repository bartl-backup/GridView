//
//  GridView.m
//  photomovie
//
//  Created by Evgeny Rusanov on 26.06.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import "GridView.h"

#define DEFAULT_CELL_MARGIN_IPHONE              4
#define DEFAULT_CELL_MARGIN_IPAD                8

#define DEFAULT_CELL_SIZE                       96

@implementation GridView
{
    UIScrollView *_scrollView;
    
    NSInteger _numberOfCells;
    
    NSMutableArray *cellsViews;
}

@synthesize cellMargin = _cellMargin;
@synthesize cellSize = _cellSize;
@synthesize dataSource = _dataSource, delegate = _delegate;

-(void)setup
{
    self.contentMode = UIViewContentModeRedraw;
    
    self.cellSize = CGSizeMake(DEFAULT_CELL_SIZE, DEFAULT_CELL_SIZE);
    
    CGRect frame = self.frame;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        self.cellMargin = DEFAULT_CELL_MARGIN_IPHONE;
    else
        self.cellMargin = DEFAULT_CELL_MARGIN_IPAD;
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self addSubview:_scrollView];
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = NO;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setup];
    }
    
    return self;
}

-(void)reloadData
{
    _numberOfCells = [_dataSource numberOfCellsInGrid:self];
    
    if (cellsViews)
    {
        for (UIView *v in cellsViews)
            [v removeFromSuperview];
    }
    
    cellsViews = [NSMutableArray array];
    
    for (NSInteger i = 0; i<_numberOfCells; i++)
    {
        GridViewCell *view = [_dataSource gridView:self cellForIndex:i];
        view.index = i;
        view.gridView = self;
        
        [_scrollView addSubview:view];
        
        [cellsViews addObject:view];
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    if (!cellsViews) [self reloadData];
    
    CGSize cellBounds = self.cellSize;
    CGSize gridBounds = self.bounds.size;    
    
    NSInteger cellsPerRow    = (gridBounds.width-self.cellMargin) / (cellBounds.width + self.cellMargin);
    NSInteger numberOfRows = (NSInteger)ceil((CGFloat)_numberOfCells / (CGFloat)cellsPerRow);
    
    CGFloat actualMarginX = (gridBounds.width - cellsPerRow*cellBounds.width) / (cellsPerRow+1);
    CGFloat actualMarginY = self.cellMargin;
    
    _scrollView.frame = CGRectMake(0, 0, gridBounds.width, gridBounds.height);
    CGSize contentSize = CGSizeMake(gridBounds.width, numberOfRows * (cellBounds.height+actualMarginY)+actualMarginY);
    _scrollView.contentSize = contentSize;
    
    for (NSInteger i=0; i<_numberOfCells; i++)
    {
        CGRect cellFrame;
        cellFrame.size = cellBounds;
        
        NSInteger row    = i / cellsPerRow;
        NSInteger column = i % cellsPerRow;
        
        cellFrame.origin = CGPointMake(actualMarginX + (actualMarginX + cellBounds.width) * column , 
                                       actualMarginY + (actualMarginY + cellBounds.height) * row);        
        
        [[cellsViews objectAtIndex:i] setFrame:CGRectIntegral(cellFrame)];
    }
}

- (void)cellWasSelected:(GridViewCell *)cell
{
    if ([_delegate respondsToSelector:@selector(gridView:didSelectCellAtIndex:)]) {
        [_delegate gridView:self didSelectCellAtIndex:cell.index];
    }
}


- (void)cellWasDoubleTapped:(GridViewCell *)cell
{
    if ([_delegate respondsToSelector:@selector(gridView:didDoubleTapCellAtIndex:)]) {
        [_delegate gridView:self didDoubleTapCellAtIndex:cell.index];
    }
}


@end
