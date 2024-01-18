//
//  RobotDetailViewController.swift
//  RoboGallery
//
//  Created by Melissa Hanson on 1/13/24.
//

import UIKit

@objc protocol RobotDetailViewControllerDelegate {
    @objc func deleteRobot(at index: Int)
}

class RobotDetailViewController: UIViewController {
    
    var delegate: RobotDetailViewControllerDelegate?
    
    private let viewmodel: RobotDetailViewModel
    
    init(viewmodel: RobotDetailViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var image: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "questionmark")
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemGray3
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    private func setUpUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(image)
        
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteRobot))
        
        title = viewmodel.robot.name
        image.image = UIImage(data: viewmodel.robot.imageData)
        
        let size = view.frame.size.width
        NSLayoutConstraint.activate([
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            image.heightAnchor.constraint(equalToConstant: size),
            image.widthAnchor.constraint(equalToConstant: size)
                        
        ])
    }
    
    
    @objc func deleteRobot() {
        print("Delete robot at index \(viewmodel.index)")
        delegate?.deleteRobot(at: viewmodel.index)
        navigationController?.popViewController(animated: true)
    }
    
}
