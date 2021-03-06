Pod::Spec.new do |s|

  s.name         = "FetchedResultsController"
  s.version      = "2.0.7"
  s.summary      = "A FetchedResultsController implementation that abstracts out the boilerplate for both UITableView."

  s.homepage     = "http://www.williamboles.me"
  s.license      = { :type => 'MIT', 
  					 :file => 'LICENSE.md' }
  s.author       = "William Boles"

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/wibosco/FetchedResultsController.git", 
  					 :branch => "master", 
  					 :tag => s.version }

  s.source_files  = "FetchedResultsController/**/*.swift"
	
  s.requires_arc = true
	
  s.frameworks = 'UIKit', 'CoreData'
  
end
