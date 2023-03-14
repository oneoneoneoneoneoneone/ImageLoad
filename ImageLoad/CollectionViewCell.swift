//
//  TableViewCell.swift
//  ImageLoad
//
//  Created by hana on 2023/03/02.
//

import UIKit

class CollectionViewCell: UICollectionViewCell{
    private var observation: NSKeyValueObservation!
    private var task: URLSessionDataTask!
    
    private let loadImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    private let progressView = UIProgressView()
    
    private lazy var loadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Load", for: .normal)
        button.setTitle("Stop", for: .selected)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 5
        
        button.addTarget(self, action: #selector(loadButtonTap), for: .touchUpInside)
        
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout(){
        [loadImageView, progressView, loadButton].forEach{
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        loadImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        loadImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loadImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        loadImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        progressView.leadingAnchor.constraint(equalTo: loadImageView.trailingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: loadButton.leadingAnchor).isActive = true
        progressView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        loadButton.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        loadButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        loadButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func reset(){
        DispatchQueue.main.async {
            self.loadImageView.image = .init(systemName: "photo")
            self.progressView.progress = 0
//            self.loadButton.isSelected = false
        }
    }
    private func fail(){
        DispatchQueue.main.async {
            self.loadImageView.image = .init(systemName: "xmark")
            self.progressView.progress = 0
            self.loadButton.isSelected = false
        }
    }
    
    private func loadImage(row: Int){
        guard let url = URL(string:"https://wallpaperaccess.com/download/cool-lion-16740\(row)") else {return}
        let urlRequest = URLRequest(url: url)
        
        task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {[weak self] data, response, error in
            if let error = error {
                guard error.localizedDescription == "cancelled" else {
                    fatalError(error.localizedDescription)
                }
                self?.reset()
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("response Error")
                self?.fail()
                return
            }
            
            guard response.statusCode == 200 else {
                print("response Error - \(response.statusCode)")
                self?.fail()
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                print("data Parsing Error")
                self?.fail()
                return
            }
            
            DispatchQueue.main.async {
                self?.loadImageView.image = image
                self?.loadButton.isSelected = false
            }
        })
        
        //전역변수로 선언해야 동작하는뎁....
        //observe 이하 겅부해
        observation = task.progress.observe(\.fractionCompleted,
                                                 options: [.new],
                                                 changeHandler: {progress, change in
            DispatchQueue.main.async {
                self.progressView.progress = Float(progress.fractionCompleted)
            }
        })
        
        task.resume()
    }
    
    @objc private func loadButtonTap(_ sender: UIButton){
        self.reset()
        
        sender.isSelected.toggle()
        
        //stop 일때 셀렉트하면
        guard sender.isSelected else {
            task.cancel()
            return
        }
        
        loadImage(row: self.tag)
    }
    
    func loadImage() {
        loadButton.sendActions(for: .touchUpInside)
    }
}
