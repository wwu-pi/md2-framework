// static: Utility
//
//  Utilities.m
//  TariffCalculator
//
//  Created by Uni Münster on 01.07.12.
//  Copyright (c) 2012 Uni-Muenster. All rights reserved.
//

#import "Utilities.h"

@implementation NSManagedObject (Utilities)

-(BOOL) containsAttributeForKey: (NSString *) key
{
    id attribute = [[[self entity] attributesByName] objectForKey: key];
    return (attribute != nil);
}

-(NSManagedObject *) setAttributesByJSONData: (NSDictionary *) keyedValues
{
    NSDictionary *attributes = [[self entity] attributesByName];
    for (NSString *attribute in attributes)
    {
        if ([attribute isEqualToString: @"createdDate"])
            continue;
        if ([attribute isEqualToString: @"identifier"])
        {
            [self setValue: [NSNumber numberWithInteger: [[keyedValues objectForKey: @"__internalId"] integerValue]] forKey: @"identifier"];
            continue;
        }
        id value = [keyedValues objectForKey: attribute];
        if (value == nil)
            continue;
        
        NSAttributeType attributeType = [[attributes objectForKey: attribute] attributeType];
        if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType)
             || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass: [NSString class]]))
            value = [NSNumber numberWithInteger: [value integerValue]];
        else if ((attributeType == NSFloatAttributeType) &&  ([value isKindOfClass: [NSString class]]))
            value = [NSNumber numberWithFloat: [value floatValue]];
        else if ((attributeType == NSDoubleAttributeType) &&  ([value isKindOfClass: [NSString class]]))
            value = [NSNumber numberWithDouble: [value doubleValue]];
        else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass: [NSString class]]))
            value = [DataConverter getDateByString: value];
        
        if (value != nil)
            [self setValue: value forKey: attribute];
    }
    
    NSDictionary *relations = [[self entity] relationshipsByName];
    for (NSString *relationshipName in relations)
    {
        id value = [keyedValues objectForKey: relationshipName];
        NSRelationshipDescription *relationship = ((NSRelationshipDescription *)[relations objectForKey: relationshipName]);
        if (value == nil)
            continue;
        if (relationship.isToMany)
        {
            NSSet *objects = [self valueForKey: relationshipName];
            NSArray *values = (NSArray *) [keyedValues objectForKey: relationshipName];
            
            NSUInteger i = 0;
            for (NSManagedObject *object in objects)
            {
                if (i >= values.count - 1)
                    break;
                [object setAttributesByJSONData: [values objectAtIndex: i++]];
            }
        }
        else
            [[self valueForKey: relationshipName] setAttributesByJSONData: value];
    }
    
    return self;
}

-(NSDictionary *) getDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *relationships = [self.entity relationshipsByName];
    for (NSString *relationshipName in relationships)
    {
        id value = nil;
        NSRelationshipDescription *relationship = ((NSRelationshipDescription *)[[self.entity relationshipsByName] objectForKey: relationshipName]);
        if (relationship.isToMany)
        {
            NSSet *relationships = ((NSSet *) [self valueForKey: relationshipName]);
            NSMutableArray *objects = [[NSMutableArray alloc] init];
            for (NSManagedObject *object in relationships)
                [objects addObject: [object getDictionary]];
            value = objects;
        }
        else
            value = [[self valueForKey: relationshipName] getDictionary];
        
        if (value != nil)
            [dictionary setValue: value forKey: relationshipName];
    }
    
    [dictionary setValuesForKeysWithDictionary: [self attributesToDictionary]];
    
    return dictionary;
}

-(NSDictionary *) attributesToDictionary
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    NSDictionary *attributes = [self.entity attributesByName];
    for (NSString *attribute in attributes)
    {
        NSAttributeType attributeType = [[attributes objectForKey: attribute] attributeType];
        if (attributeType == NSDateAttributeType)
            [dictionary setValue: [DataConverter getStringByDate: [self valueForKey: attribute]] forKey: attribute];
        else
            [dictionary setValue: [self valueForKey: attribute] forKey: attribute];
    }
    return dictionary;
}

-(void) revertLocalChanges
{
    NSDictionary *changed = [self changedValues];
    NSDictionary *original = [self committedValuesForKeys:[changed allKeys]];
    for (id key in [changed keyEnumerator]) {
        [self setValue:[original objectForKey:key] forKey:key];
    }
}

@end