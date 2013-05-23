// static: ContentProviders
//
//  GPSContentProvider.m
//  TariffCalculator
//
//  Created by Uni Münster on 30.06.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "GPSContentProvider.h"

@implementation GPSContentProvider

@synthesize latitude, longitude, altitude;
@synthesize street, number, postalCode, city, state, country, province;

-(id) init
{
	self = [super init];
	if (self)
    {
        locationManager = [[CLLocationManager alloc] init];
        geoCoder = [[CLGeocoder alloc] init];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
        [self fetchLocationInformation];
	}
	return self;
}

-(NSManagedObject *) getDataObject: (BOOL) shouldReload
{
    return nil;
}

-(id) getDataObjectValueForKey: (NSString *) key
{
    if ([key isEqualToString: @"latitude"])
        return latitude.stringValue;
    else if ([key isEqualToString: @"longitude"])
        return longitude.stringValue;
    else if ([key isEqualToString: @"altitude"])
        return altitude.stringValue;
    else if ([key isEqualToString: @"street"])
        return street;
    else if ([key isEqualToString: @"number"])
        return number;
    else if ([key isEqualToString: @"postalCode"])
        return postalCode;
    else if ([key isEqualToString: @"city"])
        return city;
    else if ([key isEqualToString: @"state"])
        return state;
    else if ([key isEqualToString: @"country"])
        return country;
    else if ([key isEqualToString: @"province"])
        return province;
    return @"";
}

-(void) setDataObjectValue: (id) value forKey: (NSString *) key {}

-(void) fetchDataObject
{
    [self fetchLocationInformation];
}

-(void) persistDataObject {}

-(void) removeDataObject {}

-(void) createNewDataObject
{
    [self fetchLocationInformation];
}

-(void) fetchLocationInformation
{
    latitude = [NSNumber numberWithDouble: locationManager.location.coordinate.latitude];
    longitude = [NSNumber numberWithDouble: locationManager.location.coordinate.longitude];
    altitude = [NSNumber numberWithDouble: locationManager.location.altitude];
    
    geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation: locationManager.location completionHandler:
     ^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks objectAtIndex: 0];
         
         street = [NSString stringWithString: (placemark.thoroughfare != nil)? placemark.thoroughfare: @""];
         number = [NSString stringWithString: (placemark.subThoroughfare != nil)? placemark.subThoroughfare: @""];
         postalCode = [NSString stringWithString: (placemark.postalCode != nil)? placemark.postalCode: @""];
         city = [NSString stringWithString: (placemark.locality != nil)? placemark.locality: @""];
         state = [NSString stringWithString: (placemark.administrativeArea != nil)? placemark.administrativeArea: @""];
         country = [NSString stringWithString: (placemark.country != nil)? placemark.country: @""];
         province = [NSString stringWithString: (placemark.subAdministrativeArea != nil)? placemark.subAdministrativeArea: @""];
     }];
}

@end