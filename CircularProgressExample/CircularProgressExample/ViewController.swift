//
//  ViewController.swift
//  CircularProgressExample
//
//  Created by Rachel on 4/1/22.
//

import UIKit
import CircularProgress

class ViewController: UIViewController {
    
    private var stackView: CircularProgressStackView!
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let stackView = CircularProgressStackView()
        stackView.spacing = 6
        
        let redProgressView = CircularProgressView(
            fillColor: CircularColor.taleRed,
            backgroundColor: CircularColor.taleSecondaryRed
        )
        redProgressView.progressItem.progress = 0.75
        
        let greenProgressView = CircularProgressView(
            fillColor: CircularColor.taleGreen,
            backgroundColor: CircularColor.taleSecondaryGreen
        )
        greenProgressView.progressItem.progress = 0.7
        
        let blueProgressView = CircularProgressView(
            fillColor: CircularColor.taleBlue,
            backgroundColor: CircularColor.taleSecondaryBlue
        )
        blueProgressView.progressItem.progress = 0.65
        
        stackView.addSubview(redProgressView)
        stackView.addSubview(greenProgressView)
        stackView.addSubview(blueProgressView)
        
        self.stackView = stackView
        
        view.addSubview(stackView)
        self.view = view
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    private var lastViewTappedAt: TimeInterval = 0
    @objc func viewTapped(_ sender: UITapGestureRecognizer) {
        let current = Date().timeIntervalSinceReferenceDate
        if current - lastViewTappedAt > 0.75 {
            stackView.managedSubviews.forEach {
                $0.progressItem.progress = .random(in: 0...1)
            }
            lastViewTappedAt = current
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 266).isActive = true
        stackView.heightAnchor.constraint(equalTo: stackView.widthAnchor).isActive = true
    }


}

