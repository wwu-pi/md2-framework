package de.wwu.md2.framework.util;

import java.nio.charset.Charset;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Map;

import com.google.common.collect.Maps;

public class UuidProvider {
	
	private int uuidSize;
	private String appName;
	private Map<String, String> hashes;
	
	public UuidProvider(int uuidSize, String appName) {
		this.uuidSize = uuidSize;
		this.appName = appName;
		hashes = Maps.newHashMap();
	}
	
	public String getUuid(String name) {
		if(hashes.containsKey(name)) {
			return hashes.get(name);
		}
		else {
			return insertUuid(appName + "_" + name, name);
		}
	}
	
	private String insertUuid(String name, String nameToInsert) {
		String hash = getMD5(name);
		hash = hash.substring(hash.length() - uuidSize, hash.length());
		hash = hash.toUpperCase();
		if(!hashes.containsValue(hash)) {
			hashes.put(nameToInsert, hash);
			return hash;
		}
		else {
			return insertUuid(name + "X", nameToInsert);
		}
	}
	
	private String getMD5(String md5) {
	   try {
	        MessageDigest md = MessageDigest.getInstance("MD5");
	        byte[] array = md.digest(md5.getBytes(Charset.forName("UTF8")));
	        StringBuffer sb = new StringBuffer();
	        for (int i = 0; i < array.length; ++i) {
	          sb.append(Integer.toHexString((array[i] & 0xFF) | 0x100).substring(1,3));
	       }
	        return sb.toString();
	    } catch (NoSuchAlgorithmException e) {
	    }
	    return null;
	}

}
