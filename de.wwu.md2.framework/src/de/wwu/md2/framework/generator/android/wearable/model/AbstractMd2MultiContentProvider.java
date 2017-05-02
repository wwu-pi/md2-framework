package de.wwu.md2.framework.generator.android.wearable.model;

import java.util.HashMap;

import com.google.inject.Provides;

import de.wwu.md2.framework.mD2.ContentProvider;

public abstract class AbstractMd2MultiContentProvider {

	
	
private HashMap<String, Md2ContentProvider> providers;	

private String key;

public Md2ContentProvider get(String name){
return providers.get(name);	
}



public AbstractMd2MultiContentProvider(String key) {
	super();
	this.key = key;
}



public void add(String providerName, Md2ContentProvider provider ){	
providers.put(providerName, provider);	
}


public void remove(String providerName){
providers.remove(providerName);	
}


public void saveAll(){
for(String name: providers.keySet()){
if(this.providers.get(name)!=null){
	this.providers.get(name).save();	
}	
}	
}


public void ResetAll(){
	for(String name: providers.keySet()){
		if(this.providers.get(name)!=null){
			this.providers.get(name).reset();	
		}	
		}	
}

public void LoadAll(){
	for(String name: providers.keySet()){
		if(this.providers.get(name)!=null){
			this.providers.get(name).load();	
		}	
		}	
}

public void RemoveAll(){
	for(String name: providers.keySet()){
		if(this.providers.get(name)!=null){
			this.providers.get(name).remove();	
		}	
		}	
}

public void saveSingle(String providerName){
if(this.providers.get(providerName)!=null){
this.providers.get(providerName).save();}
}


public void ResetSingle(String providerName){
	if(this.providers.get(providerName)!=null){
		this.providers.get(providerName).reset();}
		}
	


public void LoadSingle(String providerName){
	if(this.providers.get(providerName)!=null){
		this.providers.get(providerName).load();}
		}
	


public void RemoveSingle(String providerName){
	if(this.providers.get(providerName)!=null){
		this.providers.get(providerName).remove();}
		}


}

