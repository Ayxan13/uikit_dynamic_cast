//
// Created by Ayxan Haqverdili on 20.09.21.
//

import Foundation;

import UIKit;

import CoreData;

class PodcastsPersistenceModel {
    private static let shared = PodcastsPersistenceModel();

    private let persistentContext =
            (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

    public func makeChildContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType);
        context.parent = persistentContext;
        return context;
    }

    deinit {
        try? persistentContext.save();
    }
}