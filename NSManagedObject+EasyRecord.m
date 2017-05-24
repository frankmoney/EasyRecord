//
//  NSManagedObject+EasyRecord.m
//  EasyRecord
//
//  Created by Ринат Муртазин on 06/03/16.
//  Copyright © 2016 Frank. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "NSManagedObject+EasyRecord.h"
#import "FAEasyRecord.h"

@implementation NSManagedObject (EasyRecord)

+ (instancetype)ER_createEntityInContext:(NSManagedObjectContext *)context
{
    NSEntityDescription *entity = [self ER_entityDescriptionInContext:context];
    
    if (entity == nil)
    {
        return nil;
    }
    
    return [[self alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
}

#pragma mark - Find First

+ (instancetype)ER_findFirstByAttribute:(NSString *)attribute
                              withValue:(id)searchValue
{
    return [self ER_findFirstByAttribute:attribute
                               withValue:searchValue
                               inContext:DEFAULT_CONTEXT];
}

+ (instancetype)ER_findFirstByAttribute:(NSString *)attribute
                              withValue:(id)searchValue
                              inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self ER_requestFirstByAttribute:attribute withValue:searchValue inContext:context];
    
    return [self ER_executeFetchRequestAndReturnFirstObject:request inContext:context];
}

#pragma mark - Find All

+ (NSArray *)ER_findAll
{
    return [self ER_executeFetchRequest:[self ER_createFetchRequestInContext:DEFAULT_CONTEXT]
                              inContext:DEFAULT_CONTEXT];
}

+ (NSArray *)ER_findAllWithPredicate:(NSPredicate *)p
{
    NSFetchRequest *request = [self ER_createFetchRequestInContext:DEFAULT_CONTEXT];
    
    request.predicate = p;
    
    return [self ER_executeFetchRequest:request inContext:DEFAULT_CONTEXT];
}

+ (NSArray *)ER_findAllSortedBy:(NSString *)sortTerm
                      ascending:(BOOL)ascending
{
    return [self ER_findAllSortedBy:sortTerm
                          ascending:ascending
                          inContext:DEFAULT_CONTEXT];
}

+ (NSArray *)ER_findAllSortedBy:(NSString *)sortTerm
                      ascending:(BOOL)ascending
                      inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self ER_requestAllSortedBy:sortTerm
                                                ascending:ascending
                                            withPredicate:nil
                                                inContext:context];
    
    return [self ER_executeFetchRequest:request inContext:context];
}

+ (NSArray *)ER_findAllSortedBy:(NSString *)sortTerm
                      ascending:(BOOL)ascending
                  withPredicate:(NSPredicate *)searchTerm
                      inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self ER_requestAllSortedBy:sortTerm
                                                ascending:ascending
                                            withPredicate:searchTerm
                                                inContext:context];
    
    return [self ER_executeFetchRequest:request inContext:context];
}

+ (NSArray *)ER_findByAttribute:(NSString *)attribute
                      withValue:(id)searchValue
{
    return [self ER_findByAttribute:attribute
                          withValue:searchValue
                          inContext:DEFAULT_CONTEXT];
}

+ (NSArray *)ER_findByAttribute:(NSString *)attribute
                      withValue:(id)searchValue
                      inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self ER_requestAllWhere:attribute isEqualTo:searchValue inContext:context];
    
    return [self ER_executeFetchRequest:request inContext:context];
}

#pragma mark - Fetch

+ (NSFetchedResultsController *)ER_fetchAllGroupedBy:(NSString *)group
                                       withPredicate:(NSPredicate *)searchTerm
                                            sortedBy:(NSString *)sortTerm
                                           ascending:(BOOL)ascending
                                            delegate:(id<NSFetchedResultsControllerDelegate>)delegate
{
    return [self ER_fetchAllGroupedBy:group
                        withPredicate:searchTerm
                             sortedBy:sortTerm
                            ascending:ascending
                             delegate:delegate
                            inContext:DEFAULT_CONTEXT];
}

+ (NSFetchedResultsController *)ER_fetchAllGroupedBy:(NSString *)group
                                       withPredicate:(NSPredicate *)searchTerm
                                            sortedBy:(NSString *)sortTerm
                                           ascending:(BOOL)ascending
                                            delegate:(id<NSFetchedResultsControllerDelegate>)delegate
                                           inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self ER_requestAllSortedBy:sortTerm
                                                ascending:ascending
                                            withPredicate:searchTerm
                                                inContext:context];
    
    NSFetchedResultsController *controller = [self ER_fetchController:request
                                                             delegate:delegate
                                                         useFileCache:NO
                                                            groupedBy:group
                                                            inContext:context];
    
    [controller performFetch:nil];
    
    return controller;
}

