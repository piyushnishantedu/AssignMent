//
//  ViewController.swift
//  DinDinAssignment
//
//  Created by Piyush Nishant on 14/07/21.
//

import UIKit

import RxMoya
import RxSwift
import ObjectMapper
import RxCocoa
import Moya
class HomeViewController: UIViewController, NavigationBarAppearance {
    @IBOutlet weak var bannerView: BannerView!
    
    var foodItemListController:FoodListViewController!
    var visualEffectView:UIVisualEffectView!
    
    let cardHeight:CGFloat = UIScreen.main.bounds.size.height
    let cardHandleAreaHeight:CGFloat = UIScreen.main.bounds.size.height*0.35
    
    var cardVisible = false
    
    var runningAnimations = [UIViewPropertyAnimator]()
    var animationProgressWhenInterrupted:CGFloat = 0
    
    var homeViewPresenter: DasboardPresenterInterface!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar(isHidden: true)
        setupCard()
        
        homeViewPresenter.output.bannerList
            .asDriver(onErrorJustReturn: [])
            .drive { [weak self] banners in
                self?.bannerView.banners = banners
                self?.bannerView.update()
            }.disposed(by: disposeBag)

        homeViewPresenter.input.viewDidLoadTrigger.onNext(())

    }
}

// MARK:- Handel interaction of child controller
extension HomeViewController {
    enum CardState {
        case expanded
        case collapsed
    }
    
    var nextState:CardState {
        return cardVisible ? .collapsed : .expanded
    }
    
    func setupCard() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        foodItemListController = FoodListConfigurator().getFoodListViewController()
        self.addChild(foodItemListController)
        self.view.addSubview(foodItemListController.view)
        
        foodItemListController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardHeight)
        
        foodItemListController.view.clipsToBounds = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleCardTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleCardPan(recognizer:)))
        
        foodItemListController.foodMenuView.addGestureRecognizer(tapGestureRecognizer)
        foodItemListController.foodMenuView.addGestureRecognizer(panGestureRecognizer)
        
        
    }
    
    @objc
    func handleCardTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    @objc
    func handleCardPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            let translation = recognizer.translation(in: self.foodItemListController.foodMenuView)
            var fractionComplete = translation.y / cardHeight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    
    func animateTransitionIfNeeded (state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.foodItemListController.view.frame.origin.y = self.view.bounds.size.height - self.cardHeight
                case .collapsed:
                    self.foodItemListController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                }
            }
            
            frameAnimator.addCompletion { _ in
                self.cardVisible = !self.cardVisible
                self.runningAnimations.removeAll()
            }
            
            
            frameAnimator.startAnimation()
            runningAnimations.append(frameAnimator)
            
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.foodItemListController.view.roundCorners([.topLeft, .topRight], radius: 0)
                case .collapsed:
                    self.foodItemListController.view.roundCorners([.topLeft, .topRight], radius: 20)
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }
            
            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
            
        }
    }
    
    func startInteractiveTransition(state:CardState, duration:TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    func continueInteractiveTransition (){
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
