//
//  AdventureCollectionViewCell.swift
//  Adventurlog
//
//  Created by Isaacs, Todd on 2/11/18.
//  Copyright © 2018 Todd Isaacs. All rights reserved.
//

import UIKit

class AdventureCollectionViewCell: UICollectionViewCell {
  
  let margin:CGFloat = 8.0
  
  lazy var title: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor.black
    label.textAlignment = .center
    self.contentView.addSubview(label)
    return label
  }()
  
  lazy var imageView:UIImageView = {
    let _imageView = UIImageView()
    _imageView.translatesAutoresizingMaskIntoConstraints = false
    //self.backgroundColor = UIColor.green
    self.contentMode = .scaleAspectFit
    self.contentView.addSubview(_imageView)
    return _imageView
  }()
 
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.contentView.backgroundColor = AppDelegate.TINT_COLOR
    layoutCell()
    layoutImage()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func layoutImage()  {
    [imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin),
     imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -margin),
     imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin),
     imageView.topAnchor.constraint(equalTo: title.bottomAnchor, constant: margin)
      ].forEach { $0.isActive = true }
  }

  func layoutCell() {
    title.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).isActive = true
    title.heightAnchor.constraint(equalToConstant: 20).isActive = true
    title.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
    title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8.0).isActive = true
  }
}
