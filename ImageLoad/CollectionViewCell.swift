//
//  TableViewCell.swift
//  ImageLoad
//
//  Created by hana on 2023/03/02.
//

import UIKit

class CollectionViewCell: UICollectionViewCell{
    private var observation: NSKeyValueObservation!
    
    let loadImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    let progressView = UIProgressView()
    
    lazy var loadButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.setTitle("Load", for: .normal)
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
    
    func setLayout(){
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
    
    func reset(){
        DispatchQueue.main.async {
            self.loadImageView.image = .init(systemName: "photo")
            self.progressView.progress = 0
        }
    }
    
    func loadImage(row: Int){
        guard let url = URL(string:"https://images.pexels.com/photos/53420\(row)/pexels-photo-53420\(row).jpeg?auto=compress&cs=tinysrgb&w=200") else {return}
        let urlRequest = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {[weak self] data, response, error in
            if let error = error {
                fatalError(error.localizedDescription)
//                self?.reset()
//                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                print("response Error")
                self?.reset()
                return
            }
            
            guard response.statusCode == 200 else {
                print("response Error - \(response.statusCode)")
                self?.reset()
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data) else {
                print("data Parsing Error")
                self?.reset()
                return
            }
            
            DispatchQueue.main.async {
                self?.loadImageView.image = image
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
    
    @objc func loadButtonTap(){
        loadImage(row: self.tag)
    }
}
