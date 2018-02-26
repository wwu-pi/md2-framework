package de.wwu.md2.framework.util

import java.security.MessageDigest

class StringExtensions {
	
	/**
	 * If the string is embraced by parentheses (...), the same string without the embracing
	 * parentheses is returned.
	 */
	def static trimParentheses(String str) {
		if (str === null) {
			return str;
		} else if (str.startsWith("(") && str.endsWith(")")) {
			return str.substring(1, str.length() - 1);
		}
		return str;
	}
	
	/**
	 * Surround a given string with quotes.
	 */
	def static quotify(String str) {
		if (str === null) {
			return str;
		}
		return '''"«str»"'''
	}
	
	/**
	 * Escapes 
	 */
	def static escape(String str) {
		if (str === null) {
			return str;
		}
		return str.replace("\\", "\\\\")
		          .replace("\"", "\\\"")
		          .replace("\r", "\\r")
		          .replace("\n", "\\n")
	}
	
	/**
	 * Replace all tabs with n spaces.
	 */
	def static tabsToSpaces(String str, int n) {
		if (str === null) {
			return str;
		}
		var spaces = ""
		var i = 0
		while(i < n) {
			spaces = spaces + " "
			i = i + 1
		}
		str.replace("\t", spaces)
	}
	
	/**
	 * Get SHA-1 hash for input string
	 */
	def static String sha1Hex(String input){
		val mDigest = MessageDigest.getInstance("SHA1");
        val byte[] result = mDigest.digest(input.getBytes());
        val sb = new StringBuffer();
        for (var i = 0; i < result.length; i++) {
            sb.append(Integer.toString(result.get(i).bitwiseAnd(0xff) + 0x100, 16).substring(1));
        }
         
        return sb.toString();
	}
}
