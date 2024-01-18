//
//  ViewController.swift
//  RoboGallery
//
//  Created by Melissa Hanson on 1/12/24.
//

import UIKit

class RobotsViewController: UIViewController {
    
    private let viewmodel: RobotsViewModel
    
    init(viewmodel: RobotsViewModel) {
        self.viewmodel = viewmodel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var textfield: UITextField = {
        let textfield = UITextField()
        textfield.attributedPlaceholder = NSAttributedString(string: "Enter a robot name", attributes: [.foregroundColor: UIColor.systemGray])
        textfield.backgroundColor = .systemFill
        textfield.isEnabled = true
        textfield.borderStyle = .roundedRect
        textfield.clearButtonMode = .whileEditing
        textfield.autocorrectionType = .no
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.alwaysBounceVertical = true
        cv.register(RobotCollectionViewCell.self, forCellWithReuseIdentifier: RobotCollectionViewCell.identifier)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var loadingIdicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textfield.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        viewmodel.getRobots()
        setUpUI()
    }
    
    func setUpUI() {
        title = "Robo Gallery"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        view.backgroundColor = .systemBackground
        view.addSubview(textfield)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            textfield.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textfield.topAnchor.constraint(equalTo: view.topAnchor, constant: 160.0),
            textfield.heightAnchor.constraint(equalToConstant: 44.0),
            textfield.widthAnchor.constraint(equalToConstant: view.frame.width - 32.0),
            collectionView.topAnchor.constraint(equalTo: textfield.bottomAnchor, constant: 12.0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        viewmodel.toggleLoadingIndicator = { [weak self] in
            guard let self else { return }

            DispatchQueue.main.async {
                if self.viewmodel.isLoading {
                    self.view.addSubview(self.loadingIdicator)
                    NSLayoutConstraint.activate([
                        self.loadingIdicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                        self.loadingIdicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                        self.loadingIdicator.heightAnchor.constraint(equalToConstant: 60.0),
                        self.loadingIdicator.widthAnchor.constraint(equalToConstant: 60.0)
                    ])
                    
                    self.loadingIdicator.startAnimating()
                    self.textfield.isEnabled = false
                } else {
                    self.loadingIdicator.stopAnimating()
                    self.loadingIdicator.removeFromSuperview()
                    self.textfield.isEnabled = true
                }
            }
        }
        
        viewmodel.updateCollectionView = { [weak self] in
            guard let self else { return }
            
            DispatchQueue.main.async {
                print("data changed")
                self.collectionView.reloadData()
                print("collection view updated")
            }
        }
    }
    
    @objc func addRobot() async {
        guard let name = textfield.text else {
            print("Robot name cannot be blank")
            return
        }
        
        print("add robot - \(name)")
        await viewmodel.addRobot(name: name)
    }

}

extension RobotsViewController: RobotDetailViewControllerDelegate {
    func deleteRobot(at index: Int) {
        viewmodel.deleteRobot(at: index)
    }

}

extension RobotsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let name = textField.text, name != "" else {
            return false
        }
        
        print("Add \(name)")
        Task { [weak self] in
            await self?.viewmodel.addRobot(name: name)
        }
        
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
}

extension RobotsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewmodel.robots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RobotCollectionViewCell.identifier, for: indexPath) as? RobotCollectionViewCell else {
            fatalError("failed to dequeue cell in collection view")
        }
        let robot = viewmodel.robots[indexPath.row]
        cell.configure(image: UIImage(data: robot.imageData) ?? UIImage(systemName: "questionmark")!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let viewmodel = RobotDetailViewModel(robot: viewmodel.robots[indexPath.row], index: indexPath.row)
        let viewController = RobotDetailViewController(viewmodel: viewmodel)
        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension RobotsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.view.frame.width / 4) - 1.5
        return CGSize(width: size, height: size)
    }
    
    // Vertical Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    // Horizontal Spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}
