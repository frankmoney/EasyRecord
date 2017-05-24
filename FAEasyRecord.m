//
//  FAEasyRecord.m
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

#import "FAEasyRecord.h"
#import <CoreData/CoreData.h>

@implementation FAEasyRecord

+ (void)setupCoreDataStackWithInMemoryStore
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DataModel" withExtension:@"momd"];
    NSManagedObjectModel *mom = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    NSAssert(mom != nil, @"Error initializing Managed Object Model");
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:mom];
    NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [moc setPersistentStoreCoordinator:psc];
    
    [psc addPersistentStoreWithType:NSInMemoryStoreType
                      configuration:nil
                                URL:nil
                            options:nil
                              error:nil];
    
    [NSManagedObjectContext ER_setDefaultContext:moc];
}

+ (void)saveWithBlock:(void (^)(NSManagedObjectContext *))block
           completion:(void (^)(BOOL, NSError *))completion
{
    NSManagedObjectContext *backContext = [NSManagedObjectContext ER_defaultContext];
    
    [backContext performBlock:^
     {
         if(block)
         {
             block(backContext);
         }
         
         [backContext save:nil];
         
         [[NSManagedObjectContext ER_defaultContext] performBlock:^
          {
              [[NSManagedObjectContext ER_defaultContext] save:nil];
              
              if(completion)
              {
                  completion(YES, nil);
              }
          }];
     }];
}

@end
