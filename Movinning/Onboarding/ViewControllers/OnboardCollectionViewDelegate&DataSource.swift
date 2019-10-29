//
//  OnboardCollectionViewDelegate&DataSource.swift
//  Movinning
//
//  Created by Thalia Freitas on 18/10/19.
//  Copyright © 2019 The Rest of Us. All rights reserved.
//

import UIKit

extension OnboardingViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = onboardingView.collectionView.dequeueReusableCell(withReuseIdentifier:
            "OnboardingCollectionViewCell", for: indexPath) as? OnboardingCollectionViewCell
            else {return UICollectionViewCell()}

        if content[indexPath.row].assetKind == .animation {
            cell.assetOpition = .animation
        } else {
            cell.assetOpition = .image
        }

        cell.titleLabel.text = content[indexPath.row].title
        cell.descriptionTextView.text = content[indexPath.row].description
        cell.setImage(name: content[indexPath.row].assetName)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if onboardingView.collectionView.frame.width != 0 {
            let pageIndex = round(scrollView.contentOffset.x/onboardingView.collectionView.frame.width)
            onboardingView.currentPage = Int(pageIndex)
        }

        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x

        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y

        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset

        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        if percentOffset.x <= 0.79 {
            onboardingView.removeGetStartedButton()
        } else if percentOffset.x >= 0.8 {
            onboardingView.addGetStartedButton()
        }
    }
}
