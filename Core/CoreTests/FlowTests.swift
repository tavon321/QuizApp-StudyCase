//
//  FlowTests.swift
//  CoreTests
//
//  Created by Tavo on 18/01/21.
//

import XCTest

class Flow {
    private let router: Router
    private let questions: [String]

    init(questions: [String], router: Router) {
        self.router = router
        self.questions = questions
    }

    func start() {
        guard !questions.isEmpty else { return }
        router.routToQuestion()
    }
}

protocol Router {
    func routToQuestion()
}

class FlowTests: XCTestCase {
    func test_start_withNoQuestionDoesNoRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: [], router: router)

        sut.start()

        XCTAssertEqual(router.routerQuestionCount, 0)
    }

    func test_start_withOneQuestionRouteToQuestion() {
        let router = RouterSpy()
        let sut = Flow(questions: ["a question"], router: router)

        sut.start()

        XCTAssertEqual(router.routerQuestionCount, 1)
    }

    class RouterSpy: Router {
        var routerQuestionCount = 0

        func routToQuestion() {
            routerQuestionCount += 1
        }
    }
}
