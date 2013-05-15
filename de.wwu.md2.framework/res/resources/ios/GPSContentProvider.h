// static: ContentProviders
//
//  GPSContentProvider.h
//  TariffCalculator
//
//  Created by Uni Münster on 30.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "ContentProvider.h"

@interface GPSContentProvider : ContentProvider <CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geoCoder;
    
    NSNumber *latitude;
    NSNumber *longitude;
    NSNumber *altitude;
    
    NSString *street;
    NSString *number;
    NSString *postalCode;
    NSString *city;
    NSString *state;
    NSString *country;
    NSString *province;
}

@property (strong, nonatomic) NSNumber *latitude;
@property (strong, nonatomic) NSNumber *longitude;
@property (strong, nonatomic) NSNumber *altitude;

@property (strong, nonatomic) NSString *street;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *postalCode;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *province;

-(void) fetchLocationInformation;

@end