//
//  ViewController.swift
//  MovieQuiz
//
//  Created by Maryna Bolotska on 10/09/23.
//

import UIKit
import SDWebImage

class ViewController: UIViewController {
    
    var numberOfQuizzes = 0
    var recordOfHighestResults = [Int]()
    
    private var randomMovie: MovieResult?
    var count = 0 {
        didSet {
            countLabel.text = "\(count) / 10"
    
        }
    }
    var correctAnswers = 0
  
    var random = ["less", "more"]
    var ratingNumber = 8
    
    var questionLabel: UILabel = {
        var label = UILabel()
        label.text = "Question:"
        return label
    }()
    
    var countLabel: UILabel = {
        var label = UILabel()
        label.text = "1 / 10"
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        return label
    }()
    
    var cinemaImage: UIImageView = {
        var image = UIImageView()
        image.backgroundColor = .gray
        image.layer.borderColor = UIColor.black.cgColor
        image.layer.borderWidth = 8
        image.layer.cornerRadius = 10
        return image
    }()
    
    var questionLabelTwo: UILabel = {
        var label = UILabel()
  //      label.text = "The rate is \(cvc) than 8?"
        return label
    }()
    
    var yesButton: UIButton = {
        let button = UIButton()
        button.setTitle("Yes", for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 10
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(correctAnswer), for: .touchUpInside)
        return button
    }()
    
    var noButton: UIButton = {
        let button = UIButton()
        button.setTitle("No", for: .normal)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 3
        button.layer.cornerRadius = 10
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(wrongAnswer), for: .touchUpInside)
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        
        gettingRandomInfoAPI()

        updateQuestionLabel()
        
     
    }
   

       
    
    @objc func wrongAnswer() {
        count += 1
        
        calculatingLogicAnswer()
        gettingRandomInfoAPI()
        updateQuestionLabel()
    }
    
    @objc func correctAnswer() {
        count += 1
        
        
        calculatingLogicAnswer()
        gettingRandomInfoAPI()
        updateQuestionLabel()
    }
    
    func wrongBorderColor() {
            cinemaImage.layer.borderColor = UIColor.red.cgColor
        }
    
    func correctBorderColor() {
            cinemaImage.layer.borderColor = UIColor.green.cgColor
        }
    
    
    func calculatingLogicAnswer(){
        if randomMovie?.voteAverage ?? 0 > 6 {
            correctBorderColor()
            correctAnswers += 1
        } else {
            wrongBorderColor()
        }
        
        if count == 10 {
            count = 0
            numberOfQuizzes += 1
            recordOfHighestResults.append(correctAnswers)
            print(recordOfHighestResults)
            cinemaImage.layer.borderColor = UIColor.black.cgColor
            var ac = UIAlertController(title: "Start new game", message: "Your result is \(correctAnswers) / 10\nNumber of games: \(numberOfQuizzes)\nYour highest result is \(recordOfHighestResults.sorted() { $0 > $1 })", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play again", style: .default))
            present(ac, animated: true)
            
            
            anotherFunction()
            
            
            correctAnswers = 0
           
        }
        
        
    }
    
    private func anotherFunction() {
        // Use the final correctAnswers value here
        print("Final Correct Answers: \(correctAnswers)")
    }

    
    func gettingRandomInfoAPI() {
        APICaller.shared.getTrendingMovies { [weak self] result in
                   switch result {
                   case .success(let movies):
                       
                       // Assuming movies is an array of MovieResult
                       if let randomMovie = movies.randomElement() {
                           self?.randomMovie = randomMovie
                           guard let backdropPath = randomMovie.posterPath else {return }
                           
                           guard let urlImage = URL(string: "https://image.tmdb.org/t/p/original\(backdropPath)") else { return }
                     
                             
                          
                           DispatchQueue.main.async {
                         //      self?.countLabel.text = "Release Date: \(randomMovie.voteAverage ?? 000)"
                               self?.cinemaImage.sd_setImage(with: urlImage)
                           }
                       }
                   case .failure(let error):
                       print("Failed to get trending movies: \(error)")
                   }
               }
        
    }
    
    private func updateQuestionLabel() {
        let randomNumer = random.randomElement()
        questionLabelTwo.text = "The rate is \(randomNumer ?? "less") than \(ratingNumber)?"
        
    }
    
    
    // MARK: - Private constants
    private enum UIConstants {
       static let topOffset: CGFloat = 20
        static let contentInset: CGFloat = 32
    }
}

private extension ViewController {
    func initialize() {
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(questionLabel)
        view.addSubview(countLabel)
        view.addSubview(cinemaImage)
        view.addSubview(questionLabelTwo)
        view.addSubview(yesButton)
        view.addSubview(noButton)
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.leading.equalToSuperview().inset(UIConstants.contentInset)
        }
        
        countLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.trailing.equalToSuperview().inset(UIConstants.contentInset)
        }
        
        cinemaImage.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(UIConstants.topOffset)
            $0.height.equalTo(500)
            $0.width.equalTo(300)
            $0.centerX.equalToSuperview()
        }
        
        questionLabelTwo.snp.makeConstraints {
            $0.top.equalTo(cinemaImage.snp.bottom).offset(UIConstants.topOffset)
            $0.centerX.equalToSuperview()
        }
        
        noButton.snp.makeConstraints {
            $0.top.equalTo(questionLabelTwo.snp.bottom).offset(50)
            $0.leading.equalToSuperview().inset(UIConstants.contentInset)
            $0.width.equalTo(150)
            $0.height.equalTo(40)
        }
        
        yesButton.snp.makeConstraints {
            $0.top.equalTo(questionLabelTwo.snp.bottom).offset(50)
            $0.trailing.equalToSuperview().inset(UIConstants.contentInset)
            $0.width.equalTo(150)
            $0.height.equalTo(40)
        }
    }
}
