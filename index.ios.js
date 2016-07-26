/**
 * @providesModule InAppBilling
 * @flow
 */
import {
  AsyncStorage, NativeModules, NativeAppEventEmitter
} from 'react-native';

const InAppBillingBridge = NativeModules.InAppBillingBridge;

const promisify = fn => (...args) => {
  return new Promise((resolve, reject) => {
    const handler = (err, resp) => err ? reject(err) : resolve(resp);
    args.push(handler);
    (typeof fn === 'function' ? fn : InAppBillingBridge[fn])
      .call(InAppBillingBridge, ...args);
  });
};

export class InAppBilling {
  static open() {
    return promisify('open')()
  }

  static close() {
    return promisify('close')()
  }

  static listProducts(productIds=[]) {
    return promisify('listProducts')(productIds);
  }

  static purchase(productId, developerPayload = null) {
    return promisify('purchase')(productId, developerPayload);
  }

  static consumePurchase(productId) {
  }

  static subscribe(productId, developerPayload = null) {
  }

  static isSubscribed(productId) {
  }

  static isPurchased(productId) {
  }

  static listOwnedProducts() {
  }

  static listOwnedSubscriptions() {
  }

  static getProductDetails(productId) {
  }

  static getPurchaseTransactionDetails(productId) {
  }

  static getSubscriptionTransactionDetails(productId) {
  }

  static getProductDetailsArray(productIds) {
  }

  static getSubscriptionDetails(productId) {
  }

  static getSubscriptionDetailsArray(productIds) {
  }
}

export default InAppBilling;
