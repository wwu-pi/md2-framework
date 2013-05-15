// static: Layouts
//
//  Layout.h
//  TariffCalculator
//
//	The Layout represents a general grid layout that consists of cells.
//
//  Created by Uni Muenster on 17.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "Layout.h"
#import "EventTrigger.h"

/*
*	This class represents one cell and contains all needed information.
*/
@interface LayoutCell : NSObject

@property (retain, nonatomic) NSString *identifier;
@property (nonatomic, retain) UIView *view;
@property (nonatomic) NSUInteger rowIndex;
@property (nonatomic) NSUInteger columnIndex;
@property (nonatomic) NSUInteger options;
@property (nonatomic) NSUInteger rowSpan;
@property (nonatomic) BOOL isSubLayout;

@end

@implementation LayoutCell

@synthesize identifier;
@synthesize view;
@synthesize rowIndex;
@synthesize columnIndex;
@synthesize options;
@synthesize rowSpan;
@synthesize isSubLayout;

@end

@implementation Layout

/*
*	Implementation of the getters and setters for the instance attributes.
*/
@synthesize identifier, numberColumns, numberRows, rowSpacing, columnSpacing;

#pragma mark Initialization Methods

/*
*	Initializes the layout with a given framen, number of rows and a identifier.
*/
-(id) initWithFrame: (CGRect) frame numberRows: (int) rows numberColumns: (int) columns identifier: (NSString *) layoutIdentifier
{
    self = [self initWithFrame: frame identifier: layoutIdentifier];
    if (self)
    {
        numberRows = rows;
        numberColumns = columns;
    }
    return self;
}

/*
*	Initializes the layout with a given identifier.
*/
-(id) initWithFrame: (CGRect) frame identifier: (NSString *) layoutIdentifier
{
    self = [super initWithFrame: frame];
    if (self)
    {
        identifier = layoutIdentifier;
        cells = [[NSMutableArray alloc] init];
        [self initializeTriggers];
        
        numberRows = -1;
        numberColumns = -1;
        
        rowSpacing = RowSpacing;
        columnSpacing = ColumnSpacing;
        
        currentRow = 0;
        currentColumn = -1;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark View Adding Methods

/*
*	Adds the view with the given idenfier.
*/
-(void) addView: (UIView *) view identifier: (NSString *) _identifier
{
    [self addView: view identifier: _identifier rowSpan: 1 isSubLayout: NO];
}

/*
*	Adds the view with the given idenfier and row span.
*/
-(void) addView: (UIView *) view identifier: (NSString *) _identifier rowSpan: (NSUInteger) rowSpan
{
    [self addView: view identifier: _identifier rowSpan: rowSpan isSubLayout: NO];
}

/*
*	Adds the view with the given idenfier, row span and if it is a sub layout.
*/
-(void) addView: (UIView *) view identifier: (NSString *) _identifier rowSpan: (NSUInteger) rowSpan isSubLayout: (BOOL) isSubLayout
{
    BOOL isNewRow = ((currentColumn + 1) >= numberColumns);
    currentRow = (isNewRow)? currentRow + 1: currentRow;
    currentColumn = (isNewRow)? 0: currentColumn + 1;
    if (currentRow < numberRows)
        [self addView: view identifier: _identifier row: currentRow column: currentColumn rowSpan: rowSpan isSubLayout: isSubLayout];
}

/*
*	Adds the view with the given idenfier, row span, row index, column index and if it is a sub layout.
*/
-(void) addView: (UIView *) view identifier: (NSString *) _identifier row: (NSUInteger) rowIndex column: (NSUInteger) columnIndex rowSpan: (NSUInteger) rowSpan isSubLayout: (BOOL) isSubLayout
{
    LayoutCell *cell = [[LayoutCell alloc] init];
    cell.identifier = _identifier;
    cell.view = view;
    cell.rowIndex = rowIndex;
    cell.columnIndex = columnIndex;
    cell.rowSpan = rowSpan;
    cell.isSubLayout = isSubLayout;
    [cells addObject: cell];
    [self setNeedsLayout];
}

/*
*	Adds the view with the given idenfier, row span, row index and column index.
*/
-(void) addView: (UIView *) view identifier: (NSString *) _identifier row: (NSUInteger) rowIndex column: (NSUInteger) columnIndex rowSpan: (NSUInteger) rowSpan
{
    [self addView: view identifier: _identifier row: rowIndex column: columnIndex rowSpan: rowSpan isSubLayout: rowSpan];
}

/*
*	Adds the layout with the given idenfier.
*/
-(void) addLayout: (UIView *) layout identifier: (NSString *) _identifier
{
    [self addView: layout identifier: _identifier rowSpan: 1 isSubLayout: YES];
}

/*
*	Adds the layout with the given idenfier and row span.
*/
-(void) addLayout: (UIView *) layout identifier: (NSString *) _identifier rowSpan: (NSUInteger) rowSpan
{
    [self addView: layout identifier: _identifier rowSpan: rowSpan isSubLayout: YES];
}

/*
*	Adds the layout with the given idenfier, row span, row index and column index.
*/
-(void) addLayout: (UIView *) layout identifier: (NSString *) _identifier row: (NSUInteger) rowIndex column: (NSUInteger) columnIndex rowSpan: (NSUInteger) rowSpan
{
    [self addView: layout identifier: _identifier row: rowIndex column: columnIndex rowSpan: rowSpan isSubLayout: YES];
}

#pragma mark View Replacement Methods

/*
*	Replaces the view of the idenfier with the given view and identifier.
*/
-(void) replaceView: (NSString *) oldIdentifier newView: (UIView *) newView newIdentifier: (NSString *) newIdentifier
{
    NSUInteger oldIndex = 0;
    for (oldIndex = 0; oldIndex < cells.count; oldIndex++)
    {
        LayoutCell *layoutCell = ((LayoutCell *)[cells objectAtIndex: oldIndex]);
        if ([layoutCell.identifier isEqualToString: oldIdentifier])
        {
            layoutCell.identifier = newIdentifier;
            layoutCell.view = newView;
            break;
        }
    }
    
    [self layoutSubviews];
}

#pragma mark Layouting Methods

/*
*	Layouts all sub views appropriately.
*/
-(void) layoutSubviews
{
    NSUInteger columnWidth = (self.frame.size.width - ((numberColumns - 1) * columnSpacing)) / numberColumns;
    NSUInteger currentHeight = 0;
    NSUInteger currentRowHeight = 0;
    CGRect formerFrame = CGRectZero;
    UIView *view = nil;
    
    for (LayoutCell *cell in cells)
    {
        view = cell.view;
        [view layoutSubviews];
        
        if ([cells indexOfObject: cell] == 0)
            formerFrame = CGRectZero;
        
        CGRect newFrame = view.frame;
        
        newFrame.origin.x = cell.columnIndex * (columnWidth + columnSpacing);
        newFrame.origin.y = currentRowHeight;
        newFrame.size.height = (newFrame.size.height * cell.rowSpan);
        newFrame.size.width = columnWidth;
        
        currentHeight = (currentHeight < currentRowHeight + newFrame.size.height + rowSpacing)? currentRowHeight + newFrame.size.height + rowSpacing: currentHeight;
        currentRowHeight = (cell.columnIndex == numberColumns - 1)? currentHeight: currentRowHeight;
        
        if (hasCellBorders)
        {
            view.layer.borderColor = [UIColor blackColor].CGColor;
            view.layer.borderWidth = 1.0f;
        }
        
        view.frame = newFrame;
        formerFrame = newFrame;
        [self addSubview: view];
    }
    [self setFrame: CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, currentHeight)];
}

@end