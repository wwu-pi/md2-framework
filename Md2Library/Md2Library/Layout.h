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

@interface Layout : UIView
{
    NSString *identifier;
    
    @private
    NSMutableArray *cells;
    int currentRow;
    int currentColumn;
    
    @protected
    int numberColumns;
    int numberRows;
    int rowSpacing;
    int columnSpacing;
    BOOL hasCellBorders;
}

@property (retain, nonatomic) NSString *identifier;

@property (assign, nonatomic) int numberColumns;
@property (assign, nonatomic) int numberRows;
@property (assign, nonatomic) int rowSpacing;
@property (assign, nonatomic) int columnSpacing;

-(id) initWithFrame: (CGRect) frame numberRows: (int) rows numberColumns: (int) columns identifier: (NSString *) layoutIdentifier;
-(id) initWithFrame: (CGRect) frame identifier: (NSString *) layoutIdentifier;

-(void) addView: (UIView *) view identifier: (NSString *) identifier;
-(void) addView: (UIView *) view identifier: (NSString *) identifier rowSpan: (NSUInteger) rowSpan;
-(void) addView: (UIView *) view identifier: (NSString *) identifier row: (NSUInteger) rowIndex column: (NSUInteger) columnIndex rowSpan: (NSUInteger) rowSpan;
-(void) addView: (UIView *) view identifier: (NSString *) identifier rowSpan: (NSUInteger) rowSpan isSubLayout: (BOOL) isSubLayout;
-(void) addView: (UIView *) view identifier: (NSString *) identifier row: (NSUInteger) rowIndex column: (NSUInteger) columnIndex rowSpan: (NSUInteger) rowSpan isSubLayout: (BOOL) isSubLayout;
-(void) addLayout: (UIView *) layout identifier: (NSString *) identifier;
-(void) addLayout: (UIView *) layout identifier: (NSString *) identifier rowSpan: (NSUInteger) rowSpan;
-(void) addLayout: (UIView *) layout identifier: (NSString *) identifier row: (NSUInteger) rowIndex column: (NSUInteger) columnIndex rowSpan: (NSUInteger) rowSpan;

-(void) replaceView: (NSString *) oldIdentifier newView: (UIView *) newView newIdentifier: (NSString *) newIdentifier;

@end