//
//  ImageCarrouselView.swift
//  BDUIConcept
//
//  Created by Pablo Gonzalez on 12/10/21.
//

import Foundation
import UIKit
import SDWebImage

class ImageCarrouselView: UIView, AlchemistLiteViewUpdatable {
    var content: ImageCarrouselComponent.Content
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 12
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    init(content: ImageCarrouselComponent.Content) {
        self.content = content
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(withContent content: ImageCarrouselComponent.Content) {
        self.content = content
        collectionView.reloadData()
    }
    
    private func setupView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        backgroundColor = .yellow
        
        NSLayoutConstraint.activate([collectionView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                                     collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
                                     collectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
                                     collectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
                                     collectionView.heightAnchor.constraint(equalToConstant: 120)])
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: "ImageCollectionCell")
    }
}

extension ImageCarrouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCell", for: indexPath) as? ImageCollectionCell else { fatalError()
        }
        
        cell.setup(image: content.images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.images.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension ImageCarrouselView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 120)
    }
}

class ImageCollectionCell: UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(image: ImageCarrouselComponent.Content.Image) {
        imageView.sd_setImage(with: URL(string: image.url)!, completed: nil)
        print("setup cell")
    }
    
    private func setupView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        NSLayoutConstraint.activate([imageView.topAnchor.constraint(equalTo: topAnchor),
                                     imageView.leftAnchor.constraint(equalTo: leftAnchor),
                                     imageView.rightAnchor.constraint(equalTo: rightAnchor),
                                     imageView.bottomAnchor.constraint(equalTo: bottomAnchor)])
    }
}
