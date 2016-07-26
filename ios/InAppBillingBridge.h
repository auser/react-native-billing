#import "RCTBridgeModule.h"
#import "RCTEventDispatcher.h"

#import <RMStore/RMStore.h>

@interface InAppBillingBridge : NSObject <RCTBridgeModule, RMStoreObserver, SKPaymentTransactionObserver> {

}

@end
