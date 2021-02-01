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
        guard let firstQuestion = questions.first else { return }
        router.route(toQuestion: firstQuestion) { _ in
            let currentQuestionIndex =  self.questions.firstIndex(of: firstQuestion)!
            let nextQuestion = self.questions[currentQuestionIndex + 1]

            self.router.route(toQuestion: nextQuestion) { _ in
            }
        }
    }
}

protocol Router {
    func route(toQuestion question: String, answerCallback: @escaping (String) -> Void)
}

class FlowTests: XCTestCase {
    func test_start_withNoQuestionDoesNoRouteToQuestion() {
        let (sut, router) = makeSUT()

        sut.start()

        XCTAssertTrue(router.routerQuestions.isEmpty)
    }

    func test_start_withOneQuestionRouteToQuestion() {
        let expectedQuestion = "a question"
        let (sut, router) = makeSUT(questions: [expectedQuestion])

        sut.start()

        XCTAssertEqual(router.routerQuestions, [expectedQuestion])
    }

    func test_start_withTwoQuestionRouteToFirstQuestion() {
        let expectedQuestion = "a question"
        let expectedQuestionTwo = "another question"
        let (sut, router) = makeSUT(questions: [expectedQuestion, expectedQuestionTwo])

        sut.start()

        XCTAssertEqual(router.routerQuestions, [expectedQuestion])
    }

    func test_startTwice_withTwoQuestionRouteToFirstQuestionTwice() {
        let expectedQuestionOne = "a question"
        let expectedQuestionTwo = "another question"
        let (sut, router) = makeSUT(questions: [expectedQuestionOne, expectedQuestionTwo])

        sut.start()
        sut.start()

        XCTAssertEqual(router.routerQuestions, [expectedQuestionOne, expectedQuestionOne])
    }

    func test_startAndAnswerFirstQuestion_withTwoQuestionRouteToSecondQuestion() {
        let expectedQuestionOne = "a question"
        let expectedQuestionTwo = "another question"
        let (sut, router) = makeSUT(questions: [expectedQuestionOne, expectedQuestionTwo])

        sut.start()
        router.answerCallbacks[0](expectedQuestionTwo)

        XCTAssertEqual(router.routerQuestions, [expectedQuestionOne, expectedQuestionTwo])
    }

    // MARK: - Helpers
    private func makeSUT(questions: [String] = []) -> (sut: Flow, router: RouterSpy){
        let router = RouterSpy()
        let sut = Flow(questions: questions, router: router)

        return (sut: sut, router: router)
    }

    private class RouterSpy: Router {
        var routerQuestions = [String]()
        var answerCallbacks = [(String) -> Void]()

        func route(toQuestion question: String, answerCallback: @escaping (String) -> Void) {
            routerQuestions.append(question)
            answerCallbacks.append(answerCallback)
        }
    }
}
