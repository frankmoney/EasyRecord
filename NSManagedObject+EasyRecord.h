//
//  NSManagedObject+EasyRecord.h
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

#import <CoreData/CoreData.h>

@interface NSManagedObject (EasyRecord)

+ (instancetype)ER_createEntityInContext:(NSManagedObjectContext *)context;

+ (instancetype)ER_findFirstByAttribute:(NSString *)attribute
                              withValue:(id)searchValue;

+ (instancetype)ER_findFirstByAttribute:(NSString *)attribute
                              withValue:(id)searchValue
                              inContext:(NSManagedObjectContext *)context;

+ (NSArray *)ER_findAll;

+ (NSArray *)ER_findAllWithPredicate:(NSPredicate *)p;

+ (NSArray *)ER_findAllSortedBy:(NSString *)sortTerm
                      ascending:(BOOL)ascending;

+ (NSArray *)ER_findAllSortedBy:(NSString *)sortTerm
                      ascending:(BOOL)ascending
                      inContext:(NSManagedObjectContext *)context;

+ (NSArray *)ER_findByAttribute:(NSString *)attribute
                      withValue:(id)searchValue;

+ (NSArray *)ER_findByAttribute:(NSString *)attribute
                      withValue:(id)searchValue
                      inContext:(NSManagedObjectContext *)context;

+ (NSArray *)ER_findAllSortedBy:(NSString *)sortTerm
                      ascending:(BOOL)ascending
                  withPredicate:(NSPredicate *)searchTerm
                      inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)ER_fetchAllGroupedBy:(NSString *)group
                                       withPredicate:(NSPredicate *)searchTerm
                                            sortedBy:(NSString *)sortTerm
                                           ascending:(BOOL)ascending
                                            delegate:(id<NSFetchedResultsControllerDelegate>)delegate;

+ (NSFetchedResultsController *)ER_fetchAllGroupedBy:(NSString *)group
                                       withPredicate:(NSPredicate *)searchTerm
                                            sortedBy:(NSString *)sortTerm
                                           ascending:(BOOL)ascending
                                            delegate:(id<NSFetchedResultsControllerDelegate>)delegate
                                           inContext:(NSManagedObjectContext *)context;

+ (NSFetchedResultsController *)ER_fetchByRequest:(NSFetchRequest*)request
										groupedBy:(NSString *)group
										 delegate:(id<NSFetchedResultsControllerDelegate>)delegate
										inContext:(NSManagedObjectContext *)context;

+ (NSFetchRequest *)ER_requestAllSortedBy:(NSString *)sortTerm
								ascending:(BOOL)ascending
							withPredicate:(NSPredicate *)searchTerm
								inContext:(NSManagedObjectContext *)context;

@end
