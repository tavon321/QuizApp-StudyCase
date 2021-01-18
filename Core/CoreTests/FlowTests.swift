//
//  FlowTests.swift
//  CoreTests
//
//  Created by Tavo on 18/01/21.
//

import XCTest

class Flow {
    private let router: Router

    init(router: Router) {
        self.router = router
    }

    func start() {}
}

protocol Router {}

class FlowTests: XCTestCase {
    func test_start_withNoQuestionDoesNoRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(router: router)

        sut.start()

        XCTAssertEqual(router.routerQuestionCount, 0)
    }

    class RouterSpy: Router {
        var routerQuestionCount = 0
    }
}
