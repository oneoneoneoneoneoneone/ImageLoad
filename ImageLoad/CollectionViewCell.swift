//
//  TableViewCell.swift
//  ImageLoad
//
//  Created by hana on 2023/03/02.
//

import UIKit

class CollectionViewCell: UICollectionViewCell{
    private var observation: NSKeyValueObservation!
    private var imageLoadTask: Task<Void, Error>!
    
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
        self.loadImageView.image = .init(systemName: "photo")
    }
    
    private func fetchImage(url: URL) async throws -> UIImage{
        let urlRequest = URLRequest(url: url)
        
        //취소확인 - 시작 전
        if imageLoadTask.isCancelled { return UIImage() }
        //dataTask에 있는 error 리턴 값이 없음.
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let statuseCode = (response as? HTTPURLResponse)?.statusCode,
              (200...299).contains(statuseCode) else {throw NSError(domain: "response", code: 0)}
        //취소확인 - 주데이터 처리 전
        if imageLoadTask.isCancelled { return UIImage() }
        guard let image = UIImage(data: data) else {throw NSError(domain: "iamge coverting", code: 0)}
        
        return image
    }
    
    private func loadImage(row: Int){
        guard let url = URL(string:"https://wallpaperaccess.com/download/cool-lion-167401\(row)") else {return}

        imageLoadTask = Task(priority: .userInitiated){
            do{
                let image = try await fetchImage(url: url)
                loadImageView.image = image
                loadButton.isSelected.toggle()
            }catch{
                guard error.localizedDescription == "cancelled" else{
                    loadImageView.image = UIImage(systemName: "xmark")
                    loadButton.isSelected.toggle()
                    return
                }
            }
        }
    }
    
    @objc private func loadButtonTap(_ sender: UIButton){
        self.reset()
        
        sender.isSelected.toggle()
        
        //stop 일때 셀렉트하면
        guard sender.isSelected else {
            imageLoadTask.cancel()
            return
        }
        
        loadImage(row: self.tag)
    }
    
    func loadImage() {
        loadButton.sendActions(for: .touchUpInside)
    }
}
