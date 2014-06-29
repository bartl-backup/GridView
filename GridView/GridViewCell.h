//
//  GridViewCell.h
//  photomovie
//
//  Created by Evgeny Rusanov on 26.06.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GridViewCell;
@protocol GridCellDelegate <NSObject>
-(void)catGridCellLongPressed:(GridViewCell*)cell;
-(void)catGridCellPerformDelete:(GridViewCell*)cell;
@end

@class GridView;
@interface GridViewCell : UIView

@property (nonatomic) BOOL editing;

@property (nonatomic,weak) id<GridCellDelegate> delegate;

@property (nonatomic) NSInteger index;
@property (nonatomic,weak) GridView *gridView;

-(void)longPress;

@end
