package de.wwu.md2.framework.generator.mapapps

import de.wwu.md2.framework.generator.util.DataContainer

import static extension de.wwu.md2.framework.generator.mapapps.util.MD2MapappsUtil.*
import static extension de.wwu.md2.framework.generator.util.MD2GeneratorUtil.*
import de.wwu.md2.framework.mD2.App

class AppClass {
	
	def static String generateAppJson(DataContainer dataContainer, App app) '''
{
    "appName": "«app.appName»",
    "properties": {
        "id": "«app.name»",
        "title": "«app.appName»"
    },
    
    "load": {
        // the bundle locations, from where the bundles should be resolved
        "bundleLocations" : ["${app}/bundles",{"name":"localbundles","noprefetch" : true},"bundles"],
        
        // the bundles to load (if empty: all are loaded)
        "allowedBundles": [
            "system",
            "splashscreen",
            "templatelayout",
            "themes",
            "templates",
            
            "windowmanager",
            "notifier",
            "dataform",
            "console",
            
            "map",
            "basemaptoggler",
            "toolset",
            "toolrules",
            
            "md2_runtime",
            "md2_store",
            "md2_location_service",
            "md2_local_store",
            "onlinestatus",
            "md2_formcontrols",
            
            "md2_workflow",
            "md2_models",
            "md2_content_providers",
            
            "md2_list_of_open_issues",
            "md2_workflow_store",
            
            «FOR elem : dataContainer.workflowElementsForApp(app) SEPARATOR ","»
                "«elem.bundleName»"
            «ENDFOR»
        ],
        
        // the bundles to skip during load (if empty none are skipped)
        // e.g.: "skipBundles" : ["splashscreen"] for disabling the splashscreen
        "skipBundles": []
    },
    
    // bundles section used to overwrite or add any property defined by components in the manifest.json of bundles
    "bundles": {
        "md2_workflow_store": {
            "MD2WorkflowStore": {
                    "url": "«dataContainer.workflowWSUri»",
                    "app": "«app.name»"
            }
        },
        "md2_runtime": {
            "WorkflowStateHandlerFactory": {
                    "appId": "md2_«app.name»"
            }
        },
        "notifier": {
            "NotifierFactory": {
                "fadeTime": 10000
            }
        },
        "map": {
            "MapState": {
                "initialExtent": {
                    "xmin": -1100000,
                    "ymin": 4000000,
                    "xmax": 3500000,
                    "ymax": 8800000,
                    "spatialReference": {
                        "wkid": 3857
                    }
                }
            },
            "MapModelFactory": {
                "_configLocation": "${app}:services-init.json"
            },
            "MappingResourceRegistryFactory": {
                "_knownServicesLocation": "${app}:services.json"
            }
        },
        "toolset": {
            "ToolsetManager": {
                "toolsets": [
                    {
                        "id": "md2_apps_toolset",
                        "title": "Startable Workflow Elements",
                        "container": "map",
                        "windowType": {
                            "window": {
                                "resizable": false,
                                "dndDraggable": true,
                                "collapsable": false
                            }
                        },
                        "position": {
                            "rel_l": 30,
                            "rel_t": 30
                        },
                        "tools": [
                            "md2_wfe_*",
                            "md2_app_*",
                            "md2_list_of_open_issues"
                        ]
                    }
                ]
            }
        }
    }
}
	'''
	
	// Generate the "allowed-bundle" string for each workflow element
	
	def static String generateBundleJson(DataContainer dataContainer, App app) '''
	{
	    "md2_models": {},
	    "md2_content_providers": {},
	    "md2_workflow" : {},
	    
	    «FOR elem : dataContainer.workflowElementsForApp(app) SEPARATOR ","»
	       "«elem.bundleName»": {}
	    «ENDFOR»
	}
	'''
}