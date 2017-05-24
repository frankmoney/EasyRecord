# EasyRecord
Shorthand Core Data tool

In fact this tool is extension category for standard Core Data classes. It will allow you to more easily perform typical standard operations: creating context, queries, filters and so on. Also this tool elaborate for easily create a core data storage in memory.

# Usage

Just include main header `#import "FAEasyRecord.h"` file into your code, and then:

__Init core data stack in memory__

`[FAEasyRecord setupCoreDataStackWithInMemoryStore];`

__Save some data__

```objectivec

NSDictionary *data = //some dict data
[FAEasyRecord saveWithBlock:^(NSManagedObjectContext *localContext){
    [FEMDeserializer objectFromRepresentation:data
                                      mapping:[SomeManagedObject defaultMapping]
                                      context:localContext];
}
completion:^(BOOL contextDidSave, NSError *error){
          // some completion there
}];
```

__Find some data__

```objectivec

NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", MyManagedObjectRelationships.otherData, data];
NSFetchedResultsController *frc = [MyManagedObject ER_fetchAllGroupedBy:@"count"
                                                          withPredicate:predicate
                                                              sortedBy:MyManagedObjectAttributes.uid
                                                              ascending:YES
                                                              delegate:self];
  NSArray *result = frc.fetchedObjects;

```

Also for that tool we recommend use [mogenerator tool](https://github.com/rentzsch/mogenerator).

# MIT License

Copyright (c) 2017 Frank

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
