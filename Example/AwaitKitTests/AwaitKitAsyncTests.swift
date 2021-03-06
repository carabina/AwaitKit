/*
 * AwaitKit
 *
 * Copyright 2016-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

@testable import AwaitKitExample
import PromiseKit
import XCTest

class AwaitKitAsyncTests: XCTestCase {
  let commonError = NSError(domain: "com.yannickloriot.error", code: 320, userInfo: nil)

  func testSimpleDelayedValidAsyncBlock() {
    let expectation = expectationWithDescription("Async should return value")

    let promise: Promise<String> = async {
      NSThread.sleepForTimeInterval(0.2)

      return "AwaitedPromiseKit"
    }

    promise.then { value in
      expectation.fulfill()
    }

    waitForExpectationsWithTimeout(0.5) { error in
      if error == nil {
        XCTAssertEqual(promise.value, "AwaitedPromiseKit")
      }
    }
  }

  func testSimpleFailedAsyncBlock() {
    let expectation = expectationWithDescription("Async should not return value")

    let promise: Promise<String> = async {
      throw self.commonError
    }

    promise.error { err in
      expectation.fulfill()
    }

    waitForExpectationsWithTimeout(0.1) { error in
      if error == nil {
        XCTAssertNil(promise.value)
      }
    }
  }

  func testNoReturnedValueAsyncBlock() {
    let expectation1 = expectationWithDescription("Async should not return value")
    let expectation2 = expectationWithDescription("Async should throw")

    async {
      expectation1.fulfill()
    }

    async {
      defer {
        expectation2.fulfill()
      }

      throw self.commonError
    }

    waitForExpectationsWithTimeout(0.1, handler: nil)
  }
}
