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

class Router {
    var routerQuestionCount = 0
}

class FlowTests: XCTestCase {
    func test_start_withNoQuestionDoesNoRouteToQuestion() {
        let router = Router()
        let sut = Flow(router: router)

        sut.start()

        XCTAssertEqual(router.routerQuestionCount, 0)
    }
}
