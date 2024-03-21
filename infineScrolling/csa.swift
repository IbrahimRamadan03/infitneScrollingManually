//
//  customView.swift
//  infineScrolling
//
//  Created by ASTRA Macbook  on 20/03/2024.
//

/*
- Create Protocol
    - Function for draw ur cell (height/Width)
    - Function for setup collection with configue params
    - Function for control velocity/speed while scrolling
    - Function for setData
 */
import UIKit

class CustomView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    //MARK: - Outlets
    
    @IBOutlet weak var mainCollection: UICollectionView!

    //MARK: - Properties
    
    let data  = [1,2,3,4,5,6]
    let numOfShownItems = 3
    var totalNum: Int = 0
    var currentIndexPath : IndexPath = IndexPath(row: 0, section: 0)
    var currentOffSet : Double =  0
    
    //MARK: - Override
    
    override class func awakeFromNib() {
        // velocity speed
    //    self.collection.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    override func layoutSubviews() {
        self.configureCollectionViewLayoutItemSize()
    }
        
    //MARK: - CollectionView
    
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
    
    //MARK: - Configure Cell
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset()
        let collectionViewLayout = mainCollection.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionViewLayout?.itemSize = CGSize(width: mainCollection!.frame.size.width - inset * 2, height: mainCollection!.frame.size.height)
    }

    //MARK: - ScrollView
    
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
    
    //MARK: - Other
    
    func calculateSectionInset() -> CGFloat {
        return 10
    }
        
    func indexOfMajorCell() -> Int {
        let itemWidth = mainCollection.contentSize.width / CGFloat(totalNum)
        let offsetPerItem = mainCollection.contentOffset.x / itemWidth
        let index = Int(round(offsetPerItem))
        let numberOfItems = mainCollection.numberOfItems(inSection: 0)
        let safeIndex = max(0, min(numberOfItems - 1, index))
        return safeIndex
    }
    
  
    
}

