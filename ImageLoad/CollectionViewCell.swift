//
//  TableViewCell.swift
//  ImageLoad
//
//  Created by hana on 2023/03/02.
//

import UIKit
import SnapKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell{
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
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout(){
        addSubview(stackView)
        
        [loadImageView, progressView, loadButton].forEach{
            stackView.addArrangedSubview($0)
        }
        
        stackView.snp.makeConstraints{
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(10)
        }
        
        loadImageView.snp.makeConstraints{
            $0.width.height.equalTo(150)
        }
        loadButton.snp.makeConstraints{
            $0.width.equalTo(80)
        }
        
    }
    
    func loadImage(row: Int){
        let url = URL(string: "https://images.pexels.com/photos/53421\(row)/pexels-photo-53421\(row).jpeg?auto=compress&cs=tinysrgb&w=200")
        
        loadImageView.kf.setImage(
            with: url,
            placeholder: UIImage(systemName: "photo"),
            options: [
                .forceRefresh,
                .transition(.fade(0.1)),
                .forceTransition
              ],
            progressBlock: { receivedSize, totalSize in
                let percentage = (Float(receivedSize) / Float(totalSize)) * 100.0
                self.progressView.progress = percentage
            },
            completionHandler: nil
        )
    }
    
    @objc func loadButtonTap(){
        loadImage(row: self.tag)
    }
}
