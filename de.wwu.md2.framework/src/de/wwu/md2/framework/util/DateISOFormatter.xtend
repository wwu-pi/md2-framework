package de.wwu.md2.framework.util

import java.util.Date
import java.text.SimpleDateFormat

class DateISOFormatter {
	
	/**
	 * Returns an ISO 8601 formatted date string.
	 */
	def static toISODate(Date date) {
		val formatter = new SimpleDateFormat("yyyy-MM-dd")
		formatter.format(date)
	}
	
	/**
	 * Returns an ISO 8601 formatted time string.
	 */
	def static toISOTime(Date date) {
		val formatter = new SimpleDateFormat("HH:mm:ssXXX")
		formatter.format(date)
		
	}
	
	/**
	 * Returns an ISO 8601 formatted date and time string.
	 */
	def static toISODateTime(Date date) {
		val formatter = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ssXXX")
		formatter.format(date)
	}
	
}
