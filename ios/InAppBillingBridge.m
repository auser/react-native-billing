#import "InAppBillingBridge.h"

@implementation InAppBillingBridge

RCT_EXPORT_MODULE(InAppBillingBridge);

RCT_EXPORT_METHOD(open:(RCTResponseSenderBlock) callback)
{
    // Only used currently to support the same js API as the android js API
    [[RMStore defaultStore] addStoreObserver:self];
    // [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    callback(@[[NSNull null], @{}]);
}

RCT_EXPORT_METHOD(close:(RCTResponseSenderBlock) callback)
{
    [[RMStore defaultStore] removeStoreObserver:self];
    // [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    callback(@[[NSNull null], @{}]);
}

RCT_EXPORT_METHOD(listProducts:(NSArray *)productIds
                  callback:(RCTResponseSenderBlock) callback)
{
    NSSet *products = [NSSet setWithArray:productIds];
    [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        NSMutableArray *productJson = [[NSMutableArray alloc] init];
        
        for (SKProduct *product in products) {
            [productJson addObject:[self productToJson:product]];
        }
        NSLog(@"Products loaded: %@", productJson);
        callback(@[[NSNull null], productJson]);
    } failure:^(NSError *error) {
        NSLog(@"Something went wrong");
        callback(@[@{
                       @"error": @"error",
                       @"message": [error localizedDescription]
                       }]);
    }];
}

RCT_EXPORT_METHOD(purchase:(NSString *)productId
                  metadata:(NSDictionary *) metadata
                  callback:(RCTResponseSenderBlock) callback)
{
    //    [[RMStore defaultStore] addPayment:productId
    //                                  user:user
    //                               success:^(SKPaymentTransaction *transaction) {
    //                                   NSLog(@"Payment went through!");
    //
    //                               }
    //                               failure:^(SKPaymentTransaction *transaction, NSError *error) {
    //                                   NSDictionary *err = @{
    //                                                         @"error": @"paymentError",
    //                                                         @"msg": [error localizedDescription]
    //                                                         };
    //
    //                                   NSLog(@"There was an error and I'm not sure why? (%@)", err);
    //                                   callback(@[err]);
    //                               }];
}

/**
 * Events
 */
- (void) paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
{
    NSLog(@"Received updatedTrasnactions array: %@", transactions);
}
- (void)storeProductsRequestFailed:(NSNotification*)notification
{
    //   NSError *error = notification.rm_storeError;
}

- (void)storeProductsRequestFinished:(NSNotification*)notification
{
    //   NSArray *products = notification.rm_products;
    //   NSArray *invalidProductIdentifiers = notification.rm_invalidProductIdentifiers;
}

- (void)storePaymentTransactionFinished:(NSNotification*)notification
{
    //   NSString *productIdentifier = notification.rm_productIdentifier;
    //   SKPaymentTransaction *transaction = notification.rm_transaction;
}

- (void)storePaymentTransactionFailed:(NSNotification*)notification
{
    //   NSError *error = notification.rm_storeError;
    //   NSString *productIdentifier = notification.rm_productIdentifier;
    //   SKPaymentTransaction *transaction = notification.rm_transaction;
}

// iOS 8+ only
- (void)storePaymentTransactionDeferred:(NSNotification*)notification
{
    //   NSString *productIdentifier = notification.rm_productIdentifier;
    //   SKPaymentTransaction *transaction = notification.rm_transaction;
}

- (void)storeRestoreTransactionsFailed:(NSNotification*)notification;
{
    //    NSError *error = notification.rm_storeError;
}

- (void)storeRestoreTransactionsFinished:(NSNotification*)notification
{
    //    NSArray *transactions = notification.rm_transactions;
}

- (void)storeDownloadFailed:(NSNotification*)notification
{
    //    SKDownload *download = notification.rm_storeDownload; // Apple-hosted only
    //    NSString *productIdentifier = notification.rm_productIdentifier;
    //    SKPaymentTransaction *transaction = notification.rm_transaction;
    //    NSError *error = notification.rm_storeError;
}

- (void)storeDownloadFinished:(NSNotification*)notification;
{
    //    SKDownload *download = notification.rm_storeDownload; // Apple-hosted only
    //    NSString *productIdentifier = notification.rm_productIdentifier;
    //    SKPaymentTransaction *transaction = notification.rm_transaction;
}

- (void)storeDownloadUpdated:(NSNotification*)notification
{
    //    SKDownload *download = notification.rm_storeDownload; // Apple-hosted only
    //    NSString *productIdentifier = notification.rm_productIdentifier;
    //    SKPaymentTransaction *transaction = notification.rm_transaction;
    //    float progress = notification.rm_downloadProgress;
}

- (void)storeDownloadCanceled:(NSNotification*)notification
{
    //    SKDownload *download = notification.rm_storeDownload;
    //    NSString *productIdentifier = notification.rm_productIdentifier;
    //    SKPaymentTransaction *transaction = notification.rm_transaction;
}

- (void)storeDownloadPaused:(NSNotification*)notification
{
    //    SKDownload *download = notification.rm_storeDownload;
    //    NSString *productIdentifier = notification.rm_productIdentifier;
    //    SKPaymentTransaction *transaction = notification.rm_transaction;
}

- (void)storeRefreshReceiptFailed:(NSNotification*)notification;
{
    //    NSError *error = notification.rm_storeError;
}

- (void)storeRefreshReceiptFinished:(NSNotification*)notification { }

- (NSString *) priceString:(SKProduct *)product
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.formatterBehavior = NSNumberFormatterBehavior10_4;
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.locale = product.priceLocale;
    
    return [formatter stringFromNumber:product.price];
}

- (NSDictionary *) productToJson:(SKProduct *)product
{
    NSDictionary *props = @{
                            @"id": product.productIdentifier,
                            @"price": product.price,
                            @"currencySymbol": [product.priceLocale objectForKey:NSLocaleCurrencySymbol],
                            @"currencyCode": [product.priceLocale objectForKey:NSLocaleCurrencyCode],
                            @"priceString": [self priceString:product],
                            @"downloadable": product.downloadable ? @"true" : @"false" ,
                            @"description": product.localizedDescription ? product.localizedDescription : @"",
                            @"title": product.localizedTitle ? product.localizedTitle : @"",
                            
                            };
    
    return props;
}

@end
