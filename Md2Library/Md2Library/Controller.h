// static: Controllers
//
//  Controller.h
//  TariffCalculator
//
//	The Controller encapsulates the business logic for a given view and fills the application with data.
//	Also, it is used as an fassade to access business logic and the data model.
//
//  Created by Uni Muenster on 01.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "DataMapper.h"
#import "View.h"
#import "EventHandlerProtocols.h"
@class EventHandler;

@interface Controller : UIViewController
{
    View *contentView;
    DataMapper *dataMapper;
}

@property (retain, nonatomic) DataMapper *dataMapper;

-(void) loadData;

-(void) writeComboBoxSelection: (id) selection identifier: (NSString *) identifier;
-(void) writeTextFieldText: (id) text identifier: (NSString *) identifier;
-(void) writeCheckboxValue: (BOOL) isEnabled identifier: (NSString *) identifier;
-(void) persistData;

-(UIView *) getViewByIdentifier: (NSString *) identifier;

-(BOOL) checkWidgetValidityByIdentifier: (NSString *) identifier;
-(BOOL) checkWidgetDataByIdentifier: (NSString *) identifier data: (NSString *) data;
-(NSString *) getWidgetDataByIdentifier: (NSString *) identifier;

@end