import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var buttonYes: UIButton!
    @IBOutlet private var buttonNo: UIButton!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    
    private var currentQuestionIndex = 0
    private var correctAnswers = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.borderWidth = 8.0
        buttonYes.layer.cornerRadius = 15
        buttonNo.layer.cornerRadius = 15
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true

        show(quiz: convert(model: questions[currentQuestionIndex]))
    }

    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }

    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }

    private let questions: [QuizQuestion] = [
        QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]

    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handleAnswer(givenAnswer: true)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handleAnswer(givenAnswer: false)
    }

    private func handleAnswer(givenAnswer: Bool) {

        setButtonsEnabled(false)
        
        let currentQuestion = questions[currentQuestionIndex]
        let isCorrect = givenAnswer == currentQuestion.correctAnswer
        
        if isCorrect {
            correctAnswers += 1
        }
        
        showAnswerResult(isCorrect: isCorrect)
    }

    private func setButtonsEnabled(_ isEnabled: Bool) {
        buttonYes.isEnabled = isEnabled
        buttonNo.isEnabled = isEnabled
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }

    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderColor = UIColor.clear.cgColor
    }

    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.borderColor = (isCorrect ? UIColor(named: "YP Green") : UIColor(named: "YP Red"))?.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
            self.setButtonsEnabled(true)
        }
    }

    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            showResults()
        } else {
            currentQuestionIndex += 1
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            show(quiz: viewModel)
        
        }
    }

    private func showResults() {
        let message = "Вы ответили правильно на \(correctAnswers) из \(questions.count) вопросов."
        
        let alert = UIAlertController(title: "Раунд окончен!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Сыграть ещё раз", style: .default) { _ in
            self.restartGame()
        }
        
        alert.addAction(action)
        present(alert, animated: true)
    }
    private func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        let firstQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: firstQuestion)
        show(quiz: viewModel)
        imageView.layer.borderColor = UIColor.clear.cgColor
        setButtonsEnabled(true)
    }
}
