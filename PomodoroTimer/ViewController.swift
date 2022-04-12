//
//  ViewController.swift
//  PomodoroTimer
//
//  Created by Syrym Zhursin on 11.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    lazy private var timerLabel: UILabel = {
        let label = UILabel()
        label.text = formatTime()
        label.textColor = .white
        label.font = UIFont(name: "Avenir Next", size: 40)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Press start to use Pomodoro timer"
        label.numberOfLines = 5
        label.font = UIFont(name: "Avenir Next", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.green, for: .normal)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.isEnabled = false
        button.alpha = 0.5
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont(name: "Avenir Next", size: 18)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy private var bottomStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 158
        return stackView
    }()
    
    var timer = Timer()
    var isTimerStarted = false
    var time = workDuration
    var state: TimerState = .inactive
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    private func configureViews() {
        view.backgroundColor = .black
        [cancelButton, startButton].forEach { bottomStackView.addArrangedSubview($0) }

        [timerLabel, bottomStackView, messageLabel].forEach { view.addSubview($0) }
        
        NSLayoutConstraint.activate([
            timerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            
            messageLabel.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 50),
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            
            bottomStackView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            bottomStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            bottomStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50)
        ])
    }
    
    @objc private func startButtonTapped() {
        if state == .inactive {
            messageLabel.text = "Work in progress"
        }
        state = .work
        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0
        if !isTimerStarted {
            startTimer()
            isTimerStarted = true
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(.orange, for: .normal)
        } else {
            timer.invalidate()
            isTimerStarted = false
            startButton.setTitle("Resume", for: .normal)
            startButton.setTitleColor(.green, for: .normal)
        }
    }
    
    @objc private func cancelButtonTapped() {
        messageLabel.text = "Press start to use Pomodoro timer"
        state = .inactive
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.green, for: .normal)
        timer.invalidate()
        time = workDuration
        timerLabel.text = formatTime()
        isTimerStarted = false
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer() {
        if time < 1 {
            if state == .work {
                messageLabel.text = "Break time"
                state = .rest
                time = restDuration
            } else if state == .rest {
                messageLabel.text = "Work in progress"
                state = .work
                time = workDuration
            }
        } else {
            time -= 1
            timerLabel.text = formatTime()
        }
    }
    
    private func formatTime() -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
}

enum TimerState {
    case inactive
    case work
    case rest
}

let workDuration = 1500
let restDuration = 300
