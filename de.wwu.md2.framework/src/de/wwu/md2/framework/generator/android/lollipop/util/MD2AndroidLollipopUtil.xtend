package de.wwu.md2.framework.generator.android.lollipop.util

import com.google.common.base.Joiner

class MD2AndroidLollipopUtil {
	
	/**
	 * Returns the package name that is being derived from the String path
	 */
	def static String getPackageNameFromPath(String path) {
		val joiner = Joiner.on(".")
		val pathSegments = path.split("/").map([s | s.toFirstLower])
		return joiner.join(pathSegments)
	}
	
}