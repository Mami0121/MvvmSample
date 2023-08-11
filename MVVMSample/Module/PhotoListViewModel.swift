//
//  PhotoListViewModel.swift
//  MVVMSample
//
//  Created by KURUMSAL on 10.08.2023.
//

import Foundation

class PhotoListViewModel {
    
    let apiService: APIServiceProtocol
    
    private var photos: [Photo] = [Photo]()
    
    private var cellViewModels: [PhotoListCellViewModel] = [PhotoListCellViewModel]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    init( apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }
    var numberOfCells: Int {
        return cellViewModels.count
    }
    var isAllowSegue: Bool = false
    
    var selectedPhoto: Photo?
    
    var reloadTableViewClosure: (()->())?
    
    var updateLoadingStatus: (()->())?

    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    
    
    func getCellViewModel( at indexPath: IndexPath ) -> PhotoListCellViewModel {
        return cellViewModels[indexPath.row]
    }
    
    func createCellViewModel( photo: Photo ) -> PhotoListCellViewModel {

        let descTextContainer: [String] = [String]()
        let desc = descTextContainer.joined(separator: " - ")
        
        return PhotoListCellViewModel(
            description: photo.description ?? "",
            imageUrl: photo.image_url
                                        )
    }
    
    func initFetch() {
        self.isLoading = true
        apiService.fetchPopularPhoto { [weak self] (success, photos, error) in
            self?.isLoading = false
            if let error = error {
            print(error)
            } else {
                print(photos)
                self?.processFetchedPhoto(photos: photos)
            }
        }
    }
    
    
    private func processFetchedPhoto( photos: [Photo] ) {
        self.photos = photos // Cache
        var vms = [PhotoListCellViewModel]()
        for photo in photos {
            vms.append( createCellViewModel(photo: photo) )
        }
        self.cellViewModels = vms
    }
}

extension PhotoListViewModel {
    func userPressed( at indexPath: IndexPath ){
        let photo = self.photos[indexPath.row]
        if photo.for_sale {
            self.isAllowSegue = true
            self.selectedPhoto = photo
        }else {
            self.isAllowSegue = false
            self.selectedPhoto = nil
            //self.alertMessage = "This item is not for sale"
        }
        
    }
}


struct PhotoListCellViewModel {
    //let titleText: String
    let description: String
    let imageUrl: String
    //let dateText: String
}
