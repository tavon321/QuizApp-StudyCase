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
        let currentIndex = 0
        router.route(toQuestion: questions[currentIndex]) { [weak self] _ in
            guard let self = self else { return }
            self.routeNextQuestion(atIndex: currentIndex)
        }
    }

    private func routeNextQuestion(atIndex index: Int) {
        let nextIndex = questions.index(after: index)
        guard nextIndex < self.questions.count else { return }

        self.router.route(toQuestion: self.questions[nextIndex]) { [weak self] _ in
            guard let self = self else { return }
            self.routeNextQuestion(atIndex: nextIndex)
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

    func test_startAndAnswerQuestion_routeToNextQuestion() {
        let expectedQuestions = makeQuestions(numberOfQuestions: 30)
        let (sut, router) = makeSUT(questions: expectedQuestions)

        sut.start()

        expectedQuestions.enumerated().forEach { (index, question) in
            router.answer(with: anyAnswer, at: index)
            XCTAssertEqual(router.routerQuestions[index], question)
        }
    }

    // MARK: - Helpers
    private func makeQuestions(numberOfQuestions: Int) -> [String] {
        return (0..<numberOfQuestions).map({ "Q\($0)" })
    }

    private func makeSUT(questions: [String] = []) -> (sut: Flow, router: RouterSpy){
        let router = RouterSpy()
        let sut = Flow(questions: questions, router: router)

        trackForMemoryLeaks(router)
        trackForMemoryLeaks(sut)
        return (sut: sut, router: router)
    }

    private func trackForMemoryLeaks(_ sut: AnyObject?, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak sut] in
            XCTAssertNil(sut,
                         "Instance should have being deallocated. Potential memory leak",
                         file: file,
                         line: line)
        }
    }

    private var anyAnswer: String { return "Any Answer" }

    private class RouterSpy: Router {
        var routerQuestions = [String]()
        private var answerCallbacks = [(String) -> Void]()

        func route(toQuestion question: String, answerCallback: @escaping (String) -> Void) {
            routerQuestions.append(question)
            answerCallbacks.append(answerCallback)
        }

        func answer(with value: String, at index: Int = 0, file: StaticString = #filePath, line: UInt = #line) {
            guard index < answerCallbacks.count else {
                XCTFail("answer call wasn't called", file: file, line: line)
                return
            }

            answerCallbacks[index](value)
        }
    }
}
