//
//  SwipeableCardViewContainer.swift
//  Pupple
//
//  Created by Jordan Sukhnandan on 4/13/22.
//

import UIKit

class SwipeableCardViewContainer: UIView, SwipeableViewDelegate {
    
    static let horizontalInset: CGFloat = 0.0

    static let verticalInset: CGFloat = 0.0
    
    var dataSource: SwipeableCardViewDataSource?
    {
        didSet{reloadData()}
    }
    
    var delegate: SwipeableCardViewDelegate?
    
    private var cardViews: [SwipeableCardViewCard] = []
    
    private var visibleCardViews: [SwipeableCardViewCard]
    {
        return subviews as? [SwipeableCardViewCard] ?? []
    }
    
    fileprivate var remainingCards: Int = 0
    
    static let numberOfVisibleCards: Int = 3
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func reloadData()
    {
        removeAllCardsViews()
        guard let dataSource = dataSource else {return}
        
        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards
        
        for index in 0..<min(numberOfCards, SwipeableCardViewContainer.numberOfVisibleCards) {
            addCardView(cardView: dataSource.card(forItemAtIndex: index), atIndex: index)
        }

        if let emptyView = dataSource.viewForEmptyCards() {
            addEdgeConstrainedSubView(view: emptyView)
        }
        
        setNeedsLayout()
    }
    
    private func addCardView(cardView: SwipeableCardViewCard, atIndex index: Int)
    {
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }
    
    private func removeAllCardsViews()
    {
        for cardView in visibleCardViews
        {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }
    
    private func setFrame(forCardView cardView: SwipeableCardViewCard, atIndex index: Int) {
           var cardViewFrame = bounds
           let horizontalInset = (CGFloat(index) * SwipeableCardViewContainer.horizontalInset)
           let verticalInset = CGFloat(index) * SwipeableCardViewContainer.verticalInset

           cardViewFrame.size.width -= 2 * horizontalInset
           cardViewFrame.origin.x += horizontalInset
           cardViewFrame.origin.y += verticalInset

           cardView.frame = cardViewFrame
       }

}

extension SwipeableCardViewContainer {
    
    func didTap(view: SwipeableView) {
        if let cardView = view as? SwipeableCardViewCard,
           let index = cardViews.firstIndex(of: cardView)
        {
            delegate?.didSelect(card: cardView, atIndex: index)
        }
    }
    
    func didBeginSwipe(onView view: SwipeableView) {
        // Swipe began
    }
    
    func didEndSwipe(onView view: SwipeableView) {
        guard let dataSource = dataSource else {return}
        
        // Remove swiped card
        view.removeFromSuperview()
        
        if remainingCards > 0
        {
            // The new card's index
            let newIndex = dataSource.numberOfCards() - remainingCards
            
            // Add a new card to the subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)
            
            // Animate frame change to reveal new card from underneath the stack of existing cards.
            for(cardIndex, cardView) in visibleCardViews.reversed().enumerated()
            {
                UIView.animate(withDuration: 0.2, animations: {
                    cardView.center = self.center
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                }, completion: nil)
            }
        }
    }
}
