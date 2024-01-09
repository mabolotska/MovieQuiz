//
//  LaunchViewController.swift
//  MovieQuiz
//
//  Created by Maryna Bolotska on 07/01/24.
//

import UIKit
import SnapKit

class LaunchViewController: UIViewController {
    let vc = ViewController()
    let mainView: UIView = {
          let view = UIView()
          return view
      }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
            navigationController?.pushViewController(vc, animated: true)
        }

        view.backgroundColor = .systemBackground
        view.addSubview(mainView)
        
               mainView.snp.makeConstraints { make in
                   make.edges.equalToSuperview()
               }
        
        let backgroundImage = UIImageView(image: UIImage(named: "Background"))
               backgroundImage.contentMode = .scaleAspectFill
               mainView.addSubview(backgroundImage)

      
               backgroundImage.snp.makeConstraints { make in
                   make.edges.equalToSuperview()
               }
    }
    


}
