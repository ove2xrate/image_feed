//
//  ImagesListCell.swift
//  image_feed
//
//  Created by Ivan Ryabov on 10/08/2023.
//

import Foundation
import UIKit

final class ImagesListCell: UITableViewCell {
    // MARK: - Private Properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
}
