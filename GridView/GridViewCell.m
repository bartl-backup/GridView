//
//  GridViewCell.m
//  photomovie
//
//  Created by Evgeny Rusanov on 26.06.12.
//  Copyright (c) 2012 Macsoftex. All rights reserved.
//

#import "GridViewCell.h"
#import "GridView.h"

#import "UICloseButton.h"

#define SELECTEDVIEW_TAG        1000

@implementation GridViewCell
{
    BOOL longpressed;
    UIButton *editButton;
}

@synthesize index;
@synthesize gridView;

-(void)setup
{
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressSelector)];
    [self addGestureRecognizer:gestureRecognizer];
    _editing = NO;
}

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
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

// ----------------------------------------------------------------------------------

-(void)addSelectedView
{
    self.editing = NO;
    
    return;
    
    UIView *selectView = [self viewWithTag:SELECTEDVIEW_TAG];
    if (!selectView)
    {
        selectView = [[UIView alloc] initWithFrame:self.bounds];
        selectView.backgroundColor = [UIColor darkGrayColor];
        selectView.alpha = 0.8;
        selectView.tag = SELECTEDVIEW_TAG;
        [self addSubview:selectView];
    }
}

-(void)removeSelectedView
{
    UIView *selectView = [self viewWithTag:SELECTEDVIEW_TAG];   
    if (!selectView) return;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         selectView.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [selectView removeFromSuperview];
                     }];
}

#pragma - Touch event handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *aTouch = [touches anyObject];
    if (aTouch.tapCount == 2) {
        [NSObject cancelPreviousPerformRequestsWithTarget:gridView];
    }
    [self addSelectedView];
    
    longpressed = NO;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    [self removeSelectedView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    if (gridView) {
        UITouch *touch = [touches anyObject];
        
        switch ([touch tapCount]) 
        {
            case 0:
            case 1:
                [gridView performSelector:@selector(cellWasSelected:) withObject:self afterDelay:.1];
                break;
                
            case 2:
                [gridView performSelector:@selector(cellWasDoubleTapped:) withObject:self];
                break;
                
            default:
                break;
        }
    }
    
    [self removeSelectedView];
}

-(void)setEditing:(BOOL)editing
{
    _editing = editing;
    
    if (_editing)
    {
        if (editButton) return;
        
        editButton = [[UICloseButton alloc] initWithFrame:CGRectZero];
        [editButton addTarget:self
                       action:@selector(editClick)
             forControlEvents:UIControlEventTouchUpInside];
        
        CGRect frame = self.frame;
        frame = CGRectOffset(frame, -15, -10);
        frame.size = CGSizeMake(30, 30);
        editButton.frame = frame;
        
        editButton.showsTouchWhenHighlighted = YES;
        
        [self addSubview:editButton];
    }
    else
    {
        [editButton removeFromSuperview];
        editButton = nil;
    }
}

-(void)longPress
{
    if (self.delegate)
    {
        [self.delegate catGridCellLongPressed:self];
    }
}

-(void)longPressSelector
{
    if (!longpressed)
    {
        longpressed = YES;
        [self longPress];
    }
}

@end
