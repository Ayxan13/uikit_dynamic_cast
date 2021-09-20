//
// Created by Ayxan Haqverdili on 20.09.21.
//

import Foundation;
import UIKit;
import CoreData;

class PodcastsPersistenceModel {
    public static let shared = PodcastsPersistenceModel();

    private let persistentContext =
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;


    



    deinit {
        try? persistentContext.save();
    }
}