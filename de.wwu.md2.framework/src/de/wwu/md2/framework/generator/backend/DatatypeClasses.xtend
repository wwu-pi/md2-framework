package de.wwu.md2.framework.generator.backend

class DatatypeClasses {
	
	def static createBooleanWrapper(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@XmlRootElement
		public class BooleanWrapper {
			
			@XmlElement(name="boolean")
			protected boolean bool;
			
			protected BooleanWrapper() {
				// no-arg default constructor necessary
			}
			
			public BooleanWrapper(boolean bool) {
				this.bool = bool;
			}
		}
	'''
	
	def static createDateWrapper(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import java.util.Date;
		
		import javax.persistence.Temporal;
		import javax.persistence.TemporalType;
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@XmlRootElement
		public class DateWrapper {
			
			@XmlElement
			@Temporal(TemporalType.DATE)
			protected Date date;
			
			protected DateWrapper() {
				// no-arg default constructor necessary
			}
			
			public DateWrapper(Date date) {
				this.date = date;
			}
		}
	'''
	
	def static createDecimalWrapper(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@XmlRootElement
		public class DecimalWrapper {
			
			@XmlElement
			protected double decimal;
			
			protected DecimalWrapper() {
				// no-arg default constructor necessary
			}
			
			public DecimalWrapper(double decimal) {
				this.decimal = decimal;
			}
		}
	'''
	
	def static createIntegerWrapper(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@XmlRootElement
		public class IntegerWrapper {
			
			@XmlElement
			protected int integer;
			
			protected IntegerWrapper() {
				// no-arg default constructor necessary
			}
			
			public IntegerWrapper(int integer) {
				this.integer = integer;
			}
		}
	'''
	
	def static createInternalIdWrapper(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@XmlRootElement(name = "internalId")
		public class InternalIdWrapper {
			
			@XmlElement
			protected int __internalId;
			
			protected InternalIdWrapper() {
				// no-arg default constructor necessary
			}
			
			public InternalIdWrapper(int integer) {
				this.__internalId = integer;
			}
		}
	'''
	
	def static createIsValidWrapper(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@XmlRootElement
		public class IsValidWrapper {
			
			@XmlElement
			protected boolean isValid;
			
			protected IsValidWrapper() {
				// no-arg default constructor necessary
			}
			
			public IsValidWrapper(boolean isValid) {
				this.isValid = isValid;
			}
		}
	'''
	
	def static createStringWrapper(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@XmlRootElement
		public class StringWrapper {
			
			@XmlElement
			protected String string;
			
			protected StringWrapper() {
				// no-arg default constructor necessary
			}
			
			public StringWrapper(String string) {
				this.string = string;
			}
		}
	'''
	
	def static createTimestampWrapper(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import java.util.Date;
		
		import javax.persistence.Temporal;
		import javax.persistence.TemporalType;
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@XmlRootElement
		public class TimestampWrapper {
			
			@XmlElement
			@Temporal(TemporalType.TIMESTAMP)
			protected Date timestamp;
			
			protected TimestampWrapper() {
				// no-arg default constructor necessary
			}
			
			public TimestampWrapper(Date timestamp) {
				this.timestamp = timestamp;
			}
		}
	'''
	
	def static createTimeWrapper(String basePackageName) '''
		package «basePackageName».datatypes;
		
		import java.util.Date;
		
		import javax.persistence.Temporal;
		import javax.persistence.TemporalType;
		import javax.xml.bind.annotation.XmlElement;
		import javax.xml.bind.annotation.XmlRootElement;
		
		@XmlRootElement
		public class TimeWrapper {
			
			@XmlElement
			@Temporal(TemporalType.TIME)
			protected Date time;
			
			protected TimeWrapper() {
				// no-arg default constructor necessary
			}
			
			public TimeWrapper(Date time) {
				this.time = time;
			}
		}
	'''
	
}