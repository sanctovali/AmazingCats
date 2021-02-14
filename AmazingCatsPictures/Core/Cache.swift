//
//  Cache.swift
//  AmazingCatsPictures
//
//  Created by Valentin Kiselev on 2/14/21.
//

import Foundation

//MARK: - Cache
final class MyCache<Key: Hashable, Value> {
	
	private let wrapped = NSCache<WrappedKey, Entry>()
	private let keyTracker = KeyTracker()
	var keys: Set<Key> {
		get {
			return keyTracker.keys
		}
	}
	
	func insert(_ value: Value, forKey key: Key) {
		let entry = Entry(value: value, key: key)
		wrapped.setObject(entry, forKey: WrappedKey(key))
		keyTracker.keys.insert(key)
	}
	
	func value(forKey key: Key) -> Value? {
		let entry = wrapped.object(forKey: WrappedKey(key))
		return entry?.value
	}
	
	private func removeValue(forKey key: Key) {
		wrapped.removeObject(forKey: WrappedKey(key))
	}
	
	init(maxEntryCount: Int = 75) {
		wrapped.countLimit = maxEntryCount
		wrapped.totalCostLimit = maxEntryCount * 1024 * 1024
		wrapped.delegate = keyTracker
	}
	
}
//MARK: - subscript
extension MyCache {
	subscript(key: Key) -> Value? {
		get { return value(forKey: key) }
		set {
			guard let value = newValue else {
				removeValue(forKey: key)
				return
			}
			insert(value, forKey: key)
		}
	}
}
//MARK: - WrappedKey for cache
private extension MyCache {
	final class WrappedKey: NSObject {
		let key: Key
		
		init(_ key: Key) {
			self.key = key
		}
		
		override var hash: Int {
			key.hashValue
		}
		
		override func isEqual(_ object: Any?) -> Bool {
			guard let value = object as? WrappedKey else { return false }
			return value.key == key
		}
	}
	
	final class Entry {
		let value: Value
		let key: Key
		
		init(value: Value, key: Key) {
			self.value = value
			self.key = key
		}
	}
	
	final class KeyTracker: NSObject, NSCacheDelegate {
		var keys = Set<Key>()
		
		func cache(_ chache: NSCache<AnyObject, AnyObject>, willEvictObject object: Any) {
			guard let entry = object as? Entry else { return }
			
			keys.remove(entry.key)
		}
	}
}
//MARK: - Entry methods
private extension MyCache {
	func entry(forKey key: Key) -> Entry? {
		guard let entry = wrapped.object(forKey: WrappedKey(key)) else { return nil }
		return entry
	}
	
	func insert(_ entry: Entry) {
		wrapped.setObject(entry, forKey: WrappedKey(entry.key))
		keyTracker.keys.insert(entry.key)
	}
}
//MARK: - MyCache.Entry: Codable
extension MyCache.Entry: Codable where Key: Codable, Value: Codable {}

//MARK: - Persistent implementation
extension MyCache: Codable where Key: Codable, Value: Codable {
	convenience init(from decoder: Decoder) throws {
		self.init()
		
		let container = try decoder.singleValueContainer()
		let entries = try container.decode([Entry].self)

		entries.forEach(insert)
	}
	
	func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(keyTracker.keys.compactMap(entry))
	}
}

extension MyCache where Key: Codable, Value: Codable {
	func saveToDisk(withName name: String, using fileManager: FileManager = .default) throws {
		let folderURLs = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
		let fileURL = folderURLs[0].appendingPathComponent(name + ".cache")
		let data = try JSONEncoder().encode(self)
		print("data to write: \(data)")
		try data.write(to: fileURL)
	}
	
	func loadFromDisk() -> [Value?] {
		var output = [Value?]()
		keys.forEach {
			output.append(entry(forKey: $0)?.value)
		}
		return output
	}
}
