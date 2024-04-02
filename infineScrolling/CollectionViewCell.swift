//
//  CollectionViewCell.swift
//  infineScrolling
//
//  Created by ibrahim on 05/03/2024.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionLbl: UILabel!
    
    func setUpCell(lblNum : Int) {
        collectionLbl.text = "\(lblNum)"
    }
    
}