+ (NSFetchedResultsController *)ER_fetchByRequest:(NSFetchRequest*)request
										groupedBy:(NSString *)group
										 delegate:(id<NSFetchedResultsControllerDelegate>)delegate
										inContext:(NSManagedObjectContext *)context
{
	NSFetchedResultsController *controller = [self ER_fetchController:request
															 delegate:delegate
														 useFileCache:NO
															groupedBy:group
															inContext:context];

	[controller performFetch:nil];

	return controller;
}

+ (NSFetchRequest *)ER_requestAllSortedBy:(NSString *)sortTerm
								ascending:(BOOL)ascending
							withPredicate:(NSPredicate *)searchTerm
								inContext:(NSManagedObjectContext *)context
{
	NSFetchRequest *request = [self ER_createFetchRequestInContext:context];

	if (searchTerm)
	{
		[request setPredicate:searchTerm];
	}

	NSMutableArray* sortDescriptors = [[NSMutableArray alloc] init];
	NSArray* sortKeys = [sortTerm componentsSeparatedByString:@","];
	for (__strong NSString* sortKey in sortKeys)
	{
		NSArray * sortComponents = [sortKey componentsSeparatedByString:@":"];
		if (sortComponents.count > 1)
		{
			NSString * customAscending = sortComponents.lastObject;
			ascending = customAscending.boolValue;
			sortKey = sortComponents[0];
		}

		NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending];
		[sortDescriptors addObject:sortDescriptor];
	}

	[request setSortDescriptors:sortDescriptors];

	return request;
}


#pragma mark - Internal

+ (NSFetchedResultsController *)ER_fetchController:(NSFetchRequest *)request
                                          delegate:(id<NSFetchedResultsControllerDelegate>)delegate
                                      useFileCache:(BOOL)useFileCache
                                         groupedBy:(NSString *)groupKeyPath
                                         inContext:(NSManagedObjectContext *)context;
{
    NSString *cacheName = useFileCache ? [NSString stringWithFormat:@"MagicalRecord-Cache-%@", NSStringFromClass([self class])] : nil;
    
    NSFetchedResultsController *controller = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                 managedObjectContext:context
                                                                                   sectionNameKeyPath:groupKeyPath
                                                                                            cacheName:cacheName];
    controller.delegate = delegate;
    
    return controller;
}

+ (NSFetchRequest *)ER_requestFirstByAttribute:(NSString *)attribute
                                     withValue:(id)searchValue
                                     inContext:(NSManagedObjectContext *)context;
{
    NSFetchRequest *request = [self ER_requestAllWhere:attribute isEqualTo:searchValue inContext:context];
    [request setFetchLimit:1];
    
    return request;
}

+ (id)ER_executeFetchRequestAndReturnFirstObject:(NSFetchRequest *)request
                                       inContext:(NSManagedObjectContext *)context
{
    [request setFetchLimit:1];
    
    return [[self ER_executeFetchRequest:request inContext:context] firstObject];
}

+ (NSFetchRequest *)ER_createFetchRequestInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[self ER_entityDescriptionInContext:context]];
    
    return request;
}

+ (NSEntityDescription *)ER_entityDescriptionInContext:(NSManagedObjectContext *)context
{
    NSString *entityName = [self ER_entityName];
    return [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
}

+ (NSFetchRequest *)ER_requestAllWhere:(NSString *)property
                             isEqualTo:(id)value
                             inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [self ER_createFetchRequestInContext:context];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K = %@", property, value]];
    
    return request;
}

+ (NSArray *)ER_executeFetchRequest:(NSFetchRequest *)request
                          inContext:(NSManagedObjectContext *)context
{
    __block NSArray *results = nil;
    
    [context performBlockAndWait:^
     {
         NSError *error = nil;
         
         results = [context executeFetchRequest:request error:&error];
     }];
    
    return results;
}

+ (NSString *)ER_entityName;
{
    NSString *entityName;
    
    if ([self respondsToSelector:@selector(entityName)])
    {
        entityName = [self performSelector:@selector(entityName)];
    }
    
    if ([entityName length] == 0)
    {
        entityName = [NSStringFromClass(self) componentsSeparatedByString:@"."].lastObject;
    }
    
    return entityName;
}

@end
