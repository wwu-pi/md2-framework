package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer

import static de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import java.util.Collection

class AppJsonBuilder {
	
	def static generateAppJson(DataContainer dataContainer, Collection<String> requiredBundles) '''
		{
		  // the name of the application (optional)
		  "appName": "«dataContainer.main.appName»",
		  
		  // properties section (optional)
		  // used to transport metadata
		  "properties": {
		    "id": "«createAppName(dataContainer)»",
		    "title": "«dataContainer.main.appName»"
		  },
		  
		  // load section used to manipulate the loading behavior of an application
		  "load": {
		    // the bundle locations, from where the bundles should be resolved
		    "bundleLocations": ["bundles", "${app}/bundles"],
		    
		    // the bundles to load (if empty: all are loaded)
		    // "system" must be listed as a bundle!
		    "allowedBundles": [«FOR bundle: requiredBundles SEPARATOR ', '»"«bundle»"«ENDFOR»],
		    
		    // the bundles to skip during load (if empty none are skipped)
		    // e.g.: "skipBundles": ["splashscreen"] for disabling the splashscreen
		    "skipBundles": [],
		    
		    "styles": ["${app}:app.css"]
		  },
		  
		  // bundles section used to overwrite or add any property defined by components in the manifest.json of bundles
		  "bundles": {
		    //"<bundle name>": {
		    //  "<component name>": {
		    //    "<propertyname>": <value>
		    //  },
		    //  
		    //  "<factory component name>": [{
		    //    "<propertyname>": <value>
		    //  }]
		    //}
		  }
		}
	'''
	
}
