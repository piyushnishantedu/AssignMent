//
//  BannerView.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 16/07/21.
//

import UIKit

protocol ViewPresentable {
    func setUpView()
    func configureView()
}

class BannerView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    var banners = [BannerPresentableData]()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    private func setTimerForAutoScroll() {
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.setUpAutoScrollingBanner(with:)), userInfo: nil, repeats: true)
    }
    
    @objc private func setUpAutoScrollingBanner(with timer: Timer) {
        guard collectionView != nil
              else { return }
        
        for cell in collectionView.visibleCells {
            if let cellIndex = collectionView.indexPath(for: cell),
               cellIndex.row < 3 {
                let indexpath = IndexPath(row: cellIndex.row + 1, section: cellIndex.section)
                collectionView.scrollToItem(at: indexpath, at: .right, animated: true)
            } else if let cellIndex = collectionView.indexPath(for: cell) {
                let indexpath = IndexPath(row: 0, section: cellIndex.section)
                collectionView.scrollToItem(at: indexpath, at: .left, animated: true)
            }
        }
    }
    
    func update() {
        collectionView.reloadData()
    }
}

// Mark:- Extension to configureView
extension BannerView: ViewPresentable {
    func configureView() {
        collectionView.register(UINib(nibName: "BannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BannerCollectionViewCell")
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection = .horizontal
        pageControl.currentPage = 0
        pageControl.tintColor = .white
        setTimerForAutoScroll()
    }
    
    func updateView(numberOfPages: Int) {
        pageControl.numberOfPages = numberOfPages
    }
    
    func setUpView() {
        contentView = loadFromNib()
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(contentView)
        configureView()
    }
}

// MARK:- Extension for UICollectionViewDelegate and Data Source
extension BannerView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCollectionViewCell", for: indexPath) as? BannerCollectionViewCell
        let banner = banners[indexPath.row].imageUrl ?? ""
        cell?.updateImageView(with: banner)
        return cell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.size.width, height: self.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollPos = scrollView.contentOffset.x / self.frame.width
        pageControl.currentPage = Int(scrollPos)
    }
}
