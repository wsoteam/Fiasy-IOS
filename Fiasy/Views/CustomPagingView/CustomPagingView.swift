
import Parchment

class CustomPagingView: PagingView {
    
    var headerHeightConstraint: NSLayoutConstraint?
    
    lazy var dateLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.width, height: options.menuHeight))
        label.textColor = .black
        label.backgroundColor = .white
        label.font = UIFont.fontRobotoBold(size: 20.0)
        label.textAlignment = .center
        
        return label
    }()
    
    lazy var headerView: PagingMainView = {
        let header = UINib(nibName: "PagingMainView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PagingMainView
        header.clipsToBounds = true
        return header
    }()
    
    static func getHeaderHeight() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        return ((screenWidth * 0.45) + 120) + ((screenWidth - 40)/3)
    }
    
    override func setupConstraints() {
        addSubview(headerView)
        addSubview(dateLabel)
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        headerHeightConstraint = headerView.heightAnchor.constraint(
            equalToConstant: CustomPagingView.getHeaderHeight()
        )
        headerHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            dateLabel.heightAnchor.constraint(equalToConstant: options.menuHeight),
            dateLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            
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
