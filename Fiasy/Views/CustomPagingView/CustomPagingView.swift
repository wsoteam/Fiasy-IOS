
import Parchment

class CustomPagingView: PagingView {
    
    var headerHeightConstraint: NSLayoutConstraint?
    
    private lazy var headerView: PagingMainView = {
        let header = UINib(nibName: "PagingMainView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PagingMainView
        header.clipsToBounds = true
        return header
    }()
    
    static func getHeaderHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return ((screenWidth * 0.45) + 110) + ((screenWidth - 40)/3)
    }
    
    override func setupConstraints() {
        addSubview(headerView)
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerHeightConstraint = headerView.heightAnchor.constraint(
            equalToConstant: CustomPagingView.getHeaderHeight()
        )
        headerHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: options.menuHeight),
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            pageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            pageView.topAnchor.constraint(equalTo: topAnchor)
            ])
    }
}
