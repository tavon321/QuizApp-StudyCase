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
        let (sut, router) = makeSUT()

        sut.start()

        XCTAssertEqual(router.routerQuestionCount, 0)
    }

    func test_start_withOneQuestionRouteToQuestion() {
        let (sut, router) = makeSUT(questions: ["any question"])

        sut.start()

        XCTAssertEqual(router.routerQuestionCount, 1)
    }

    // MARK: - Helpers
    private func makeSUT(questions: [String] = []) -> (sut: Flow, router: RouterSpy){
        let router = RouterSpy()
        let sut = Flow(questions: questions, router: router)

        return (sut: sut, router: router)
    }

    private class RouterSpy: Router {
        var routerQuestionCount = 0

        func routToQuestion() {
            routerQuestionCount += 1
        }
    }
}
