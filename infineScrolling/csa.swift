import UIKit

@objc protocol CustomViewDelegate: AnyObject {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    func setCellData() ->[Any]

    @objc optional func setScrollSpeed() ->Double
    func setWidth() -> Double
    func setHeight() -> Double
    @objc optional func AutoScrolling() -> Bool
    
}

class CustomView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //MARK: - Outlets
    
    @IBOutlet weak var mainCollection: UICollectionView!

    //MARK: - Properties
    
    var data = [Any]()
    let numOfShownItems = 3
    var totalNum: Int = 0
    var currentIndexPath: IndexPath = IndexPath(row: 0, section: 0)
    var currentOffSet: Double = 0
    var currentIndex: Int = 0
    var timer = Timer()

    
    weak var delegate: CustomViewDelegate?

    //MARK: - Override
    
    override  func awakeFromNib() {
        print("view awakens")
     

     //   print(delegate?.AutoScrolling?())
  
     //   data = (delegate?.setCellData()) ?? []
        // velocity speed
        //    self.collection.decelerationRate = UIScrollView.DecelerationRate.fast
    }

    override func layoutSubviews() {
        data = (delegate?.setCellData())!
        if (delegate?.AutoScrolling?() == true){
            self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.scrollNext), userInfo: nil, repeats: true)
        }
        if (delegate?.setScrollSpeed?() != nil){
            self.mainCollection.decelerationRate = UIScrollView.DecelerationRate(rawValue: CGFloat((delegate?.setScrollSpeed?())!))
        }
        self.configureCollectionViewLayoutItemSize()
      
    }
    
    @objc func scrollNext(){
            if(currentIndex < data.count - 1){
                currentIndex = currentIndex + 1;
            
            }else if (currentIndex == data.count - 1) {
                currentIndex = 0;
            }
        mainCollection.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .right, animated: true)
        }
        
    //MARK: - CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        totalNum = numOfShownItems + data.count
        return totalNum
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colCell", for: indexPath) as! CollectionViewCell
        let elemenet =  data
        
        let currentCell = indexPath.row % data.count
        cell.setUpCell(lblNum: data[currentCell] as! Int)
    
       // cell.setUpCell(lblNum: delegate?.setCellData[indexPath.row]())
        return cell
    }
    
    
    

    
    
    
    //MARK: - Configure Cell
    
    private func configureCollectionViewLayoutItemSize() {
        let inset: CGFloat = calculateSectionInset()
        let collectionViewLayout = mainCollection.collectionViewLayout as? UICollectionViewFlowLayout
        collectionViewLayout?.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        collectionViewLayout?.itemSize = CGSize(width: mainCollection.frame.width - inset * 2, height: mainCollection!.frame.size.height)
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
