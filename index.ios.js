/**
 * @providesModule InAppBilling
 * @flow
 */
import {NativeModules, NativeAppEventEmitter} from 'react-native';
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
    return promisify('purchase')(productId, developerPayload)
  }

  static consumePurchase(productId) {
    return InAppBillingBridge.consumePurchase(productId);
  }

  static subscribe(productId, developerPayload = null) {
    return InAppBillingBridge.subscribe(productId, developerPayload);
  }

  static isSubscribed(productId) {
    return InAppBillingBridge.isSubscribed(productId);
  }

  static isPurchased(productId) {
    return InAppBillingBridge.isPurchased(productId);
  }

  static listOwnedProducts() {
    return InAppBillingBridge.listOwnedProducts();
  }

  static listOwnedSubscriptions() {
    return InAppBillingBridge.listOwnedSubscriptions();
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
