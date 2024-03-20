//
//  ViewController.swift
//  infineScrolling
//
//  Created by ibrahim on 05/03/2024.
//

import UIKit

class ViewController: UIViewController ,UICollectionViewDelegate , UICollectionViewDataSource , UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.configureCollectionViewLayoutItemSize()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    let numbers = 50
    let numOfShownItems = 3
    var totalNum: Int = 0
    var currentIndexPath : IndexPath = IndexPath(row: 0, section: 0)
    var currentOffSet : Double =  0
    
    @IBOutlet weak var mainCollection: UICollectionView!
    
    let data  = [1,2,3,4,5,6]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        totalNum = numOfShownItems + data.count
        return totalNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colCell", for: indexPath) as! CollectionViewCell
        let currentCell = indexPath.row % data.count
        print("\(collectionView.contentOffset.x)" + " collection offset")
        print("\(collectionView.contentSize.width)" + " collection width")
        print("\(collectionView.contentSize.width / CGFloat(totalNum))" + " collection equation")
        cell.collectionLbl.text = "\(data[currentCell])"
        currentIndexPath = indexPath
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let singleElementSize = mainCollection.contentSize.width / CGFloat(totalNum)
        if mainCollection.contentOffset.x > singleElementSize*CGFloat(data.count) {
            mainCollection.contentOffset.x = mainCollection.contentOffset.x - singleElementSize*CGFloat(data.count)
        }
        if mainCollection.contentOffset.x < 0 {
            print("left")
            mainCollection.contentOffset.x = mainCollection.contentOffset.x + singleElementSize * CGFloat(data.count)
        }
        
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        targetContentOffset.pointee = scrollView.contentOffset
        let indexOfMajorCell = self.indexOfMajorCell()
        let indexPath = IndexPath(row: indexOfMajorCell, section: 0)
        mainCollection!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func calculateSectionInset() -> CGFloat {
        return 10
    }
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset()
        let collectionViewLayout = mainCollection.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionViewLayout?.itemSize = CGSize(width: mainCollection!.frame.size.width - inset * 2, height: mainCollection!.frame.size.height)
    }
    
    
    func indexOfMajorCell() -> Int {
        let itemWidth = mainCollection.contentSize.width / CGFloat(totalNum)
        let offsetPerItem = mainCollection.contentOffset.x / itemWidth
        print("offset per item \(offsetPerItem)")
        let index = Int(round(offsetPerItem))
        let numberOfItems = mainCollection.numberOfItems(inSection: 0)
        print(numberOfItems)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    
    
}




